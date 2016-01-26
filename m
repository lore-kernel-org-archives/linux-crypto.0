From: Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 02/10] crypto: add algorithm type specific flag, CRYPTO_ALG_PRIVATE
Date: Tue, 26 Jan 2016 17:15:04 +0900
Message-ID: <1453796112-14273-3-git-send-email-iamjoonsoo.kim@lge.com>
References: <1453796112-14273-1-git-send-email-iamjoonsoo.kim@lge.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	Weigang Li <weigang.li@intel.com>,
	Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Dan Streetman <ddstreet@ieee.org>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f65.google.com ([209.85.220.65]:34661 "EHLO
	mail-pa0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090AbcAZIPf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 26 Jan 2016 03:15:35 -0500
In-Reply-To: <1453796112-14273-1-git-send-email-iamjoonsoo.kim@lge.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

In following patch, new synchronous compression APIs will be
introduced and it needs one flags to determine whether context buffer is
needed or not for decompression. It can be implemented by flag in it's own
algorithm structure definition but because there is a room in general
crypto_alg flag, this patch reuses it to reduce complexity. It possibly
can be used for other algorithm type.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
---
 include/linux/crypto.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index ab2a745..96530a1 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -101,6 +101,11 @@
 #define CRYPTO_ALG_INTERNAL		0x00002000
 
 /*
+ * Use this flag as algorithm type specific one.
+ */
+#define CRYPTO_ALG_PRIVATE		0x00004000
+
+/*
  * Transform masks and values (for crt_flags).
  */
 #define CRYPTO_TFM_REQ_MASK		0x000fff00
-- 
1.9.1
