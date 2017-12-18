From: Li Kun <hw.likun@huawei.com>
Subject: [PATCH] crypto: af_alg - add keylen checking to avoid NULL ptr passing down
Date: Mon, 18 Dec 2017 11:09:23 +0000
Message-ID: <1513595363-27577-1-git-send-email-hw.likun@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: <stable@vger.kernel.org>
To: <linux-crypto@vger.kernel.org>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

alg_setkey do not check the keylen whether it is zero, so the key
may be ZERO_SIZE_PTR when keylen is 0, which will pass the
copy_from_user's checking and be passed to the lower functions as key.

If the lower functions only check the key if it is NULL, ZERO_SIZE_PTR
will pass the checking, and will cause null ptr dereference, so it's
better to intercept the invalid parameters in the upper functions.

This patch is also suitable to fix CVE-2017-15116 for stable trees.

Signed-off-by: Li Kun <hw.likun@huawei.com>
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
