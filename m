From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2 2/2] crypto: algif - change algif_skcipher to be asynchronous
Date: Tue, 10 Mar 2015 08:41:30 +0100
Message-ID: <26409073.mC6eRvfGxi@tauon>
References: <20150309205514.9648.701.stgit@tstruk-mobl1> <20150309205525.9648.96093.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:46467 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbbCJHld convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Mar 2015 03:41:33 -0400
In-Reply-To: <20150309205525.9648.96093.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 9. M=E4rz 2015, 13:55:25 schrieb Tadeusz Struk:

Hi Tadeusz,


>The way the algif_skcipher works currently is that on sendmsg/sendpage
>it builds an sgl for the input data and then on read/recvmsg it sends
>the job for encryption putting the user to sleep till the data is
>processed. This way it can only handle one job at a given time.
>This patch changes it to be asynchronous by adding AIO support.
>
>Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
>---
> crypto/algif_skcipher.c |  233
>++++++++++++++++++++++++++++++++++++++++++++++- 1 file changed, 226
>insertions(+), 7 deletions(-)
>
>diff --git a/crypto/algif_skcipher.c b/crypto/algif_skcipher.c
>index 0c8a1e5..790ed35 100644
>--- a/crypto/algif_skcipher.c
>+++ b/crypto/algif_skcipher.c
>@@ -39,6 +39,7 @@ struct skcipher_ctx {
>
> 	struct af_alg_completion completion;
>
>+	atomic_t inflight;
> 	unsigned used;
>
> 	unsigned int len;
>@@ -49,9 +50,65 @@ struct skcipher_ctx {
> 	struct ablkcipher_request req;
> };
>
>+struct skcipher_async_rsgl {
>+	struct af_alg_sgl sgl;
>+	struct list_head list;
>+};
>+
>+struct skcipher_async_req {
>+	struct kiocb *iocb;
>+	struct skcipher_async_rsgl first_sgl;
>+	struct list_head list;
>+	struct scatterlist *tsg;
>+	char iv[];
>+};
>+
>+#define GET_SREQ(areq, ctx) (struct skcipher_async_req *)((char *)are=
q
>+ \ +	crypto_ablkcipher_reqsize(crypto_ablkcipher_reqtfm(&ctx->req)))
>+
>+#define GET_REQ_SIZE(ctx) \
>+	crypto_ablkcipher_reqsize(crypto_ablkcipher_reqtfm(&ctx->req))
>+
>+#define GET_IV_SIZE(ctx) \
>+	crypto_ablkcipher_ivsize(crypto_ablkcipher_reqtfm(&ctx->req))

Wouldn't be an inline function better?
>+
> #define MAX_SGL_ENTS ((4096 - sizeof(struct skcipher_sg_list)) / \
> 		      sizeof(struct scatterlist) - 1)
>
>+static void skcipher_free_async_sgls(struct skcipher_async_req *sreq)
>+{
>+	struct skcipher_async_rsgl *rsgl, *tmp;
>+	struct scatterlist *sgl;
>+	struct scatterlist *sg;
>+	int i, n;
>+
>+	list_for_each_entry_safe(rsgl, tmp, &sreq->list, list) {
>+		af_alg_free_sg(&rsgl->sgl);
>+		if (rsgl !=3D &sreq->first_sgl)
>+			kfree(rsgl);
>+	}
>+	sgl =3D sreq->tsg;
>+	n =3D sg_nents(sgl);
>+	for_each_sg(sgl, sg, n, i)
>+		put_page(sg_page(sg));
>+
>+	kfree(sreq->tsg);
>+}
>+
>+static void skcipher_async_cb(struct crypto_async_request *req, int
>err) +{
>+	struct sock *sk =3D req->data;
>+	struct alg_sock *ask =3D alg_sk(sk);
>+	struct skcipher_ctx *ctx =3D ask->private;
>+	struct skcipher_async_req *sreq =3D GET_SREQ(req, ctx);
>+	struct kiocb *iocb =3D sreq->iocb;
>+
>+	atomic_dec(&ctx->inflight);
>+	skcipher_free_async_sgls(sreq);
>+	kfree(req);
>+	aio_complete(iocb, err, err);
>+}
>+
> static inline int skcipher_sndbuf(struct sock *sk)
> {
> 	struct alg_sock *ask =3D alg_sk(sk);
>@@ -96,7 +153,7 @@ static int skcipher_alloc_sgl(struct sock *sk)
> 	return 0;
> }
>
>-static void skcipher_pull_sgl(struct sock *sk, int used)
>+static void skcipher_pull_sgl(struct sock *sk, int used, int put)
> {
> 	struct alg_sock *ask =3D alg_sk(sk);
> 	struct skcipher_ctx *ctx =3D ask->private;
>@@ -123,8 +180,8 @@ static void skcipher_pull_sgl(struct sock *sk, int
>used)
>
> 			if (sg[i].length)
> 				return;
>-
>-			put_page(sg_page(sg + i));
>+			if (put)
>+				put_page(sg_page(sg + i));
> 			sg_assign_page(sg + i, NULL);
> 		}
>
>@@ -143,7 +200,7 @@ static void skcipher_free_sgl(struct sock *sk)
> 	struct alg_sock *ask =3D alg_sk(sk);
> 	struct skcipher_ctx *ctx =3D ask->private;
>
>-	skcipher_pull_sgl(sk, ctx->used);
>+	skcipher_pull_sgl(sk, ctx->used, 1);
> }
>
> static int skcipher_wait_for_wmem(struct sock *sk, unsigned flags)
>@@ -424,8 +481,149 @@ unlock:
> 	return err ?: size;
> }
>
>-static int skcipher_recvmsg(struct kiocb *unused, struct socket *sock=
,
>-			    struct msghdr *msg, size_t ignored, int=20
flags)
>+static int skcipher_all_sg_nents(struct skcipher_ctx *ctx)
>+{
>+	struct skcipher_sg_list *sgl;
>+	struct scatterlist *sg;
>+	int nents =3D 0;
>+
>+	list_for_each_entry(sgl, &ctx->tsgl, list) {
>+		sg =3D sgl->sg;
>+
>+		while (!sg->length)
>+			sg++;
>+
>+		nents +=3D sg_nents(sg);
>+	}
>+	return nents;
>+}
>+
>+static int skcipher_recvmsg_async(struct kiocb *iocb, struct socket
>*sock, +				  struct msghdr *msg, int flags)
>+{
>+	struct sock *sk =3D sock->sk;
>+	struct alg_sock *ask =3D alg_sk(sk);
>+	struct skcipher_ctx *ctx =3D ask->private;
>+	struct skcipher_sg_list *sgl;
>+	struct scatterlist *sg;
>+	struct skcipher_async_req *sreq;
>+	struct ablkcipher_request *req;
>+	struct skcipher_async_rsgl *last_rsgl =3D NULL;
>+	unsigned int len =3D 0, tx_nents =3D skcipher_all_sg_nents(ctx);
>+	unsigned int reqlen =3D sizeof(struct skcipher_async_req) +
>+				GET_REQ_SIZE(ctx) + GET_IV_SIZE(ctx);
>+	int i =3D 0;
>+	int err =3D -ENOMEM;
>+
>+	lock_sock(sk);
>+	req =3D kmalloc(reqlen, GFP_KERNEL);
>+	if (unlikely(!req))
>+		goto unlock;
>+
>+	sreq =3D GET_SREQ(req, ctx);
>+	sreq->iocb =3D iocb;
>+	memset(&sreq->first_sgl, '\0', sizeof(struct=20
skcipher_async_rsgl));
>+	INIT_LIST_HEAD(&sreq->list);
>+	sreq->tsg =3D kcalloc(tx_nents, sizeof(*sg), GFP_KERNEL);

Why do you use kcalloc here and not kmalloc (why is there a memset=20
needed considering that sg_init_table is called?

>+	if (unlikely(!sreq->tsg)) {
>+		kfree(req);
>+		goto unlock;
>+	}
>+	sg_init_table(sreq->tsg, tx_nents);
>+	memcpy(sreq->iv, ctx->iv, GET_IV_SIZE(ctx));
>+	ablkcipher_request_set_tfm(req, crypto_ablkcipher_reqtfm(&ctx-
>req));
>+	ablkcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG,
>+					skcipher_async_cb, sk);
>+
>+	while (iov_iter_count(&msg->msg_iter)) {
>+		struct skcipher_async_rsgl *rsgl;
>+		unsigned long used;
>+
>+		if (!ctx->used) {
>+			err =3D skcipher_wait_for_data(sk, flags);
>+			if (err)
>+				goto free;
>+		}
>+		sgl =3D list_first_entry(&ctx->tsgl,
>+				       struct skcipher_sg_list, list);
>+		sg =3D sgl->sg;
>+
>+		while (!sg->length)
>+			sg++;
>+
>+		used =3D min_t(unsigned long, ctx->used,
>+			     iov_iter_count(&msg->msg_iter));
>+		used =3D min_t(unsigned long, used, sg->length);
>+
>+		if (i =3D=3D tx_nents) {
>+			struct scatterlist *tmp;
>+			int x;
>+			/* Ran out of tx slots in async request
>+			 * need to expand */
>+			tmp =3D kcalloc(tx_nents * 2, sizeof(*tmp),
>+				      GFP_KERNEL);

Why is the memory increased by a factor of two?

Could you please point me to the logic that limits the allocation to=20
prevent user space eating up kernel memory?

Same as above: Why do you use kcalloc here and not kmalloc (why is ther=
e=20
a memset needed considering that sg_init_table is called?

>+			if (!tmp)
>+				goto free;
>+
>+			sg_init_table(tmp, tx_nents * 2);
>+			for (x =3D 0; x < tx_nents; x++)
>+				sg_set_page(&tmp[x], sg_page(&sreq-
>tsg[x]),
>+					    sreq->tsg[x].length,
>+					    sreq->tsg[x].offset);
>+			kfree(sreq->tsg);

It seems I miss a point here, but the code is freeing the existing sreg=
-
>tsg scatterlist just to replace it with the scatterlist that is twice=20
as big. The kernel had to fill the scatterlist that is twice as big wit=
h=20
seemingly the same data we already filled our list with (according to=20
the sg_set_page call below).

If I understand that right, isn't that unnecessary work? Why not just=20
allocate just one chunk of memory for a scatterlist holding the new=20
data, fill it and chain it with the existing scatterlist?

>+			sreq->tsg =3D tmp;
>+			tx_nents *=3D 2;
>+		}
>+		/* Need to take over the tx sgl from ctx
>+		 * to the asynch req - these sgls will be freed later */
>+		sg_set_page(sreq->tsg + i++, sg_page(sg), sg->length,
>+			    sg->offset);
>+
>+		if (list_empty(&sreq->list)) {
>+			rsgl =3D &sreq->first_sgl;
>+			list_add_tail(&rsgl->list, &sreq->list);
>+		} else {
>+			rsgl =3D kzalloc(sizeof(*rsgl), GFP_KERNEL);

Why is kzalloc called? Shouldn't kmalloc suffice?

>+			if (!rsgl) {
>+				err =3D -ENOMEM;
>+				goto free;
>+			}
>+			list_add_tail(&rsgl->list, &sreq->list);
>+		}
>+
>+		used =3D af_alg_make_sg(&rsgl->sgl, &msg->msg_iter, used);
>+		err =3D used;
>+		if (used < 0)
>+			goto free;
>+		if (last_rsgl)
>+			af_alg_link_sg(&last_rsgl->sgl, &rsgl->sgl);
>+
>+		last_rsgl =3D rsgl;
>+		len +=3D used;
>+		skcipher_pull_sgl(sk, used, 0);
>+		iov_iter_advance(&msg->msg_iter, used);
>+	}
>+
>+	ablkcipher_request_set_crypt(req, sreq->tsg, sreq-
>first_sgl.sgl.sg,
>+				     len, sreq->iv);
>+	err =3D ctx->enc ? crypto_ablkcipher_encrypt(req) :
>+			 crypto_ablkcipher_decrypt(req);
>+	if (err =3D=3D -EINPROGRESS) {
>+		atomic_inc(&ctx->inflight);
>+		err =3D -EIOCBQUEUED;
>+		goto unlock;
>+	}

To avoid races, shouldn't the atomic_inc of inflight happen before the=20
encryption / decryption call?

>+free:
>+	skcipher_free_async_sgls(sreq);
>+	kfree(req);
>+unlock:
>+	skcipher_wmem_wakeup(sk);
>+	release_sock(sk);
>+	return err;
>+}
>+
>+static int skcipher_recvmsg_sync(struct socket *sock, struct msghdr
>*msg, +				 int flags)
> {
> 	struct sock *sk =3D sock->sk;
> 	struct alg_sock *ask =3D alg_sk(sk);
>@@ -484,7 +682,7 @@ free:
> 			goto unlock;
>
> 		copied +=3D used;
>-		skcipher_pull_sgl(sk, used);
>+		skcipher_pull_sgl(sk, used, 1);
> 		iov_iter_advance(&msg->msg_iter, used);
> 	}
>
>@@ -497,6 +695,13 @@ unlock:
> 	return copied ?: err;
> }
>
>+static int skcipher_recvmsg(struct kiocb *iocb, struct socket *sock,
>+			    struct msghdr *msg, size_t ignored, int=20
flags)
>+{
>+	return is_sync_kiocb(iocb) ?
>+		skcipher_recvmsg_sync(sock, msg, flags) :
>+		skcipher_recvmsg_async(iocb, sock, msg, flags);
>+}
>
> static unsigned int skcipher_poll(struct file *file, struct socket
>*sock, poll_table *wait)
>@@ -555,12 +760,25 @@ static int skcipher_setkey(void *private, const
>u8 *key, unsigned int keylen) return crypto_ablkcipher_setkey(private,
>key, keylen);
> }
>
>+static void skcipher_wait(struct sock *sk)
>+{
>+	struct alg_sock *ask =3D alg_sk(sk);
>+	struct skcipher_ctx *ctx =3D ask->private;
>+	int ctr =3D 0;
>+
>+	while (atomic_read(&ctx->inflight) && ctr++ < 100)
>+		msleep(100);

What is the reason for taking 100? Why not 50 or 200?
>+}
>+
> static void skcipher_sock_destruct(struct sock *sk)
> {
> 	struct alg_sock *ask =3D alg_sk(sk);
> 	struct skcipher_ctx *ctx =3D ask->private;
> 	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(&ctx-
>req);
>
>+	if (atomic_read(&ctx->inflight))
>+		skcipher_wait(sk);
>+
> 	skcipher_free_sgl(sk);
> 	sock_kzfree_s(sk, ctx->iv, crypto_ablkcipher_ivsize(tfm));
> 	sock_kfree_s(sk, ctx, ctx->len);
>@@ -592,6 +810,7 @@ static int skcipher_accept_parent(void *private,
>struct sock *sk) ctx->more =3D 0;
> 	ctx->merge =3D 0;
> 	ctx->enc =3D 0;
>+	atomic_set(&ctx->inflight, 0);
> 	af_alg_init_completion(&ctx->completion);
>
> 	ask->private =3D ctx;
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-crypto=
"
>in the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


Ciao
Stephan
