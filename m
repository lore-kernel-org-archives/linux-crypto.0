From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH] [crypto] XTS: use proper alignment.
Date: Wed, 5 Mar 2008 12:46:52 +0100
Message-ID: <20080305114652.GA18070@Chamillionaire.breakpoint.cc>
References: <20080302135135.GC16659@Chamillionaire.breakpoint.cc> <958c4032ba3b28931dea586d0338bf1ec1594659.1204465942.git.sebastian@breakpoint.cc> <20080305111602.GB27552@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org,
	Stefan Hellermann <stefan@the2masters.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:48022 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759677AbYCELqy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Mar 2008 06:46:54 -0500
Content-Disposition: inline
In-Reply-To: <20080305111602.GB27552@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Herbert Xu | 2008-03-05 19:16:02 [+0800]:

>> +struct sinfo {
>> +	be128 t;
>> +	struct crypto_tfm *tfm;
>> +	void (*fn)(struct crypto_tfm *, u8 *, const u8 *);
>> +};
>> +
>>  struct priv {
>> +	/* s.t being the first member in this struct enforces proper alignment
>> +	 * required by the underlying cipher without explicit knowing the it.
>> +	 */
>> +	struct sinfo s;
>
>tfm objects should be reentrant so you can't store any per-op
>info in the context structure.
I could also do kmalloc(), align() and kfree() after encrypt but this
was faster.

>
>> -	tw(crypto_cipher_tfm(ctx->tweak), (void *)&s.t, w->iv);
>> +	tw(crypto_cipher_tfm(ctx->tweak), (void *)&s->t, w->iv);
>
>However, the real question is why do we need this at all? The
>tw argument should be using the proper entry points that do
>copying for you if necessary.
>
>OK, I see that the issue is that we're using cia_encrypt instead
>of cit_encrypt_one.  So if we just change that then it should work
>correctly.
I'm not sure if we are allowed to modify the IV or if it should
remain untouched. If it is possible to modify it, I could encrypt it
inplace and save two memcpy().
I will check this tonight.

>
>Cheers,
Sebastian
