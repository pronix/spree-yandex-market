class YandexMarketConfiguration < Configuration
  preference :category,        :string
  preference :currency,        :string
  preference :wares,           :string,  :default => "active"
  preference :number_of_files, :integer, :default => 5
  preference :short_name,      :string
  preference :full_name,       :string
  preference :url,             :string
  preference :local_delivery_cost, :float # стоимость доставки по своему региону

  
  # wares property 
  preference :type_prefix,     :string, :default => "prefix"   # Группа товаров \ категория
  preference :vendor,          :string, :default => "vendor"        # Производитель
  preference :model,           :string, :default => "model"         # Модель
  preference :vendor_code,     :string,  :default => "vendor_code"  # Код товара (указывается код производителя)
  preference :country_of_manufacturer, :string, :default => "country_of_manufacturer" #страны производства товара.
  preference :manufacturer_warranty, :string, :default => "manufacturer_warranty" # есть официальная гарантию производителя.
  preference :wares_type,      :string, :default => "wares_type"   # Тип Товара
  
  # wares property Книги и АудиоКниги
  preference :author, :string            # Автор книги
  preference :publisher, :string         # Издательство
  preference :series, :string            # Серия
  preference :year, :string              # Год издания
  preference :isbn, :string              # Код книги, если их несколько, то указываются через запятую.
  preference :volume, :string            # Количество томов.
  preference :part, :string              # Номер тома.
  preference :language, :string          # Язык произведения.
  preference :binding, :string           # Переплет.
  preference :page_extent, :string       # Количествово страниц в книге, должно быть целым положиельным числом.
  preference :performed_by, :string      # Исполнитель. Если их несколько, перечисляются через запятую
  preference :storage, :string           # Носитель, на котором поставляется аудиокнига.
  preference :format, :string            # Формат аудиокниги.
  preference :recording_length , :string # Время звучания задается в формате mm.ss (минуты.секунды).
  
  # wares property Музыка и Видео
  preference :artist , :string          # Исполнитель
  preference :title , :string           # Наименование 
  preference :music_video_year, :string # Год
  preference :media , :string           # Носитель
  preference :starring , :string        # Актеры
  preference :director , :string        # Режиссер
  preference :original_name , :string     # Оригинальное наименовани
  preference :video_country, :string    # Страна
  
  # wares property Билеты
  preference :place, :string         # Место мероприятия
  preference :hall, :string          # Зал
  preference :hall_url_plan, :string # Ссылка на картинку версии зала
  preference :event_date, :string    # Дата и время сеанса. Указываются в формате ISO 8601: YYYY-MM-DDThh:mm
  preference :is_premiere, :string   # Признак премьерности мероприятия
  preference :is_kids, :string       # Признак детского мероприятия
  
end

