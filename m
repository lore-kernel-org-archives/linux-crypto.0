From: James Yonan <james@openvpn.net>
Subject: Re: race condition in crypto larval handling
Date: Sun, 08 Sep 2013 19:41:23 -0600
Message-ID: <522D2743.9060802@openvpn.net>
References: <CAGXu5jJvuAC3paV5k_bmoHHrHVgc0Hi6ShSDk3iQUt1Lf0cioQ@mail.gmail.com> <20130908013210.GA30627@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: unlisted-recipients:; (no To-header on input)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from magnetar.openvpn.net ([74.52.27.18]:43119 "EHLO
	magnetar.openvpn.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab3IIBlZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 8 Sep 2013 21:41:25 -0400
Received: from moab.lan (c-24-9-78-222.hsd1.co.comcast.net [24.9.78.222])
	(authenticated bits=0)
	by magnetar.openvpn.net (8.13.1/8.13.1) with ESMTP id r891fIXg000698
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-crypto@vger.kernel.org>; Sun, 8 Sep 2013 19:41:19 -0600
In-Reply-To: <20130908013210.GA30627@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/09/2013 19:32, Herbert Xu wrote:
> On Fri, Sep 06, 2013 at 04:20:50PM -0700, Kees Cook wrote:
>>
>> In the two-thread situation, the first thread gets a larval with
>> refcnt 2 via crypto_larval_add. (Why 2?) The next thread finds the
>> larval via crypto_larval_add's call to __crypto_alg_lookup() and sees
>> the ref bump to 3. While exiting crypto_alg_mod_lookup, each thread
>> decrements the ref count twice.
>>
>> It seems to me like either each call to crypto_larval_lookup() should
>> result in a refcount bumped by two, or crypto_alg_mod_lookup() should
>> decrement only once, and the initial refcount should be 1 not 2 from
>> crypto_larval_add. But it's not clear to me which is sensible here.
>>
>> What's the right solution here?
>
> First of all thanks a lot for tracking this problem down! It's
> been bothering me for months but I was unable to find a good
> reproducer.
>
> So now that you've identified the problem, the solution is easy.
> crypto_larval_lookup should only ever return a larval if it created
> one.  Any larval created earlier must be waited on first before we
> return.
>
> So does this patch fix the crash for you?
>
> diff --git a/crypto/api.c b/crypto/api.c
> index 320ea4d..a2b39c5 100644
> --- a/crypto/api.c
> +++ b/crypto/api.c
> @@ -34,6 +34,8 @@ EXPORT_SYMBOL_GPL(crypto_alg_sem);
>   BLOCKING_NOTIFIER_HEAD(crypto_chain);
>   EXPORT_SYMBOL_GPL(crypto_chain);
>
> +static struct crypto_alg *crypto_larval_wait(struct crypto_alg *alg);
> +
>   struct crypto_alg *crypto_mod_get(struct crypto_alg *alg)
>   {
>   	return try_module_get(alg->cra_module) ? crypto_alg_get(alg) : NULL;
> @@ -144,8 +146,11 @@ static struct crypto_alg *crypto_larval_add(const char *name, u32 type,
>   	}
>   	up_write(&crypto_alg_sem);
>
> -	if (alg != &larval->alg)
> +	if (alg != &larval->alg) {
>   		kfree(larval);
> +		if (crypto_is_larval(alg))
> +			alg = crypto_larval_wait(alg);
> +	}
>
>   	return alg;
>   }

I tried this patch, but I still see an apparent module lookup/load race 
if code on several CPUs calls crypto_alloc_aead at the same time, and an 
external module such as aes needs to be loaded.

Seeing this in the log: "request_module: runaway loop modprobe gcm(aes)"

Shouldn't module lookup/load be bracketed by some sort of lock to 
prevent this?

James
