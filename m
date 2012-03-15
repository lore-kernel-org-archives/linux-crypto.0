From: Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 2/2] crypto: twofish-x86_64-3way - module init/exit functions
 should be static
Date: Thu, 15 Mar 2012 15:49:41 -0700
Message-ID: <4F627205.4070606@xenotime.net>
References: <4F620F37.4070404@xenotime.net> <20120315201157.11667.30754.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Return-path: <linux-next-owner@vger.kernel.org>
In-Reply-To: <20120315201157.11667.30754.stgit@localhost6.localdomain6>
Sender: linux-next-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 03/15/2012 01:11 PM, Jussi Kivilinna wrote:

> This caused conflict with camellia-x86_64 when compiled into kernel, same
> function names and not static.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  arch/x86/crypto/twofish_glue_3way.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
> index 408fc0c..922ab24 100644
> --- a/arch/x86/crypto/twofish_glue_3way.c
> +++ b/arch/x86/crypto/twofish_glue_3way.c
> @@ -668,7 +668,7 @@ static int force;
>  module_param(force, int, 0);
>  MODULE_PARM_DESC(force, "Force module load, ignore CPU blacklist");
>  
> -int __init init(void)
> +static int __init init(void)
>  {
>  	if (!force && is_blacklisted_cpu()) {
>  		printk(KERN_INFO
> @@ -681,7 +681,7 @@ int __init init(void)
>  	return crypto_register_algs(tf_algs, ARRAY_SIZE(tf_algs));
>  }
>  
> -void __exit fini(void)
> +static void __exit fini(void)
>  {
>  	crypto_unregister_algs(tf_algs, ARRAY_SIZE(tf_algs));
>  }
> 



-- 
~Randy
