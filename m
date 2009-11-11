From: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: Bug in geode-aes.c ?
Date: Wed, 11 Nov 2009 23:08:32 +0100
Message-ID: <20091111220832.GC18452@Chamillionaire.breakpoint.cc>
References: <aa09d86e0911100600x79617b85je8e4bd52df37b0a3@mail.gmail.com>
Reply-To: Sebastian Andrzej Siewior <linux-crypto@ml.breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Sergey Mironov <ierton@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:42698 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758868AbZKKWI1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 11 Nov 2009 17:08:27 -0500
Content-Disposition: inline
In-Reply-To: <aa09d86e0911100600x79617b85je8e4bd52df37b0a3@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Sergey Mironov | 2009-11-10 17:00:31 [+0300]:

> 116 static int geode_setkey_cip(struct crypto_tfm *tfm, const u8 *key,
> 117                 unsigned int len)
> 118 {
>...
>
>/** BUG? Should it be 'op->fallback.cip' instead of 'op->fallback.blk' ?  **/
>
> 138         op->fallback.blk->base.crt_flags &= ~CRYPTO_TFM_REQ_MASK;
> 139         op->fallback.blk->base.crt_flags |= (tfm->crt_flags &
>CRYPTO_TFM_REQ_MASK);
>
>...
>
> 144                 tfm->crt_flags |=
>(op->fallback.blk->base.crt_flags & CRYPTO_TFM_RES_MASK);
> 145         }
> 146         return ret;

Yup, good catch. It has to be cip instead of blk. I've copy/pasted it
and the same bug is in s390's crypto driver. No one noticed it because
both structs are equal, just the name / type is different.
Do you mind sending a patch?

Sebastian
