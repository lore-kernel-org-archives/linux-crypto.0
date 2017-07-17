From: "Zeng, Xin" <xin.zeng@intel.com>
Subject: RE: [PATCH] crypto: virtio - Refacotor virtio_crypto driver for new
 virito crypto services
Date: Mon, 17 Jul 2017 14:14:27 +0000
Message-ID: <82063967A54EF84C8AFCD6BD7F6AD93310D7102B@SHSMSX103.ccr.corp.intel.com>
References: <1498231879-3795-1-git-send-email-xin.zeng@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"arei.gonglei@huawei.com" <arei.gonglei@huawei.com>
To: "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"virtio-dev@lists.oasis-open.org" <virtio-dev@lists.oasis-open.org>
Return-path: <virtio-dev-return-2401-gcvd-virtio-dev=m.gmane.org@lists.oasis-open.org>
Sender: <virtio-dev@lists.oasis-open.org>
List-Post: <mailto:virtio-dev@lists.oasis-open.org>
List-Help: <mailto:virtio-dev-help@lists.oasis-open.org>
List-Unsubscribe: <mailto:virtio-dev-unsubscribe@lists.oasis-open.org>
List-Subscribe: <mailto:virtio-dev-subscribe@lists.oasis-open.org>
In-Reply-To: <1498231879-3795-1-git-send-email-xin.zeng@intel.com>
Content-Language: en-US
List-Id: linux-crypto.vger.kernel.org

Hi Herbert:
   Ping... any comments for this patch?

Regards
Xin

< -----Original Message-----
< From: Zeng, Xin
< Sent: Friday, June 23, 2017 11:31 PM
< To: herbert@gondor.apana.org.au; virtio-dev@lists.oasis-open.org
< Cc: linux-crypto@vger.kernel.org; arei.gonglei@huawei.com; Zeng, Xin
< <xin.zeng@intel.com>
< Subject: [PATCH] crypto: virtio - Refacotor virtio_crypto driver for new =
virito
< crypto services
<=20
< In current virtio crypto device driver, some common data structures and
< implementations that should be used by other virtio crypto algorithms
< (e.g. asymmetric crypto algorithms) introduce symmetric crypto algorithms
< specific implementations.
< This patch refactors these pieces of code so that they can be reused by
< other virtio crypto algorithms.
<=20
< Acked-by: Gonglei <arei.gonglei@huawei.com>
< Signed-off-by: Xin Zeng <xin.zeng@intel.com>
< ---
<  drivers/crypto/virtio/virtio_crypto_algs.c   | 109 +++++++++++++++++++++=
------
<  drivers/crypto/virtio/virtio_crypto_common.h |  22 +-----
<  drivers/crypto/virtio/virtio_crypto_core.c   |  37 ++-------
<  3 files changed, 98 insertions(+), 70 deletions(-)
<=20
< diff --git a/drivers/crypto/virtio/virtio_crypto_algs.c
< b/drivers/crypto/virtio/virtio_crypto_algs.c
< index 49defda..5035b0d 100644
< --- a/drivers/crypto/virtio/virtio_crypto_algs.c
< +++ b/drivers/crypto/virtio/virtio_crypto_algs.c
< @@ -27,12 +27,68 @@
<  #include <uapi/linux/virtio_crypto.h>
<  #include "virtio_crypto_common.h"
<=20
< +
< +struct virtio_crypto_ablkcipher_ctx {
< +	struct virtio_crypto *vcrypto;
< +	struct crypto_tfm *tfm;
< +
< +	struct virtio_crypto_sym_session_info enc_sess_info;
< +	struct virtio_crypto_sym_session_info dec_sess_info;
< +};
< +
< +struct virtio_crypto_sym_request {
< +	struct virtio_crypto_request base;
< +
< +	/* Cipher or aead */
< +	uint32_t type;
< +	struct virtio_crypto_ablkcipher_ctx *ablkcipher_ctx;
< +	struct ablkcipher_request *ablkcipher_req;
< +	uint8_t *iv;
< +	/* Encryption? */
< +	bool encrypt;
< +};
< +
<  /*
<   * The algs_lock protects the below global virtio_crypto_active_devs
<   * and crypto algorithms registion.
<   */
<  static DEFINE_MUTEX(algs_lock);
<  static unsigned int virtio_crypto_active_devs;
< +static void virtio_crypto_ablkcipher_finalize_req(
< +	struct virtio_crypto_sym_request *vc_sym_req,
< +	struct ablkcipher_request *req,
< +	int err);
< +
< +static void virtio_crypto_dataq_sym_callback
< +		(struct virtio_crypto_request *vc_req, int len)
< +{
< +	struct virtio_crypto_sym_request *vc_sym_req =3D
< +		container_of(vc_req, struct virtio_crypto_sym_request, base);
< +	struct ablkcipher_request *ablk_req;
< +	int error;
< +
< +	/* Finish the encrypt or decrypt process */
< +	if (vc_sym_req->type =3D=3D VIRTIO_CRYPTO_SYM_OP_CIPHER) {
< +		switch (vc_req->status) {
< +		case VIRTIO_CRYPTO_OK:
< +			error =3D 0;
< +			break;
< +		case VIRTIO_CRYPTO_INVSESS:
< +		case VIRTIO_CRYPTO_ERR:
< +			error =3D -EINVAL;
< +			break;
< +		case VIRTIO_CRYPTO_BADMSG:
< +			error =3D -EBADMSG;
< +			break;
< +		default:
< +			error =3D -EIO;
< +			break;
< +		}
< +		ablk_req =3D vc_sym_req->ablkcipher_req;
< +		virtio_crypto_ablkcipher_finalize_req(vc_sym_req,
< +							ablk_req, error);
< +	}
< +}
<=20
<  static u64 virtio_crypto_alg_sg_nents_length(struct scatterlist *sg)
<  {
< @@ -286,13 +342,14 @@ static int virtio_crypto_ablkcipher_setkey(struct
< crypto_ablkcipher *tfm,
<  }
<=20
<  static int
< -__virtio_crypto_ablkcipher_do_req(struct virtio_crypto_request *vc_req,
< +__virtio_crypto_ablkcipher_do_req(struct virtio_crypto_sym_request
< *vc_sym_req,
<  		struct ablkcipher_request *req,
<  		struct data_queue *data_vq)
<  {
<  	struct crypto_ablkcipher *tfm =3D crypto_ablkcipher_reqtfm(req);
< +	struct virtio_crypto_ablkcipher_ctx *ctx =3D vc_sym_req->ablkcipher_ctx=
;
< +	struct virtio_crypto_request *vc_req =3D &vc_sym_req->base;
<  	unsigned int ivsize =3D crypto_ablkcipher_ivsize(tfm);
< -	struct virtio_crypto_ablkcipher_ctx *ctx =3D vc_req->ablkcipher_ctx;
<  	struct virtio_crypto *vcrypto =3D ctx->vcrypto;
<  	struct virtio_crypto_op_data_req *req_data;
<  	int src_nents, dst_nents;
< @@ -326,9 +383,9 @@ __virtio_crypto_ablkcipher_do_req(struct
< virtio_crypto_request *vc_req,
<  	}
<=20
<  	vc_req->req_data =3D req_data;
< -	vc_req->type =3D VIRTIO_CRYPTO_SYM_OP_CIPHER;
< +	vc_sym_req->type =3D VIRTIO_CRYPTO_SYM_OP_CIPHER;
<  	/* Head of operation */
< -	if (vc_req->encrypt) {
< +	if (vc_sym_req->encrypt) {
<  		req_data->header.session_id =3D
<  			cpu_to_le64(ctx->enc_sess_info.session_id);
<  		req_data->header.opcode =3D
< @@ -383,7 +440,7 @@ __virtio_crypto_ablkcipher_do_req(struct
< virtio_crypto_request *vc_req,
<  	memcpy(iv, req->info, ivsize);
<  	sg_init_one(&iv_sg, iv, ivsize);
<  	sgs[num_out++] =3D &iv_sg;
< -	vc_req->iv =3D iv;
< +	vc_sym_req->iv =3D iv;
<=20
<  	/* Source data */
<  	for (i =3D 0; i < src_nents; i++)
< @@ -421,15 +478,18 @@ static int virtio_crypto_ablkcipher_encrypt(struct
< ablkcipher_request *req)
<  {
<  	struct crypto_ablkcipher *atfm =3D crypto_ablkcipher_reqtfm(req);
<  	struct virtio_crypto_ablkcipher_ctx *ctx =3D crypto_ablkcipher_ctx(atfm=
);
< -	struct virtio_crypto_request *vc_req =3D ablkcipher_request_ctx(req);
< +	struct virtio_crypto_sym_request *vc_sym_req =3D
< +				ablkcipher_request_ctx(req);
< +	struct virtio_crypto_request *vc_req =3D &vc_sym_req->base;
<  	struct virtio_crypto *vcrypto =3D ctx->vcrypto;
<  	/* Use the first data virtqueue as default */
<  	struct data_queue *data_vq =3D &vcrypto->data_vq[0];
<=20
< -	vc_req->ablkcipher_ctx =3D ctx;
< -	vc_req->ablkcipher_req =3D req;
< -	vc_req->encrypt =3D true;
<  	vc_req->dataq =3D data_vq;
< +	vc_req->alg_cb =3D virtio_crypto_dataq_sym_callback;
< +	vc_sym_req->ablkcipher_ctx =3D ctx;
< +	vc_sym_req->ablkcipher_req =3D req;
< +	vc_sym_req->encrypt =3D true;
<=20
<  	return crypto_transfer_cipher_request_to_engine(data_vq->engine,
< req);
<  }
< @@ -438,16 +498,18 @@ static int virtio_crypto_ablkcipher_decrypt(struct
< ablkcipher_request *req)
<  {
<  	struct crypto_ablkcipher *atfm =3D crypto_ablkcipher_reqtfm(req);
<  	struct virtio_crypto_ablkcipher_ctx *ctx =3D crypto_ablkcipher_ctx(atfm=
);
< -	struct virtio_crypto_request *vc_req =3D ablkcipher_request_ctx(req);
< +	struct virtio_crypto_sym_request *vc_sym_req =3D
< +				ablkcipher_request_ctx(req);
< +	struct virtio_crypto_request *vc_req =3D &vc_sym_req->base;
<  	struct virtio_crypto *vcrypto =3D ctx->vcrypto;
<  	/* Use the first data virtqueue as default */
<  	struct data_queue *data_vq =3D &vcrypto->data_vq[0];
<=20
< -	vc_req->ablkcipher_ctx =3D ctx;
< -	vc_req->ablkcipher_req =3D req;
< -
< -	vc_req->encrypt =3D false;
<  	vc_req->dataq =3D data_vq;
< +	vc_req->alg_cb =3D virtio_crypto_dataq_sym_callback;
< +	vc_sym_req->ablkcipher_ctx =3D ctx;
< +	vc_sym_req->ablkcipher_req =3D req;
< +	vc_sym_req->encrypt =3D false;
<=20
<  	return crypto_transfer_cipher_request_to_engine(data_vq->engine,
< req);
<  }
< @@ -456,7 +518,7 @@ static int virtio_crypto_ablkcipher_init(struct crypt=
o_tfm
< *tfm)
<  {
<  	struct virtio_crypto_ablkcipher_ctx *ctx =3D crypto_tfm_ctx(tfm);
<=20
< -	tfm->crt_ablkcipher.reqsize =3D sizeof(struct virtio_crypto_request);
< +	tfm->crt_ablkcipher.reqsize =3D sizeof(struct virtio_crypto_sym_request=
);
<  	ctx->tfm =3D tfm;
<=20
<  	return 0;
< @@ -479,11 +541,13 @@ int virtio_crypto_ablkcipher_crypt_req(
<  	struct crypto_engine *engine,
<  	struct ablkcipher_request *req)
<  {
< -	struct virtio_crypto_request *vc_req =3D ablkcipher_request_ctx(req);
< +	struct virtio_crypto_sym_request *vc_sym_req =3D
< +				ablkcipher_request_ctx(req);
< +	struct virtio_crypto_request *vc_req =3D &vc_sym_req->base;
<  	struct data_queue *data_vq =3D vc_req->dataq;
<  	int ret;
<=20
< -	ret =3D __virtio_crypto_ablkcipher_do_req(vc_req, req, data_vq);
< +	ret =3D __virtio_crypto_ablkcipher_do_req(vc_sym_req, req, data_vq);
<  	if (ret < 0)
<  		return ret;
<=20
< @@ -492,14 +556,15 @@ int virtio_crypto_ablkcipher_crypt_req(
<  	return 0;
<  }
<=20
< -void virtio_crypto_ablkcipher_finalize_req(
< -	struct virtio_crypto_request *vc_req,
< +static void virtio_crypto_ablkcipher_finalize_req(
< +	struct virtio_crypto_sym_request *vc_sym_req,
<  	struct ablkcipher_request *req,
<  	int err)
<  {
< -	crypto_finalize_cipher_request(vc_req->dataq->engine, req, err);
< -
< -	virtcrypto_clear_request(vc_req);
< +	crypto_finalize_cipher_request(vc_sym_req->base.dataq->engine,
< +					req, err);
< +	kzfree(vc_sym_req->iv);
< +	virtcrypto_clear_request(&vc_sym_req->base);
<  }
<=20
<  static struct crypto_alg virtio_crypto_algs[] =3D { {
< diff --git a/drivers/crypto/virtio/virtio_crypto_common.h
< b/drivers/crypto/virtio/virtio_crypto_common.h
< index da6d8c0..e976539 100644
< --- a/drivers/crypto/virtio/virtio_crypto_common.h
< +++ b/drivers/crypto/virtio/virtio_crypto_common.h
< @@ -83,26 +83,16 @@ struct virtio_crypto_sym_session_info {
<  	__u64 session_id;
<  };
<=20
< -struct virtio_crypto_ablkcipher_ctx {
< -	struct virtio_crypto *vcrypto;
< -	struct crypto_tfm *tfm;
< -
< -	struct virtio_crypto_sym_session_info enc_sess_info;
< -	struct virtio_crypto_sym_session_info dec_sess_info;
< -};
< +struct virtio_crypto_request;
< +typedef void (*virtio_crypto_data_callback)
< +		(struct virtio_crypto_request *vc_req, int len);
<=20
<  struct virtio_crypto_request {
< -	/* Cipher or aead */
< -	uint32_t type;
<  	uint8_t status;
< -	struct virtio_crypto_ablkcipher_ctx *ablkcipher_ctx;
< -	struct ablkcipher_request *ablkcipher_req;
<  	struct virtio_crypto_op_data_req *req_data;
<  	struct scatterlist **sgs;
< -	uint8_t *iv;
< -	/* Encryption? */
< -	bool encrypt;
<  	struct data_queue *dataq;
< +	virtio_crypto_data_callback alg_cb;
<  };
<=20
<  int virtcrypto_devmgr_add_dev(struct virtio_crypto *vcrypto_dev);
< @@ -119,10 +109,6 @@ void virtcrypto_dev_stop(struct virtio_crypto *vcryp=
to);
<  int virtio_crypto_ablkcipher_crypt_req(
<  	struct crypto_engine *engine,
<  	struct ablkcipher_request *req);
< -void virtio_crypto_ablkcipher_finalize_req(
< -	struct virtio_crypto_request *vc_req,
< -	struct ablkcipher_request *req,
< -	int err);
<=20
<  void
<  virtcrypto_clear_request(struct virtio_crypto_request *vc_req);
< diff --git a/drivers/crypto/virtio/virtio_crypto_core.c
< b/drivers/crypto/virtio/virtio_crypto_core.c
< index 21472e4..5752d4c 100644
< --- a/drivers/crypto/virtio/virtio_crypto_core.c
< +++ b/drivers/crypto/virtio/virtio_crypto_core.c
< @@ -29,7 +29,6 @@ void
<  virtcrypto_clear_request(struct virtio_crypto_request *vc_req)
<  {
<  	if (vc_req) {
< -		kzfree(vc_req->iv);
<  		kzfree(vc_req->req_data);
<  		kfree(vc_req->sgs);
<  	}
< @@ -41,40 +40,18 @@ static void virtcrypto_dataq_callback(struct virtqueu=
e
< *vq)
<  	struct virtio_crypto_request *vc_req;
<  	unsigned long flags;
<  	unsigned int len;
< -	struct ablkcipher_request *ablk_req;
< -	int error;
<  	unsigned int qid =3D vq->index;
<=20
<  	spin_lock_irqsave(&vcrypto->data_vq[qid].lock, flags);
<  	do {
<  		virtqueue_disable_cb(vq);
<  		while ((vc_req =3D virtqueue_get_buf(vq, &len)) !=3D NULL) {
< -			if (vc_req->type =3D=3D VIRTIO_CRYPTO_SYM_OP_CIPHER)
< {
< -				switch (vc_req->status) {
< -				case VIRTIO_CRYPTO_OK:
< -					error =3D 0;
< -					break;
< -				case VIRTIO_CRYPTO_INVSESS:
< -				case VIRTIO_CRYPTO_ERR:
< -					error =3D -EINVAL;
< -					break;
< -				case VIRTIO_CRYPTO_BADMSG:
< -					error =3D -EBADMSG;
< -					break;
< -				default:
< -					error =3D -EIO;
< -					break;
< -				}
< -				ablk_req =3D vc_req->ablkcipher_req;
< -
< -				spin_unlock_irqrestore(
< -					&vcrypto->data_vq[qid].lock, flags);
< -				/* Finish the encrypt or decrypt process */
< -				virtio_crypto_ablkcipher_finalize_req(vc_req,
< -				    ablk_req, error);
< -				spin_lock_irqsave(
< -					&vcrypto->data_vq[qid].lock, flags);
< -			}
< +			spin_unlock_irqrestore(
< +				&vcrypto->data_vq[qid].lock, flags);
< +			if (vc_req->alg_cb)
< +				vc_req->alg_cb(vc_req, len);
< +			spin_lock_irqsave(
< +				&vcrypto->data_vq[qid].lock, flags);
<  		}
<  	} while (!virtqueue_enable_cb(vq));
<  	spin_unlock_irqrestore(&vcrypto->data_vq[qid].lock, flags);
< @@ -271,7 +248,7 @@ static int virtcrypto_update_status(struct virtio_cry=
pto
< *vcrypto)
<=20
<  			return -EPERM;
<  		}
< -		dev_info(&vcrypto->vdev->dev, "Accelerator is ready\n");
< +		dev_info(&vcrypto->vdev->dev, "Accelerator device is ready\n");
<  	} else {
<  		virtcrypto_dev_stop(vcrypto);
<  		dev_info(&vcrypto->vdev->dev, "Accelerator is not ready\n");
< --
< 2.4.11
