From: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v5] crypto: Add Allwinner Security System crypto accelerator
Date: Sun, 19 Oct 2014 16:16:18 +0200
Message-ID: <1413728182-13569-1-git-send-email-clabbe.montjoie@gmail.com>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	pawel.moll-5wv7dgnIgG8@public.gmane.org,
	mark.rutland-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org,
	galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
	maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org,
	linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org,
	akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org,
	gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org,
	joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org,
	mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org,
	crope-X3B1VOXEql0@public.gmane.org
Return-path: <linux-sunxi+bncBD7YLCN32UNBBOUPR6RAKGQEJDYBVNI-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <http://groups.google.com/group/linux-sunxi/subscribe>
List-Id: linux-crypto.vger.kernel.org

Hello

This is the driver for the Security System included in Allwinner SoC A20.
The Security System (SS for short) is a hardware cryptographic accelerator that support AES/MD5/SHA1/DES/3DES/PRNG algorithms.
It could be found on others Allwinner SoC: 
- A10s, A33 and A31 diagram speak about it with precisions (AES/DES/3DES/Md5/SHA1/PRNG)
- A10 and A13 manual give the same datasheet for SS than A20
- A23 speak about a security system but without precisions
- A80 datasheet speak about a security system with more functions (SHA224/SHA256/RSA/CRC) but without precisions
But I do not have access on any of those hardware, tests are welcome.

This driver currently supports:
- MD5 and SHA1 hash algorithms
- AES block cipher in CBC mode with 128/196/256bits keys.
- DES and 3DES block cipher in CBC mode
The driver exposes all those algorithms through the kernel cryptographic API.

The driver support only CPU driven (aka poll mode) transfer mode since the DMA engine of the A20 does not have a mainline driver yet.

Changes since v4:
- Rework all mutex path
- Use ahash_request_ctx() in hash functions
- Major rework of hash functions for solving mutex problems
- Split sunxi_req_ctx in two since ciphers now use struct sunxi_tfm_ctx
- Hash functions now test FIFO space register

Changes since v3:
- Remove all algorithms options from Kconfig, so now only one module is used
- Add the sunxi_ss_cipher function to unify mode calculation
- Remove the sunxi_cipher_exit empty function
- Add some missing mutex_unlock()
- Drop PRNG support, I wait for more comment on its results before re-enabling it.

Changes since v2:
- Fix Makefile and Kconfig for static kernel.

Changes since v1:
- annotate ss->base as __iomem
- regroup all mutex in the ss_ctx structure
- splited driver in 7 modules (core md5 sha1 aes des 3des prng) in sunxi-ss directory
- use dev_exit_p() for .remove
- added missing CRYPTO_BLKCIPHER dep in Kconfig
- use ahash instead of shash
- use ablkcipher instead of blkcipher
- use crypto_rng_ctx instead of crypto_tfm_ctx
- set seed as an u32
- drop useless comment decoration
- drop useless debug
- ss_ctx is now a static pointer and whole structure being allocated
- fix the platform_get_resource/devm_ioremap_resource pattern
- invert getting die id and configuring clock
- set clock value as a const unsigned long
- add MODULE_ALIAS
- use define names more consistency (SS_xxx)
- fix PRNG errors
- respell SS to Security System in DT documentation
