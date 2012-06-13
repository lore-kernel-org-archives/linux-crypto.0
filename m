From: Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/2] drivers: crypto: fix typo in nx driver config option
Date: Wed, 13 Jun 2012 15:23:53 -0500
Message-ID: <1339619033.28242.24.camel@key-ThinkPad-W510>
References: <1339611763-14603-1-git-send-email-sjenning@linux.vnet.ibm.com>
	 <1339611763-14603-2-git-send-email-sjenning@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, trivial@kernel.org
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339611763-14603-2-git-send-email-sjenning@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, 2012-06-13 at 13:22 -0500, Seth Jennings wrote:
> Cc: Kent Yoder <key@linux.vnet.ibm.com>
> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> ---
>  drivers/crypto/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Acked-by: Kent Yoder <key@linux.vnet.ibm.com>

> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 1092a77..b9b11a6 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -298,7 +298,7 @@ config CRYPTO_DEV_TEGRA_AES
>  	  will be called tegra-aes.
> 
>  config CRYPTO_DEV_NX
> -	tristate "Support for Power7+ in-Nest cryptographic accleration"
> +	tristate "Support for Power7+ in-Nest cryptographic acceleration"
>  	depends on PPC64 && IBMVIO
>  	select CRYPTO_AES
>  	select CRYPTO_CBC
