Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8282396593;
	Thu, 30 Apr 2026 07:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777532610; cv=none; b=Jyjda6U74R6LwDOIOUnpkT4/RCKboXzcE56y4tBo9P0Cb6imFOHLP5KXawiXQZEoF82CUDE/RICUjHHP5mhh/R1COhdrH6i39UYtv61Qai3If/CGWgrXc+HY2ZsIsMclYq4B9EFSlnmH24wkfLoSQa/jSpgQfA5mTB/tmTnkd60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777532610; c=relaxed/simple;
	bh=zP+VpE8M32uh4GtiVIlSAZ7EK2PWnXUxewv2Kv5ePz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xf3o6Sm0WCAEFX/rhomttmQtztz0yQAmifFeXRwP2oaceIQCxq/jsxSpU3oj70/pdABGh3QtSsCVnobkVnGmlHejwXeTizug9Gy/kl9iWoLt7VPJrZYfyua5PrS8A61NVxT7ksjckI8+4KGaV4cW9GVN4Ylm+h9zZF/LKDuzujc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GInRRQU9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GInRRQU9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C566C2BCB4;
	Thu, 30 Apr 2026 07:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777532610;
	bh=zP+VpE8M32uh4GtiVIlSAZ7EK2PWnXUxewv2Kv5ePz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GInRRQU9VecwNMWmUep3UsHQQwlo7iI587zpAv4g/joiDR7+nreXqN03KI1matXf+
	 IH/wFrVrW1UVIjfAhRxAvKh2i5o9QsPhgYGXQnu9Zm6su8inCHUnNUaDpu9hKUPpFH
	 297jTCY703vcXA9kfTWC94IdY5Cad7WnJ62Sy0tPi8NFS7U8UUL01jgAHU86/zTxyg
	 CVxrscY8awy5o5SDZNqPeYhNf83pRobSDE1uU02EWIHze7T+nawdNd7Zqd63e5+HnZ
	 o8NEduRtcwjTcAeSfnkZvlz5Dj1t3RjNyHRJsyS51JVWNGbbbyy4s684XuyV+ZGNlN
	 HANwylcnn9XqQ==
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Randy Dunlap <rdunlap@infradead.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 5.10 01/10] crypto: doc - fix kernel-doc notation in chacha.c and af_alg.c
Date: Thu, 30 Apr 2026 00:01:19 -0700
Message-ID: <20260430070128.219863-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260430070128.219863-1-ebiggers@kernel.org>
References: <20260430070128.219863-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

commit b2a4411aca29ab7feb17c927d1d91d979361983c upstream.

Fix function name in chacha.c kernel-doc comment to remove a warning.

Convert af_alg.c to kernel-doc notation to eliminate many kernel-doc
warnings.

../lib/crypto/chacha.c:77: warning: expecting prototype for chacha_block(). Prototype was for chacha_block_generic() instead
chacha.c:104: warning: Excess function parameter 'out' description in 'hchacha_block_generic'

af_alg.c:498: warning: Function parameter or member 'sk' not described in 'af_alg_alloc_tsgl'
../crypto/af_alg.c:539: warning: expecting prototype for aead_count_tsgl(). Prototype was for af_alg_count_tsgl() instead
../crypto/af_alg.c:596: warning: expecting prototype for aead_pull_tsgl(). Prototype was for af_alg_pull_tsgl() instead
af_alg.c:663: warning: Function parameter or member 'areq' not described in 'af_alg_free_areq_sgls'
af_alg.c:700: warning: Function parameter or member 'sk' not described in 'af_alg_wait_for_wmem'
af_alg.c:700: warning: Function parameter or member 'flags' not described in 'af_alg_wait_for_wmem'
af_alg.c:731: warning: Function parameter or member 'sk' not described in 'af_alg_wmem_wakeup'
af_alg.c:757: warning: Function parameter or member 'sk' not described in 'af_alg_wait_for_data'
af_alg.c:757: warning: Function parameter or member 'flags' not described in 'af_alg_wait_for_data'
af_alg.c:757: warning: Function parameter or member 'min' not described in 'af_alg_wait_for_data'
af_alg.c:796: warning: Function parameter or member 'sk' not described in 'af_alg_data_wakeup'
af_alg.c:832: warning: Function parameter or member 'sock' not described in 'af_alg_sendmsg'
af_alg.c:832: warning: Function parameter or member 'msg' not described in 'af_alg_sendmsg'
af_alg.c:832: warning: Function parameter or member 'size' not described in 'af_alg_sendmsg'
af_alg.c:832: warning: Function parameter or member 'ivsize' not described in 'af_alg_sendmsg'
af_alg.c:985: warning: Function parameter or member 'sock' not described in 'af_alg_sendpage'
af_alg.c:985: warning: Function parameter or member 'page' not described in 'af_alg_sendpage'
af_alg.c:985: warning: Function parameter or member 'offset' not described in 'af_alg_sendpage'
af_alg.c:985: warning: Function parameter or member 'size' not described in 'af_alg_sendpage'
af_alg.c:985: warning: Function parameter or member 'flags' not described in 'af_alg_sendpage'
af_alg.c:1040: warning: Function parameter or member 'areq' not described in 'af_alg_free_resources'
af_alg.c:1059: warning: Function parameter or member '_req' not described in 'af_alg_async_cb'
af_alg.c:1059: warning: Function parameter or member 'err' not described in 'af_alg_async_cb'
af_alg.c:1083: warning: Function parameter or member 'file' not described in 'af_alg_poll'
af_alg.c:1083: warning: Function parameter or member 'sock' not described in 'af_alg_poll'
af_alg.c:1083: warning: Function parameter or member 'wait' not described in 'af_alg_poll'
af_alg.c:1114: warning: Function parameter or member 'sk' not described in 'af_alg_alloc_areq'
af_alg.c:1114: warning: Function parameter or member 'areqlen' not described in 'af_alg_alloc_areq'
af_alg.c:1146: warning: Function parameter or member 'sk' not described in 'af_alg_get_rsgl'
af_alg.c:1146: warning: Function parameter or member 'msg' not described in 'af_alg_get_rsgl'
af_alg.c:1146: warning: Function parameter or member 'flags' not described in 'af_alg_get_rsgl'
af_alg.c:1146: warning: Function parameter or member 'areq' not described in 'af_alg_get_rsgl'
af_alg.c:1146: warning: Function parameter or member 'maxsize' not described in 'af_alg_get_rsgl'
af_alg.c:1146: warning: Function parameter or member 'outlen' not described in 'af_alg_get_rsgl'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 crypto/af_alg.c     | 94 +++++++++++++++++++++++++--------------------
 lib/crypto/chacha.c |  4 +-
 2 files changed, 55 insertions(+), 43 deletions(-)

diff --git a/crypto/af_alg.c b/crypto/af_alg.c
index 5e0fe58f8bdd..b503ac2b276e 100644
--- a/crypto/af_alg.c
+++ b/crypto/af_alg.c
@@ -489,12 +489,12 @@ static int af_alg_cmsg_send(struct msghdr *msg, struct af_alg_control *con)
 }
 
 /**
  * af_alg_alloc_tsgl - allocate the TX SGL
  *
- * @sk socket of connection to user space
- * @return: 0 upon success, < 0 upon error
+ * @sk: socket of connection to user space
+ * Return: 0 upon success, < 0 upon error
  */
 static int af_alg_alloc_tsgl(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct af_alg_ctx *ctx = ask->private;
@@ -525,19 +525,19 @@ static int af_alg_alloc_tsgl(struct sock *sk)
 
 	return 0;
 }
 
 /**
- * aead_count_tsgl - Count number of TX SG entries
+ * af_alg_count_tsgl - Count number of TX SG entries
  *
  * The counting starts from the beginning of the SGL to @bytes. If
- * an offset is provided, the counting of the SG entries starts at the offset.
+ * an @offset is provided, the counting of the SG entries starts at the @offset.
  *
- * @sk socket of connection to user space
- * @bytes Count the number of SG entries holding given number of bytes.
- * @offset Start the counting of SG entries from the given offset.
- * @return Number of TX SG entries found given the constraints
+ * @sk: socket of connection to user space
+ * @bytes: Count the number of SG entries holding given number of bytes.
+ * @offset: Start the counting of SG entries from the given offset.
+ * Return: Number of TX SG entries found given the constraints
  */
 unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset)
 {
 	const struct alg_sock *ask = alg_sk(sk);
 	const struct af_alg_ctx *ctx = ask->private;
@@ -577,23 +577,23 @@ unsigned int af_alg_count_tsgl(struct sock *sk, size_t bytes, size_t offset)
 	return sgl_count;
 }
 EXPORT_SYMBOL_GPL(af_alg_count_tsgl);
 
 /**
- * aead_pull_tsgl - Release the specified buffers from TX SGL
+ * af_alg_pull_tsgl - Release the specified buffers from TX SGL
  *
- * If @dst is non-null, reassign the pages to dst. The caller must release
+ * If @dst is non-null, reassign the pages to @dst. The caller must release
  * the pages. If @dst_offset is given only reassign the pages to @dst starting
  * at the @dst_offset (byte). The caller must ensure that @dst is large
  * enough (e.g. by using af_alg_count_tsgl with the same offset).
  *
- * @sk socket of connection to user space
- * @used Number of bytes to pull from TX SGL
- * @dst If non-NULL, buffer is reassigned to dst SGL instead of releasing. The
- *	caller must release the buffers in dst.
- * @dst_offset Reassign the TX SGL from given offset. All buffers before
- *	       reaching the offset is released.
+ * @sk: socket of connection to user space
+ * @used: Number of bytes to pull from TX SGL
+ * @dst: If non-NULL, buffer is reassigned to dst SGL instead of releasing. The
+ *	 caller must release the buffers in dst.
+ * @dst_offset: Reassign the TX SGL from given offset. All buffers before
+ *	        reaching the offset is released.
  */
 void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 		      size_t dst_offset)
 {
 	struct alg_sock *ask = alg_sk(sk);
@@ -657,11 +657,11 @@ void af_alg_pull_tsgl(struct sock *sk, size_t used, struct scatterlist *dst,
 EXPORT_SYMBOL_GPL(af_alg_pull_tsgl);
 
 /**
  * af_alg_free_areq_sgls - Release TX and RX SGLs of the request
  *
- * @areq Request holding the TX and RX SGL
+ * @areq: Request holding the TX and RX SGL
  */
 static void af_alg_free_areq_sgls(struct af_alg_async_req *areq)
 {
 	struct sock *sk = areq->sk;
 	struct alg_sock *ask = alg_sk(sk);
@@ -692,13 +692,13 @@ static void af_alg_free_areq_sgls(struct af_alg_async_req *areq)
 }
 
 /**
  * af_alg_wait_for_wmem - wait for availability of writable memory
  *
- * @sk socket of connection to user space
- * @flags If MSG_DONTWAIT is set, then only report if function would sleep
- * @return 0 when writable memory is available, < 0 upon error
+ * @sk: socket of connection to user space
+ * @flags: If MSG_DONTWAIT is set, then only report if function would sleep
+ * Return: 0 when writable memory is available, < 0 upon error
  */
 static int af_alg_wait_for_wmem(struct sock *sk, unsigned int flags)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	int err = -ERESTARTSYS;
@@ -725,11 +725,11 @@ static int af_alg_wait_for_wmem(struct sock *sk, unsigned int flags)
 }
 
 /**
  * af_alg_wmem_wakeup - wakeup caller when writable memory is available
  *
- * @sk socket of connection to user space
+ * @sk: socket of connection to user space
  */
 void af_alg_wmem_wakeup(struct sock *sk)
 {
 	struct socket_wq *wq;
 
@@ -748,14 +748,14 @@ void af_alg_wmem_wakeup(struct sock *sk)
 EXPORT_SYMBOL_GPL(af_alg_wmem_wakeup);
 
 /**
  * af_alg_wait_for_data - wait for availability of TX data
  *
- * @sk socket of connection to user space
- * @flags If MSG_DONTWAIT is set, then only report if function would sleep
- * @min Set to minimum request size if partial requests are allowed.
- * @return 0 when writable memory is available, < 0 upon error
+ * @sk: socket of connection to user space
+ * @flags: If MSG_DONTWAIT is set, then only report if function would sleep
+ * @min: Set to minimum request size if partial requests are allowed.
+ * Return: 0 when writable memory is available, < 0 upon error
  */
 int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min)
 {
 	DEFINE_WAIT_FUNC(wait, woken_wake_function);
 	struct alg_sock *ask = alg_sk(sk);
@@ -790,11 +790,11 @@ int af_alg_wait_for_data(struct sock *sk, unsigned flags, unsigned min)
 EXPORT_SYMBOL_GPL(af_alg_wait_for_data);
 
 /**
  * af_alg_data_wakeup - wakeup caller when new data can be sent to kernel
  *
- * @sk socket of connection to user space
+ * @sk: socket of connection to user space
  */
 static void af_alg_data_wakeup(struct sock *sk)
 {
 	struct alg_sock *ask = alg_sk(sk);
 	struct af_alg_ctx *ctx = ask->private;
@@ -820,16 +820,16 @@ static void af_alg_data_wakeup(struct sock *sk)
  * in ctx->tsgl_list. This implies allocation of the required numbers of
  * struct af_alg_tsgl.
  *
  * In addition, the ctx is filled with the information sent via CMSG.
  *
- * @sock socket of connection to user space
- * @msg message from user space
- * @size size of message from user space
- * @ivsize the size of the IV for the cipher operation to verify that the
+ * @sock: socket of connection to user space
+ * @msg: message from user space
+ * @size: size of message from user space
+ * @ivsize: the size of the IV for the cipher operation to verify that the
  *	   user-space-provided IV has the right size
- * @return the number of copied data upon success, < 0 upon error
+ * Return: the number of copied data upon success, < 0 upon error
  */
 int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 		   unsigned int ivsize)
 {
 	struct sock *sk = sock->sk;
@@ -984,10 +984,15 @@ int af_alg_sendmsg(struct socket *sock, struct msghdr *msg, size_t size,
 }
 EXPORT_SYMBOL_GPL(af_alg_sendmsg);
 
 /**
  * af_alg_sendpage - sendpage system call handler
+ * @sock: socket of connection to user space to write to
+ * @page: data to send
+ * @offset: offset into page to begin sending
+ * @size: length of data
+ * @flags: message send/receive flags
  *
  * This is a generic implementation of sendpage to fill ctx->tsgl_list.
  */
 ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 			int offset, size_t size, int flags)
@@ -1042,10 +1047,11 @@ ssize_t af_alg_sendpage(struct socket *sock, struct page *page,
 }
 EXPORT_SYMBOL_GPL(af_alg_sendpage);
 
 /**
  * af_alg_free_resources - release resources required for crypto request
+ * @areq: Request holding the TX and RX SGL
  */
 void af_alg_free_resources(struct af_alg_async_req *areq)
 {
 	struct sock *sk = areq->sk;
 	struct af_alg_ctx *ctx;
@@ -1058,10 +1064,13 @@ void af_alg_free_resources(struct af_alg_async_req *areq)
 }
 EXPORT_SYMBOL_GPL(af_alg_free_resources);
 
 /**
  * af_alg_async_cb - AIO callback handler
+ * @_req: async request info
+ * @err: if non-zero, error result to be returned via ki_complete();
+ *       otherwise return the AIO output length via ki_complete().
  *
  * This handler cleans up the struct af_alg_async_req upon completion of the
  * AIO operation.
  *
  * The number of bytes to be generated with the AIO operation must be set
@@ -1084,10 +1093,13 @@ void af_alg_async_cb(struct crypto_async_request *_req, int err)
 }
 EXPORT_SYMBOL_GPL(af_alg_async_cb);
 
 /**
  * af_alg_poll - poll system call handler
+ * @file: file pointer
+ * @sock: socket to poll
+ * @wait: poll_table
  */
 __poll_t af_alg_poll(struct file *file, struct socket *sock,
 			 poll_table *wait)
 {
 	struct sock *sk = sock->sk;
@@ -1109,13 +1121,13 @@ __poll_t af_alg_poll(struct file *file, struct socket *sock,
 EXPORT_SYMBOL_GPL(af_alg_poll);
 
 /**
  * af_alg_alloc_areq - allocate struct af_alg_async_req
  *
- * @sk socket of connection to user space
- * @areqlen size of struct af_alg_async_req + crypto_*_reqsize
- * @return allocated data structure or ERR_PTR upon error
+ * @sk: socket of connection to user space
+ * @areqlen: size of struct af_alg_async_req + crypto_*_reqsize
+ * Return: allocated data structure or ERR_PTR upon error
  */
 struct af_alg_async_req *af_alg_alloc_areq(struct sock *sk,
 					   unsigned int areqlen)
 {
 	struct af_alg_ctx *ctx = alg_sk(sk)->private;
@@ -1143,17 +1155,17 @@ EXPORT_SYMBOL_GPL(af_alg_alloc_areq);
 
 /**
  * af_alg_get_rsgl - create the RX SGL for the output data from the crypto
  *		     operation
  *
- * @sk socket of connection to user space
- * @msg user space message
- * @flags flags used to invoke recvmsg with
- * @areq instance of the cryptographic request that will hold the RX SGL
- * @maxsize maximum number of bytes to be pulled from user space
- * @outlen number of bytes in the RX SGL
- * @return 0 on success, < 0 upon error
+ * @sk: socket of connection to user space
+ * @msg: user space message
+ * @flags: flags used to invoke recvmsg with
+ * @areq: instance of the cryptographic request that will hold the RX SGL
+ * @maxsize: maximum number of bytes to be pulled from user space
+ * @outlen: number of bytes in the RX SGL
+ * Return: 0 on success, < 0 upon error
  */
 int af_alg_get_rsgl(struct sock *sk, struct msghdr *msg, int flags,
 		    struct af_alg_async_req *areq, size_t maxsize,
 		    size_t *outlen)
 {
diff --git a/lib/crypto/chacha.c b/lib/crypto/chacha.c
index 6b6ca1cba818..1bff9f283777 100644
--- a/lib/crypto/chacha.c
+++ b/lib/crypto/chacha.c
@@ -62,11 +62,11 @@ static void chacha_permute(u32 *x, int nrounds)
 		x[9]  += x[14];   x[4]  = rol32(x[4]  ^ x[9],   7);
 	}
 }
 
 /**
- * chacha_block - generate one keystream block and increment block counter
+ * chacha_block_generic - generate one keystream block and increment block counter
  * @state: input state matrix (16 32-bit words)
  * @stream: output keystream block (64 bytes)
  * @nrounds: number of rounds (20 or 12; 20 is recommended)
  *
  * This is the ChaCha core, a function from 64-byte strings to 64-byte strings.
@@ -92,11 +92,11 @@ void chacha_block_generic(u32 *state, u8 *stream, int nrounds)
 EXPORT_SYMBOL(chacha_block_generic);
 
 /**
  * hchacha_block_generic - abbreviated ChaCha core, for XChaCha
  * @state: input state matrix (16 32-bit words)
- * @out: output (8 32-bit words)
+ * @stream: output (8 32-bit words)
  * @nrounds: number of rounds (20 or 12; 20 is recommended)
  *
  * HChaCha is the ChaCha equivalent of HSalsa and is an intermediate step
  * towards XChaCha (see https://cr.yp.to/snuffle/xsalsa-20081128.pdf).  HChaCha
  * skips the final addition of the initial state, and outputs only certain words
-- 
2.54.0

