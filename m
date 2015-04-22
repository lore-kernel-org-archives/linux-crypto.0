From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: crypto: api - Move module sig ifdef into accessor function
Date: Wed, 22 Apr 2015 16:29:16 +0930
Message-ID: <87pp6wodh7.fsf@rustcorp.com.au>
References: <20150422032846.GA6798@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150422032846.GA6798@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Herbert Xu <herbert@gondor.apana.org.au> writes:
> Currently we're hiding mod->sig_ok under an ifdef in open code.
> This patch adds a module_sig_ok accessor function and removes that
> ifdef.
>     
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Did you want me to take this via modules-next?  Assuming not.

So:
        Acked-by: Rusty Russell <rusty@rustcorp.com.au>

Thanks,
Rusty.

> diff --git a/crypto/algapi.c b/crypto/algapi.c
> index 8057c9f..c63836f 100644
> --- a/crypto/algapi.c
> +++ b/crypto/algapi.c
> @@ -44,12 +44,9 @@ static inline int crypto_set_driver_name(struct crypto_alg *alg)
>  
>  static inline void crypto_check_module_sig(struct module *mod)
>  {
> -#ifdef CONFIG_CRYPTO_FIPS
> -	if (fips_enabled && mod && !mod->sig_ok)
> +	if (fips_enabled && mod && !module_sig_ok(mod))
>  		panic("Module %s signature verification failed in FIPS mode\n",
>  		      mod->name);
> -#endif
> -	return;
>  }
>  
>  static int crypto_check_alg(struct crypto_alg *alg)
> diff --git a/include/linux/module.h b/include/linux/module.h
> index c883b86..1e54360 100644
> --- a/include/linux/module.h
> +++ b/include/linux/module.h
> @@ -655,4 +655,16 @@ static inline void module_bug_finalize(const Elf_Ehdr *hdr,
>  static inline void module_bug_cleanup(struct module *mod) {}
>  #endif	/* CONFIG_GENERIC_BUG */
>  
> +#ifdef CONFIG_MODULE_SIG
> +static inline bool module_sig_ok(struct module *module)
> +{
> +	return module->sig_ok;
> +}
> +#else	/* !CONFIG_MODULE_SIG */
> +static inline bool module_sig_ok(struct module *module)
> +{
> +	return true;
> +}
> +#endif	/* CONFIG_MODULE_SIG */
> +
>  #endif /* _LINUX_MODULE_H */
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
