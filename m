From: Adrian Bunk <bunk@stusta.de>
Subject: [-mm patch] CRYPTO_DEV_PADLOCK_AES must select CRYPTO_BLKCIPHER
Date: Sun, 20 Aug 2006 18:09:28 +0200
Message-ID: <20060820160928.GN7813@stusta.de>
References: <20060819220008.843d2f64.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Michal Ludvig <michal@logix.cz>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:61963 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S1750835AbWHTQJb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 20 Aug 2006 12:09:31 -0400
To: Andrew Morton <akpm@osdl.org>, herbert@gondor.apana.org.au
Content-Disposition: inline
In-Reply-To: <20060819220008.843d2f64.akpm@osdl.org>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sat, Aug 19, 2006 at 10:00:08PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.18-rc4-mm1:
>...
>  git-cryptodev.patch
> 
>  git trees
>...

This patch fixes the following compile error:

<--  snip  -->

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `cbc_aes_decrypt':
padlock-aes.c:(.text+0x6c63a): undefined reference to `blkcipher_walk_virt'
padlock-aes.c:(.text+0x6c66f): undefined reference to `blkcipher_walk_done'
drivers/built-in.o: In function `ecb_aes_decrypt':
padlock-aes.c:(.text+0x6c6af): undefined reference to `blkcipher_walk_virt'
padlock-aes.c:(.text+0x6c6de): undefined reference to `blkcipher_walk_done'
drivers/built-in.o: In function `ecb_aes_encrypt':
padlock-aes.c:(.text+0x6c768): undefined reference to `blkcipher_walk_virt'
padlock-aes.c:(.text+0x6c794): undefined reference to `blkcipher_walk_done'
drivers/built-in.o: In function `cbc_aes_encrypt':
padlock-aes.c:(.text+0x6c7d5): undefined reference to `blkcipher_walk_virt'
padlock-aes.c:(.text+0x6c821): undefined reference to `blkcipher_walk_done'
drivers/built-in.o:(.data+0xcfa8): undefined reference to `crypto_blkcipher_type'
drivers/built-in.o:(.data+0xd088): undefined reference to `crypto_blkcipher_type'
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->
 
Signed-off-by: Adrian Bunk <bunk@stusta.de>

---

BTW: The Kconfig+Makefile parts for padlock-sha seem to be missing.

--- linux-2.6.18-rc4-mm2/drivers/crypto/Kconfig.old	2006-08-20 17:28:46.000000000 +0200
+++ linux-2.6.18-rc4-mm2/drivers/crypto/Kconfig	2006-08-20 17:44:56.000000000 +0200
@@ -16,6 +16,7 @@
 config CRYPTO_DEV_PADLOCK_AES
 	bool "Support for AES in VIA PadLock"
 	depends on CRYPTO_DEV_PADLOCK
+	select CRYPTO_BLKCIPHER
 	default y
 	help
 	  Use VIA PadLock for AES algorithm.

