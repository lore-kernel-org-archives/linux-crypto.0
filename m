From: LABBE Corentin <clabbe.montjoie-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3] crypto: Add Allwinner Security System crypto accelerator
Date: Tue, 10 Jun 2014 14:43:13 +0200
Message-ID: <1402404197-4236-1-git-send-email-clabbe.montjoie@gmail.com>
Reply-To: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org,
	linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org,
	linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
To: robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org,
	pawel.moll-5wv7dgnIgG8@public.gmane.org,
	mark.rutland-5wv7dgnIgG8@public.gmane.org,
	ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org,
	galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org,
	rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org,
	maxime.ripard-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org,
	linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org,
	herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org,
	davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org,
	grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Return-path: <linux-sunxi+bncBD7YLCN32UNBB4P23OOAKGQEQZX7GYY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Post: <http://groups.google.com/group/linux-sunxi/post>, <mailto:linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <http://groups.google.com/support/>, <mailto:linux-sunxi+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <http://groups.google.com/group/linux-sunxi>
Sender: linux-sunxi-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
List-Subscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:linux-sunxi+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <http://groups.google.com/group/linux-sunxi/subscribe>, <mailto:googlegroups-manage+1076902468213+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Id: linux-crypto.vger.kernel.org

Hello

This is the driver for the Security System included in Allwinner SoC A20.
The Security System (SS for short) is a hardware cryptographic accelerator that support AES/MD5/SHA1/DES/3DES/PRNG algorithms.
It could be found on others Allwinner SoC: 
- A10s and A31 diagram speak about it with precisions (AES/DES/3DES/Md5/SHA1/PRNG)
- A10 and A13 manual give the same datasheet for SS than A20
- A23 speak about a security system but without precisions
But I do not have access on any of those hardware, tests are welcome.

This driver currently supports:
- MD5 and SHA1 hash algorithms
- AES block cipher in CBC mode with 128/196/256bits keys.
- DES and 3DES block cipher in CBC mode
- PRNG
The driver exposes all those algorithms through the kernel cryptographic API.

The driver support only CPU driven (aka poll mode) transfer mode since the DMA engine of the A20 does not have a driver yet.

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
