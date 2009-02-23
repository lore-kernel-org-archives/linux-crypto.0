From: "Loc Ho" <lho@amcc.com>
Subject: RE: [PATCH 1/1 v8] Add CryptoAPI User Interface Support v8
Date: Mon, 23 Feb 2009 10:46:43 -0800
Message-ID: <0CA0A16855646F4FA96D25A158E299D605E823E1@SDCEXCHANGE01.ad.amcc.com>
References: <DB599F406D04E34389140B7D99C71B1B06F2B86C@SDCEXCHANGE01.ad.amcc.com> <20090128044634.GE13157@gondor.apana.org.au> <0CA0A16855646F4FA96D25A158E299D605D3F8FD@SDCEXCHANGE01.ad.amcc.com> <20090223093558.GC10515@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Cc: <linux-crypto@vger.kernel.org>,
	"Evgeniy Polyakov" <zbr@ioremap.net>,
	"Shasi Pulijala" <spulijala@amcc.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sdcmail02.amcc.com ([198.137.200.73]:62263 "EHLO
	sdcmail02.amcc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996AbZBWSqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Feb 2009 13:46:46 -0500
Content-class: urn:content-classes:message
In-Reply-To: <20090223093558.GC10515@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

See inline...

-Loc

> 
> struct crypto_type {
> 	unsigned int (*ctxsize)(struct crypto_alg *alg, u32 type, u32 mask);
> 	int (*init)(struct crypto_tfm *tfm, u32 type, u32 mask);
> 	void (*exit)(struct crypto_tfm *tfm);
> 	void (*show)(struct seq_file *m, struct crypto_alg *alg);
> 	int (*uspace_setparam)(struct crypto_tfm *tfm, void *param, u32 param_size);
> 	int (*uspace_op)(struct crypto_tfm *tfm, 
> 			const struct iovec *iov, u32 iov_cnt,
> 			crypto_completion_t cb, void *ctx);
> };

I'd like to see a name field.  It's better to have user-space
pass through a string for the type instead of an ID.

The reason you want user-space to pass that through is so that
you can locate the crypto_type object and then call crypto_alloc_tfm
on it..

[Loc Ho]
The name field would not be known here. It will be at the cryptodev layer as it is the layer that create the tfm. In the above two functions, the parameter tfm has already been created.

Also the other two functions should take a void * instead of
crypto_tfm * since crypto_alloc_tfm now returns that.

[Loc Ho]
The function ctxsize, init, exit, and show already existed. For cryptodev, I added only uspace_setparam and uspace_op. We will change their first parameter to void *.

 
> struct uspace_session {
> 	__u8 alg_name[64];
> 	__u32 front_type; /* I don't believe we need this - leave for now */

So instead of front_type I'd like to see front_type_name.

[Loc Ho]
Okay... Maybe you see some value having a front_type_name. But as of right now, I only see the need for alg_name, type, and mask. 
 
> struct uspace_param {
> 	__u16 size;		/* We need this parameter as I/O control is only one pointer */
> 	__u8 data[0];	/* Variable size - parameters are crypto type specific */
> };
> 
> struct uspace_param_ahash { /* This is the data field of struct uspace_param */
> 	__u16 hmackey_size;
> 	__u8	data[0];
> };
> 
> struct uspace_param_aead { /* This is the data field of struct uspace_param */
> 	__u16 key_size;
> 	__u16 hmackey_size;
> 	__u8	data[0];
> };
> 
> /* Create crypto session */
> #define CIOCGSESSION    _IOWR('c', 101, struct session_op)
> /* Set algorithm parameters */
> #define CIOCPARAM    	_IOWR('c', 102, struct key_op)
> 
> struct upsace_aead_op {	/* Per operation for aead type */
> 	#define COP_NONE	0
> 	#define COP_ENCRYPT	1
> 	#define COP_DECRYPT	2
> 	__u16		op;		/* i.e. COP_ENCRYPT */
> 	__u16		flags;
> 	__u16		iv_size;
> 	__u16 	assoc_size;
> 	__u8		data[0];	/* parameter for aead per operation */		
> };

OK, I presume the idea is to stuff this into the iov that's passed
to uspace_op?

[Loc Ho]
Yes...

I'm starting to think that write(2) isn't really what we want.  The
reason is that each operation always has two types of data: obviously
we have the data itself, plus ancillary information like this struct
right here.

So how about switching over to the socket interface:

1. Create fd.

	fd = socket(AF_ALGO, SOCK_DGRAM, 0);

2. Allocate tfm, alg_name would be the uspace_session struct.

	connect(fd, alg_name, alg_name_len);

3. Set parameters.

	setsockopt(fd, ..., param, param_len);

4. Operate.

	sendmsg(fd, msg, flags);
[Loc Ho]
Okay... This would requires the caller to call the recvmsg and make use of standard async/sync socket interface. For async interface, caller will have to call the recvmsg. A sendmsg will always returns success unless HW ring is full. For sync interface, the function will block until the operation completed. If we switch to this interface, are you going to stick with this interface and apply this - at least until there is a better reason to change? Even if there is a good reason to change, I would like to see a version available in the crypto tree if not Linux kernel release tree. We will also look at splice as well if time permit.

Here struct msghdr provides for both the IOV array and space for
ancillary information.

Then the uspace_op function would just need to take a msg plus
the callback stuff.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
--
To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
