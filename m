From: jonathan.thieuleux@gmail.com
Subject: Cipher block questions
Date: Tue, 21 Apr 2015 09:27:34 +0200
Message-ID: <20150421072734.GA9043@arch.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="UlVJffcvxoiEqYs2"
Content-Transfer-Encoding: 8bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38432 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751734AbbDUH1i (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Apr 2015 03:27:38 -0400
Received: by wiun10 with SMTP id n10so10771726wiu.1
        for <linux-crypto@vger.kernel.org>; Tue, 21 Apr 2015 00:27:37 -0700 (PDT)
Received: from localhost (lns-bzn-49f-62-147-175-21.adsl.proxad.net. [62.147.175.21])
        by mx.google.com with ESMTPSA id gu7sm18383346wib.21.2015.04.21.00.27.35
        for <linux-crypto@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Apr 2015 00:27:36 -0700 (PDT)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I'm implementing a new cipher block within the kernel and I'm stuck into a
problem. My algorithm works pretty well, it can cipher and decipher a block. The
algorithm also works with ECB, CBC, and CTR modes, however when I try to use the
modes such as XTS or LRW I have the following errors which are attached. Did I
need to add more code to make it work with XTS and other modes ?

Cheers,

--
Jonathan "Coldshell" Thieuleux
Mail : jonathan.thieuleux@gmail.com
IRC : coldshell [Freenode, OFTC]
Shaarli : https://links.stdcall.me/

"If you write interfaces with more than 4 or 5 function arguments, it's possible that you and I cannot be friends." -- David Miller

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=utf-8
Content-Disposition: attachment; filename="errors.txt"
Content-Transfer-Encoding: 8bit

-----------------------------Cryptsetup----------------------------
$sudo cryptsetup luksFormat --debug --cipher gost-xts-plain64 ~/test
# cryptsetup 1.6.6 processing "cryptsetup luksFormat --debug --cipher gost-xts-plain64 /home/coldshell/test"
# Running command luksFormat.
# Locking memory.
# Installing SIGINT/SIGTERM handler.
# Unblocking interruption on signal.

WARNING!
========
This will overwrite data on /home/coldshell/test irrevocably.

Are you sure? (Type uppercase yes): YES
# Allocating crypt device /home/coldshell/test context.
# Trying to open and read device /home/coldshell/test.
# Initialising device-mapper backend library.
# Timeout set to 0 miliseconds.
# Iteration time set to 1000 miliseconds.
# Interactive passphrase entry requested.
Enter passphrase:
Verify passphrase:
# Formatting device /home/coldshell/test as type LUKS1.
# Crypto backend (gcrypt 1.6.3) initialized.
# Detected kernel Linux 3.19.3-3-ARCH x86_64.
# Topology info for /home/coldshell/test not supported, using default offset 1048576 bytes.
# Checking if cipher gost-xts-plain64 is usable.
# Userspace crypto wrapper cannot use gost-xts-plain64 (-2).
# Using dmcrypt to access keyslot area.
# Allocating a free loop device.
# Trying to open and read device /dev/loop0.
# Calculated device size is 8 sectors (RW), offset 0.
# dm version   OF   [16384] (*1)
# dm versions   OF   [16384] (*1)
# Detected dm-crypt version 1.13.0, dm-ioctl version 4.29.0.
# Device-mapper backend running with UDEV support enabled.
# DM-UUID is CRYPT-TEMP-temporary-cryptsetup-1570
# Udev cookie 0xd4dffcb (semid 11042818) created
# Udev cookie 0xd4dffcb (semid 11042818) incremented to 1
# Udev cookie 0xd4dffcb (semid 11042818) incremented to 2
# Udev cookie 0xd4dffcb (semid 11042818) assigned to CREATE task(0) with flags DISABLE_SUBSYSTEM_RULES DISABLE_DISK_RULES DISABLE_OTHER_RULES         (0xe)
# dm create temporary-cryptsetup-1570 CRYPT-TEMP-temporary-cryptsetup-1570 OF   [16384] (*1)
# dm reload temporary-cryptsetup-1570  OFRW    [16384] (*1)
device-mapper: reload ioctl on  failed: Invalid argument
# Udev cookie 0xd4dffcb (semid 11042818) decremented to 1
# Udev cookie 0xd4dffcb (semid 11042818) incremented to 2
# Udev cookie 0xd4dffcb (semid 11042818) assigned to REMOVE task(2) with flags DISABLE_SUBSYSTEM_RULES DISABLE_DISK_RULES DISABLE_OTHER_RULES         (0xe)
# dm remove temporary-cryptsetup-1570  OFRW    [16384] (*1)
# temporary-cryptsetup-1570: Stacking NODE_DEL [verify_udev]
# Udev cookie 0xd4dffcb (semid 11042818) decremented to 0
# Udev cookie 0xd4dffcb (semid 11042818) waiting for zero
# Udev cookie 0xd4dffcb (semid 11042818) destroyed
# temporary-cryptsetup-1570: Processing NODE_DEL [verify_udev]
Failed to setup dm-crypt key mapping for device /home/coldshell/test.
Check that kernel supports gost-xts-plain64 cipher (check syslog for more info).
# Releasing crypt device /home/coldshell/test context.
# Releasing device-mapper backend.
# Closed loop /dev/loop0 (/home/coldshell/test).
# Unlocking memory.
Command failed with code 5: Failed to setup dm-crypt key mapping for device /home/coldshell/test.
Check that kernel supports gost-xts-plain64 cipher (check syslog for more info).

-----------------------------------Dmesg---------------------------------

$dmesg
[159333.709726] device-mapper: table: 254:0: crypt: Error allocating crypto tfm
[159333.709734] device-mapper: ioctl: error adding target to table

-----------------------------------Debug---------------------------------

When I debug, it fails at the function crypto_alloc_ablkcipher(), see below:

file : /drivers/md/dm-crypt.c

1399│ static int crypt_alloc_tfms(struct crypt_config *cc, char *ciphermode)
1400│ {
1401│         unsigned i;
1402│         int err;
1403│
1404│         cc->tfms = kmalloc(cc->tfms_count * sizeof(struct crypto_ablkcipher *),
1405│                            GFP_KERNEL);
1406│         if (!cc->tfms)
1407│                 return -ENOMEM;
1408│
1409│         for (i = 0; i < cc->tfms_count; i++) {
1410│                 cc->tfms[i] = crypto_alloc_ablkcipher(ciphermode, 0, 0);
1411├───────────────> if (IS_ERR(cc->tfms[i])) {
1412│                         err = PTR_ERR(cc->tfms[i]);
1413│                         crypt_free_tfms(cc);
1414│                         return err;
1415│                 }
1416│         }
1417│
1418│         return 0;
1419│ }
1420│

(gdb) p/x cc->tfms[i]
$1 = 0xffffffffffffffea

Input of the function : crypto_alloc_ablkcipher (alg_name=0xffff880039607cc0 "xts(gost)", type=0, mask=0) at crypto/ablkcipher.c:676

--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=proc-crypto

name         : xts(gost)
driver       : xts(gost-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : givcipher
async        : no
blocksize    : 8
min keysize  : 64
max keysize  : 64
ivsize       : 8
geniv        : eseqiv

name         : xts(gost)
driver       : xts(gost-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 8
min keysize  : 64
max keysize  : 64
ivsize       : 8
geniv        : <default>

name         : xts(aes)
driver       : xts(aes-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : givcipher
async        : no
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
geniv        : eseqiv

name         : xts(aes)
driver       : xts(aes-generic)
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 16
min keysize  : 32
max keysize  : 64
ivsize       : 16
geniv        : <default>

name         : gost
driver       : gost-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 32
max keysize  : 32

name         : stribog-256
driver       : stribog-256-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : stribog-512
driver       : stribog-512-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 64

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
driver       : krng
module       : kernel
priority     : 200
refcnt       : 2
selftest     : passed
type         : rng
seedsize     : 0

name         : crc32c
driver       : crc32c-generic
module       : kernel
priority     : 100
refcnt       : 2
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 4

name         : ecb(arc4)
driver       : ecb(arc4)-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : blkcipher
blocksize    : 1
min keysize  : 1
max keysize  : 256
ivsize       : 0
geniv        : <default>

name         : arc4
driver       : arc4-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 1
min keysize  : 1
max keysize  : 256

name         : cast5
driver       : cast5-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 5
max keysize  : 16

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

name         : des3_ede
driver       : des3_ede-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 24
max keysize  : 24

name         : des
driver       : des-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
type         : cipher
blocksize    : 8
min keysize  : 8
max keysize  : 8

name         : tgr128
driver       : tgr128-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : tgr160
driver       : tgr160-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 20

name         : tgr192
driver       : tgr192-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 24

name         : wp256
driver       : wp256-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

name         : wp384
driver       : wp384-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 48

name         : wp512
driver       : wp512-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
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

name         : sha512
driver       : sha512-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 128
digestsize   : 64

name         : sha224
driver       : sha224-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 28

name         : sha256
driver       : sha256-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 32

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
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 64
digestsize   : 16

name         : digest_null
driver       : digest_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : shash
blocksize    : 1
digestsize   : 0

name         : compress_null
driver       : compress_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
type         : compression

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


--UlVJffcvxoiEqYs2
Content-Type: text/x-c; charset=us-ascii
Content-Disposition: attachment; filename="gost28147-89.c"

/*
*
*
* Based on "Applied Cryptography" book
* Dev:
*    Me
*/

#include <linux/init.h>
#include <linux/module.h>
#include <linux/scatterlist.h>
#include <linux/crypto.h>
#include <linux/kernel.h>
#include <linux/types.h>
#include <linux/errno.h>
#include <crypto/gost28147-89.h>

int gost_expand_key(struct gost_ctx *CTX, const u8 *key, unsigned int keylen)
{
	if(unlikely(keylen != GOST_MAX_KEY_SIZE))
		goto gost_expand_keysize_err;

	memset(CTX, 0, sizeof(struct gost_ctx));

	/* Copy of the cipher key */
	memcpy(CTX->key_enc, key, keylen);
	if(IS_ERR(CTX->key_dec))
		goto gost_expand_copy_err;

	/* Copy of the decipher key */
	memcpy(CTX->key_dec, key, keylen);
	if(IS_ERR(CTX->key_dec))
		goto gost_expand_copy_err;

	CTX->key_length = keylen;
	CTX->sbox = &gost_sboxes[0];

	return 0;

 gost_expand_keysize_err:
	pr_err("An error occurred with the key size, key size is %u,"
	       "expected size is %u\n", keylen, GOST_MAX_KEY_SIZE);
	return -1;

 gost_expand_copy_err:
	pr_err("An error occurred during the copy of the structure\n");
	return -2;
}

inline void split_in_two(const u8 *src, u32 block[2])
{
	/* MSB */
	block[0] = *(u32 *) src;
	/* LSB */
	block[1] = *(u32 *) (src + sizeof(u32));
}
inline void merge_in_one(u32 block[2], u8 *dst)
{
	dst[0] = block[0]	& 0xFF;
	dst[1] = block[0] >> 8	& 0xFF;
	dst[2] = block[0] >> 16 & 0xFF;
	dst[3] = block[0] >> 24 & 0xFF;
	dst[4] = block[1]	& 0xFF;
	dst[5] = block[1] >> 8	& 0xFF;
	dst[6] = block[1] >> 16 & 0xFF;
	dst[7] = block[1] >> 24 & 0xFF;
}
inline u32 transform(u32 cm1, struct gost_ctx *CTX){

	cm1 = (uint32_t) (CTX->sbox->sbox[7][(cm1>>28) & 0xF]<< 28 |
			  CTX->sbox->sbox[6][cm1>>24 & 0xF] << 24 |
			  CTX->sbox->sbox[5][cm1>>20 & 0xF] << 20 |
			  CTX->sbox->sbox[4][cm1>>16 & 0xF] << 16 |
			  CTX->sbox->sbox[3][cm1>>12 & 0xF] << 12 |
			  CTX->sbox->sbox[2][cm1>> 8 & 0xF] <<  8 |
			  CTX->sbox->sbox[1][cm1>> 4 & 0xF] <<  4 |
			  CTX->sbox->sbox[0][cm1     & 0xF]);
	return (cm1 << 11) | (cm1 >> 21);
}
int gost_setkey(struct crypto_tfm * tfm, const u8 * key,
		unsigned int keylen)
{
	int ret;
	struct gost_ctx *CTX = crypto_tfm_ctx(tfm);

	ret = gost_expand_key(CTX, key, keylen);
	if(unlikely(ret != 0))
		goto gost_expand_err;

	return 0;

 gost_expand_err:
	pr_err("An error occurred during initialization of the key\n");
	return -1;

}
EXPORT_SYMBOL(gost_setkey);

void gost_encrypt(struct crypto_tfm * tfm,
		  u8 * dst,
		  const u8 * src)
{
	u32 in[2], out[2];
	register u32 n1, n2; 	/* see rfc5830 */
	struct gost_ctx *CTX = crypto_tfm_ctx(tfm);

	split_in_two(src, in);



	n1 = in[1];		/* R_{i-1} (lsb)*/
	n2 = in[0];		/* L_{i-1} (msb) */

	n2 ^= transform(n1+CTX->key_enc[0], CTX);/* n2 = R_{i}; n1 = R_{i-1} = L_{i} */
	n1 ^= transform(n2+CTX->key_enc[1], CTX);/* n1 = R{i+1}; n2 = R_{i} =  L_{i+1} */
	n2 ^= transform(n1+CTX->key_enc[2], CTX);
	n1 ^= transform(n2+CTX->key_enc[3], CTX);
	n2 ^= transform(n1+CTX->key_enc[4], CTX);
	n1 ^= transform(n2+CTX->key_enc[5], CTX);
	n2 ^= transform(n1+CTX->key_enc[6], CTX);
	n1 ^= transform(n2+CTX->key_enc[7], CTX);

	n2 ^= transform(n1+CTX->key_enc[0], CTX);
	n1 ^= transform(n2+CTX->key_enc[1], CTX);
	n2 ^= transform(n1+CTX->key_enc[2], CTX);
	n1 ^= transform(n2+CTX->key_enc[3], CTX);
	n2 ^= transform(n1+CTX->key_enc[4], CTX);
	n1 ^= transform(n2+CTX->key_enc[5], CTX);
	n2 ^= transform(n1+CTX->key_enc[6], CTX);
	n1 ^= transform(n2+CTX->key_enc[7], CTX);

	n2 ^= transform(n1+CTX->key_enc[0], CTX);
	n1 ^= transform(n2+CTX->key_enc[1], CTX);
	n2 ^= transform(n1+CTX->key_enc[2], CTX);
	n1 ^= transform(n2+CTX->key_enc[3], CTX);
	n2 ^= transform(n1+CTX->key_enc[4], CTX);
	n1 ^= transform(n2+CTX->key_enc[5], CTX);
	n2 ^= transform(n1+CTX->key_enc[6], CTX);
	n1 ^= transform(n2+CTX->key_enc[7], CTX);

	n2 ^= transform(n1+CTX->key_enc[7], CTX);
	n1 ^= transform(n2+CTX->key_enc[6], CTX);
	n2 ^= transform(n1+CTX->key_enc[5], CTX);
	n1 ^= transform(n2+CTX->key_enc[4], CTX);
	n2 ^= transform(n1+CTX->key_enc[3], CTX);
	n1 ^= transform(n2+CTX->key_enc[2], CTX);
	n2 ^= transform(n1+CTX->key_enc[1], CTX);
	n1 ^= transform(n2+CTX->key_enc[0], CTX);

	/* In the RFC order - N1, then N2 */
	out[0] = n2;
	out[1] = n1;
	merge_in_one(out, dst);

}
EXPORT_SYMBOL(gost_encrypt);
void gost_decrypt(struct crypto_tfm * tfm,
		  u8 * dst,
		  const u8 * src)
{

	u32 in[2], out[2];
	register u32 n1, n2; 	/* see rfc5830 */
	struct gost_ctx *CTX = crypto_tfm_ctx(tfm);

	split_in_two(src, in);

	n1 = in[0];		/* R_{i-1} (lsb)*/
	n2 = in[1];		/* L_{i-1} (msb) */

	n2 ^= transform(n1+CTX->key_dec[0], CTX); /* n2 = R_{i}; n1 = R_{i-1} = L_{i} */
	n1 ^= transform(n2+CTX->key_dec[1], CTX); /* n1 = R_{i+1}; n2 = R_{i} =  L_{i+1} */
	n2 ^= transform(n1+CTX->key_dec[2], CTX);
	n1 ^= transform(n2+CTX->key_dec[3], CTX);
	n2 ^= transform(n1+CTX->key_dec[4], CTX);
	n1 ^= transform(n2+CTX->key_dec[5], CTX);
	n2 ^= transform(n1+CTX->key_dec[6], CTX);
	n1 ^= transform(n2+CTX->key_dec[7], CTX);

	n2 ^= transform(n1+CTX->key_dec[7], CTX);
	n1 ^= transform(n2+CTX->key_dec[6], CTX);
	n2 ^= transform(n1+CTX->key_dec[5], CTX);
	n1 ^= transform(n2+CTX->key_dec[4], CTX);
	n2 ^= transform(n1+CTX->key_dec[3], CTX);
	n1 ^= transform(n2+CTX->key_dec[2], CTX);
	n2 ^= transform(n1+CTX->key_dec[1], CTX);
	n1 ^= transform(n2+CTX->key_dec[0], CTX);


	n2 ^= transform(n1+CTX->key_dec[7], CTX);
	n1 ^= transform(n2+CTX->key_dec[6], CTX);
	n2 ^= transform(n1+CTX->key_dec[5], CTX);
	n1 ^= transform(n2+CTX->key_dec[4], CTX);
	n2 ^= transform(n1+CTX->key_dec[3], CTX);
	n1 ^= transform(n2+CTX->key_dec[2], CTX);
	n2 ^= transform(n1+CTX->key_dec[1], CTX);
	n1 ^= transform(n2+CTX->key_dec[0], CTX);


	n2 ^= transform(n1+CTX->key_dec[7], CTX);
	n1 ^= transform(n2+CTX->key_dec[6], CTX);
	n2 ^= transform(n1+CTX->key_dec[5], CTX);
	n1 ^= transform(n2+CTX->key_dec[4], CTX);
	n2 ^= transform(n1+CTX->key_dec[3], CTX);
	n1 ^= transform(n2+CTX->key_dec[2], CTX);
	n2 ^= transform(n1+CTX->key_dec[1], CTX);
	n1 ^= transform(n2+CTX->key_dec[0], CTX);

	out[0] = n1;
	out[1] = n2;

	merge_in_one(out, dst);

}
EXPORT_SYMBOL(gost_decrypt);
static struct crypto_alg gost_alg = {
	.cra_name		=	"gost",
	.cra_driver_name	=	"gost-generic",
	.cra_priority	        =       100,
	.cra_flags		=	CRYPTO_ALG_TYPE_CIPHER,
	.cra_blocksize		=	GOST_BLOCK_SIZE,
	.cra_ctxsize		=	sizeof(struct gost_ctx),
	.cra_alignmask		=	3,
	.cra_module		=	THIS_MODULE,
	.cra_u			=	{
		.cipher = {
			.cia_min_keysize	=	GOST_MIN_KEY_SIZE,
			.cia_max_keysize	=	GOST_MAX_KEY_SIZE,
			.cia_setkey		=	gost_setkey,
			.cia_encrypt		=	gost_encrypt,
			.cia_decrypt		=	gost_decrypt
		}
	}
};

static int __init gost_init(void)
{
	pr_info("Initialization : GOST 28147-89 module\n");
	return crypto_register_alg(&gost_alg);
}

static void __exit gost_exit(void)
{
	pr_info("Exit : GOST 28147-89 module\n");
	crypto_unregister_alg(&gost_alg);
}
module_init(gost_init);
module_exit(gost_exit);

MODULE_DESCRIPTION("GOST 28147-89 cipher algorithm");
MODULE_LICENSE("GPL");
MODULE_ALIAS_CRYPTO("gost28147-89");
MODULE_ALIAS_CRYPTO("gost89");

--UlVJffcvxoiEqYs2
Content-Type: text/x-c; charset=us-ascii
Content-Disposition: attachment; filename="gost28147-89.h"

#ifndef GOST28147_89
#define GOST28147_89

#include <linux/types.h>

#define GOST_BLOCK_SIZE 8
#define GOST_MIN_KEY_SIZE 32
#define GOST_MAX_KEY_SIZE 32

struct  gost_s_box {
	char  *name;
	char  *oid;
	u8 sbox[8][16];
	u8 sbox_opti[4][256];
};


struct gost_ctx {
	u8 key_enc[GOST_MAX_KEY_SIZE];
	u8 key_dec[GOST_MAX_KEY_SIZE];
	u8 key_length;
	struct gost_s_box *sbox;
};

static struct gost_s_box gost_sboxes[] = {
	/*Russian Central Bank*/
	{ "test_3411",
	  "1.2.643.2.2.30.0",
	  {
		  {0x4, 0xA, 0x9, 0x2, 0xD, 0x8, 0x0, 0xE, 0x6, 0xB, 0x1, 0xC, 0x7, 0xF, 0x5, 0x3},
		  {0xE, 0xB, 0x4, 0xC, 0x6, 0xD, 0xF, 0xA, 0x2, 0x3, 0x8, 0x1, 0x0, 0x7, 0x5, 0x9},
		  {0x5, 0x8, 0x1, 0xD, 0xA, 0x3, 0x4, 0x2, 0xE, 0xF, 0xC, 0x7, 0x6, 0x0, 0x9, 0xB},
		  {0x7, 0xD, 0xA, 0x1, 0x0, 0x8, 0x9, 0xF, 0xE, 0x4, 0x6, 0xC, 0xB, 0x2, 0x5, 0x3},
		  {0x6, 0xC, 0x7, 0x1, 0x5, 0xF, 0xD, 0x8, 0x4, 0xA, 0x9, 0xE, 0x0, 0x3, 0xB, 0x2},
		  {0x4, 0xB, 0xA, 0x0, 0x7, 0x2, 0x1, 0xD, 0x3, 0x6, 0x8, 0x5, 0x9, 0xC, 0xF, 0xE},
		  {0xD, 0xB, 0x4, 0x1, 0x3, 0xF, 0x5, 0x9, 0x0, 0xA, 0xE, 0x7, 0x6, 0x8, 0x2, 0xC},
		  {0x1, 0xF, 0xD, 0x0, 0x5, 0x7, 0xA, 0x4, 0x9, 0x2, 0x3, 0xE, 0x6, 0xB, 0x8, 0xC}
	  },
	  {
		  {0},{0},{0},{0}
	  }

	}
};

#endif /* GOST28147_89 */

--UlVJffcvxoiEqYs2--
