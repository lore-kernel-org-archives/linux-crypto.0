From: =?UTF-8?B?R3J6ZWdvcnogR8WCb3dhY2tp?= <G.Glowacki@wasko.pl>
Subject: IV is not send by kernel (ESP packet)
Date: Tue, 04 Jun 2013 14:28:02 +0200
Message-ID: <51ADDD52.8010404@wasko.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.wasko.pl ([193.178.240.3]:34158 "EHLO kurier.wasko.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314Ab3FDM24 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 4 Jun 2013 08:28:56 -0400
Received: from [10.4.20.8] (port=40358)
	by kurier.wasko.pl with esmtpsa (TLSv1:AES256-SHA:256)
	(Exim 4.76)
	(envelope-from <G.Glowacki@wasko.pl>)
	id 1UjqMA-0005jp-Gr
	for linux-crypto@vger.kernel.org; Tue, 04 Jun 2013 14:28:54 +0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


	

	

	

	


Hi,

I'm writing a kernel driver for a blkcipher. It does CBC and ciphering at one stage.
I can see packets going trough IPSec tunnel, but can't encode them on the other side, becouse the packet doesn't contain IV: on the decipher side in walk.iv, instead of IV, i see the ciphered data. captured package doesn't contain IV after sequance.
On the cipher side the walk.iv contains valid IV. Do You have any idea what's wrong?

During debugging process i've found out that IV is generated in eseqiv. I'm using linux-kernel 3.2.7.

Here is my /proc/crypto log:


Here is my /proc/crypto log:

# cat /proc/crypto
name         : cbc(aes)
driver       : cbc(aes-asm)
module       : kernel
priority     : 200
refcnt       : 3
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : authenc(hmac(md5),cbc(aes))
driver       : authenc(hmac(md5-generic),cbc-aes-jsd)
module       : kernel
priority     : 4000
refcnt       : 3
selftest     : passed
type         : aead
async        : no
blocksize    : 16
ivsize       : 16
maxauthsize  : 16
geniv        : <built-in>

name         : cbc(aes)
driver       : cbc-aes-jsd
module       : kernel
priority     : 400
refcnt       : 3
selftest     : passed
type         : givcipher
async        : no
blocksize    : 16
min keysize  : 32
max keysize  : 32
ivsize       : 16
geniv        : eseqiv

name         : rfc3686(ctr(aes))
driver       : rfc3686(ctr(aes-asm))
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 20
max keysize  : 36
ivsize       : 8
geniv        : seqiv

name         : ctr(aes)
driver       : ctr(aes-asm)
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : chainiv

name         : cbc(des3_ede)
driver       : cbc(des3_ede-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 24
max keysize  : 24
ivsize       : 8
geniv        : <default>

name         : cbc(des)
driver       : cbc(des-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 8
max keysize  : 8
ivsize       : 8
geniv        : <default>

name         : xcbc(aes)
driver       : xcbc(aes-asm)
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 16
digestsize   : 16

name         : hmac(sha512)
driver       : hmac(sha512-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 128
digestsize   : 64

name         : hmac(sha384)
driver       : hmac(sha384-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 128
digestsize   : 48

name         : hmac(sha256)
driver       : hmac(sha256-generic)
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : hmac(sha1)
driver       : hmac(sha1-ssse3)
module       : kernel
priority     : 150
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : hmac(md5)
driver       : hmac(md5-generic)
module       : kernel
priority     : 0
refcnt       : 5
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : cbc(aes)
driver       : cbc-aes-jsd
module       : kernel
priority     : 400
refcnt       : 3
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 32
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : ghash
driver       : ghash-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 16
digestsize   : 16

name         : stdrng
driver       : ansi_cprng
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : rng
seedsize     : 48

name         : stdrng
driver       : krng
module       : kernel
priority     : 200
refcnt       : 2
selftest     : passed
type         : rng
seedsize     : 0

name         : deflate
driver       : deflate-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : compression

name         : aes
driver       : aes-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : twofish
driver       : twofish-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : blowfish
driver       : blowfish-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 4
max keysize  : 56

name         : des3_ede
driver       : des3_ede-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 24
max keysize  : 24

name         : des
driver       : des-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 8
max keysize  : 8

name         : sha512
driver       : sha512-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 128
digestsize   : 64

name         : sha384
driver       : sha384-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 128
digestsize   : 48

name         : sha256
driver       : sha256-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : sha224
driver       : sha224-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 28

name         : sha1
driver       : sha1-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : md5
driver       : md5-generic
module       : kernel
priority     : 0
refcnt       : 3
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : compress_null
driver       : compress_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : compression

name         : digest_null
driver       : digest_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 0

name         : ecb(cipher_null)
driver       : ecb-cipher_null
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 0
max keysize  : 0
ivsize       : 0
geniv        : <default>

name         : cipher_null
driver       : cipher_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 1
min keysize  : 0
max keysize  : 0

name         : sha1
driver       : sha1-ssse3
module       : kernel
priority     : 150
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : ctr(twofish)
driver       : ctr-twofish-3way
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : cbc(twofish)
driver       : cbc-twofish-3way
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 16
geniv        : <default>

name         : ecb(twofish)
driver       : ecb-twofish-3way
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
geniv        : <default>

name         : twofish
driver       : twofish-asm
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : ctr(blowfish)
driver       : ctr-blowfish-asm
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 4
max keysize  : 56
ivsize       : 8
geniv        : <default>

name         : cbc(blowfish)
driver       : cbc-blowfish-asm
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 4
max keysize  : 56
ivsize       : 8
geniv        : <default>

name         : ecb(blowfish)
driver       : ecb-blowfish-asm
module       : kernel
priority     : 300
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 4
max keysize  : 56
ivsize       : 0
geniv        : <default>

name         : blowfish
driver       : blowfish-asm
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 4
max keysize  : 56

name         : aes
driver       : aes-asm
module       : kernel
priority     : 200
refcnt       : 3
selftest     : passed
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32



Here's my initialization blkcipher struct:

static struct crypto_alg jsd_aes_256_cbc_alg = {
	.cra_name			=	"cbc(aes)",
	.cra_driver_name	=	"cbc-aes-jsd",
	.cra_priority		=	400,
	.cra_flags			=	CRYPTO_ALG_TYPE_BLKCIPHER |
							CRYPTO_ALG_NEED_FALLBACK,
	.cra_init			=	fallback_init_blk,
	.cra_exit			=	fallback_exit_blk,
	.cra_blocksize		=	AES_MIN_BLOCK_SIZE,
	.cra_ctxsize		=	sizeof(struct mct_aes_op),
	.cra_alignmask		=	15,
	.cra_type			=	&crypto_blkcipher_type,
	.cra_module			=	THIS_MODULE,
	.cra_list			=	LIST_HEAD_INIT(jsd_aes_256_cbc_alg.cra_list),
	.cra_u				=	{
		.blkcipher	=	{
			.min_keysize	=	AES_KEYSIZE_256,
			.max_keysize	=	AES_KEYSIZE_256,
			.setkey			=	jsd_setkey_blk,
			.encrypt		=	jsd_cbc_encrypt,
			.decrypt		=	jsd_cbc_decrypt,
			.ivsize			=	AES_IV_LENGTH,
		}
	}
};

And very simmilar to the geode-aes encrypt function

static int
jsd_cbc_encrypt(struct blkcipher_desc *desc,
		  struct scatterlist *dst, struct scatterlist *src,
		  unsigned int nbytes)
{
	struct mct_aes_op *op = crypto_blkcipher_ctx(desc->tfm);
	struct blkcipher_walk walk;
	int err, ret;

	if (unlikely(op->keylen != AES_KEYSIZE_256))
	{
		printk(KERN_INFO "Encrypt Fallback\n");
		return fallback_blk_enc(desc, dst, src, nbytes);
	}
	blkcipher_walk_init(&walk, dst, src, nbytes);
	err = blkcipher_walk_virt(desc, &walk);

	op->flags = AES_DIR_ENCRYPT | AES_MODE_CBC | AES_256  | AES_BIGENDIAN;

	jsd_aes_set_key( (struct reg256_t *)op->key );

	if ( op->flags & AES_MODE_CBC ) {
		op->iv = walk.iv;
		//printk(KERN_DEBUG "JSD IV:%llX_%llX\n",((uint64_t*)op->iv)[0],((uint64_t*)op->iv)[1]);
		jsd_aes_set_iv ((struct reg128_t *)op->iv);
	}

	while ((nbytes = walk.nbytes)) {
		op->src = walk.src.virt.addr,
		op->dst = walk.dst.virt.addr;
		op->len = nbytes - (nbytes % AES_MIN_BLOCK_SIZE);

		ret = jsd_aes_crypt(op);
		memcpy(walk.iv, op->iv, AES_BLOCK_SIZE);
		nbytes -= ret;
		err = blkcipher_walk_done(desc, &walk, nbytes);
	}


	return err;
}

Thank You!
-- 
Grzegorz
