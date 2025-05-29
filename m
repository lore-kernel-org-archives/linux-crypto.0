Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57DC3B67F;
	Thu, 29 May 2025 17:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748539882; cv=none; b=THuS7kvoGxEwnWGciYOinnEVCjfzJmMffrjNlg9Fc4mP1+GRknmLNp8W04pJEXCqOqKtZGqFdwVH8lLz+uuRSbTGxfdXcyON6ij5gITnLMMTMR1fnUUz8ph4PxqTmEoWimw6TAXFgVAbPkD3It7LNCNpcSEZclZLtbV3Z8tx7Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748539882; c=relaxed/simple;
	bh=eJHe3QL2ZFLGTuDAjKNfjZ95JLx6wVjs73kqdqjM65Q=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k4LZMqRtKMOmVwpvrXtlEbdh1m3osSQOGZKAswid3yJi3gDKhy/6cjY/kyV2mCr59IxpeAdVIe+ccVnpyVqPczOyOhHb8yx6BBwxmybj+eT03Rrb215b0z6H0uwNmy0O6SwgiXAeM8wDSx4VrcEZdDf8SM23WE8rxleW4RdPH5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JIobDUBE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JIobDUBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7E4C4CEE7;
	Thu, 29 May 2025 17:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748539882;
	bh=eJHe3QL2ZFLGTuDAjKNfjZ95JLx6wVjs73kqdqjM65Q=;
	h=From:To:Cc:Subject:Date:From;
	b=JIobDUBEKLhUSuISDV4aU+0j9KyJeS5Hl3ctPf7pRuD+UDy60r0taqWf9dRsVnGPm
	 /a32ulttUyZR0bf53VL3jSwWK1hsSovHrYaBJFtw1xjRObX9A9wL1EUday4dgIvdgK
	 rV4Mq+qhQcVkyNqBfKmHy6F7NV4yno/WJa8XWNeUmCabnBT6orGgtHp8pjo7mawrY/
	 CJupza/+RIeL2wzHZjLaNx0fD3Lfd6BXdMqJN/K+OLkpykf94mjbU9pOu8DIjNvjhC
	 QuK+eA198il3vtK42qaygU2Ou3csZ58Et7OthB+cKyXmPTHqchojYV1rKCAtWNyCD6
	 FhuJdZI90z77Q==
From: Kees Cook <kees@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <kees@kernel.org>,
	Eric Biggers <ebiggers@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-hardening@vger.kernel.org
Subject: [PATCH] crypto: Annotate crypto strings with nonstring
Date: Thu, 29 May 2025 10:31:17 -0700
Message-Id: <20250529173113.work.760-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8228; i=kees@kernel.org; h=from:subject:message-id; bh=eJHe3QL2ZFLGTuDAjKNfjZ95JLx6wVjs73kqdqjM65Q=; b=owGbwMvMwCVmps19z/KJym7G02pJDBkWM5/KOb9d1D+DT/W1FXPESROHnwaTzy4+XnxU6J2px Am3yceEO0pZGMS4GGTFFFmC7NzjXDzetoe7z1WEmcPKBDKEgYtTACaiUMXIcKJAR/HYeq+F52aH 5tb7pc8Q8rD7fmzt7oeaFdsvNatxLmH4Zy6ze+WyTQnXzI90Nqx6a7xlKmepy2G51THvj2kayMY 3MAAA
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

Annotate various keys, ivs, and other byte arrays with __nonstring so
that static initializers will not complain about truncating the trailing
NUL byte under GCC 15 with -Wunterminated-string-initialization enabled.
Silences many warnings like:

../lib/crypto/aesgcm.c:642:27: warning: initializer-string for array of 'unsigned char' truncates NUL terminator but destination lacks 'nonstring' attribute (13 chars into 12 available) [-Wunterminated-string-initialization]
  642 |                 .iv     = "\xca\xfe\xba\xbe\xfa\xce\xdb\xad"
      |                           ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Kees Cook <kees@kernel.org>
---
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: <linux-crypto@vger.kernel.org>
---
 lib/crypto/aescfb.c |  8 ++++----
 lib/crypto/aesgcm.c | 46 ++++++++++++++++++++++-----------------------
 2 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/lib/crypto/aescfb.c b/lib/crypto/aescfb.c
index 437613265e14..2f09ae92ffa0 100644
--- a/lib/crypto/aescfb.c
+++ b/lib/crypto/aescfb.c
@@ -106,11 +106,11 @@ MODULE_LICENSE("GPL");
  */
 
 static struct {
-	u8	ptext[64];
-	u8	ctext[64];
+	u8	ptext[64] __nonstring;
+	u8	ctext[64] __nonstring;
 
-	u8	key[AES_MAX_KEY_SIZE];
-	u8	iv[AES_BLOCK_SIZE];
+	u8	key[AES_MAX_KEY_SIZE] __nonstring;
+	u8	iv[AES_BLOCK_SIZE] __nonstring;
 
 	int	klen;
 	int	len;
diff --git a/lib/crypto/aesgcm.c b/lib/crypto/aesgcm.c
index 277824d6b4af..faa4dee9bb1b 100644
--- a/lib/crypto/aesgcm.c
+++ b/lib/crypto/aesgcm.c
@@ -205,19 +205,19 @@ MODULE_LICENSE("GPL");
  * Test code below. Vectors taken from crypto/testmgr.h
  */
 
-static const u8 __initconst ctext0[16] =
+static const u8 __initconst ctext0[16] __nonstring =
 	"\x58\xe2\xfc\xce\xfa\x7e\x30\x61"
 	"\x36\x7f\x1d\x57\xa4\xe7\x45\x5a";
 
 static const u8 __initconst ptext1[16];
 
-static const u8 __initconst ctext1[32] =
+static const u8 __initconst ctext1[32] __nonstring =
 	"\x03\x88\xda\xce\x60\xb6\xa3\x92"
 	"\xf3\x28\xc2\xb9\x71\xb2\xfe\x78"
 	"\xab\x6e\x47\xd4\x2c\xec\x13\xbd"
 	"\xf5\x3a\x67\xb2\x12\x57\xbd\xdf";
 
-static const u8 __initconst ptext2[64] =
+static const u8 __initconst ptext2[64] __nonstring =
 	"\xd9\x31\x32\x25\xf8\x84\x06\xe5"
 	"\xa5\x59\x09\xc5\xaf\xf5\x26\x9a"
 	"\x86\xa7\xa9\x53\x15\x34\xf7\xda"
@@ -227,7 +227,7 @@ static const u8 __initconst ptext2[64] =
 	"\xb1\x6a\xed\xf5\xaa\x0d\xe6\x57"
 	"\xba\x63\x7b\x39\x1a\xaf\xd2\x55";
 
-static const u8 __initconst ctext2[80] =
+static const u8 __initconst ctext2[80] __nonstring =
 	"\x42\x83\x1e\xc2\x21\x77\x74\x24"
 	"\x4b\x72\x21\xb7\x84\xd0\xd4\x9c"
 	"\xe3\xaa\x21\x2f\x2c\x02\xa4\xe0"
@@ -239,7 +239,7 @@ static const u8 __initconst ctext2[80] =
 	"\x4d\x5c\x2a\xf3\x27\xcd\x64\xa6"
 	"\x2c\xf3\x5a\xbd\x2b\xa6\xfa\xb4";
 
-static const u8 __initconst ptext3[60] =
+static const u8 __initconst ptext3[60] __nonstring =
 	"\xd9\x31\x32\x25\xf8\x84\x06\xe5"
 	"\xa5\x59\x09\xc5\xaf\xf5\x26\x9a"
 	"\x86\xa7\xa9\x53\x15\x34\xf7\xda"
@@ -249,7 +249,7 @@ static const u8 __initconst ptext3[60] =
 	"\xb1\x6a\xed\xf5\xaa\x0d\xe6\x57"
 	"\xba\x63\x7b\x39";
 
-static const u8 __initconst ctext3[76] =
+static const u8 __initconst ctext3[76] __nonstring =
 	"\x42\x83\x1e\xc2\x21\x77\x74\x24"
 	"\x4b\x72\x21\xb7\x84\xd0\xd4\x9c"
 	"\xe3\xaa\x21\x2f\x2c\x02\xa4\xe0"
@@ -261,17 +261,17 @@ static const u8 __initconst ctext3[76] =
 	"\x5b\xc9\x4f\xbc\x32\x21\xa5\xdb"
 	"\x94\xfa\xe9\x5a\xe7\x12\x1a\x47";
 
-static const u8 __initconst ctext4[16] =
+static const u8 __initconst ctext4[16] __nonstring =
 	"\xcd\x33\xb2\x8a\xc7\x73\xf7\x4b"
 	"\xa0\x0e\xd1\xf3\x12\x57\x24\x35";
 
-static const u8 __initconst ctext5[32] =
+static const u8 __initconst ctext5[32] __nonstring =
 	"\x98\xe7\x24\x7c\x07\xf0\xfe\x41"
 	"\x1c\x26\x7e\x43\x84\xb0\xf6\x00"
 	"\x2f\xf5\x8d\x80\x03\x39\x27\xab"
 	"\x8e\xf4\xd4\x58\x75\x14\xf0\xfb";
 
-static const u8 __initconst ptext6[64] =
+static const u8 __initconst ptext6[64] __nonstring =
 	"\xd9\x31\x32\x25\xf8\x84\x06\xe5"
 	"\xa5\x59\x09\xc5\xaf\xf5\x26\x9a"
 	"\x86\xa7\xa9\x53\x15\x34\xf7\xda"
@@ -281,7 +281,7 @@ static const u8 __initconst ptext6[64] =
 	"\xb1\x6a\xed\xf5\xaa\x0d\xe6\x57"
 	"\xba\x63\x7b\x39\x1a\xaf\xd2\x55";
 
-static const u8 __initconst ctext6[80] =
+static const u8 __initconst ctext6[80] __nonstring =
 	"\x39\x80\xca\x0b\x3c\x00\xe8\x41"
 	"\xeb\x06\xfa\xc4\x87\x2a\x27\x57"
 	"\x85\x9e\x1c\xea\xa6\xef\xd9\x84"
@@ -293,17 +293,17 @@ static const u8 __initconst ctext6[80] =
 	"\x99\x24\xa7\xc8\x58\x73\x36\xbf"
 	"\xb1\x18\x02\x4d\xb8\x67\x4a\x14";
 
-static const u8 __initconst ctext7[16] =
+static const u8 __initconst ctext7[16] __nonstring =
 	"\x53\x0f\x8a\xfb\xc7\x45\x36\xb9"
 	"\xa9\x63\xb4\xf1\xc4\xcb\x73\x8b";
 
-static const u8 __initconst ctext8[32] =
+static const u8 __initconst ctext8[32] __nonstring =
 	"\xce\xa7\x40\x3d\x4d\x60\x6b\x6e"
 	"\x07\x4e\xc5\xd3\xba\xf3\x9d\x18"
 	"\xd0\xd1\xc8\xa7\x99\x99\x6b\xf0"
 	"\x26\x5b\x98\xb5\xd4\x8a\xb9\x19";
 
-static const u8 __initconst ptext9[64] =
+static const u8 __initconst ptext9[64] __nonstring =
 	"\xd9\x31\x32\x25\xf8\x84\x06\xe5"
 	"\xa5\x59\x09\xc5\xaf\xf5\x26\x9a"
 	"\x86\xa7\xa9\x53\x15\x34\xf7\xda"
@@ -313,7 +313,7 @@ static const u8 __initconst ptext9[64] =
 	"\xb1\x6a\xed\xf5\xaa\x0d\xe6\x57"
 	"\xba\x63\x7b\x39\x1a\xaf\xd2\x55";
 
-static const u8 __initconst ctext9[80] =
+static const u8 __initconst ctext9[80] __nonstring =
 	"\x52\x2d\xc1\xf0\x99\x56\x7d\x07"
 	"\xf4\x7f\x37\xa3\x2a\x84\x42\x7d"
 	"\x64\x3a\x8c\xdc\xbf\xe5\xc0\xc9"
@@ -325,7 +325,7 @@ static const u8 __initconst ctext9[80] =
 	"\xb0\x94\xda\xc5\xd9\x34\x71\xbd"
 	"\xec\x1a\x50\x22\x70\xe3\xcc\x6c";
 
-static const u8 __initconst ptext10[60] =
+static const u8 __initconst ptext10[60] __nonstring =
 	"\xd9\x31\x32\x25\xf8\x84\x06\xe5"
 	"\xa5\x59\x09\xc5\xaf\xf5\x26\x9a"
 	"\x86\xa7\xa9\x53\x15\x34\xf7\xda"
@@ -335,7 +335,7 @@ static const u8 __initconst ptext10[60] =
 	"\xb1\x6a\xed\xf5\xaa\x0d\xe6\x57"
 	"\xba\x63\x7b\x39";
 
-static const u8 __initconst ctext10[76] =
+static const u8 __initconst ctext10[76] __nonstring =
 	"\x52\x2d\xc1\xf0\x99\x56\x7d\x07"
 	"\xf4\x7f\x37\xa3\x2a\x84\x42\x7d"
 	"\x64\x3a\x8c\xdc\xbf\xe5\xc0\xc9"
@@ -347,7 +347,7 @@ static const u8 __initconst ctext10[76] =
 	"\x76\xfc\x6e\xce\x0f\x4e\x17\x68"
 	"\xcd\xdf\x88\x53\xbb\x2d\x55\x1b";
 
-static const u8 __initconst ptext11[60] =
+static const u8 __initconst ptext11[60] __nonstring =
 	"\xd9\x31\x32\x25\xf8\x84\x06\xe5"
 	"\xa5\x59\x09\xc5\xaf\xf5\x26\x9a"
 	"\x86\xa7\xa9\x53\x15\x34\xf7\xda"
@@ -357,7 +357,7 @@ static const u8 __initconst ptext11[60] =
 	"\xb1\x6a\xed\xf5\xaa\x0d\xe6\x57"
 	"\xba\x63\x7b\x39";
 
-static const u8 __initconst ctext11[76] =
+static const u8 __initconst ctext11[76] __nonstring =
 	"\x39\x80\xca\x0b\x3c\x00\xe8\x41"
 	"\xeb\x06\xfa\xc4\x87\x2a\x27\x57"
 	"\x85\x9e\x1c\xea\xa6\xef\xd9\x84"
@@ -369,7 +369,7 @@ static const u8 __initconst ctext11[76] =
 	"\x25\x19\x49\x8e\x80\xf1\x47\x8f"
 	"\x37\xba\x55\xbd\x6d\x27\x61\x8c";
 
-static const u8 __initconst ptext12[719] =
+static const u8 __initconst ptext12[719] __nonstring =
 	"\x42\xc1\xcc\x08\x48\x6f\x41\x3f"
 	"\x2f\x11\x66\x8b\x2a\x16\xf0\xe0"
 	"\x58\x83\xf0\xc3\x70\x14\xc0\x5b"
@@ -461,7 +461,7 @@ static const u8 __initconst ptext12[719] =
 	"\x59\xfa\xfa\xaa\x44\x04\x01\xa7"
 	"\xa4\x78\xdb\x74\x3d\x8b\xb5";
 
-static const u8 __initconst ctext12[735] =
+static const u8 __initconst ctext12[735] __nonstring =
 	"\x84\x0b\xdb\xd5\xb7\xa8\xfe\x20"
 	"\xbb\xb1\x12\x7f\x41\xea\xb3\xc0"
 	"\xa2\xb4\x37\x19\x11\x58\xb6\x0b"
@@ -559,9 +559,9 @@ static struct {
 	const u8	*ptext;
 	const u8	*ctext;
 
-	u8		key[AES_MAX_KEY_SIZE];
-	u8		iv[GCM_AES_IV_SIZE];
-	u8		assoc[20];
+	u8		key[AES_MAX_KEY_SIZE] __nonstring;
+	u8		iv[GCM_AES_IV_SIZE] __nonstring;
+	u8		assoc[20] __nonstring;
 
 	int		klen;
 	int		clen;
-- 
2.34.1

