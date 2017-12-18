From: Li Kun <hw.likun@huawei.com>
Subject: [PATCH RESEND] crypto: af_alg - add keylen checking to avoid NULL ptr passing down
Date: Mon, 18 Dec 2017 13:40:36 +0000
Message-ID: <1513604436-43814-1-git-send-email-hw.likun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:2731 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1758598AbdLRNtk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Dec 2017 08:49:40 -0500
Received: from DGGEMS402-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 9DEB1F56713C4
        for <linux-crypto@vger.kernel.org>; Mon, 18 Dec 2017 21:49:25 +0800 (CST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

alg_setkey do not check the keylen whether it is zero, so the key
may be ZERO_SIZE_PTR when keylen is 0, which will pass the
copy_from_user's checking and be passed to the lower functions as key.

If the lower functions only check the key if it is NULL, ZERO_SIZE_PTR
will pass the checking, and will cause null ptr dereference, so it's
better to intercept the invalid parameters in the upper functions.

This patch is also suitable to fix CVE-2017-15116 for stable trees.

Signed-off-by: Li Kun <hw.likun@huawei.com>
Cc: stable@vger.kernel.org
---
 crypto/af_alg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 337cf38..10f22f3 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -210,6 +210,8 @@ static int alg_setkey(struct sock *sk, char __user *ukey,
 	u8 *key;
 	int err;
 
+	if (!keylen)
+		return -EINVAL;
 	key = sock_kmalloc(sk, keylen, GFP_KERNEL);
 	if (!key)
 		return -ENOMEM;
-- 
1.8.3.4
