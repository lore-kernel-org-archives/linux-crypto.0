Received: from smtpo67.poczta.onet.pl (smtpo67.poczta.onet.pl [141.105.16.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20DE2430BB5;
	Sun,  1 Mar 2026 15:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.105.16.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772380469; cv=none; b=RP2yo9sJQXG7C1B5OX2lbwY+Ms1obibciq1KLO4DBq+8yV8Qg+1/7UMpM0JhF74r/QCAWTw7m4lYIDfkIhJNEeGhfidsBwe9Tro2ygAN7amK3jIAckFt17QM/UbFtIgXvKORyE1KtxMQKS1rExelnV0cVFghd4+2/dacdyBC+qg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772380469; c=relaxed/simple;
	bh=bzH1qwJlVZQpTOdjoQ7/HDuWS6x3bdq2r4X1cQvTWlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VaMrhMumredqj+FRj6BkWGTBADlyfZv1yR2y1A/sGIDmPl5jzc9gVgWblUFbGIvvArBdSMDwWXu4bdFprBMIGx4BH17N53CR9oACp00Trx/WctokIclJWRfMCs2tskBD2nA7MVVUI1vpiuH7JFSo3BT4VuHSe1Fq85IiK8fzJlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=onet.pl; spf=pass smtp.mailfrom=onet.pl; dkim=pass (1024-bit key) header.d=onet.pl header.i=@onet.pl header.b=KAzJHyqF; arc=none smtp.client-ip=141.105.16.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=onet.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=onet.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=onet.pl header.i=@onet.pl header.b="KAzJHyqF"
Received: from laptop-olek.lan (83.24.116.171.ipv4.supernova.orange.pl [83.24.116.171])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: aleksaander@onet.pl)
	by smtp.poczta.onet.pl (Onet) with ESMTPSA id 4fP67V6S6wz1wPS;
	Sun,  1 Mar 2026 16:54:14 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onet.pl; s=2011;
	t=1772380461; bh=QoBVyp0ZSVB0PS0OKSgCDjrksC+dtGh1u2EEC73VD7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KAzJHyqFdpbAybrFBo5HfxkTWi57ceLQk6voeVeiN6g3A8MrlmMoNOjgNYA/V+uWJ
	 meF3pgd2Y4rBxXu2MV9YjgWfVifMKvWpoVn0fh8+0U9C4deWh4aVbrIUIb/6iHnqBF
	 IzdszHMLoE2mP1j5UwL93A+x2mv8BPAw/Id0agH8=
From: Aleksander Jan Bajkowski <aleksaander@onet.pl>
To: herbert@gondor.apana.org.au,
	davem@davemloft.net,
	mcoquelin.stm32@gmail.com,
	alexandre.torgue@foss.st.com,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: [PATCH 2/5] crypto: testmgr - Add test vectors for authenc(hmac(sha224),rfc3686(ctr(aes)))
Date: Sun,  1 Mar 2026 16:53:39 +0100
Message-ID: <20260301155351.5840-2-aleksaander@onet.pl>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260301155351.5840-1-aleksaander@onet.pl>
References: <20260301155351.5840-1-aleksaander@onet.pl>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Aleksander Jan Bajkowski <olek2@wp.pl>

Test vectors were generated starting from existing RFC3686(CTR(AES)) test
vectors and adding HMAC(SHA224) computed with software implementation.
Then, the results were double-checked on Mediatek MT7986 (safexcel).
Platform pass self-tests.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 crypto/testmgr.c |   6 +-
 crypto/testmgr.h | 235 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 240 insertions(+), 1 deletion(-)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 91831b548062..b64a8b58b3fc 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -4165,8 +4165,12 @@ static const struct alg_test_desc alg_test_descs[] = {
 		}
 	}, {
 		.alg = "authenc(hmac(sha224),rfc3686(ctr(aes)))",
-		.test = alg_test_null,
+		.generic_driver = "authenc(hmac-sha224-lib,rfc3686(ctr(aes-generic)))",
+		.test = alg_test_aead,
 		.fips_allowed = 1,
+		.suite = {
+			.aead = __VECS(hmac_sha224_aes_ctr_rfc3686_tv_temp)
+		}
 	}, {
 		.alg = "authenc(hmac(sha256),cbc(aes))",
 		.generic_driver = "authenc(hmac-sha256-lib,cbc(aes-lib))",
diff --git a/crypto/testmgr.h b/crypto/testmgr.h
index d232417c20a1..42fa8d4b49ff 100644
--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -15425,6 +15425,241 @@ static const struct aead_testvec hmac_sha224_aes_cbc_tv_temp[] = {
 	},
 };
 
+static const struct aead_testvec hmac_sha224_aes_ctr_rfc3686_tv_temp[] = {
+	{ /* RFC 3686 Case 1 */
+#ifdef __LITTLE_ENDIAN
+		.key    = "\x08\x00"		/* rta length */
+			  "\x01\x00"		/* rta type */
+#else
+		.key    = "\x00\x08"		/* rta length */
+			  "\x00\x01"		/* rta type */
+#endif
+			  "\x00\x00\x00\x14"	/* enc key length */
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00"
+			  "\xae\x68\x52\xf8\x12\x10\x67\xcc"
+			  "\x4b\xf7\xa5\x76\x55\x77\xf3\x9e"
+			  "\x00\x00\x00\x30",
+		.klen	= 8 + 28 + 20,
+		.iv	= "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.assoc	= "\x00\x00\x00\x00\x00\x00\x00\x00",
+		.alen	= 8,
+		.ptext	= "Single block msg",
+		.plen	= 16,
+		.ctext	= "\xe4\x09\x5d\x4f\xb7\xa7\xb3\x79"
+			  "\x2d\x61\x75\xa3\x26\x13\x11\xb8"
+			  "\x36\xb4\x3b\x9c\x62\xed\xcf\x77"
+			  "\xdc\x19\x27\x3f\x92\x80\x52\xce"
+			  "\x8f\xad\x01\x0b\x79\xda\x04\x83"
+			  "\xcb\x45\x1a\x52",
+		.clen	= 16 + 28,
+	}, { /* RFC 3686 Case 2 */
+#ifdef __LITTLE_ENDIAN
+		.key    = "\x08\x00"		/* rta length */
+			  "\x01\x00"		/* rta type */
+#else
+		.key    = "\x00\x08"		/* rta length */
+			  "\x00\x01"		/* rta type */
+#endif
+			  "\x00\x00\x00\x14"	/* enc key length */
+			  "\x20\x21\x22\x23\x24\x25\x26\x27"
+			  "\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f"
+			  "\x30\x31\x32\x33\x34\x35\x36\x37"
+			  "\x38\x39\x3a\x3b"
+			  "\x7e\x24\x06\x78\x17\xfa\xe0\xd7"
+			  "\x43\xd6\xce\x1f\x32\x53\x91\x63"
+			  "\x00\x6c\xb6\xdb",
+		.klen	= 8 + 28 + 20,
+		.iv	= "\xc0\x54\x3b\x59\xda\x48\xd9\x0b",
+		.assoc	= "\xc0\x54\x3b\x59\xda\x48\xd9\x0b",
+		.alen	= 8,
+		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			  "\x10\x11\x12\x13\x14\x15\x16\x17"
+			  "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.plen	= 32,
+		.ctext	= "\x51\x04\xa1\x06\x16\x8a\x72\xd9"
+			  "\x79\x0d\x41\xee\x8e\xda\xd3\x88"
+			  "\xeb\x2e\x1e\xfc\x46\xda\x57\xc8"
+			  "\xfc\xe6\x30\xdf\x91\x41\xbe\x28"
+			  "\x7f\xe4\x8f\xa7\x06\x71\xe9\xe5"
+			  "\x16\x79\xef\xf9\x7e\x5c\x93\x4d"
+			  "\xa0\xf8\x3b\x3a\xaa\x1c\xc0\xd9"
+			  "\x6b\x48\x49\x01",
+		.clen	= 32 + 28,
+	}, { /* RFC 3686 Case 3 */
+#ifdef __LITTLE_ENDIAN
+		.key    = "\x08\x00"		/* rta length */
+			  "\x01\x00"		/* rta type */
+#else
+		.key    = "\x00\x08"		/* rta length */
+			  "\x00\x01"		/* rta type */
+#endif
+			  "\x00\x00\x00\x14"	/* enc key length */
+			  "\x11\x22\x33\x44\x55\x66\x77\x88"
+			  "\x99\xaa\xbb\xcc\xdd\xee\xff\x11"
+			  "\x22\x33\x44\x55\x66\x77\x88\x99"
+			  "\xaa\xbb\xcc\xdd"
+			  "\x76\x91\xbe\x03\x5e\x50\x20\xa8"
+			  "\xac\x6e\x61\x85\x29\xf9\xa0\xdc"
+			  "\x00\xe0\x01\x7b",
+		.klen	= 8 + 28 + 20,
+		.iv	= "\x27\x77\x7f\x3f\x4a\x17\x86\xf0",
+		.assoc	= "\x27\x77\x7f\x3f\x4a\x17\x86\xf0",
+		.alen	= 8,
+		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			  "\x10\x11\x12\x13\x14\x15\x16\x17"
+			  "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f"
+			  "\x20\x21\x22\x23",
+		.plen	= 36,
+		.ctext	= "\xc1\xcf\x48\xa8\x9f\x2f\xfd\xd9"
+			  "\xcf\x46\x52\xe9\xef\xdb\x72\xd7"
+			  "\x45\x40\xa4\x2b\xde\x6d\x78\x36"
+			  "\xd5\x9a\x5c\xea\xae\xf3\x10\x53"
+			  "\x25\xb2\x07\x2f"
+			  "\xb0\x19\x45\xee\xa7\x31\xd9\xd0"
+			  "\x74\x6b\xb8\xb1\x67\x61\x2f\x8c"
+			  "\x68\xde\xe3\xc9\x3b\x0c\x72\xda"
+			  "\x48\xba\x1b\x51",
+		.clen	= 36 + 28,
+	}, { /* RFC 3686 Case 4 */
+#ifdef __LITTLE_ENDIAN
+		.key    = "\x08\x00"		/* rta length */
+			  "\x01\x00"		/* rta type */
+#else
+		.key    = "\x00\x08"		/* rta length */
+			  "\x00\x01"		/* rta type */
+#endif
+			  "\x00\x00\x00\x1c"	/* enc key length */
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00"
+			  "\x16\xaf\x5b\x14\x5f\xc9\xf5\x79"
+			  "\xc1\x75\xf9\x3e\x3b\xfb\x0e\xed"
+			  "\x86\x3d\x06\xcc\xfd\xb7\x85\x15"
+			  "\x00\x00\x00\x48",
+		.klen	= 8 + 28 + 28,
+		.iv	= "\x36\x73\x3c\x14\x7d\x6d\x93\xcb",
+		.assoc	= "\x36\x73\x3c\x14\x7d\x6d\x93\xcb",
+		.alen	= 8,
+		.ptext	= "Single block msg",
+		.plen	= 16,
+		.ctext	= "\x4b\x55\x38\x4f\xe2\x59\xc9\xc8"
+			  "\x4e\x79\x35\xa0\x03\xcb\xe9\x28"
+			  "\xfd\xf5\x35\x26\x50\x3d\xdf\x80"
+			  "\x6e\xbe\xba\x8d\x56\xf3\x03\xb7"
+			  "\x27\xb8\x13\xe8\x72\x8f\xc9\x52"
+			  "\x4a\xb7\xc3\x3a",
+		.clen	= 16 + 28,
+	}, { /* RFC 3686 Case 5 */
+#ifdef __LITTLE_ENDIAN
+		.key    = "\x08\x00"		/* rta length */
+			  "\x01\x00"		/* rta type */
+#else
+		.key    = "\x00\x08"		/* rta length */
+			  "\x00\x01"		/* rta type */
+#endif
+			  "\x00\x00\x00\x1c"	/* enc key length */
+			  "\x20\x21\x22\x23\x24\x25\x26\x27"
+			  "\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f"
+			  "\x30\x31\x32\x33\x34\x35\x36\x37"
+			  "\x38\x39\x3a\x3b"
+			  "\x7c\x5c\xb2\x40\x1b\x3d\xc3\x3c"
+			  "\x19\xe7\x34\x08\x19\xe0\xf6\x9c"
+			  "\x67\x8c\x3d\xb8\xe6\xf6\xa9\x1a"
+			  "\x00\x96\xb0\x3b",
+		.klen	= 8 + 28 + 28,
+		.iv	= "\x02\x0c\x6e\xad\xc2\xcb\x50\x0d",
+		.assoc	= "\x02\x0c\x6e\xad\xc2\xcb\x50\x0d",
+		.alen	= 8,
+		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			  "\x10\x11\x12\x13\x14\x15\x16\x17"
+			  "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.plen	= 32,
+		.ctext	= "\x45\x32\x43\xfc\x60\x9b\x23\x32"
+			  "\x7e\xdf\xaa\xfa\x71\x31\xcd\x9f"
+			  "\x84\x90\x70\x1c\x5a\xd4\xa7\x9c"
+			  "\xfc\x1f\xe0\xff\x42\xf4\xfb\x00"
+			  "\x72\x89\xa8\x04\xa5\xac\x8f\x29"
+			  "\xe6\xb8\x58\xe8\xcf\x6a\x91\x89"
+			  "\xd3\x66\x3b\xdc\xce\x43\x23\xb7"
+			  "\x6a\xdd\x9d\xbd",
+		.clen	= 32 + 28,
+	}, { /* RFC 3686 Case 7 */
+#ifdef __LITTLE_ENDIAN
+		.key    = "\x08\x00"		/* rta length */
+			  "\x01\x00"		/* rta type */
+#else
+		.key    = "\x00\x08"		/* rta length */
+			  "\x00\x01"		/* rta type */
+#endif
+			  "\x00\x00\x00\x24"	/* enc key length */
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00\x00\x00\x00\x00"
+			  "\x00\x00\x00\x00"
+			  "\x77\x6b\xef\xf2\x85\x1d\xb0\x6f"
+			  "\x4c\x8a\x05\x42\xc8\x69\x6f\x6c"
+			  "\x6a\x81\xaf\x1e\xec\x96\xb4\xd3"
+			  "\x7f\xc1\xd6\x89\xe6\xc1\xc1\x04"
+			  "\x00\x00\x00\x60",
+		.klen	= 8 + 28 + 36,
+		.iv	= "\xdb\x56\x72\xc9\x7a\xa8\xf0\xb2",
+		.assoc	= "\xdb\x56\x72\xc9\x7a\xa8\xf0\xb2",
+		.alen	= 8,
+		.ptext	= "Single block msg",
+		.plen	= 16,
+		.ctext	= "\x14\x5a\xd0\x1d\xbf\x82\x4e\xc7"
+			  "\x56\x08\x63\xdc\x71\xe3\xe0\xc0"
+			  "\xfe\xdf\x6f\x62\x8a\x79\xb5\x34"
+			  "\xd0\x6f\x32\xaf\x31\x50\x5b\x1f"
+			  "\xe0\x6d\x0b\xbc\x02\x25\xee\x74"
+			  "\x7a\xdf\x97\x3c",
+		.clen	= 16 + 28,
+	}, { /* RFC 3686 Case 8 */
+#ifdef __LITTLE_ENDIAN
+		.key    = "\x08\x00"		/* rta length */
+			  "\x01\x00"		/* rta type */
+#else
+		.key    = "\x00\x08"		/* rta length */
+			  "\x00\x01"		/* rta type */
+#endif
+			  "\x00\x00\x00\x24"	/* enc key length */
+			  "\x20\x21\x22\x23\x24\x25\x26\x27"
+			  "\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f"
+			  "\x30\x31\x32\x33\x34\x35\x36\x37"
+			  "\x38\x39\x3a\x3b"
+			  "\xf6\xd6\x6d\x6b\xd5\x2d\x59\xbb"
+			  "\x07\x96\x36\x58\x79\xef\xf8\x86"
+			  "\xc6\x6d\xd5\x1a\x5b\x6a\x99\x74"
+			  "\x4b\x50\x59\x0c\x87\xa2\x38\x84"
+			  "\x00\xfa\xac\x24",
+		.klen	= 8 + 28 + 36,
+		.iv	= "\xc1\x58\x5e\xf1\x5a\x43\xd8\x75",
+		.assoc	= "\xc1\x58\x5e\xf1\x5a\x43\xd8\x75",
+		.alen	= 8,
+		.ptext	= "\x00\x01\x02\x03\x04\x05\x06\x07"
+			  "\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f"
+			  "\x10\x11\x12\x13\x14\x15\x16\x17"
+			  "\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f",
+		.plen	= 32,
+		.ctext	= "\xf0\x5e\x23\x1b\x38\x94\x61\x2c"
+			  "\x49\xee\x00\x0b\x80\x4e\xb2\xa9"
+			  "\xb8\x30\x6b\x50\x8f\x83\x9d\x6a"
+			  "\x55\x30\x83\x1d\x93\x44\xaf\x1c"
+			  "\x19\x1e\x9c\x2c\x6d\x4e\x21\xda"
+			  "\x6c\x4d\x88\x90\xf8\x5f\xa5\x9d"
+			  "\xb4\xd4\x40\xad\xfa\x67\x3f\x0e"
+			  "\x11\x12\xd6\x10",
+		.clen	= 32 + 28,
+	},
+};
+
 static const struct aead_testvec hmac_sha256_aes_cbc_tv_temp[] = {
 	{ /* RFC 3602 Case 1 */
 #ifdef __LITTLE_ENDIAN
-- 
2.47.3

