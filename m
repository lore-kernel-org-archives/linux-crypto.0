From: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: Updated Openssl Patch to support Linux CryptoAPI
Date: Fri, 21 Nov 2008 17:15:28 +0300
Message-ID: <20081121141528.GA12867@ioremap.net>
References: <DB599F406D04E34389140B7D99C71B1B0679695D@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, Loc Ho <lho@amcc.com>
To: Shasi Pulijala <spulijala@amcc.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from intermatrixgroup.ru ([195.178.208.66]:42402 "EHLO
	tservice.net.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbYKUOPb (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 21 Nov 2008 09:15:31 -0500
Content-Disposition: inline
In-Reply-To: <DB599F406D04E34389140B7D99C71B1B0679695D@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi.

On Thu, Nov 20, 2008 at 05:58:15PM -0800, Shasi Pulijala (spulijala@amcc.com) wrote:
> #define CRYPTO_ALGORITHM_MIN		1
> @@ -178,16 +181,13 @@
> #define CRYPTO_FLAG_SOFTWARE	0x02000000	/* software implementation */
>  
>  /* NB: deprecated */

It is marked deprecated not even being submitted? :)

> -struct session_op {
> -	u_int32_t	cipher;		/* ie. CRYPTO_DES_CBC */
> -	u_int32_t	mac;		/* ie. CRYPTO_MD5_HMAC */
>  
> -	u_int32_t	keylen;		/* cipher key */
> -	caddr_t		key;
> -	int		mackeylen;	/* mac key */
> -	caddr_t		mackey;
> -
> -  	u_int32_t	ses;		/* returns: session # */ 
> +struct session_op {
> +	__u16		algo_size;
> +	__u16		key_size;	/* cipher key length */
> +	__u16		hmackey_size;	/* mac key length */
> +	__u16		icv_size;	/* authsize (ccm, gcm) */
> +	__u8		data[0];
> };
> 
>  struct crypt_op {
> -	u_int32_t	ses;
> -	u_int16_t	op;		/* i.e. COP_ENCRYPT */
> #define COP_NONE	0
> #define COP_ENCRYPT	1
> #define COP_DECRYPT	2
> -	u_int16_t	flags;
> -#define	COP_F_BATCH	0x0008		/* Batch op if possible */
> -	u_int		len;
> -	caddr_t		src, dst;	/* become iov[] inside kernel */
> -	caddr_t		mac;		/* must be big enough for chosen MAC */
> -	caddr_t		iv;
> +	__u16		op;		/* i.e. COP_ENCRYPT */
> +	__u16		flags;
> +	__u16		iv_size;
> +	__u16 		assoc_size;
> +	__u8		data[0];	/* must be big enough for chosen MAC */
> };
> -

Those structures should be included from appropriate kernel headers, no
need to create to different files with the same content.

> +/*******************************************************************************
> +* Table Lookup for Algorithms name(Crypto/hash name)
> +* Helper Structure
> +*******************************************************************************
> +*/
> +char *algo_map_tbl[CRYPTO_ALGORITHM_MAX] = {
> +	[CRYPTO_DES_CBC]  	= "cbc(des)",
> +	[CRYPTO_3DES_CBC] 	= "cbc(des3_ede)",
> +	[CRYPTO_MD5_HMAC] 	= "hmac(md5)",
> +	[CRYPTO_BLF_CBC]  	= "cbc(blowfish)",
> +	[CRYPTO_CAST_CBC]	= "cbc(cast5)",
> +	[CRYPTO_SKIPJACK_CBC]	= "camellia",
> +	[CRYPTO_MD5_HMAC]	= "hmac(md5)",
> +	[CRYPTO_SHA1_HMAC]	= "hmac(sha1)",
> +	[CRYPTO_RIPEMD160_HMAC]	= "hmac(rmd160)",
> +	[CRYPTO_MD5_KPDK]	= "",
> +	[CRYPTO_SHA1_KPDK]	= "",
> +	[CRYPTO_RIJNDAEL128_CBC] = "cbc(aes)",
> +	[CRYPTO_AES_CBC]	= "cbc(aes)",
> +	[CRYPTO_ARC4]		= "ecb(arc4)",
> +	[CRYPTO_MD5]		= "md5",
> +	[CRYPTO_SHA1]		= "sha1",
> +	[CRYPTO_NULL_HMAC]	= "",
> +	[CRYPTO_NULL_CBC]	= "",
> +	[CRYPTO_DEFLATE_COMP]	= "deflate",
> +	[CRYPTO_SHA2_256_HMAC]	= "hmac(sha256)",
> +	[CRYPTO_SHA2_384_HMAC]	= "hmac(sha384)",
> +	[CRYPTO_SHA2_512_HMAC]	= "hmac(sha512)",
> +	[CRYPTO_CAMELLIA_CBC]	= "cbc(camellia)",
> +	[CRYPTO_SHA2_256]	= "sha256",
> +	[CRYPTO_SHA2_384]	= "sha384",
> +	[CRYPTO_SHA2_512]	= "sha512",
> +	[CRYPTO_RIPEMD160]	= "rmd160",
> +	[CRYPTO_AES_GCM]	= "gcm(aes)",
> +	[CRYPTO_AES_CCM]	= "ccm(aes)",
> +};

This will not work with all possible algoritms and modes of operation,
what about creating ID as a bitmap of the mode and name IDs?

> +static int
>  open_dev_crypto(void)
>  {
>  	static int fd = -1;
> @@ -279,27 +332,31 @@
>  get_cryptodev_ciphers(const int **cnids)
>  {
>  	static int nids[CRYPTO_ALGORITHM_MAX];
> -	struct session_op sess;
> +	char datam[100];
> +	struct session_op *op = (struct session_op *) datam;
>  	int fd, i, count = 0;
> -
> -	if ((fd = get_dev_crypto()) < 0) {
> -		*cnids = NULL;
> -		return (0);
> -	}
> -	memset(&sess, 0, sizeof(sess));
> -	sess.key = (caddr_t)"123456789abcdefghijklmno";
> -
> +	char *key;
> +	
>  	for (i = 0; ciphers[i].id && count < CRYPTO_ALGORITHM_MAX; i++) {
>  		if (ciphers[i].nid == NID_undef)
>  			continue;
> -		sess.cipher = ciphers[i].id;
> -		sess.keylen = ciphers[i].keylen;
> -		sess.mac = 0;
> -		if (ioctl(fd, CIOCGSESSION, &sess) != -1 &&
> -		    ioctl(fd, CIOCFSESSION, &sess.ses) != -1)
> +		if ((fd = open_cryptodev_fd()) < 0) {
> +			*cnids = NULL;
> +			return (0);
> +		}
> +		memset(op, 0, sizeof(struct session_op));
> +		key = (caddr_t) "123456789abcdefghijklmno";
> +		op->algo_size = strlen(algo_map_tbl[ciphers[i].id]);
> +		op->key_size = ciphers[i].keylen;
> +		op->hmackey_size = 0;
> +		memcpy(op->data, algo_map_tbl[ciphers[i].id], op->algo_size);
> +		op->data[op->algo_size++] = '\0';
> +		memcpy(op->data + op->algo_size, key, op->key_size);
> +		
> +		if (ioctl(fd, CIOCGSESSION, op) != -1)
>  			nids[count++] = ciphers[i].nid;

I thought this is a fatal error, doesn't?

> +		close(fd);
>  	}
> -	close(fd);
>  
>  	if (count > 0)
>  		*cnids = nids;
> @@ -318,26 +375,34 @@
>  get_cryptodev_digests(const int **cnids)
>  {
>  	static int nids[CRYPTO_ALGORITHM_MAX];
> -	struct session_op sess;
> +	char data[100];
> +	struct session_op *op = (struct session_op *)data;
>  	int fd, i, count = 0;
> +	char *mackey = NULL;
>  
> -	if ((fd = get_dev_crypto()) < 0) {
> -		*cnids = NULL;
> -		return (0);
> -	}
> -	memset(&sess, 0, sizeof(sess));
> -	sess.mackey = (caddr_t)"123456789abcdefghijklmno";
>  	for (i = 0; digests[i].id && count < CRYPTO_ALGORITHM_MAX; i++) {
>  		if (digests[i].nid == NID_undef)
>  			continue;
> -		sess.mac = digests[i].id;
> -		sess.mackeylen = digests[i].keylen;
> -		sess.cipher = 0;
> -		if (ioctl(fd, CIOCGSESSION, &sess) != -1 &&
> -		    ioctl(fd, CIOCFSESSION, &sess.ses) != -1)
> +		if ((fd = open_cryptodev_fd()) < 0) {
> +			*cnids = NULL;
> +			return (0);
> +		}
> +
> +		memset(op, 0, sizeof(struct session_op));
> +		op->algo_size = strlen(algo_map_tbl[digests[i].id]);
> +		op->key_size = 0;
> +		op->hmackey_size = digests[i].keylen;
> +		memcpy(op->data, algo_map_tbl[digests[i].id], op->algo_size);
> +		if (op->hmackey_size)
> +			mackey = (caddr_t) "123456789abcdefghijklmno";
> +		op->data[op->algo_size++] = '\0';
> +		memcpy(op->data + op->algo_size, mackey, op->hmackey_size);
> +
> +		if (ioctl(fd, CIOCGSESSION, op) != -1)
>  			nids[count++] = digests[i].nid;

Same here and in other places where ioctl fails without returning error
to the callers.

-- 
	Evgeniy Polyakov
