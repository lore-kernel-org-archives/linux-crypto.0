From: Paul Bolle <pebolle@tiscali.nl>
Subject: Re: [PATCH 05/28] Remove MPILIB_EXTRA
Date: Sun, 09 Feb 2014 21:18:43 +0100
Message-ID: <1391977123.25855.24.camel@x220>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	 <1391971686-9517-6-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1391971686-9517-6-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
> The symbol is an orphan, get rid of it.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Acked-by: Paul Bolle <pebolle@tiscali.nl>

> ---
>  crypto/asymmetric_keys/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
> index 03a6eb9..0320c7d 100644
> --- a/crypto/asymmetric_keys/Kconfig
> +++ b/crypto/asymmetric_keys/Kconfig
> @@ -22,7 +22,6 @@ config ASYMMETRIC_PUBLIC_KEY_SUBTYPE
>  
>  config PUBLIC_KEY_ALGO_RSA
>  	tristate "RSA public-key algorithm"
> -	select MPILIB_EXTRA
>  	select MPILIB
>  	help
>  	  This option enables support for the RSA algorithm (PKCS#1, RFC3447).

I tried this a year ago (see https://lkml.org/lkml/2013/3/8/142 ).


Paul Bolle
