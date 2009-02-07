From: "Loc Ho" <lho@amcc.com>
Subject: RE: [PATCH 1/1 v8] Add CryptoAPI User Interface Support v8
Date: Fri, 6 Feb 2009 16:13:40 -0800
Message-ID: <0CA0A16855646F4FA96D25A158E299D605D3F8FD@SDCEXCHANGE01.ad.amcc.com>
References: <DB599F406D04E34389140B7D99C71B1B06F2B86C@SDCEXCHANGE01.ad.amcc.com> <20090128044634.GE13157@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>,
	"Evgeniy Polyakov" <zbr@ioremap.net>,
	"Shasi Pulijala" <spulijala@amcc.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.73]:20379 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206AbZBGANq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Feb 2009 19:13:46 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20090128044634.GE13157@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I had looked into what you suggested. What about this implementation design below. I will show an implementation for ahash type only:

File: algapi.h

struct crypto_type {
	unsigned int (*ctxsize)(struct crypto_alg *alg, u32 type, u32 mask);
	int (*init)(struct crypto_tfm *tfm, u32 type, u32 mask);
	void (*exit)(struct crypto_tfm *tfm);
	void (*show)(struct seq_file *m, struct crypto_alg *alg);
	int (*uspace_setparam)(struct crypto_tfm *tfm, void *param, u32 param_size);
	int (*uspace_op)(struct crypto_tfm *tfm, 
			const struct iovec *iov, u32 iov_cnt,
			crypto_completion_t cb, void *ctx);
};

Please note the extra function uspace_setparam and uspace_op. Please note that
the parameter 'void *param' from function uspace_setparam are kernel space pointer.
The parameter 'const struct iovec *iov' are kernel space pointer. The handling of user 
space pointers will be handled by cryptodev driver. Linux CryptoAPI algorithm type will
always expect kernel accessible pointers.

File: cryptodev.h

struct uspace_session {
	__u8 alg_name[64];
	__u32 front_type; /* I don't believe we need this - leave for now */
	__u32 type;		/* We might need to allow a value of 0 for any */
	__u32 mask;		/* We might need to allow a value of 0 for any */
};

struct uspace_param {
	__u16 size;		/* We need this parameter as I/O control is only one pointer */
	__u8 data[0];	/* Variable size - parameters are crypto type specific */
};

struct uspace_param_ahash { /* This is the data field of struct uspace_param */
	__u16 hmackey_size;
	__u8	data[0];
};

struct uspace_param_aead { /* This is the data field of struct uspace_param */
	__u16 key_size;
	__u16 hmackey_size;
	__u8	data[0];
};

/* Create crypto session */
#define CIOCGSESSION    _IOWR('c', 101, struct session_op)
/* Set algorithm parameters */
#define CIOCPARAM    	_IOWR('c', 102, struct key_op)

struct upsace_aead_op {	/* Per operation for aead type */
	#define COP_NONE	0
	#define COP_ENCRYPT	1
	#define COP_DECRYPT	2
	__u16		op;		/* i.e. COP_ENCRYPT */
	__u16		flags;
	__u16		iv_size;
	__u16 	assoc_size;
	__u8		data[0];	/* parameter for aead per operation */		
};

File: cryptodev.c

Ioctl function:

switch (cmd) {
case CIOCGSESSION:
	a bunch of cryptodev code as before to decode alg_name, alg_type, alg_mask...
	/* Now create the session */
	ca = __crypto_alg_lookup(alg_name, alg_type, alg_mask);
	tfm = __crypto_alloc_tfm(ca, alg_type, alg_mask);
	/* Now save ca and tfm into cryptodev context structure */
	/* With this implementation, it relies on Linux CryptoAPI to create the tfm and
         no extra switch, if, and etc statement. */
	break;
case CIOCPARAM:
	a bunch of cryptodev code as before to decode 'struct uspace_param'
	/* Extract the alg type and tfm */
	tftm = ...
	ca = ...
	ca->cra_type->uspace_setparam(tfm, param, param_size);	
	break;
}

Write function (Per a operation):

Cryptodev_write(...)
{
	A bound of cryptodev code as before to map in the vector buffers.
	For ahash, it is just the data to be hashed. For aead, there is
	The data buffer and aead parameters. Plus cryptodev house works
	/* At this point, we have two pointers accessible by kernel - data to 
	   be hashed and result pointer - let call this iov[2] */
	/* Extract tftm and crypto alg */
	ca = ...
	tftm = ...
	ca->cra_type->uspace_op(tftm, iov, 2, cd_write_cb, context_ptr);
	return;		
}

... cd_write_cb(...)
{
	A bound of cryptodev code as before... If pages are pinned, then
	not much to do. If not, do copy to user space function calls.
}

File ahash.c:


static int crypto_ahash_us_setparam(struct crypto_tfm *tfm, 
				void *param, u32 param_size)
{
	struct crypto_ahash *atfm = __crypto_ahash_cast(tfm);	
	struct uspace_ahash_param *usp = param;
	int 	rc;

	rc = crypto_ahash_setkey(atfm, usp->data, usp->hmackey_size);
		::::
	return rc;
}
	
static int crypto_ahash_us_op(struct crypto_tfm *tfm, const struct iovec *iov,
				u32 iov_cnt, crypto_completion_t cb, void *ctx)
{
	struct crypto_ahash * atfm = __crypto_ahash_cast(tfm);	
	struct ahash_request * req;
	struct scatterlist * ssg;
	int 	len;
	int	len_sg;
	int	rc;
	
	len  = sizeof(struct ahash_request) + crypto_ahash_reqsize(atfm);
	len  = ALIGN(len, __alignof__(struct scatterlist));
	len_sg = len;
	len += sizeof(struct scatterlist);
	req  = kzalloc(len, GFP_KERNEL);
	if (req == NULL) 
		return -ENOMEM;

	/* For this example, iov[0] is data to be hashed and iov[1] is result buffer */
	ssg  = (struct scatterlist *) ((u8 *) req + len_sg);
	sg_init_one(ssg, iov[0].iov_base, iov[0].iov_len);
	
	ahash_request_set_tfm(req, atfm);
	ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_BACKLOG, cb, ctx);
	ahash_request_set_crypt(req, ssg, iov[1].iov_base, iov[0].iov_len);

	rc = crypto_ahash_digest(req);
	switch (rc) {
	case -EINPROGRESS:
		break;	
	case 0:
	case -EBUSY:
	default:
		kfree(req);
		break;
	}
	return rc;
}

const struct crypto_type crypto_ahash_type = {
	.ctxsize = crypto_ahash_ctxsize,
	.init = crypto_init_ahash_ops,
#ifdef CONFIG_PROC_FS
	.show = crypto_ahash_show,
#endif
	.uspace_setparam = crypto_ahash_us_setparam,
	.uspace_op = crypto_ahash_us_op
};

This addresses the algorithm abstraction as well as support for any CryptoAPI 
algorithm types. All user space buffers mapping to kernel space will still be handled 
by CryptoDev driver. This avoids creating a bunch of complication for each type of 
CryptoAPI type of algorithms.

-Loc

-----Original Message-----
From: Herbert Xu [mailto:herbert@gondor.apana.org.au] 
Sent: Tuesday, January 27, 2009 8:47 PM
To: Shasi Pulijala
Cc: Loc Ho
Subject: Re: [PATCH 1/1 v8] Add CryptoAPI User Interface Support v8

On Tue, Jan 20, 2009 at 11:40:21PM -0800, Shasi Pulijala wrote:
> Hi Herbert,
> 
> Thanks for all your comments and suggestions. 
> As per your comments we have come up with the following design for the
> user space design. The below are the structures and 
> API's  that provide the user interface to the cryptodev implementation.
> Could you please review this once and let me know 
> if it's a better abstract interface or if you see any problems with it.

Thanks for the quick turn-around!

> #define CRYPTODEV_NCRYPTO   Max num of Operations

If by operations you mean things like encrypt/decrypt/compress/decompress
then we shouldn't have a global ID space for them.  They should be
per-type.  That is, you have a separate ID space fir ciphers, hashes,
and so on.
 
> static struct cryptodev_link_handler
> *cryptodev_msg_handlers[CRYPTODEV_NCRYPTO];
> int cryptodev_register_handlers(int protocol,
>                 session_link_handler sessit, operation_link_handler
> opit)

Is this the kernel API? If so I don't think we need any new
registration interface since we can just go through the existing
crypto_type object.

So what would happen is that upon initilisation user-space gives
us a 4-tuple of (name, frontend type, type, mask).  We use that
to create the tfm object which would give us a pointer to the
frontend type (note that we don't currently have that pointer
but we should add it to crypto_tfm) that should then contain all
the hooks to further parse the requests from user-space.

After initilisation we would give user-space some sort of an ID
to the tfm object so all subsequent operations simply need to give
us the ID to get to the tfm and the rest of the info.

In fact we can just generate one file descriptor per tfm since
that gives us a natural limit on how many tfms you can allocate,
plus you can poll on it without being overwhelmed.

> struct cryptodev_cipher_op {
> #define COP_NONE	0
> #define COP_ENCRYPT	1
> #define COP_DECRYPT	2
> 	__u16		op;		/* i.e. COP_ENCRYPT */
> 	__u16		flags;
> 	__u16		iv_size;
> 	__u8 		data[0];
> }

It's probably best to separate the meta-data from the data since
making them contiguous is not always easy.  But otherwise this
looks fine to me.
 
> /** For Session **/
> 
> struct cryptodev_param_algo {
>       int type;
>       int param_len;
>       char param[0];
> };
> 
> struct cryptodev_cipher_algo {
>       char        alg_name[64];
>       __u16      alg_key_len;    
>       char        alg_key[0];
> };
> 
> struct cryptodev_aead_algo {
>       char        alg_name[64];
>       __u16      alg_key_len;      
>      __u16      alg_icv_len;      
>       char        alg_key[0];
> };

As I said above, I think we should have a generic 4-tuple struct
that is used to allocate the tfm, after which we can just use the
file descriptor.

> Session Related API's
> 
> static int cryptodev_ioctl(struct inode *inode, struct file *filp,
>             unsigned int cmd, unsigned long arg)
> {
> / *This will called when the user does an ioctl session creation */
>       This routine will do:
>       Creating the session,
>       copy_from_user(cryptodev_param_algo,  (void *) arg, sizeof(struct
> cryptodev_param_algo))
>       Check the type value in cryptodev_param_algo structure, and call
> the appropriate 
>       session creation handler
> 
> }

Right, I think we really only need to one ioctl to allocate the tfm,
which returns a new file descriptor and everything else can be done
with read/write.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
