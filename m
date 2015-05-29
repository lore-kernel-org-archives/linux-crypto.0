From: Stephan Mueller <smueller@chronox.de>
Subject: Re: crypto: algif_aead - Switch to new AEAD interface
Date: Fri, 29 May 2015 16:50:50 +0200
Message-ID: <4167986.EDUjNpGSba@tauon>
References: <20150527092441.GA27913@gondor.apana.org.au> <2444206.rbm5Z3UBF9@tachyon.chronox.de> <20150529132840.GA20596@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58349 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755331AbbE2OvD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 29 May 2015 10:51:03 -0400
In-Reply-To: <20150529132840.GA20596@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Freitag, 29. Mai 2015, 21:28:40 schrieb Herbert Xu:

Hi Herbert,

>On Fri, May 29, 2015 at 12:09:35PM +0200, Stephan Mueller wrote:
>> > -	return (ctx->used >= (ctx->aead_assoclen + (ctx->enc ? 0 : as)));
>> > +	return ctx->used >= ctx->aead_assoclen + as;
>> 
>> This change requires that the buffer handed in by user space always has
>> room
>> for the tag, regardless whether it is needed or not. Is that intended?
>
>Yes for two reasons.  One is that sometimes we need to enforce
>in-place processing, in which case dst must be at least as big
>as src.  The other reason is to eventually allow in-place processing
>through algif_aead.  Unless the two SG lists were of the same length,
>it isn't possible to do that.

Do we really need to copy in and copy out unneeded data? That sounds very 
inefficient. Besides, can't we leave it to user space to build the right 
memory structure? I.e. if user space wants in-place operation, it needs to 
ensure that the one buffer is sufficient for the requested operation (i.e. 
that the requirements for src lengths and dst lengths are covered).

>> However, when use those changes and I perform the test of
>> libkcapi/test/kcapi -y -s, I get the following strange crash which i have
>> no idea where to look for the cause (normal sendmsg and vmsplice tests
>> with libkcapi/test/kcapi -y and libkcapi/test/kcapi -y -v work flawless)
>
>This is clearly not good.  It looks like memory corruption.

It seems it is triggered by my change suggestions. It is triggered in the 
while() loop in the recvmsg when allocating an output buffer larger than 16 
pages. So, this is nothing in the current upstream code.


Ciao
Stephan
