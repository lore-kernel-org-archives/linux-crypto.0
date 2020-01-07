Return-Path: <SRS0=chSI=24=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DD46C47409
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 20:14:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5AB4524656
	for <linux-crypto@archiver.kernel.org>; Tue,  7 Jan 2020 20:14:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728711AbgAGUO3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 Jan 2020 15:14:29 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:59605 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728379AbgAGUO3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Jan 2020 15:14:29 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue012 [212.227.15.129]) with ESMTPA (Nemesis) id
 1MTfgb-1jGb592rZl-00U0gY; Tue, 07 Jan 2020 21:13:34 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Andy Polyakov <appro@cryptogams.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Ondrej Mosnacek <omosnace@redhat.com>,
        Eric Biggers <ebiggers@google.com>,
        Vitaly Chikunov <vt@altlinux.org>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] crypto: curve25519 - Work around link failure
Date:   Tue,  7 Jan 2020 21:12:52 +0100
Message-Id: <20200107201327.3863345-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:pH50uSqCPXHunlRYi6L8CL6v1F+HPRpeGWLVm1siLpp01pLtaYn
 2PDMeX31+oZWljGNiyUjWfyxUAFZwK/QAfPI1wCcfZl5GAPYJx5qHOhEpBctrIl2uSjelXj
 i1UTXn5i/CNQUw0e09IOKdcp8GXAp2bsUdxECMYVmA0h1keXVYE+yFYXhAL5ixNOMrFMeQw
 TFVM2igKOFrWWhhnU2NUg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:tDcVV9wxuqU=:t8AUGn6nGKs3yyta8KcKP9
 YezldtC334Khb/zyCxX4Fu431iOpWdOxOc9G3oFdit+QZ2W3BW4i7FDBhGMWSDe/eF1m0hCHt
 oXUfPnslXBwdE5ok7fJkCYAQM9UDMAp0hKGIge5Wpk+ygXLgA0ob73HjQRi0YzRXC1tKogWq+
 H6Kit0nwKikgOhDWy+1aHIO681UnKANQgTn1Ni8AnssmzzAWOuSwF6QiTyyjQyJLwD4o8GtQo
 wS/yE6dJrhWtHYpUMAaoU1UfjiYtt1MR5FYhRNMTRNh87Zvr2rFixrKANALKT1mf3rk9uC8d4
 i6YuQwE7HI/bGAHs3jKN/QOIXJJ1FRruNQVhTL/zEZujMszjaLc6R03kNW2XQIf7p4nO42U/W
 FiFkMy1iV7GZ5rwv38Xy9YeDyrLjT1wrWWOclFTgof+QoMdfsYFFhXeu7rUysNAoFhO+9RfOg
 t2KxGnJV/Q9wx9PRTY0/e5VHmarkx8Zx/sJUhU7azenscql3gXSITqJkGmGBvjVP00LZNwrKA
 EStlkmVMa3GgKb1tPQhMRcNaRwKGAGSQbFNVHMV5Vc1IMuX713DOS6JusgMuGAKyA+GsPFaoa
 ZyxVll8+IOIJCw8bMPb7sUNWWvoCexA5E2hdmeQxuauQZ5BEI3f3sOvFNTYemcv+8ma6Spg1g
 h0VllTvNpGHXiww1strijITU48e7q/RmxzKm5dK8z+WcPT+iRZmcjkgghcv++j0aX6i7cpIb9
 O1NRNJ3fyT2sshmooUf71rr1om2p6WjYb5qRDNHEO6RJOxw2xjsEzH5xsJHgFlKjeJs9m7Ljj
 Urp5ZSnywq+FNozooUpaW/j2zFufIRrtkNpG4N3lDDlGhdEO1W5qCWR38VhXtov6MNnNNim3T
 5zcMACR9nlBNHY2eU8KA==
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The curve25519 selftest causes a link failure when one of the two
implementations is built-in and the other one is a loadable module,
as then the library gets built in as well but cannot call into the
module:

lib/crypto/curve25519-selftest.o: In function `curve25519_selftest':
curve25519-selftest.c:(.init.text+0x5c): undefined reference to `curve25519_arch'
curve25519-selftest.c:(.init.text+0xfd): undefined reference to `curve25519_base_arch'
curve25519-selftest.c:(.init.text+0x15a): undefined reference to `curve25519_arch'

There is probably a better fix, but this is the local workaround
that I used to get a clean randconfig build again, using Makefile
tricks to make all the curve25519 code built-in if any of the
implementations are.

Fixes: aa127963f1ca ("crypto: lib/curve25519 - re-add selftests")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/crypto/Makefile | 4 +++-
 arch/x86/crypto/Makefile | 4 +++-
 crypto/Makefile          | 5 ++++-
 3 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm/crypto/Makefile b/arch/arm/crypto/Makefile
index b745c17d356f..a7b3957aca58 100644
--- a/arch/arm/crypto/Makefile
+++ b/arch/arm/crypto/Makefile
@@ -12,7 +12,9 @@ obj-$(CONFIG_CRYPTO_SHA512_ARM) += sha512-arm.o
 obj-$(CONFIG_CRYPTO_CHACHA20_NEON) += chacha-neon.o
 obj-$(CONFIG_CRYPTO_POLY1305_ARM) += poly1305-arm.o
 obj-$(CONFIG_CRYPTO_NHPOLY1305_NEON) += nhpoly1305-neon.o
-obj-$(CONFIG_CRYPTO_CURVE25519_NEON) += curve25519-neon.o
+ifdef CONFIG_CRYPTO_CURVE25519_NEON
+obj-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC) += curve25519-neon.o
+endif
 
 obj-$(CONFIG_CRYPTO_AES_ARM_CE) += aes-arm-ce.o
 obj-$(CONFIG_CRYPTO_SHA1_ARM_CE) += sha1-arm-ce.o
diff --git a/arch/x86/crypto/Makefile b/arch/x86/crypto/Makefile
index 958440eae27e..7546c276e2f0 100644
--- a/arch/x86/crypto/Makefile
+++ b/arch/x86/crypto/Makefile
@@ -39,7 +39,9 @@ obj-$(CONFIG_CRYPTO_AEGIS128_AESNI_SSE2) += aegis128-aesni.o
 
 obj-$(CONFIG_CRYPTO_NHPOLY1305_SSE2) += nhpoly1305-sse2.o
 obj-$(CONFIG_CRYPTO_NHPOLY1305_AVX2) += nhpoly1305-avx2.o
-obj-$(CONFIG_CRYPTO_CURVE25519_X86) += curve25519-x86_64.o
+ifdef CONFIG_CRYPTO_CURVE25519_X86
+obj-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC) += curve25519-x86_64.o
+endif
 
 # These modules require assembler to support AVX.
 ifeq ($(avx_supported),yes)
diff --git a/crypto/Makefile b/crypto/Makefile
index 4ca12b6044f7..93ecbfe50285 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -166,7 +166,10 @@ obj-$(CONFIG_CRYPTO_ZSTD) += zstd.o
 obj-$(CONFIG_CRYPTO_OFB) += ofb.o
 obj-$(CONFIG_CRYPTO_ECC) += ecc.o
 obj-$(CONFIG_CRYPTO_ESSIV) += essiv.o
-obj-$(CONFIG_CRYPTO_CURVE25519) += curve25519-generic.o
+
+ifdef CONFIG_CRYPTO_CURVE25519
+obj-$(CONFIG_CRYPTO_LIB_CURVE25519_GENERIC) += curve25519-generic.o
+endif
 
 ecdh_generic-y += ecdh.o
 ecdh_generic-y += ecdh_helper.o
-- 
2.20.0

