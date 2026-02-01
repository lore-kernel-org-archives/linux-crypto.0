Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB35824A049
	for <linux-crypto@vger.kernel.org>; Sun,  1 Feb 2026 11:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.77.101.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769945322; cv=none; b=BH9EXOP4dlaoNy6kt9py9+w5Lic5nb0TCg06NA2lwDlIXv1S3rNNiVbcSt0Sg9F8TJ8BypJ3g1tFu+iZGSHDqrioDh94YORlNfZ/wJ85NJiO16c2+1qAum+7Wexkx6+zhalzSWSH7fhKBZYMGO2p5fUX6myAlDo+6ry2cIyyB9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769945322; c=relaxed/simple;
	bh=0ghplTbu/J2f+YqaRk4Osg6DbmV/ect4TIdIrPUBNvo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=hCgpHD3Ka55KJBmHQR0gb6VZXMhPdZaO0EZ67kbnISLEdK3rh4X4PrCgWto68PKnDBD1oh9lmobOO08DQKYz4NKyG6XHG2h+12r5OZq1ej/QgkLM6JDENrYDtzZK2LuRVdSqQ3y+cWJGXcdVa/DGcY3YW15FWFkT7pu8NGDMAAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl; spf=pass smtp.mailfrom=wp.pl; dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b=F4MdyiWF; arc=none smtp.client-ip=212.77.101.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=wp.pl header.i=@wp.pl header.b="F4MdyiWF"
Received: (wp-smtpd smtp.wp.pl 3160 invoked from network); 1 Feb 2026 12:28:36 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=20241105;
          t=1769945316; bh=/MfwfCTQ2QheiPcRl9dLEuVTRmc97tG+vjYeZQwO0Ao=;
          h=From:To:Cc:Subject;
          b=F4MdyiWFWHFPx38n4hqWuWj2OOcYypKlpGg2PPRaUobkWaibc5T65jtPvsvns2UQ0
           /rU7afYTcgc7L78NH2quW7gYyljMlXljZD4cdgfMbg0wN/OSTYEB4J+WoCiP6pdgfr
           pQIL2zvguiDWqVYxrdlusf+yehpmMamuJ81WSgYUNTUj4mkOapUUzJBvXWGNHC/ahD
           L9oSNQQSNVBPo21PoZpMkhp5iJj/b9BB38ZsjqvdI2B83VZJSp2Pmvzww4rCKTKSo8
           RodDVNCMGpiEQX3oz+ynu6iAK3CKSJLs8fAStnC1NThkZQ5sOooLDYovTD/zB/RUVq
           Dr9oPNnUHsg6w==
Received: from 83.5.238.100.ipv4.supernova.orange.pl (HELO laptop-olek.lan) (olek2@wp.pl@[83.5.238.100])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <herbert@gondor.apana.org.au>; 1 Feb 2026 12:28:36 +0100
From: Aleksander Jan Bajkowski <olek2@wp.pl>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH] crypto: testmgr - Add test vectors for authenc(hmac(md5),cbc(des3_ede))
Date: Sun,  1 Feb 2026 12:27:08 +0100
Message-ID: <20260201112834.3378-1-olek2@wp.pl>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-DKIM-Status: good (id: wp.pl)                                                      
X-WP-MailID: 704c276ecd49b0c0ab7a0051055d0b4b
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000008 [wfs3]                               

Test vector was generated using a software implementation and then double
checked using a hardware implementation on NXP P2020 (talitos). The
encryption part is identical to authenc(hmac(sha1),cbc(des3_ede)),
only HMAC is different.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 crypto/testmgr.c |  7 ++++++
 crypto/testmgr.h | 59 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index f3e068382073..0fef46c35367 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4086,6 +4086,13 @@ static const struct alg_test_desc alg_test_descs[] = {
 		.suite = {
 			.aead = __VECS(hmac_md5_aes_cbc_tv_temp)
 		}
+	}, {
+		.alg = "authenc(hmac(md5),cbc(des3_ede))",
+		.generic_driver = "authenc(hmac-md5-lib,cbc(des3_ede-generic))",
+		.test = alg_test_aead,
+		.suite = {
+			.aead = __VECS(hmac_md5_des3_ede_cbc_tv_temp)
+		}
 	}, {
 		.alg = "authenc(hmac(md5),ecb(cipher_null))",
 		.generic_driver = "authenc(hmac-md5-lib,ecb-cipher_null)",
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index dd690da11bae..c582255373d1 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -17481,6 +17481,65 @@ static const struct aead_testvec hmac_sha512_des_cbc_tv_temp[] = {
 	},
 };
 
+static const struct aead_testvec hmac_md5_des3_ede_cbc_tv_temp[] = {
+	{ /*Generated with cryptopp*/
+#ifdef __LITTLE_ENDIAN
+		.key    = "\x08\x00"		/* rta length */
+			  "\x01\x00"		/* rta type */
+#else
+		.key    = "\x00\x08"		/* rta length */
+			  "\x00\x01"		/* rta type */
+#endif
+			  "\x00\x00\x00\x18"	/* enc key length */
+			  "\x11\x22\x33\x44\x55\x66\x77\x88"
+			  "\x99\xaa\xbb\xcc\xdd\xee\xff\x11"
+			  "\xE9\xC0\xFF\x2E\x76\x0B\x64\x24"
+			  "\x44\x4D\x99\x5A\x12\xD6\x40\xC0"
+			  "\xEA\xC2\x84\xE8\x14\x95\xDB\xE8",
+		.klen	= 8 + 16 + 24,
+		.iv	= "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
+		.assoc  = "\x00\x00\x43\x21\x00\x00\x00\x01"
+			  "\x7D\x33\x88\x93\x0F\x93\xB2\x42",
+		.alen   = 16,
+		.ptext	= "\x6f\x54\x20\x6f\x61\x4d\x79\x6e"
+			  "\x53\x20\x63\x65\x65\x72\x73\x74"
+			  "\x54\x20\x6f\x6f\x4d\x20\x6e\x61"
+			  "\x20\x79\x65\x53\x72\x63\x74\x65"
+			  "\x20\x73\x6f\x54\x20\x6f\x61\x4d"
+			  "\x79\x6e\x53\x20\x63\x65\x65\x72"
+			  "\x73\x74\x54\x20\x6f\x6f\x4d\x20"
+			  "\x6e\x61\x20\x79\x65\x53\x72\x63"
+			  "\x74\x65\x20\x73\x6f\x54\x20\x6f"
+			  "\x61\x4d\x79\x6e\x53\x20\x63\x65"
+			  "\x65\x72\x73\x74\x54\x20\x6f\x6f"
+			  "\x4d\x20\x6e\x61\x20\x79\x65\x53"
+			  "\x72\x63\x74\x65\x20\x73\x6f\x54"
+			  "\x20\x6f\x61\x4d\x79\x6e\x53\x20"
+			  "\x63\x65\x65\x72\x73\x74\x54\x20"
+			  "\x6f\x6f\x4d\x20\x6e\x61\x0a\x79",
+		.plen	= 128,
+		.ctext	= "\x0e\x2d\xb6\x97\x3c\x56\x33\xf4"
+			  "\x67\x17\x21\xc7\x6e\x8a\xd5\x49"
+			  "\x74\xb3\x49\x05\xc5\x1c\xd0\xed"
+			  "\x12\x56\x5c\x53\x96\xb6\x00\x7d"
+			  "\x90\x48\xfc\xf5\x8d\x29\x39\xcc"
+			  "\x8a\xd5\x35\x18\x36\x23\x4e\xd7"
+			  "\x76\xd1\xda\x0c\x94\x67\xbb\x04"
+			  "\x8b\xf2\x03\x6c\xa8\xcf\xb6\xea"
+			  "\x22\x64\x47\xaa\x8f\x75\x13\xbf"
+			  "\x9f\xc2\xc3\xf0\xc9\x56\xc5\x7a"
+			  "\x71\x63\x2e\x89\x7b\x1e\x12\xca"
+			  "\xe2\x5f\xaf\xd8\xa4\xf8\xc9\x7a"
+			  "\xd6\xf9\x21\x31\x62\x44\x45\xa6"
+			  "\xd6\xbc\x5a\xd3\x2d\x54\x43\xcc"
+			  "\x9d\xde\xa5\x70\xe9\x42\x45\x8a"
+			  "\x6b\xfa\xb1\x91\x13\xb0\xd9\x19"
+			  "\x99\x09\xfb\x05\x35\xc8\xcc\x38"
+			  "\xc3\x1e\x5e\xe1\xe6\x96\x84\xc8",
+			  .clen	= 128 + 16,
+	},
+};
+
 static const struct aead_testvec hmac_sha1_des3_ede_cbc_tv_temp[] = {
 	{ /*Generated with cryptopp*/
 #ifdef __LITTLE_ENDIAN
-- 
2.47.3

