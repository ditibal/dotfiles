import datetime
import os

SCOPES = ['https://www.googleapis.com/auth/calendar.readonly']


def map_color(color):
    mapped = {
        '#d06b64': '#e67c73',
        '#ffb878': '#f4511e',
        '#7ae7bf': '#33b679',
        '#51b749': '#0b8043',
        '#46d6db': '#039be5',
        '#5484ed': '#3f51b5',
        '#dbadff': '#8e24aa',
        '#e1e1e1': '#616161',
        '#fbd75b': '#ffc114',
    }

    return mapped.get(color, color)


def build_service():
    from google.auth.transport.requests import Request
    from google.oauth2.credentials import Credentials
    from google_auth_oauthlib.flow import InstalledAppFlow
    from googleapiclient.discovery import build

    creds = None
    # The file token.json stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.


    local_path = os.getenv('HOME') + '/.local/awesome/calendar'
    os.makedirs(local_path, exist_ok=True)
    token_path = local_path + '/token.json'

    if os.path.exists(token_path):
        creds = Credentials.from_authorized_user_file(token_path, SCOPES)

    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(local_path + '/credentials.json', SCOPES)
            creds = flow.run_local_server(port=0)
        # Save the credentials for the next run
        with open(token_path, 'w') as token:
            token.write(creds.to_json())

    return build('calendar', 'v3', credentials=creds)


class Cal:
    def __init__(self):
        self.error = None
        self.events = []
        self.calendar_id = 'primary'
        self.event_colors = []

    def fetch_event(self):
        try:
            self.error = None
            service = build_service()

            if not self.event_colors:
                colors = service.colors().get().execute()
                self.event_colors = colors.get('event', [])
                calendar_colors = colors.get('calendar', [])
                calendar_color_id = service.calendarList().get(calendarId=self.calendar_id).execute().get('colorId')
                self.calendar_color = calendar_colors.get(calendar_color_id)

            # Call the Calendar API
            now = datetime.datetime.utcnow()
            timeMin = now.isoformat() + 'Z'
            timeMax = (now + datetime.timedelta(days=1)).isoformat() + 'Z'

            events_result = (service.events().list(
                calendarId=self.calendar_id,
                timeMin=timeMin, timeMax=timeMax,
                maxResults=10, singleEvents=True,
                orderBy='startTime'
            ).execute())
            events = events_result.get('items', [])

            self.events = events
        except Exception as error:
            self.error = str(error)

    def get_color(self, event):
        event_color_id = event.get('colorId')
        if event_color_id is not None:
            return self.event_colors.get(event_color_id, '#000000')

        return self.calendar_color

    def current_event(self):
        now = datetime.datetime.now().timestamp()
        now_event = {
            'name': 'Свободно',
            'desc': None,
            'color': '#00000',
            'start_time': '',
            'end_time': '',
        }

        for event in self.events:
            start_date_time = event['start'].get('dateTime', None)
            if start_date_time is None:
                continue

            start = datetime.datetime.fromisoformat(start_date_time).timestamp()
            end = datetime.datetime.fromisoformat(event['end'].get('dateTime')).timestamp()

            if start <= now <= end:
                color = self.get_color(event)
                color = color['background']
                color = map_color(color)

                start = datetime.datetime.fromisoformat(start_date_time).strftime('%H:%M')
                end = datetime.datetime.fromisoformat(event['end'].get('dateTime')).strftime('%H:%M')

                now_event = {
                    'name': event.get('summary', 'Нет заголовка'),
                    'desc': event.get('description', None),
                    'start_time': start,
                    'end_time': end,
                    'color': color,
                }

                break

        return now_event


def create():
    return Cal()