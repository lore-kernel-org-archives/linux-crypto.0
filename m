Return-Path: <SRS0=sLqA=CY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95131C433E2
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 03:30:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 522A0208E4
	for <linux-crypto@archiver.kernel.org>; Tue, 15 Sep 2020 03:30:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726045AbgIODac (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 14 Sep 2020 23:30:32 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:44438 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbgIODac (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 14 Sep 2020 23:30:32 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kI1fk-0005Nq-Gl; Tue, 15 Sep 2020 13:30:25 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Tue, 15 Sep 2020 13:30:24 +1000
Date:   Tue, 15 Sep 2020 13:30:24 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [PATCH] crypto: lib/chacha20poly1305 - Set SG_MITER_ATOMIC
 unconditionally
Message-ID: <20200915033024.GB25789@gondor.apana.org.au>
References: <20200914204209.256266093@linutronix.de>
 <CAHk-=win80rdof8Pb=5k6gT9j_v+hz-TQzKPVastZDvBe9RimQ@mail.gmail.com>
 <871rj4owfn.fsf@nanos.tec.linutronix.de>
 <CAHk-=wj0eUuVQ=hRFZv_nY7g5ZLt7Fy3K7SMJL0ZCzniPtsbbg@mail.gmail.com>
 <CAHk-=wjOV6f_ddg+QVCF6RUe+pXPhSR2WevnNyOs9oT+q2ihEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjOV6f_ddg+QVCF6RUe+pXPhSR2WevnNyOs9oT+q2ihEA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I trimmed the cc as the mailing lists appear to be blocking this
email because of it.

On Mon, Sep 14, 2020 at 03:37:49PM -0700, Linus Torvalds wrote:
>
> So it _looks_ like this code started using kmap() - probably back when
> kmap_atomic() was so cumbersome to use - and was then converted
> (conditionally) to kmap_atomic() rather than just changed whole-sale.
> Is there actually something that wants to use those sg_miter functions
> and sleep?

I dug up the old zinc patch submissions and this wasn't present at
all in the original.  The original zinc code used blkcipher_walk
which unconditinoally does kmap_atomic.

So it's only the SG miter conversion that introduced this change,
which appears to be a simple oversight (I think Ard was working on
latency issues at that time, perhaps he was worried about keeping
preemption off unnecessarily).

---8<---
There is no reason for the chacha20poly1305 SG miter code to use
kmap instead of kmap_atomic as the critical section doesn't sleep
anyway.  So we can simply get rid of the preemptible check and
set SG_MITER_ATOMIC unconditionally.

Even if we need to reenable preemption to lower latency we should
be doing that by interrupting the SG miter walk rather than using
kmap.

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/lib/crypto/chacha20poly1305.c b/lib/crypto/chacha20poly1305.c
index 431e04280332..5850f3b87359 100644
--- a/lib/crypto/chacha20poly1305.c
+++ b/lib/crypto/chacha20poly1305.c
@@ -251,9 +251,7 @@ bool chacha20poly1305_crypt_sg_inplace(struct scatterlist *src,
 			poly1305_update(&poly1305_state, pad0, 0x10 - (ad_len & 0xf));
 	}
 
-	flags = SG_MITER_TO_SG;
-	if (!preemptible())
-		flags |= SG_MITER_ATOMIC;
+	flags = SG_MITER_TO_SG | SG_MITER_ATOMIC;
 
 	sg_miter_start(&miter, src, sg_nents(src), flags);
 
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
