Return-Path: <SRS0=B+FN=SQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DFF3C10F14
	for <linux-crypto@archiver.kernel.org>; Sun, 14 Apr 2019 12:03:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67C932084E
	for <linux-crypto@archiver.kernel.org>; Sun, 14 Apr 2019 12:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726296AbfDNMDr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 14 Apr 2019 08:03:47 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:50378 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726283AbfDNMDr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 14 Apr 2019 08:03:47 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hFdrJ-0000Bi-Of; Sun, 14 Apr 2019 20:03:41 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hFdrG-0002Yg-Hy; Sun, 14 Apr 2019 20:03:38 +0800
Date:   Sun, 14 Apr 2019 20:03:38 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     syzbot <syzbot+6f72c20560060c98b566@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        Ondrej Mosnacek <omosnace@redhat.com>
Subject: crypto: xts - Fix atomic sleep when walking skcipher
Message-ID: <20190414120338.edioq25dkafp2m7h@gondor.apana.org.au>
References: <0000000000002bb2b105867bcd11@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000000000002bb2b105867bcd11@google.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Apr 14, 2019 at 04:26:04AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    e0a092eb Merge branch 'smc-next'
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=139878f3200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=94c460c3e4cd188a
> dashboard link: https://syzkaller.appspot.com/bug?extid=6f72c20560060c98b566
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> 
> Unfortunately, I don't have any reproducer for this crash yet.
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+6f72c20560060c98b566@syzkaller.appspotmail.com
> 
> BUG: sleeping function called from invalid context at crypto/skcipher.c:477
> in_atomic(): 1, irqs_disabled(): 0, pid: 12, name: kworker/0:1
> 2 locks held by kworker/0:1/12:
>  #0: 000000000864d9ff ((wq_completion)crypto){+.+.}, at: __write_once_size
> include/linux/compiler.h:220 [inline]
>  #0: 000000000864d9ff ((wq_completion)crypto){+.+.}, at: arch_atomic64_set
> arch/x86/include/asm/atomic64_64.h:34 [inline]
>  #0: 000000000864d9ff ((wq_completion)crypto){+.+.}, at: atomic64_set
> include/asm-generic/atomic-instrumented.h:855 [inline]
>  #0: 000000000864d9ff ((wq_completion)crypto){+.+.}, at: atomic_long_set
> include/asm-generic/atomic-long.h:40 [inline]
>  #0: 000000000864d9ff ((wq_completion)crypto){+.+.}, at: set_work_data
> kernel/workqueue.c:619 [inline]
>  #0: 000000000864d9ff ((wq_completion)crypto){+.+.}, at:
> set_work_pool_and_clear_pending kernel/workqueue.c:646 [inline]
>  #0: 000000000864d9ff ((wq_completion)crypto){+.+.}, at:
> process_one_work+0x87e/0x1790 kernel/workqueue.c:2240
>  #1: 000000008b3d6218 ((work_completion)(&cpu_queue->work)){+.+.}, at:
> process_one_work+0x8b4/0x1790 kernel/workqueue.c:2244
> Preemption disabled at:
> [<ffffffff830d4130>] local_bh_disable include/linux/bottom_half.h:19
> [inline]
> [<ffffffff830d4130>] cryptd_skcipher_complete+0x90/0x170 crypto/cryptd.c:471
> CPU: 0 PID: 12 Comm: kworker/0:1 Not tainted 5.1.0-rc4+ #135
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS
> Google 01/01/2011
> Workqueue: crypto cryptd_queue_worker
> Call Trace:
>  __dump_stack lib/dump_stack.c:77 [inline]
>  dump_stack+0x172/0x1f0 lib/dump_stack.c:113
>  ___might_sleep.cold+0x1bd/0x1f6 kernel/sched/core.c:6190
>  __might_sleep+0x95/0x190 kernel/sched/core.c:6143
>  skcipher_walk_virt+0x11e/0x150 crypto/skcipher.c:477
>  xor_tweak+0x146/0x350 crypto/xts.c:105
>  xor_tweak_post crypto/xts.c:133 [inline]
>  crypt_done+0x87/0xa0 crypto/xts.c:141
>  cryptd_skcipher_complete+0xbf/0x170 crypto/cryptd.c:472
>  cryptd_skcipher_decrypt+0x2f7/0x420 crypto/cryptd.c:532
>  cryptd_queue_worker+0x126/0x1f0 crypto/cryptd.c:193
>  process_one_work+0x98e/0x1790 kernel/workqueue.c:2269
>  worker_thread+0x98/0xe40 kernel/workqueue.c:2415
>  kthread+0x357/0x430 kernel/kthread.c:253
>  ret_from_fork+0x3a/0x50 arch/x86/entry/entry_64.S:352

Thanks for the report.  Please try this patch:

---8<---
When we perform a walk in the completion function, we need to ensure
that it is atomic.

Reported-by: syzbot+6f72c20560060c98b566@syzkaller.appspotmail.com
Fixes: 78105c7e769b ("crypto: xts - Drop use of auxiliary buffer")
Cc: <stable@vger.kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/xts.c b/crypto/xts.c
index 847f54f76789..c915a45711f5 100644
--- a/crypto/xts.c
+++ b/crypto/xts.c
@@ -88,7 +88,8 @@ static int setkey(struct crypto_skcipher *parent, const u8 *key,
  * mutliple calls to the 'ecb(..)' instance, which usually would be slower than
  * just doing the gf128mul_x_ble() calls again.
  */
-static int xor_tweak(struct skcipher_request *req, bool second_pass)
+static int xor_tweak(struct skcipher_request *req, bool second_pass,
+		     bool atomic)
 {
 	struct rctx *rctx = skcipher_request_ctx(req);
 	struct crypto_skcipher *tfm = crypto_skcipher_reqtfm(req);
@@ -102,7 +103,7 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
 		/* set to our TFM to enforce correct alignment: */
 		skcipher_request_set_tfm(req, tfm);
 	}
-	err = skcipher_walk_virt(&w, req, false);
+	err = skcipher_walk_virt(&w, req, atomic);
 
 	while (w.nbytes) {
 		unsigned int avail = w.nbytes;
@@ -125,12 +126,12 @@ static int xor_tweak(struct skcipher_request *req, bool second_pass)
 
 static int xor_tweak_pre(struct skcipher_request *req)
 {
-	return xor_tweak(req, false);
+	return xor_tweak(req, false, false);
 }
 
-static int xor_tweak_post(struct skcipher_request *req)
+static int xor_tweak_post(struct skcipher_request *req, bool atomic)
 {
-	return xor_tweak(req, true);
+	return xor_tweak(req, true, atomic);
 }
 
 static void crypt_done(struct crypto_async_request *areq, int err)
@@ -138,7 +139,7 @@ static void crypt_done(struct crypto_async_request *areq, int err)
 	struct skcipher_request *req = areq->data;
 
 	if (!err)
-		err = xor_tweak_post(req);
+		err = xor_tweak_post(req, true);
 
 	skcipher_request_complete(req, err);
 }
@@ -166,7 +167,7 @@ static int encrypt(struct skcipher_request *req)
 	init_crypt(req);
 	return xor_tweak_pre(req) ?:
 		crypto_skcipher_encrypt(subreq) ?:
-		xor_tweak_post(req);
+		xor_tweak_post(req, false);
 }
 
 static int decrypt(struct skcipher_request *req)
@@ -177,7 +178,7 @@ static int decrypt(struct skcipher_request *req)
 	init_crypt(req);
 	return xor_tweak_pre(req) ?:
 		crypto_skcipher_decrypt(subreq) ?:
-		xor_tweak_post(req);
+		xor_tweak_post(req, false);
 }
 
 static int init_tfm(struct crypto_skcipher *tfm)
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
