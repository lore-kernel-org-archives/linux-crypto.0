From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: api - Change crypto_unregister_instance argument type
Date: Thu, 02 Apr 2015 17:13:23 +0200
Message-ID: <8420276.vapgpo2qik@tauon>
References: <20150402143122.GA9699@gondor.apana.org.au> <2597941.K7IMfLeYM0@tauon> <20150402145911.GA10227@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58121 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449AbbDBPN0 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Apr 2015 11:13:26 -0400
In-Reply-To: <20150402145911.GA10227@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Donnerstag, 2. April 2015, 22:59:11 schrieb Herbert Xu:

Hi Herbert,

>On Thu, Apr 02, 2015 at 04:54:03PM +0200, Stephan Mueller wrote:
>> >@@ -316,7 +316,7 @@ static int crypto_del_alg(struct sk_buff *skb, struct
>> >nlmsghdr *nlh, if (atomic_read(&alg->cra_refcnt) != 1)
>> >
>> > 		return -EBUSY;
>> >
>> >-	return crypto_unregister_instance(alg);
>> >+	return crypto_unregister_instance((struct crypto_instance *)alg);
>> 
>> Instead of using type casts, isn't container_of() a cleaner way (and
>> hopefully a safer way) of casting?
>
>Actually no that would only make sense if every alg sat within
>an instance which is not the case.  So I don't think using that
>would buy us much clarity.

In crypto_remove_instance, the code dereferences inst->tmpl. If you say that 
it is not guaranteed that the alg is always wrapped by an inst, wouldn't we 
have a potential invalid pointer?
>
>Thanks,


Ciao
Stephan
