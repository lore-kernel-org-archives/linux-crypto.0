From: Eric Biggers <ebiggers3@gmail.com>
Subject: Re: general protection fault in af_alg_free_areq_sgls
Date: Tue, 28 Nov 2017 01:02:52 -0800
Message-ID: <20171128090252.GB23413@zzz.localdomain>
References: <001a1140f578d9710d055efb76a9@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Stephan Mueller <smueller@chronox.de>
To: syzbot
        <bot+ff72ab869817b6ea60bc570f638ee030f4fc73e5@syzkaller.appspotmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:42357 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750907AbdK1JCz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Nov 2017 04:02:55 -0500
Content-Disposition: inline
In-Reply-To: <001a1140f578d9710d055efb76a9@google.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Nov 27, 2017 at 10:56:47AM -0800, syzbot wrote:
> Hello,
> 
> syzkaller hit the following crash on
> b0a84f19a5161418d4360cd57603e94ed489915e
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> compiler: gcc (GCC) 7.1.1 20170620
> .config is attached
> Raw console output is attached.
> 
> Unfortunately, I don't have any reproducer for this bug yet.
> 

This was probably caused by taking the path where areq->tsgl could not be
allocated.  (syzkaller probably reached it after injecting a memory allocation
failure.)  The following should fix it:

---8<---

>From 1a7a7f86f09c50652f1fff75b8d3a32712826b32 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Tue, 28 Nov 2017 00:46:24 -0800
Subject: [PATCH] crypto: af_alg - fix NULL pointer dereference in
 af_alg_free_areq_sgls()

If allocating the ->tsgl member of 'struct af_alg_async_req' failed,
during cleanup we dereferenced the NULL ->tsgl pointer in
af_alg_free_areq_sgls(), because ->tsgl_entries was nonzero.

Fix it by only freeing the ->tsgl list if it is non-NULL.

This affected both algif_skcipher and algif_aead.

Fixes: e870456d8e7c ("crypto: algif_skcipher - overhaul memory management")
Fixes: d887c52d6ae4 ("crypto: algif_aead - overhaul memory management")
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: <stable@vger.kernel.org> # v4.14+
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/af_alg.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 358749c38894..415a54ced4d6 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -672,14 +672,15 @@ void af_alg_free_areq_sgls(struct af_alg_async_req *areq)
 	}
 
 	tsgl = areq->tsgl;
-	for_each_sg(tsgl, sg, areq->tsgl_entries, i) {
-		if (!sg_page(sg))
-			continue;
-		put_page(sg_page(sg));
-	}
+	if (tsgl) {
+		for_each_sg(tsgl, sg, areq->tsgl_entries, i) {
+			if (!sg_page(sg))
+				continue;
+			put_page(sg_page(sg));
+		}
 
-	if (areq->tsgl && areq->tsgl_entries)
 		sock_kfree_s(sk, tsgl, areq->tsgl_entries * sizeof(*tsgl));
+	}
 }
 EXPORT_SYMBOL_GPL(af_alg_free_areq_sgls);
 
-- 
2.15.0
