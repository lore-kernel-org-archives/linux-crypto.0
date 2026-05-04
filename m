Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD67E56A;
	Mon,  4 May 2026 06:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777875444; cv=none; b=Q8/zjx7gOtLGimyDJ+4P3fRIDgrTXtjlAycrnwC9x+Om70Gsq8Fkttxu3kr6wW7JH8sXAGnVA46mewRLGPGIXLHNfljWmyZmI9yHA207PTXbugytsi1Juj1JZynekHqQSa0qpjO8bu00vpXEGbqH9GsCYieGDXq2mEAam2K7c8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777875444; c=relaxed/simple;
	bh=obD0iH84tW/+pzwZKDlX11jbGOFk77pketOtW3wIkHI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jKz4taachmzBajx+CCrWRy30sNeMRsbrhNeXnUH5UfkIVNKvs8O2CCWvBkz57P+O00nZPDyGYKbt346slRjoRImqTpBa0m5IGRt2JtmrNOMWi8GdYard7EoMOIAnN7O5g3/mx3FUT3hDkGmVkenzJ1WhdBxgRTYEzm4Iv7d2EHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uG9s/ND5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uG9s/ND5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3FD2C2BCB8;
	Mon,  4 May 2026 06:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777875444;
	bh=obD0iH84tW/+pzwZKDlX11jbGOFk77pketOtW3wIkHI=;
	h=From:To:Cc:Subject:Date:From;
	b=uG9s/ND57OtwTsDjbVOx8GeWrKgUeAkpyBMvX3uQz96lQvM3lDTwSRQnyvE2+doOV
	 2Lgb7ULxvS5H1LFRHjV30fyfiDeUl2FY5RuJTGn+c+N7XoltvFcl3z9Ynrh3TT/537
	 cGD1+4IRy2wHDlpDZtlrUKPvU7hefG+La+0UqAWIgylGf3bzveGIaBhBmYQtzOOQ5f
	 HBdhVFge7G0FLzETRQaxiquwVw5xlaKWf3DVWRH78bYPe8I1T5CazbcIqRs7yrPG2K
	 8Ndu14Pn5XwCO+gLOhuRphjSZnd1qpNDuI/tV1s5geDyAWv75oJ+GjlWaiNGtLbOjs
	 CSW5q3Y3/8UAQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org,
	Taeyang Lee <0wn@theori.io>,
	Brian Pak <bpak@theori.io>,
	Juno Im <juno@theori.io>,
	Jungwon Lim <setuid0@theori.io>,
	Tim Becker <tjbecker@theori.io>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Feng Ning <feng@innora.ai>,
	stable@vger.kernel.org
Subject: [PATCH] crypto: af_alg - Remove zero-copy support from AF_ALG
Date: Sun,  3 May 2026 23:15:32 -0700
Message-ID: <20260504061532.172013-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The zero-copy support is one of the riskiest aspects of AF_ALG.  It
allows userspace to request cryptographic operations directly on
pagecache pages of files like the 'su' binary.  It also allows userspace
to concurrently modify the memory which is being operated on, a huge
recipe for TOCTOU vulnerabilities.

While zero-copy support is more valuable in other areas of the kernel
like the frequently used networking and file I/O code, it has far less
value in AF_ALG, which is a niche UAPI.  AF_ALG primarily just exists
for backwards compatibility with a small set of userspace programs such
as 'iwd' that haven't yet been fixed to use userspace crypto code.

Originally AF_ALG was intended to be used to access hardware crypto
accelerators.  However, it isn't an efficient interface for that anyway,
and it turned out to be rarely used in this way in practice.

Thus, the risks of the zero-copy support in AF_ALG vastly outweigh its
benefits.  Just remove it.

Note that this isn't a hard break, since the splice syscall is still
supported.  The data is just now copied instead.  So it still works,
just a bit slower in some cases.

Tested with libkcapi/test.sh.  All its test cases still pass.  I also
verified that this would have prevented the copy.fail exploit as well.

Fixes: 8ff590903d5f ("crypto: algif_skcipher - User-space interface for skcipher operations")
Fixes: 400c40cf78da ("crypto: algif - add AEAD support")
Reported-by: Taeyang Lee <0wn@theori.io>
Reported-by: Feng Ning <feng@innora.ai>
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 Documentation/crypto/userspace-if.rst | 30 ++---------
 crypto/af_alg.c                       | 73 +++++++++------------------
 crypto/algif_aead.c                   |  8 +--
 3 files changed, 32 insertions(+), 79 deletions(-)

diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
index 021759198fe7..80eb2819901a 100644
--- a/Documentation/crypto/userspace-if.rst
+++ b/Documentation/crypto/userspace-if.rst
@@ -325,37 +325,13 @@ CRYPTO_USER_API_RNG_CAVP option:
    but only after the entropy has been set.
 
 Zero-Copy Interface
 -------------------
 
-In addition to the send/write/read/recv system call family, the AF_ALG
-interface can be accessed with the zero-copy interface of
-splice/vmsplice. As the name indicates, the kernel tries to avoid a copy
-operation into kernel space.
-
-The zero-copy operation requires data to be aligned at the page
-boundary. Non-aligned data can be used as well, but may require more
-operations of the kernel which would defeat the speed gains obtained
-from the zero-copy interface.
-
-The system-inherent limit for the size of one zero-copy operation is 16
-pages. If more data is to be sent to AF_ALG, user space must slice the
-input into segments with a maximum size of 16 pages.
-
-Zero-copy can be used with the following code example (a complete
-working example is provided with libkcapi):
-
-::
-
-    int pipes[2];
-
-    pipe(pipes);
-    /* input data in iov */
-    vmsplice(pipes[1], iov, iovlen, SPLICE_F_GIFT);
-    /* opfd is the file descriptor returned from accept() system call */
-    splice(pipes[0], NULL, opfd, NULL, ret, 0);
-    read(opfd, out, outlen);
+AF_ALG used to have zero-copy support, but it was removed due to it being a
+frequent source of vulnerabilities.  For backwards compatibility the splice
+system call is still supported, but the data will simply be copied.
 
 
 Setsockopt Interface
 --------------------
 
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 5a00c18eb145..fce0b87c2b65 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -971,11 +971,11 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		struct scatterlist *sg;
 		size_t len = size;
 		ssize_t plen;
 
 		/* use the existing memory in an allocated page */
-		if (ctx->merge && !(msg->msg_flags & MSG_SPLICE_PAGES)) {
+		if (ctx->merge) {
 			sgl = list_entry(ctx->tsgl_list.prev,
 					 struct af_alg_tsgl, list);
 			sg = sgl->sg + sgl->cur - 1;
 			len = min_t(size_t, len,
 				    PAGE_SIZE - sg->offset - sg->length);
@@ -1015,64 +1015,41 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 				 list);
 		sg = sgl->sg;
 		if (sgl->cur)
 			sg_unmark_end(sg + sgl->cur - 1);
 
-		if (msg->msg_flags & MSG_SPLICE_PAGES) {
-			struct sg_table sgtable = {
-				.sgl		= sg,
-				.nents		= sgl->cur,
-				.orig_nents	= sgl->cur,
-			};
-
-			plen = extract_iter_to_sg(&msg->msg_iter, len, &sgtable,
-						  MAX_SGL_ENTS - sgl->cur, 0);
-			if (plen < 0) {
-				err = plen;
+		do {
+			struct page *pg;
+			unsigned int i = sgl->cur;
+
+			plen = min_t(size_t, len, PAGE_SIZE);
+
+			pg = alloc_page(GFP_KERNEL);
+			if (!pg) {
+				err = -ENOMEM;
 				goto unlock;
 			}
 
-			for (; sgl->cur < sgtable.nents; sgl->cur++)
-				get_page(sg_page(&sg[sgl->cur]));
+			sg_assign_page(sg + i, pg);
+
+			err = memcpy_from_msg(page_address(sg_page(sg + i)),
+					      msg, plen);
+			if (err) {
+				__free_page(sg_page(sg + i));
+				sg_assign_page(sg + i, NULL);
+				goto unlock;
+			}
+
+			sg[i].length = plen;
 			len -= plen;
 			ctx->used += plen;
 			copied += plen;
 			size -= plen;
-		} else {
-			do {
-				struct page *pg;
-				unsigned int i = sgl->cur;
-
-				plen = min_t(size_t, len, PAGE_SIZE);
-
-				pg = alloc_page(GFP_KERNEL);
-				if (!pg) {
-					err = -ENOMEM;
-					goto unlock;
-				}
-
-				sg_assign_page(sg + i, pg);
-
-				err = memcpy_from_msg(
-					page_address(sg_page(sg + i)),
-					msg, plen);
-				if (err) {
-					__free_page(sg_page(sg + i));
-					sg_assign_page(sg + i, NULL);
-					goto unlock;
-				}
-
-				sg[i].length = plen;
-				len -= plen;
-				ctx->used += plen;
-				copied += plen;
-				size -= plen;
-				sgl->cur++;
-			} while (len && sgl->cur < MAX_SGL_ENTS);
-
-			ctx->merge = plen & (PAGE_SIZE - 1);
-		}
+			sgl->cur++;
+		} while (len && sgl->cur < MAX_SGL_ENTS);
+
+		ctx->merge = plen & (PAGE_SIZE - 1);
 
 		if (!size)
 			sg_mark_end(sg + sgl->cur - 1);
 	}
 
diff --git a/crypto/algif_aead.c b/crypto/algif_aead.c
index cb651ab58d62..c6c2ce21895d 100644
--- a/crypto/algif_aead.c
+++ b/crypto/algif_aead.c
@@ -7,14 +7,14 @@
  * This file provides the user-space API for AEAD ciphers.
  *
  * The following concept of the memory management is used:
  *
  * The kernel maintains two SGLs, the TX SGL and the RX SGL. The TX SGL is
- * filled by user space with the data submitted via sendmsg (maybe with
- * MSG_SPLICE_PAGES).  Filling up the TX SGL does not cause a crypto operation
- * -- the data will only be tracked by the kernel. Upon receipt of one recvmsg
- * call, the caller must provide a buffer which is tracked with the RX SGL.
+ * filled by user space with the data submitted via sendmsg.  Filling up the TX
+ * SGL does not cause a crypto operation -- the data will only be tracked by the
+ * kernel. Upon receipt of one recvmsg call, the caller must provide a buffer
+ * which is tracked with the RX SGL.
  *
  * During the processing of the recvmsg operation, the cipher request is
  * allocated and prepared. As part of the recvmsg operation, the processed
  * TX buffers are extracted from the TX SGL into a separate SGL.
  *

base-commit: 6d35786de28116ecf78797a62b84e6bf3c45aa5a
-- 
2.54.0

