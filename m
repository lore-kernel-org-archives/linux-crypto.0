Return-Path: <SRS0=xIDj=ZV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5223C432C0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 08:40:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96E8921781
	for <linux-crypto@archiver.kernel.org>; Fri, 29 Nov 2019 08:40:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726360AbfK2Ikd (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 Nov 2019 03:40:33 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:59734 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725886AbfK2Ikd (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 Nov 2019 03:40:33 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iabpE-00011i-Sn; Fri, 29 Nov 2019 16:40:28 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iabpA-00060T-N4; Fri, 29 Nov 2019 16:40:24 +0800
Date:   Fri, 29 Nov 2019 16:40:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Daniel Jordan <daniel.m.jordan@oracle.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH] crypto: pcrypt - Do not clear MAY_SLEEP flag in original
 request
Message-ID: <20191129084024.arwefx7bpvvxpyjk@gondor.apana.org.au>
References: <20191119130556.dso2ni6qlks3lr23@gondor.apana.org.au>
 <20191119173732.GB819@sol.localdomain>
 <20191119185827.nerskpvddkcsih25@gondor.apana.org.au>
 <20191126053238.yxhtfbt5okcjycuy@ca-dmjordan1.us.oracle.com>
 <20191126075845.2v3woc3xqx2fxzqh@gondor.apana.org.au>
 <20191127191452.GC49214@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191127191452.GC49214@sol.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Nov 27, 2019 at 11:14:52AM -0800, Eric Biggers wrote:
>
> I tried applying the following patches and running syzkaller again:
> 
> 	padata: Remove unused padata_remove_cpu
> 	padata: Remove broken queue flushing
> 	crypto: pcrypt - Fix user-after-free on module unload
> 	[v3] crypto: pcrypt - Avoid deadlock by using per-instance padata queues
> 
> This time I got a crypto self-test failure when
> "pcrypt(pcrypt(rfc4106-gcm-aesni))" was instantiated:
> 
> [ 2220.165113] alg: aead: pcrypt(pcrypt(rfc4106-gcm-aesni)) encryption corrupted request struct on test vector 0, cfg="uneven misaligned splits, may sleep"
> [ 2220.170295] alg: aead: changed 'req->base.flags'
> [ 2220.171799] Kernel panic - not syncing: alg: self-tests for pcrypt(pcrypt(rfc4106-gcm-aesni)) (rfc4106(gcm(aes))) failed in panic_on_fail mode!
> 
> So the algorithm is not preserving aead_request::base.flags.

Thanks for the report.  This is a preexisting bug in pcrypt.  Here
is a patch for it.

---8<---
We should not be modifying the original request's MAY_SLEEP flag
upon completion.  It makes no sense to do so anyway.

Reported-by: Eric Biggers <ebiggers@kernel.org>
Fixes: 5068c7a883d1 ("crypto: pcrypt - Add pcrypt crypto...")
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index 543792e0ebf0..2f6f81183e45 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -63,7 +63,6 @@ static void pcrypt_aead_done(struct crypto_async_request *areq, int err)
 	struct padata_priv *padata = pcrypt_request_padata(preq);
 
 	padata->info = err;
-	req->base.flags &= ~CRYPTO_TFM_REQ_MAY_SLEEP;
 
 	padata_do_serial(padata);
 }
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
