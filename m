From: Adrian Bunk <bunk@kernel.org>
Subject: [2.6.25 patch] CRYPTO_NULL must select CRYPTO_BLKCIPHER
Date: Sun, 17 Feb 2008 22:09:45 +0200
Message-ID: <20080217200945.GG1403@cs181133002.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: herbert@gondor.apana.org.au, davem@davemloft.net
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp6.pp.htv.fi ([213.243.153.40]:59628 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357AbYBQUKN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Feb 2008 15:10:13 -0500
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch fixes the following build error caused by commit 
3631c650c495d61b1dabf32eb26b46873636e918:

<--  snip  -->

...
  LD      .tmp_vmlinux1
crypto/built-in.o: In function `skcipher_null_crypt':
crypto_null.c:(.text+0x3d14): undefined reference to `blkcipher_walk_virt'
crypto_null.c:(.text+0x3d14): relocation truncated to fit: R_MIPS_26 against `blkcipher_walk_virt'
crypto/built-in.o: In function `$L32':
crypto_null.c:(.text+0x3d54): undefined reference to `blkcipher_walk_done'
crypto_null.c:(.text+0x3d54): relocation truncated to fit: R_MIPS_26 against `blkcipher_walk_done'
crypto/built-in.o:(.data+0x2e8): undefined reference to `crypto_blkcipher_type'
make[1]: *** [.tmp_vmlinux1] Error 1

<--  snip  -->

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
0f6b025864c8536538da5a6b2b68e73dba1a2ab8 diff --git a/crypto/Kconfig b/crypto/Kconfig
index c3166a1..b12a3ee 100644
--- a/crypto/Kconfig
+++ b/crypto/Kconfig
@@ -74,6 +74,7 @@ config CRYPTO_XCBC
 config CRYPTO_NULL
 	tristate "Null algorithms"
 	select CRYPTO_ALGAPI
+	select CRYPTO_BLKCIPHER
 	help
 	  These are 'Null' algorithms, used by IPsec, which do nothing.
 
