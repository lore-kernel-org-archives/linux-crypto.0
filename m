From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] algif_skcipher: Avoid crash if buffer is not multiple of cipher block size
Date: Mon, 29 Oct 2012 14:04:21 +0100
Message-ID: <1351515861-3596-1-git-send-email-mbroz@redhat.com>
Cc: Milan Broz <mbroz@redhat.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756512Ab2J2NEY (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 29 Oct 2012 09:04:24 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id q9TD4OWk015828
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-crypto@vger.kernel.org>; Mon, 29 Oct 2012 09:04:24 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

When user requests encryption (or decryption) of block which
is not aligned to cipher block size, an OOps like this can happen:

[   37.672185] BUG: unable to handle kernel paging request at e1c5fbc0
[   37.672457] IP: [<c1214393>] scatterwalk_done+0x53/0x70
...
[   37.679183] Call Trace:
[   37.679326]  [<c1216cf0>] blkcipher_walk_done+0x160/0x1e0
[   37.679516]  [<c1217088>] blkcipher_walk_next+0x318/0x3c0
[   37.679707]  [<c1007f1c>] ? native_sched_clock+0x2c/0xb0
[   37.679895]  [<c12171a0>] blkcipher_walk_first+0x70/0x160
[   37.680082]  [<c12172e7>] blkcipher_walk_virt+0x17/0x20
[   37.680272]  [<e0a36249>] cbc_encrypt+0x29/0x100 [aesni_intel]
[   37.680472]  [<c1029403>] ? get_user_pages_fast+0x123/0x150
[   37.680665]  [<c106e9fb>] ? trace_hardirqs_on+0xb/0x10
[   37.680851]  [<e083a1c9>] __ablk_encrypt+0x39/0x40 [ablk_helper]
[   37.681052]  [<e083a1ea>] ablk_encrypt+0x1a/0x70 [ablk_helper]
[   37.681250]  [<e0de95ac>] skcipher_recvmsg+0x20c/0x400 [algif_skcipher]
[   37.681474]  [<c1346897>] ? sock_kfree_s+0x17/0x30
[   37.681652]  [<c1344bc4>] sock_aio_read+0x104/0x140
[   37.681834]  [<c10d2637>] do_sync_read+0x97/0xd0
[   37.682009]  [<c10d2f1d>] vfs_read+0x11d/0x140
[   37.682183]  [<c1346213>] ? sys_socketcall+0x2a3/0x320
[   37.682366]  [<c10d2f82>] sys_read+0x42/0x90
[   37.682597]  [<c1403afa>] sysenter_do_call+0x12/0x32

Patch fixes it by simply rejecting buffer which is not multiple of cipher block.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 crypto/algif_skcipher.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
index 6a6dfc0..5f7713b 100644
--- a/crypto/algif_skcipher.c
+++ b/crypto/algif_skcipher.c
@@ -463,7 +463,7 @@ static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock,
 				used -= used % bs;
 
 			err = -EINVAL;
-			if (!used)
+			if (!used || used % bs)
 				goto free;
 
 			ablkcipher_request_set_crypt(&ctx->req, sg,
-- 
1.7.10.4
