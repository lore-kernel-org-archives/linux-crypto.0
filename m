From: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/11] crypto: sunxi-ss: prevent compilation
 on 64-bit
Date: Tue, 2 Feb 2016 09:42:54 +0100
Message-ID: <20160202084254.GA22621@Red>
References: <1454348370-3816-1-git-send-email-andre.przywara@arm.com>
 <1454348370-3816-3-git-send-email-andre.przywara@arm.com>
Reply-To: clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Maxime Ripard <maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>,
	Chen-Yu Tsai <wens-jdAy2FN1RRM@public.gmane.org>, linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org,
	Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	"David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>
Return-path: <linux-sunxi+bncBD7YLCN32UNBBEWYYG2QKGQEQGDJKCY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454348370-3816-3-git-send-email-andre.przywara-5wv7dgnIgG8@public.gmane.org>
List-Post: <https://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <https://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

On Mon, Feb 01, 2016 at 05:39:21PM +0000, Andre Przywara wrote:
> The driver for the sunxi-ss crypto engine is not entirely 64-bit safe,
> compilation on arm64 spits some warnings.
> The proper fix was deemed to involved [1], so since 64-bit SoCs won't
> have this IP block we just disable this driver for 64-bit.
> 
> [1]: http://lists.infradead.org/pipermail/linux-arm-kernel/2016-January/399988.html
>      (and the reply)
> 
> Signed-off-by: Andre Przywara <andre.przywara-5wv7dgnIgG8@public.gmane.org>

Acked-by: Corentin LABBE <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

> ---
>  drivers/crypto/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/crypto/Kconfig b/drivers/crypto/Kconfig
> index 07d4942..737200f 100644
> --- a/drivers/crypto/Kconfig
> +++ b/drivers/crypto/Kconfig
> @@ -487,7 +487,7 @@ config CRYPTO_DEV_IMGTEC_HASH
>  
>  config CRYPTO_DEV_SUN4I_SS
>  	tristate "Support for Allwinner Security System cryptographic accelerator"
> -	depends on ARCH_SUNXI
> +	depends on ARCH_SUNXI && !64BIT
>  	select CRYPTO_MD5
>  	select CRYPTO_SHA1
>  	select CRYPTO_AES
> -- 
> 2.6.4
> 
> -- 
