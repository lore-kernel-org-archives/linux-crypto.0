From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [PATCH 1/1] Crypto: [xp ]cbc: use 64bit regs on 64bit machines (rev. 2)
Date: Sat, 23 Jun 2007 00:44:06 +0200
Message-ID: <20070622224406.GA29941@Chamillionaire.breakpoint.cc>
References: <20070614122900.GA7286@Chamillionaire.breakpoint.cc> <20070622124130.GB30017@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:37678 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750939AbXFVWoI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 22 Jun 2007 18:44:08 -0400
Content-Disposition: inline
In-Reply-To: <20070622124130.GB30017@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Herbert Xu | 2007-06-22 20:41:30 [+0800]:

>On Thu, Jun 14, 2007 at 12:29:00PM +0000, Sebastian Siewior wrote:
>> 
>> Maybe my computer is just as tired as I am. In general I thing 64bit
>> registers should be prefered.
>> 
>> Signed-off-by: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
>
>OK this makes sense.  However you need to make sure that alignmask
>is set appropriately (i.e., at least 8/16).

I don't thing I understand. Why do I have to change the alignmask for
the xor operation? I guess you are talking about crypto_cbc_alloc()

|if (!(alg->cra_blocksize % 4))
|        inst->alg.cra_alignmask |= 3;

don't you?
Since this (also) changes the alignment of in+out data I would prefer not
to. The speed up you gain from less xors is probably less than what you
spent on additional kmap()/memcpy()/kmalloc() in case the data is %4 but
not %5.

>Cheers,
Sebastian
