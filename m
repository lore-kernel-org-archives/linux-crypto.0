From: Arnd Bergmann <arnd@arndb.de>
Subject: lib: sw842: select crc32
Date: Wed, 13 Jan 2016 23:24:02 +0100
Message-ID: <4168537.6I1FVkp3DA@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Dan Streetman <ddstreet@ieee.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:59585 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750AbcAMWYl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 13 Jan 2016 17:24:41 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

The sw842 library code was merged in linux-4.1 and causes a very rare randconfig
failure when CONFIG_CRC32 is not set:
    
    lib/built-in.o: In function `sw842_compress':
    oid_registry.c:(.text+0x12ddc): undefined reference to `crc32_be'
    lib/built-in.o: In function `sw842_decompress':
    oid_registry.c:(.text+0x137e4): undefined reference to `crc32_be'

This adds an explict 'select CRC32' statement, similar to what the other users
of the crc32 code have. In practice, CRC32 is always enabled anyway because
over 100 other symbols select it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Fixes: 2da572c959dd ("lib: add software 842 compression/decompression")

diff --git a/lib/Kconfig b/lib/Kconfig
index 1ce5af9cc418..ee38a3fd2814 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -217,9 +217,11 @@ config RANDOM32_SELFTEST
 # compression support is select'ed if needed
 #
 config 842_COMPRESS
+	select CRC32
 	tristate
 
 config 842_DECOMPRESS
+	select CRC32
 	tristate
 
 config ZLIB_INFLATE
