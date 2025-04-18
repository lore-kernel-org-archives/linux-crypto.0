Received: from forward100b.mail.yandex.net (forward100b.mail.yandex.net [178.154.239.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D6141C5485
	for <linux-crypto@vger.kernel.org>; Fri, 18 Apr 2025 10:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744970601; cv=none; b=ZPTCEG9aGWxXmzoBcYBssmVz+8URYEJa1jdlokG+sDjkEGXKkXPgjzomKJ8OuZxy0TNjUZWKl/A+h8/7vLp9HyZKJ3Q+QPypS+5ILplZil8npEJvQlwTgb8XgQYfOQ/MOgAAsLuBLVW4zIR/+UaO2Byq0zEwmh1HJ3543ojExbg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744970601; c=relaxed/simple;
	bh=JE9mJJIrnNI4PqURikbFnd//W/A2WpDYEbwa99vBCT4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IOXRA7AanHm+3Xe8eY3yFC7ulZpbU+9fDFmqtiqbwJxX9q1XHdZE7UhtUWj/th8ve8lv8BU8g8Qz0JUASuHwUv7lnzrQRPAkvP2Jv0WHbp11TukjT6+eLkZ/+T9A7yqV5akqVHUJKfwoMNOKdklqhRU9pXuTBRnbN9XkPj8Lbxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=UonzzgAR; arc=none smtp.client-ip=178.154.239.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="UonzzgAR"
Received: from mail-nwsmtp-smtp-production-main-91.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-91.sas.yp-c.yandex.net [IPv6:2a02:6b8:c1e:3990:0:640:808c:0])
	by forward100b.mail.yandex.net (Yandex) with ESMTPS id 7B8F460D1E;
	Fri, 18 Apr 2025 13:03:09 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-91.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id 73H724qLgqM0-l7FR3Fkl;
	Fri, 18 Apr 2025 13:03:09 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1744970589; bh=jgn7k3K4UWAHxu94tiegkEH+T7uHzPfDRJlEWr2a6NU=;
	h=Message-ID:Date:Cc:Subject:To:From;
	b=UonzzgAR+1QjUvJZ7kgctxyeNT0g69284m3Gy+2Jc1G8yce9jJyXuAE2nmn5zD9cC
	 nmfSq84i9J5MbK2SM54foGZ1/5lTIlJZZ27ZhOgLNnxD+Gly3SMktD/sbH7+kBbiW9
	 5tr68r6pAKoVSdyHLAU/bkt03cGwHCzbU//Ge04Y=
Authentication-Results: mail-nwsmtp-smtp-production-main-91.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
From: Dmitry Antipov <dmantipov@yandex.ru>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org,
	Dmitry Antipov <dmantipov@yandex.ru>
Subject: [PATCH] crypto: acomp: fix memory leaks caused by chained requests
Date: Fri, 18 Apr 2025 13:02:29 +0300
Message-ID: <20250418100229.9868-1-dmantipov@yandex.ru>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Running 6.15.0-rc2 with kmemleak enabled, I've noticed 45
memory leaks looks like the following:

unreferenced object 0xffff888114032a00 (size 256):
  comm "cryptomgr_test", pid 246, jiffies 4294668840
  hex dump (first 32 bytes):
    00 20 03 14 81 88 ff ff 00 da 02 14 81 88 ff ff  . ..............
    90 ca 54 9b ff ff ff ff c8 fb a6 00 00 c9 ff ff  ..T.............
  backtrace (crc cd58738d):
    __kmalloc_noprof+0x272/0x520
    alg_test_comp+0x74e/0x1b60
    alg_test+0x3f0/0xc40
    cryptomgr_test+0x47/0x80
    kthread+0x4e1/0x620
    ret_from_fork+0x37/0x70
    ret_from_fork_asm+0x1a/0x30

These leaks comes from 'test_acomp()' where an extra requests chained to
the head one (e.g. 'reqs[0]') are never freed. Fix this by unchaining
and freeing such an extra requests in 'acomp_request_free()'.

(I'm new to this subsystem and not sure about Fixes: tag BTW).

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
---
 include/crypto/acompress.h | 28 ++++++++++++++++++++++------
 include/linux/crypto.h     |  5 +++++
 2 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
index c497c73baf13..d7de4cbccd60 100644
--- a/include/crypto/acompress.h
+++ b/include/crypto/acompress.h
@@ -310,6 +310,20 @@ static inline void *acomp_request_extra(struct acomp_req *req)
 	return (void *)((char *)req + len);
 }
 
+static inline void acomp_request_chain(struct acomp_req *req,
+				       struct acomp_req *head)
+{
+	crypto_request_chain(&req->base, &head->base);
+}
+
+static inline void acomp_request_unchain(struct acomp_req *req)
+{
+	crypto_request_unchain(&req->base);
+}
+
+#define acomp_request_for_each(this, tmp, head) \
+	list_for_each_entry_safe((this), (tmp), &(head)->base.list, base.list)
+
 /**
  * acomp_request_free() -- zeroize and free asynchronous (de)compression
  *			   request as well as the output buffer if allocated
@@ -319,8 +333,16 @@ static inline void *acomp_request_extra(struct acomp_req *req)
  */
 static inline void acomp_request_free(struct acomp_req *req)
 {
+	struct acomp_req *this, *tmp;
+
 	if (!req || (req->base.flags & CRYPTO_TFM_REQ_ON_STACK))
 		return;
+
+	acomp_request_for_each(this, tmp, req) {
+		acomp_request_unchain(this);
+		kfree_sensitive(this);
+	}
+
 	kfree_sensitive(req);
 }
 
@@ -558,12 +580,6 @@ static inline void acomp_request_set_dst_folio(struct acomp_req *req,
 	req->base.flags |= CRYPTO_ACOMP_REQ_DST_FOLIO;
 }
 
-static inline void acomp_request_chain(struct acomp_req *req,
-				       struct acomp_req *head)
-{
-	crypto_request_chain(&req->base, &head->base);
-}
-
 /**
  * crypto_acomp_compress() -- Invoke asynchronous compress operation
  *
diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 1e3809d28abd..3e12bcee1497 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -486,6 +486,11 @@ static inline void crypto_request_chain(struct crypto_async_request *req,
 	list_add_tail(&req->list, &head->list);
 }
 
+static inline void crypto_request_unchain(struct crypto_async_request *req)
+{
+	list_del(&req->list);
+}
+
 static inline bool crypto_tfm_is_async(struct crypto_tfm *tfm)
 {
 	return tfm->__crt_alg->cra_flags & CRYPTO_ALG_ASYNC;
-- 
2.49.0

