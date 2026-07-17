Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED1631AAA3;
	Fri, 17 Jul 2026 03:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784259395; cv=none; b=eTe7zd6u6WEpm8eTEA+A2j6LeLlHMqvhO/62NxDBnZyI5cYqOQvUfC3rLDro3wKnAnYshDyB4Y8z9c6/iEhJKDd/+/6AeFJhsOPmxM4AnU5cut1UcgoqglyYRtVv8fE2v2uPbnWrQbixs2j1wqjrV8ID3f/xiwx4dk8OlYQAOy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784259395; c=relaxed/simple;
	bh=b4hq/DE9KjU+Wgl9Isjbt/gCcQ+fpp2TgeM27O6A1jw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=CCxlbHU32flCcATJR+J+JKL94PGeKMzCjOd8jK+jwfIojW6fiR63QSret1p2y+uvhoF6OZ/XRNvIBhIMO92ulaD71FM8iD+O3QI+zb7uCNVsSFciEikHBXYZA1g1mPUrud1/s8XTnLfduD3GTifV1BfCvL+sQ48SuOanh+ZXNLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ktHsWx19; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ktHsWx19"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE9C1F000E9;
	Fri, 17 Jul 2026 03:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784259394;
	bh=6zX/L8PSXUr41wSgynTLiTeTcXVr6cEgkuhU1lLFvJo=;
	h=From:To:Cc:Subject:Date;
	b=ktHsWx194O7SraCulngwYrY3sO+C9soxJ95L5d88wCp4iCIdCP3Gx4DUyf7hjMStl
	 AMSpL4dmX+AEljo4s4dX3ls4i9q+1WEvHrDEm9E1xagJ41FglpfvrznbweOjGDkVfm
	 kwFVtdK90ozoW6tENephnd+s/DlntXgBQfOLp7SEBgk5iPtReCQSveTbToX9+Blvjm
	 G/RrASp8xwJGoO5cSekTrKZhkNIVJULqbHpmVZV2gNfJUioZK1R2xQjuUFbLCL9Pnf
	 910zyGE2b3aN8uk+bxgszi9Dmy+y2RRSJ9ZAl3FgTO0zMHgJeqo4g97XDWj6Bh2EX+
	 f86SmrREYEPSA==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>,
	Taeyang Lee <0wn@theori.io>,
	Feng Ning <feng@innora.ai>,
	Demi Marie Obenour <demiobenour@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH 5.15,5.10] crypto: af_alg - Remove zero-copy support from skcipher and aead
Date: Thu, 16 Jul 2026 20:34:03 -0700
Message-ID: <20260717033403.285821-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit ffdd2bc378953b525aca61902534e753f1f8e734 upstream.

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
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 Documentation/crypto/userspace-if.rst | 31 ++-------------
 crypto/af_alg.c                       | 54 +++++----------------------
 2 files changed, 14 insertions(+), 71 deletions(-)

diff --git a/Documentation/crypto/userspace-if.rst b/Documentation/crypto/userspace-if.rst
index b45dabbf69d6..90dbbd56c4e3 100644
--- a/Documentation/crypto/userspace-if.rst
+++ b/Documentation/crypto/userspace-if.rst
@@ -328,33 +328,10 @@ CRYPTO_USER_API_RNG_CAVP option:
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
diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index bbd47d04f89d..8dfb94aa9928 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -972,53 +972,19 @@ EXPORT_SYMBOL_GPL(af_alg_sendmsg);
 ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 			int offset, size_t size, int flags)
 {
-	struct sock *sk = sock->sk;
-	struct alg_sock *ask = alg_sk(sk);
-	struct af_alg_ctx *ctx = ask->private;
-	struct af_alg_tsgl *sgl;
-	int err = -EINVAL;
+	struct bio_vec bvec;
+	struct msghdr msg = {
+		.msg_flags = flags,
+	};
 
 	if (flags & MSG_SENDPAGE_NOTLAST)
-		flags |= MSG_MORE;
-
-	lock_sock(sk);
-	if (!ctx->more && ctx->used)
-		goto unlock;
-
-	if (!size)
-		goto done;
-
-	if (!af_alg_writable(sk)) {
-		err = af_alg_wait_for_wmem(sk, flags);
-		if (err)
-			goto unlock;
-	}
-
-	err = af_alg_alloc_tsgl(sk);
-	if (err)
-		goto unlock;
-
-	ctx->merge = 0;
-	sgl = list_entry(ctx->tsgl_list.prev, struct af_alg_tsgl, list);
-
-	if (sgl->cur)
-		sg_unmark_end(sgl->sg + sgl->cur - 1);
-
-	sg_mark_end(sgl->sg + sgl->cur);
-
-	get_page(page);
-	sg_set_page(sgl->sg + sgl->cur, page, size, offset);
-	sgl->cur++;
-	ctx->used += size;
-
-done:
-	ctx->more = flags & MSG_MORE;
-
-unlock:
-	af_alg_data_wakeup(sk);
-	release_sock(sk);
+		msg.msg_flags |= MSG_MORE;
 
-	return err ?: size;
+	bvec.bv_page = page;
+	bvec.bv_len = size;
+	bvec.bv_offset = offset;
+	iov_iter_bvec(&msg.msg_iter, ITER_SOURCE, &bvec, 1, size);
+	return sock_sendmsg(sock, &msg);
 }
 EXPORT_SYMBOL_GPL(af_alg_sendpage);
 

base-commit: c86c4726e7f044ab73b493c6f00527aafef640cd
-- 
2.55.0

