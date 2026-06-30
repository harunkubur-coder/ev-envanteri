import Foundation

enum PrivacyPolicyText {
    static let lastUpdated = "30 Haziran 2026"

    static let sections: [(title: String, body: String)] = [
        (
            "Giriş",
            """
            Ev Envanteri ("uygulama"), evinizdeki eşyaları kaydetmenize, konumlarını takip etmenize ve garanti tarihlerini yönetmenize yardımcı olur. Gizliliğinize saygı duyuyoruz. Bu metin, uygulamayı kullanırken verilerinizin nasıl işlendiğini açıklar.
            """
        ),
        (
            "Toplanan veriler",
            """
            Uygulamaya girdiğiniz bilgiler cihazınızda (ve iCloud açıksa iCloud hesabınızda) saklanır:
            • Eşya adı, kategori ve konumu
            • Satın alma ve garanti tarihleri
            • Notlar
            • İsteğe bağlı eşya fotoğrafları

            Ayrı bir hesap oluşturmanız gerekmez. Ad, e-posta veya telefon numarası toplamayız.
            """
        ),
        (
            "Verilerin kullanımı",
            """
            Verileriniz yalnızca uygulamanın çalışması için kullanılır: envanter listeleme, arama, filtreleme ve garanti takibi. Verilerinizi reklam profili oluşturmak veya üçüncü taraflara satmak için kullanmayız.
            """
        ),
        (
            "iCloud senkronizasyonu",
            """
            iCloud açık ve cihazınızda Apple ID ile oturum açmışsanız, envanter verileriniz Apple'ın iCloud altyapısı üzerinden iPhone ve iPad gibi cihazlarınız arasında senkronize edilebilir.

            Bu senkronizasyon Apple'ın iCloud Hüküm ve Koşulları kapsamında gerçekleşir. Verileriniz yalnızca sizin iCloud hesabınıza bağlı kalır; geliştirici olarak sunucularımızda veri barındırmayız.
            """
        ),
        (
            "Fotoğraf ve kamera erişimi",
            """
            Eşyalarınıza fotoğraf eklemek isterseniz uygulama galeri veya kamera erişimi ister. Bu izin yalnızca siz fotoğraf seçtiğinizde veya çektiğinizde kullanılır. Fotoğraflar cihazınızda (ve iCloud açıksa iCloud'unuzda) saklanır.
            """
        ),
        (
            "Veri saklama ve silme",
            """
            Veriler, uygulamayı silene kadar cihazınızda kalır. Bir eşyayı uygulama içinden sildiğinizde ilgili kayıt kalıcı olarak kaldırılır. iCloud senkronizasyonu açıksa silme işlemi bağlı cihazlara da yansıyabilir.
            """
        ),
        (
            "Üçüncü taraflar",
            """
            Uygulama analitik, reklam veya izleme SDK'ları içermez. Apple'ın iCloud hizmeti dışında verilerinizi üçüncü taraflarla paylaşmayız.
            """
        ),
        (
            "Çocuklar",
            """
            Uygulama genel kitleye yöneliktir. Bilerek 13 yaş altı çocuklardan kişisel veri toplamayız.
            """
        ),
        (
            "Değişiklikler",
            """
            Bu gizlilik politikasını güncelleyebiliriz. Önemli değişiklikler uygulama içinde veya App Store açıklamasında belirtilir. Güncelleme tarihi sayfanın üstünde yer alır.
            """
        ),
        (
            "İletişim",
            """
            Gizlilik ile ilgili sorularınız için \(AppInfo.supportEmail) adresine e-posta gönderebilirsiniz.
            """
        )
    ]
}
