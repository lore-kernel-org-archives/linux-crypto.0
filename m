From: Tomasz Figa <t.figa@samsung.com>
Subject: Re: [PATCH 7/8 v3] crypto:s5p-sss: validate iv before memcpy
Date: Fri, 10 Jan 2014 17:03:09 +0100
Message-ID: <52D019BD.30401@samsung.com>
References: <1389243640-13282-1-git-send-email-ch.naveen@samsung.com>
 <1389354321-32096-1-git-send-email-ch.naveen@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com, tomasz.figa@gmail.com
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <1389354321-32096-1-git-send-email-ch.naveen@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Naveen,

On 10.01.2014 12:45, Naveen Krishna Chatradhi wrote:
> This patch adds code to validate "iv" buffer before trying to
> memcpy the contents
>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
> Changes since v2:
> None
>
>   drivers/crypto/s5p-sss.c |    5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/crypto/s5p-sss.c b/drivers/crypto/s5p-sss.c
> index f274f5f..7058bb6 100644
> --- a/drivers/crypto/s5p-sss.c
> +++ b/drivers/crypto/s5p-sss.c
> @@ -381,8 +381,9 @@ static void s5p_set_aes(struct s5p_aes_dev *dev,
>   	struct samsung_aes_variant *var = dev->variant;
>   	void __iomem *keystart;
>
> -	memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA
> -				(var->aes_offset, 0), iv, 0x10);
> +	if (iv)
> +		memcpy(dev->ioaddr + SSS_REG_AES_IV_DATA
> +					(var->aes_offset, 0), iv, 0x10);

In what conditions can the iv end up being NULL?

Best regards,
Tomasz
