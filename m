Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DAB4256C6D
	for <linux-crypto@vger.kernel.org>; Sat,  2 May 2026 13:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777728316; cv=none; b=PLr1w1zZzheLiiL3AznmGDYWhiYLISQaFfCKXiqHxb3yqa/9XB8LIM6t0cJ7VqqXMaMLfiPAOnn3CKSHVyvzmmGEb4eDavMpFv8ShB0WTeCSNmT8wfGtQFfbJ98IxjSL+CB2EZRcJqPSOxC3o/pvcEXXjTPHCKwdGWnR/ekrZls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777728316; c=relaxed/simple;
	bh=kH62rsUaAss0NtHCfCwEnwUM3x0gdN/omUvzry1yAtw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=i78E6QP2hsuwJqZpWnRyxxCAW+XqyddxVJigGYCQ0ya9/nzuzo61sWSE/TqhcLiqSQMpYRZu9peYe6te9xdXyO8p4NMAtb8HCMnQ2hxPXtQsSHLjNQVoMtrmi1EbqOY6ULNldRae1AV/1n+o1FePWFu6NorXpSPWvcBJzp8VrXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hhQiepSO; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hhQiepSO"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8d4f78fc9f6so299354085a.3
        for <linux-crypto@vger.kernel.org>; Sat, 02 May 2026 06:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777728312; x=1778333112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TiHfmUTUQA6/Fcz5xp0cK2FWPU1oMzmHzKsF4Cf9JWQ=;
        b=hhQiepSOK7cavYOEwZGlaprRwvuSVv+vsxVSCypNpJ7qU7v4mf9GwDNomw6X5VW66D
         bZl6z0rXS1iysG89+4xFsXyuNM9radoeHaCX90827IpS8HibtGdVCCeZ6Pb0RTUT+Ppx
         Wa/XNgSGpNSnp0dFr2sInL+um9w9AqPixZodiWnKxA18k8S5bH2ABs8d4FUlSdKS7GO8
         /h/unIQVp2uz1mas1vRwN/QPuHiEYYYZNcOR76zmMgljxwrP0DdwIKORHE3JlJLVGaKV
         nAm1zJ9uNtTg0zvtjwk1Q8tfaI8z2uVYMb1bYgLcZsnWlFcM1sZxfyqG7yN4TIRSnKlG
         +Drw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777728312; x=1778333112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TiHfmUTUQA6/Fcz5xp0cK2FWPU1oMzmHzKsF4Cf9JWQ=;
        b=Hi4BcJ8N3OsaOEZN30NySbpJpv12ivmi1lWBDZCynAHiyAV+7XnuduxMgYHOv1bN3X
         1XcT137ea/R44z0esr0+3IDPCTxgCSws0RK0Nx1pJfqBRt1KcNJzp4cjYiLjOr+L+mzE
         zMoQcJWG17BM4jW/dYxA42jW23ZPIQ6gSup7oNvaSEo5O1MvmnaSDUf1lpvpjbvAqNbn
         wuaHplx327mLRC9xUT/K5cRP6kfakVVB9EYtGQJQF5A/s+4Z8oXPz+Ev35Ce/X5dfdL2
         N0I8yMsoUHWX1bOG0c/boueGk3SYFfDNY07kVinoa54fFWtw0q0ZtLICq9tEUJEVekEH
         +SDg==
X-Forwarded-Encrypted: i=1; AFNElJ/FyR7vrTzLFBRDyHH4fpdYBVbTK2pTaJdgQbLSbp27oDzlKeGuV/jYjp+TG4gWu9CobqA8mYcGTm2TZfw=@vger.kernel.org
X-Gm-Message-State: AOJu0YxMoS+KQzbtMJcDI3Y3+T88Kf5xHMfTM2QL4O1LzuKuZ2/vBMaG
	7/Um9WskMm8rMYDiVzBZpGbXdYpBQXrZg4DHhMKAZZHWlmiJk00r9goN
X-Gm-Gg: AeBDiesLHVv9xwDGh3JcivE5ObQEE/ib8MsoF2hA2D+myAOWy/mxPVYALLS6OPKVrgH
	Tj1s/Gkhu6DuDRvgjbONd6C4Tw2M6RSCbmrJUZ6ag11mo+vg3vueMp37asVNq5BndIzZin+BETK
	96Gh5jNnrristz6Tjx9zzSql2F3YDSdpkYKjTARTKJfY5iR19ONvxtWgSysSTkZ52z+g2Iikhjh
	7MlhU0rEET+9ie2z5f3lqDeBTWJaLmsvNGb5MkQN3p9EzkoR5fuJE2A98V+1BCqV9G/9NHNOwOh
	BQGeouRKjXEi5T8/8NGmns15CgvNMh/lcim/dBlNX/6afhXpDYxekUuZKfscT5zoyN0Sc3DTFtD
	h0kOVfPDog3h5L6pDDJ89dTM1dkPgxBQz+DSOLlXwGKY+W2iCi0FpHJgpfS2BiTb+B3zvc6AYk7
	yKr+NNzeD7nvwa4PztQvpYECpD+eSq0YpHcMwGybYU0ffRgy5lo6aQ2/FBBb0KqHyQxDJr2J2Oq
	ANOPsMaR6GriMQf2gimMGlt9vrdElw=
X-Received: by 2002:a05:620a:4015:b0:8cf:d6f8:599f with SMTP id af79cd13be357-8fd1863dbfcmr491717085a.57.1777728312166;
        Sat, 02 May 2026 06:25:12 -0700 (PDT)
Received: from server1 (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2c91dd48sm491819285a.38.2026.05.02.06.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2026 06:25:11 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	David Howells <dhowells@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
Cc: Eric Biggers <ebiggers@kernel.org>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org,
	Ilya Dryomov <idryomov@gmail.com>,
	Xiubo Li <xiubli@redhat.com>,
	ceph-devel@vger.kernel.org,
	stable@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: krb5 - wait for async aead completion before freeing buffer
Date: Sat,  2 May 2026 09:25:06 -0400
Message-ID: <20260502132506.1936358-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

krb5_aead_encrypt(), krb5_aead_decrypt() in rfc3961_simplified.c and
rfc8009_encrypt(), rfc8009_decrypt() in rfc8009_aes2.c set a NULL
completion callback on the aead_request and treat any negative return
from crypto_aead_{encrypt,decrypt}() as terminal, falling through to
kfree_sensitive(buffer) where buffer == req.

The crypto API returns -EINPROGRESS when an asynchronous backend has
accepted the request and queued it for completion by a worker, and
-EBUSY when a backlog-capable backend has accepted it onto its
backlog (with CRYPTO_TFM_REQ_MAY_BACKLOG set).  In both cases the
operation will complete asynchronously and the request buffer must
remain live until the backend's completion callback fires.  Without
that flag set, -EBUSY instead means "rejected, try again later" and
no completion will fire.  In the current code the callback is NULL
and any negative return is treated as terminal, so when the
encrypt_name composition resolves to an async instance (a hardware
AEAD provider that registers an instance for the krb5 inner template,
or any future code path that takes a cryptd-wrapped instance for the
krb5 enctype name), -EINPROGRESS satisfies the "if (ret < 0)" check
and the buffer is freed while the backend's worker still holds a
pointer.  The worker subsequently dereferences req via
aead_request_complete(), reading from freed slab.

KASAN report under UML+SLUB with a faithful reproducer that drives
crypto_krb5_decrypt() through the existing API, with an async aead
backend bound to krb5->encrypt_name:

  BUG: KASAN: slab-use-after-free in t5_stub_complete+0x7d/0xc7
  Read of size 8 at addr 00000000619e9410 by task kworker/0:1/12

  Allocated by task 40:
   __kmalloc_noprof+0x1df/0x1ee
   kzalloc_noprof.constprop.0+0x19/0x1b [krb5]
   rfc8009_decrypt+0x294/0x7c4 [krb5]
   crypto_krb5_decrypt+0x93/0xa2 [krb5]

  Freed by task 40:
   kfree_sensitive+0x57/0x5c
   rfc8009_decrypt+0x790/0x7c4 [krb5]
   crypto_krb5_decrypt+0x93/0xa2 [krb5]

  The buggy address belongs to the cache kmalloc-128 of size 128

These helpers are reached today from net/rxrpc/rxgk.c and
rxgk_common.h (AFS/RxRPC RxGK packet encrypt/decrypt),
fs/afs/cm_security.c, and net/ceph/crypto.c (Linux kernel Ceph
client cephx encrypt/decrypt).  The bug is triggerable when one of
these paths uses a krb5 AEAD whose selected implementation is async
(or inherits async completion from an async child/provider).

Fix by following the standard kernel idiom for synchronous waiting on
a potentially-asynchronous AEAD: install crypto_req_done() as the
completion callback, set CRYPTO_TFM_REQ_MAY_BACKLOG so a backlogged
backend's -EBUSY indicates a queued (not rejected) request, and wrap
the crypto_aead_{encrypt,decrypt}() return through crypto_wait_req()
so the function blocks on the worker's completion before falling
through to kfree_sensitive().  This matches the crypto_wait_req()
usage pattern in net/tls/, fs/ecryptfs/, fs/smb/server/auth.c, and
other consumers that need a synchronous result over an arbitrarily-
async backend; MAY_BACKLOG is required (not optional) so that
crypto_wait_req() does not block waiting for a completion that will
never fire from a rejected request.

Regression coverage: the in-tree krb5 selftests
(CONFIG_CRYPTO_KRB5_SELFTESTS=y) cover all four touched functions for
all six supported enctypes (aes128/aes256-cts-hmac-sha1-96,
aes128/aes256-cts-hmac-sha256/384, camellia128/256-cts-cmac) via the
PRF, key-derivation, encrypt, decrypt and MIC paths; the patched
kernel reports "krb5: Selftests succeeded" when those default sync
backends are in use.  Additionally, on a separate boot of the
patched kernel with CONFIG_CRYPTO_SELFTESTS_FULL=y and without the
synthetic async-aead provider used to drive the reproducer loaded,
the kernel's testmgr emits no "alg: ... self-test failed" lines for
the authenc(hmac(sha256/sha384),cts(cbc(aes))) instances the krb5
layer instantiates.  (The reproducer boot does carry an expected
testmgr failure for that synthetic provider's algorithm name; that
is not a regression of any in-tree algorithm.)  The faithful
reproducer above no longer trips KASAN when an async backend is
bound.

Fixes: 00244da40f78 ("crypto/krb5: Implement the Kerberos5 rfc3961 encrypt and decrypt functions")
Fixes: 6c3c0e86c2ac ("crypto/krb5: Implement the AES enctypes from rfc8009")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4-7
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
---
 crypto/krb5/rfc3961_simplified.c | 12 ++++++++----
 crypto/krb5/rfc8009_aes2.c       | 12 ++++++++----
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/crypto/krb5/rfc3961_simplified.c b/crypto/krb5/rfc3961_simplified.c
index e49cbdec7c40..c4b8e9b89c7b 100644
--- a/crypto/krb5/rfc3961_simplified.c
+++ b/crypto/krb5/rfc3961_simplified.c
@@ -543,6 +543,7 @@ ssize_t krb5_aead_encrypt(const struct krb5_enctype *krb5,
 			  size_t data_offset, size_t data_len,
 			  bool preconfounded)
 {
+	DECLARE_CRYPTO_WAIT(wait);
 	struct aead_request *req;
 	ssize_t ret, done;
 	size_t bsize, base_len, secure_offset, secure_len, pad_len, cksum_offset;
@@ -588,9 +589,10 @@ ssize_t krb5_aead_encrypt(const struct krb5_enctype *krb5,
 	iv = buffer + krb5_aead_size(aead);
 
 	aead_request_set_tfm(req, aead);
-	aead_request_set_callback(req, 0, NULL, NULL);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  crypto_req_done, &wait);
 	aead_request_set_crypt(req, sg, sg, secure_len, iv);
-	ret = crypto_aead_encrypt(req);
+	ret = crypto_wait_req(crypto_aead_encrypt(req), &wait);
 	if (ret < 0)
 		goto error;
 
@@ -610,6 +612,7 @@ int krb5_aead_decrypt(const struct krb5_enctype *krb5,
 		      struct scatterlist *sg, unsigned int nr_sg,
 		      size_t *_offset, size_t *_len)
 {
+	DECLARE_CRYPTO_WAIT(wait);
 	struct aead_request *req;
 	size_t bsize;
 	void *buffer;
@@ -633,9 +636,10 @@ int krb5_aead_decrypt(const struct krb5_enctype *krb5,
 	iv = buffer + krb5_aead_size(aead);
 
 	aead_request_set_tfm(req, aead);
-	aead_request_set_callback(req, 0, NULL, NULL);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  crypto_req_done, &wait);
 	aead_request_set_crypt(req, sg, sg, *_len, iv);
-	ret = crypto_aead_decrypt(req);
+	ret = crypto_wait_req(crypto_aead_decrypt(req), &wait);
 	if (ret < 0)
 		goto error;
 
diff --git a/crypto/krb5/rfc8009_aes2.c b/crypto/krb5/rfc8009_aes2.c
index d39851fc3a4e..dda29f0bb700 100644
--- a/crypto/krb5/rfc8009_aes2.c
+++ b/crypto/krb5/rfc8009_aes2.c
@@ -175,6 +175,7 @@ static ssize_t rfc8009_encrypt(const struct krb5_enctype *krb5,
 			       size_t data_offset, size_t data_len,
 			       bool preconfounded)
 {
+	DECLARE_CRYPTO_WAIT(wait);
 	struct aead_request *req;
 	struct scatterlist bsg[2];
 	ssize_t ret, done;
@@ -227,10 +228,11 @@ static ssize_t rfc8009_encrypt(const struct krb5_enctype *krb5,
 
 	/* Hash and encrypt the message. */
 	aead_request_set_tfm(req, aead);
-	aead_request_set_callback(req, 0, NULL, NULL);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  crypto_req_done, &wait);
 	aead_request_set_ad(req, krb5_aead_ivsize(aead));
 	aead_request_set_crypt(req, bsg, bsg, secure_len, iv);
-	ret = crypto_aead_encrypt(req);
+	ret = crypto_wait_req(crypto_aead_encrypt(req), &wait);
 	if (ret < 0)
 		goto error;
 
@@ -253,6 +255,7 @@ static int rfc8009_decrypt(const struct krb5_enctype *krb5,
 			   struct scatterlist *sg, unsigned int nr_sg,
 			   size_t *_offset, size_t *_len)
 {
+	DECLARE_CRYPTO_WAIT(wait);
 	struct aead_request *req;
 	struct scatterlist bsg[2];
 	size_t bsize;
@@ -283,10 +286,11 @@ static int rfc8009_decrypt(const struct krb5_enctype *krb5,
 
 	/* Decrypt the message and verify its checksum. */
 	aead_request_set_tfm(req, aead);
-	aead_request_set_callback(req, 0, NULL, NULL);
+	aead_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
+				  crypto_req_done, &wait);
 	aead_request_set_ad(req, krb5_aead_ivsize(aead));
 	aead_request_set_crypt(req, bsg, bsg, *_len, iv);
-	ret = crypto_aead_decrypt(req);
+	ret = crypto_wait_req(crypto_aead_decrypt(req), &wait);
 	if (ret < 0)
 		goto error;
 
-- 
2.53.0

