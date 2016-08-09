From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: AF_ALG broken?
Date: Tue, 9 Aug 2016 08:08:59 +0100
Message-ID: <20160809070859.GF1041@n2100.armlinux.org.uk>
References: <20160808181117.GD1041@n2100.armlinux.org.uk>
 <20160809031820.GA4142@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: noloader@gmail.com, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33902 "EHLO
	pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbcHIHJL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Aug 2016 03:09:11 -0400
Content-Disposition: inline
In-Reply-To: <20160809031820.GA4142@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 09, 2016 at 11:18:20AM +0800, Herbert Xu wrote:
> Russell King - ARM Linux <linux@armlinux.org.uk> wrote:
> > Testing that code on 4.8-rc (and 4.7 fwiw) gives:
> > 
> > socket(PF_ALG, SOCK_SEQPACKET, 0)       = 3
> > bind(3, {sa_family=AF_ALG, sa_data="hash\0\0\0\0\0\0\0\0\0\0"}, 88) = 0
> > accept(3, 0, NULL)                      = 4
> > write(4, "abc", 3)                      = -1 ENOKEY (Required key not available)
> > read(4, 0xbec50508, 20)                 = -1 ENOKEY (Required key not available)
> > 
> > IOW, the same problem - and it seems not to be a recent regression.
> > 
> > Since the last time I tested CESA or CAAM was back in 4.4 times,
> > it's got to be something between 4.4 and 4.7.
> > 
> > Looking at the history, my guess would be the setkey changes -
> > crypto: algif_skcipher - Require setkey before accept(2)
> > crypto: af_alg - Disallow bind/setkey/... after accept(2)
> > crypto: af_alg - Add nokey compatibility path
> > crypto: hash - Add crypto_ahash_has_setkey
> > crypto: algif_hash - Require setkey before accept(2)
> 
> This is definitely supposed to work.  Basically if the algorithm
> requires a key (e.g., HMAC) then you must set it.  Otherwise it
> should never return ENOKEY.
> 
> Which algorithm were you testing and what does /proc/crypto say?

Hi Herbert,

I thought I gave the commands and link to your example code.  The
openssl case is md5, though sha* also gives the same result.  Your
example code was sha1 iirc.  I guess none of these would be using
HMAC - the openssl cases used to give results compatible with the
md5sum/ sha1sum etc userspace commands.

/proc/crypto:

name         : md5
driver       : md5-caam
module       : caamhash
priority     : 3000
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 16

name         : hmac(md5)
driver       : hmac-md5-caam
module       : caamhash
priority     : 3000
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 16

name         : sha256
driver       : sha256-caam
module       : caamhash
priority     : 3000
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 32

name         : hmac(sha256)
driver       : hmac-sha256-caam
module       : caamhash
priority     : 3000
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 32

name         : sha224
driver       : sha224-caam
module       : caamhash
priority     : 3000
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 28

name         : hmac(sha224)
driver       : hmac-sha224-caam
module       : caamhash
priority     : 3000
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 28

name         : sha1
driver       : sha1-caam
module       : caamhash
priority     : 3000
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 20

name         : hmac(sha1)
driver       : hmac-sha1-caam
module       : caamhash
priority     : 3000
refcnt       : 1
selftest     : passed
internal     : no
type         : ahash
async        : yes
blocksize    : 64
digestsize   : 20

name         : ecb(aes)
driver       : ecb(aes-asm)
module       : kernel
priority     : 200
refcnt       : 3
selftest     : passed
internal     : no
type         : blkcipher
blocksize    : 16
min keysize  : 16
max keysize  : 32
ivsize       : 0
geniv        : <default>

name         : ghash
driver       : ghash-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 16
digestsize   : 16

name         : jitterentropy_rng
driver       : jitterentropy_rng
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : rng
seedsize     : 0

name         : stdrng
driver       : drbg_nopr_hmac_sha256
module       : kernel
priority     : 207
refcnt       : 2
selftest     : passed
internal     : no
type         : rng
seedsize     : 0

name         : stdrng
driver       : drbg_nopr_hmac_sha512
module       : kernel
priority     : 206
refcnt       : 1
selftest     : passed
internal     : no
type         : rng
seedsize     : 0

name         : stdrng
driver       : drbg_nopr_hmac_sha384
module       : kernel
priority     : 205
refcnt       : 1
selftest     : passed
internal     : no
type         : rng
seedsize     : 0

name         : stdrng
driver       : drbg_nopr_hmac_sha1
module       : kernel
priority     : 204
refcnt       : 1
selftest     : passed
internal     : no
type         : rng
seedsize     : 0

name         : hmac(sha256)
driver       : hmac(sha256-asm)
module       : kernel
priority     : 150
refcnt       : 2
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 32

name         : stdrng
driver       : drbg_pr_hmac_sha256
module       : kernel
priority     : 203
refcnt       : 1
selftest     : passed
internal     : no
type         : rng
seedsize     : 0

name         : stdrng
driver       : drbg_pr_hmac_sha512
module       : kernel
priority     : 202
refcnt       : 1
selftest     : passed
internal     : no
type         : rng
seedsize     : 0

name         : stdrng
driver       : drbg_pr_hmac_sha384
module       : kernel
priority     : 201
refcnt       : 1
selftest     : passed
internal     : no
type         : rng
seedsize     : 0

name         : stdrng
driver       : drbg_pr_hmac_sha1
module       : kernel
priority     : 200
refcnt       : 1
selftest     : passed
internal     : no
type         : rng
seedsize     : 0

name         : lzo
driver       : lzo-generic
module       : kernel
priority     : 0
refcnt       : 2
selftest     : passed
internal     : no
type         : compression

name         : crct10dif
driver       : crct10dif-generic
module       : kernel
priority     : 100
refcnt       : 2
selftest     : passed
internal     : no
type         : shash
blocksize    : 1
digestsize   : 2

name         : crc32c
driver       : crc32c-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 1
digestsize   : 4

name         : deflate
driver       : deflate-generic
module       : kernel
priority     : 0
refcnt       : 2
selftest     : passed
internal     : no
type         : compression

name         : ecb(arc4)
driver       : ecb(arc4)-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
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
internal     : no
type         : cipher
blocksize    : 1
min keysize  : 1
max keysize  : 256

name         : aes
driver       : aes-generic
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

name         : sha224
driver       : sha224-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 28

name         : sha256
driver       : sha256-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 32

name         : sha1
driver       : sha1-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 20

name         : digest_null
driver       : digest_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 1
digestsize   : 0

name         : compress_null
driver       : compress_null-generic
module       : kernel
priority     : 0
refcnt       : 1
selftest     : passed
internal     : no
type         : compression

name         : ecb(cipher_null)
driver       : ecb-cipher_null
module       : kernel
priority     : 100
refcnt       : 1
selftest     : passed
internal     : no
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
internal     : no
type         : cipher
blocksize    : 1
min keysize  : 0
max keysize  : 0

name         : sha512
driver       : sha512-arm
module       : kernel
priority     : 250
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 128
digestsize   : 64

name         : sha384
driver       : sha384-arm
module       : kernel
priority     : 250
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 128
digestsize   : 48

name         : sha224
driver       : sha224-asm
module       : kernel
priority     : 150
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 28

name         : sha256
driver       : sha256-asm
module       : kernel
priority     : 150
refcnt       : 2
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 32

name         : sha1
driver       : sha1-asm
module       : kernel
priority     : 150
refcnt       : 1
selftest     : passed
internal     : no
type         : shash
blocksize    : 64
digestsize   : 20

name         : aes
driver       : aes-asm
module       : kernel
priority     : 200
refcnt       : 2
selftest     : passed
internal     : no
type         : cipher
blocksize    : 16
min keysize  : 16
max keysize  : 32

Thanks.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line: currently at 9.6Mbps down 400kbps up
according to speedtest.net.
