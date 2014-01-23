From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Subject: Re: [PATCH 7/8 v4] crypto:s5p-sss: validate iv before memcpy
Date: Thu, 23 Jan 2014 15:48:39 +0530
Message-ID: <CAHfPSqDPRrn9z+EQ09RrhouYAXJ--tVNXUk+DB1T3XWTjSpyjg@mail.gmail.com>
References: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com> <1389777447-15225-1-git-send-email-ch.naveen@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-crypto@vger.kernel.org,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org,
	Vladimir Zapolskiy <vzapolskiy@gmail.com>,
	herbert@gondor.apana.org.au, cpgs@samsung.com,
	tomasz.figa@gmail.com
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1389777447-15225-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello All,

On 15 January 2014 14:47, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> This patch adds code to validate "iv" buffer before trying to
> memcpy the contents
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v3:
> None
>
>  drivers/crypto/s5p-sss.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index 69130b2..f7c66c7 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -380,7 +380,8 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
>  {
>         void __iomem *keystart;
>
> -       memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA (0), iv, 0x10);
> +       if (iv)
> +               memcpy(dev->aes_ioaddr + SSS_REG_AES_IV_DATA (0), iv, 0x10);
>
>         if (keylen == AES_KEYSIZE_256)
>                 keystart = dev->aes_ioaddr + SSS_REG_AES_KEY_DATA(0);
> --
> 1.7.9.5
Any update on this patch, Please
>



-- 
Shine bright,
(: Nav :)
