Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21BC036495F;
	Mon,  4 May 2026 22:53:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777935237; cv=none; b=oT8xS4SD7dAZu3MokHL0hx2480dH7p6n2M20xFXc8InR9QZI23K5SZ7WiB2hz32uMgquaZYwq81ayTVfFA1JtJ6OjSOElBuCz4HxiTzPv4/8cSQUrCWUwL1BgAm9j1Avcdq8xqt6nsw2A+8xXETSTjqyvDkSeVd6/xeR2o9fjcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777935237; c=relaxed/simple;
	bh=i2fPoHqb8xx58hB925XeINZ1xXUggfULPyDbIosH0Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDlGExiyyDAqqNCGw918rQIchCjT45KKWQFs+aSdJfwkGDXrDXLkAhGUPXWGZoh/ptzXP77g7xyufvwPvmsHH+YVIYarK8bQ29RD4O/D6Pl9RKPqs+hmLewjf5dawmlKzK7Mq7xvYGtYNG0ap9qZGktclCgkgMSdsGC0N5t+tMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Es82fauC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Es82fauC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E612C2BCB8;
	Mon,  4 May 2026 22:53:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777935236;
	bh=i2fPoHqb8xx58hB925XeINZ1xXUggfULPyDbIosH0Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Es82fauCn2gm1BNzPMKFu4D/4fDab1uEpE48DXZvZ+mRHGMTWATBvYsl1yIpnA1CS
	 Mf9hYt2AoMZSCdnuBmwGGSzZTnh3pgMLUEfBaFgseiUmCwqKpavwyxTi4ROvd3fXGh
	 NtlVFUMJL8Gk8LcsoS4XU2IeqeMTa4gemISG9ffd1c1B20FIRhY6OZchyXzq33Uad4
	 KavXcdDkUYb/2aPJv7xl0Ri7rGoQ3/hy13SQFtc2l0isaStJzQRC/9cd4wxhou2Dtn
	 YbzFBzBau/lQSxbfS4/CqOWmfoURgu4O2e79RIdewk392cdr+mxPy6Wzq2hbbKCnxs
	 rtdbpBT0sTh9Q==
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
Subject: [PATCH v3] crypto: af_alg - Remove zero-copy support from skcipher and aead
Date: Mon,  4 May 2026 15:53:28 -0700
Message-ID: <20260504225328.25356-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504092442.GA2486@quark>
References: <20260504092442.GA2486@quark>
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
to concurrently modify the memory which is being operated on, a recipe
for TOCTOU vulnerabilities.

While zero-copy support is more valuable in other areas of the kernel
like the frequently used networking and file I/O code, it has far less
value in AF_ALG, which is a niche UAPI.  AF_ALG primarily just exists
for backwards compatibility with a small set of userspace programs such
as 'iwd' that haven't yet been fixed to use userspace crypto code.

Originally AF_ALG was intended to be used to access hardware crypto
accelerators.  However, it isn't an efficient interface for that anyway,
and it turned out to be rarely used in this way in practice.

Thus, the risks of the zero-copy support in AF_ALG vastly outweigh its
benefits.  Let's just remove it.

This commit removes it from the "skcipher" and "aead" algorithm types.
"hash" will be handled separately.

This is a soft break, not a hard break.  Even after this commit, it
still works to use splice() or sendfile() to transfer data to an AF_ALG
request socket from a pipe or any file, respectively.  What changes is
just that the kernel now makes an internal, stable copy of the data
before doing the crypto operation.  So performance is slightly reduced,
but the UAPI isn't broken.  And, very importantly, it's much safer.

Tested with libkcapi/test.sh.  All its test cases still pass.  I also
verified that this would have prevented the copy.fail exploit as well.
I also used a custom test program to verify that sendfile() still works.

Fixes: 8ff590903d5f ("crypto: algif_skcipher - User-space interface for skcipher operations")
Fixes: 400c40cf78da ("crypto: algif - add AEAD support")
Reported-by: Taeyang Lee <0wn@theori.io>
Link: https://copy.fail/
Reported-by: Feng Ning <feng@innora.ai>
Closes: https://lore.kernel.org/r/afYcc-tZFwvZZo76@ans-MacBook-Pro.local
Reviewed-by: Demi Marie Obenour <demiobenour@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

v3: improved explanation
v2: added tags

 Documentation/crypto/userspace-if.rst | 31 ++----------
 crypto/af_alg.c                       | 73 +++++++++------------------
 crypto/algif_aead.c                   |  8 +--
 3 files changed, 33 insertions(+), 79 deletions(-)

diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
index 021759198fe7..d220e266b8de 100644
--- a/Documentation/crypto/userspace-if.rst
+++ b/Documentation/crypto/userspace-if.rst
@@ -325,37 +325,14 @@ CRYPTO_USER_API_RNG_CAVP option:
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
+frequent source of vulnerabilities.  For backwards compatibility the splice()
+and sendfile() system calls are still supported, but the kernel will make an
+internal copy of the data before passing it to the crypto code.
 
 
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

base-commit: c7e4e4d5f7dc2daa439303d1b5bf6bdfaa249f49
-- 
2.54.0

