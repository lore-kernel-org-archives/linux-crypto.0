Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84662836BD;
	Thu,  4 Sep 2025 15:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001328; cv=none; b=Zl3IKkPz09cCDtlcsADmDX2AftSJhqxYWJyc64OODsKQlfjI323a84VPDF2od2K5ZjzwSxRdV9WCwhApji1+fqxxxJxAYZ2zsY4PAzAn9U6p7ASDFNsO9GcwagUibtKsrhkBv76z5jVBtINs57LYKgQEDiUCXmRN4/rn+zUgjsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001328; c=relaxed/simple;
	bh=E5POAFItc4X5Xz6bIPSl+2EWDIJH0MVDxOhE1eHGcgE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=omrzAmoA0gwrX/C9tkFAArfxT/4sTsL40e+gaOPepuU0md4j8EuGq1qFwfoZoT/NtjtaRpgIUys0Fdc+q/DP4YNiS71i08EoHbBNw79SLPbdxo+qqFvCjw+TKRJfE64cdOiVO+e5Kdbdvqeb3dSSaIw9PbWE9sTlmHBeHC7PyKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ibfLa45+; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ibfLa45+"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FjeEV006267;
	Thu, 4 Sep 2025 15:55:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=v6cCC
	CJplLJlwfsIag1JvyfKetr+A3NnvB+eaYc8TWI=; b=ibfLa45+JGvvOQ/QLKt9U
	UtgaVHCeENDTEL6KSWx+dbMZhDJpEs8dCYP5/M7207+cJ36ZQBrDnqmh28vxrWvI
	4v25Bx4pxb9WhynXiRuNpG4L9vmjrokyqYz2qF6n1eJ34l82liRd5NUdI+d8lCx8
	7LgxCoBq4/VIqhX1QH15NCfrZE1MleY67qNchzLq4gQHVGi2kN1UgboDwg/sR6V5
	xHKBKEsaOzZWjys0ZYmtF+p25QeAKfxrEljyHLn3ZlWFOh4qXFeeZRGzkktxcO6e
	ev42P/sp/qeFg02G2Kqd8XP4Uw5QYp5Uq43dNDkkXmGmi6IK5lORTL03Ti2Fz6w7
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ydhd01xu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:09 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584F0DR1040089;
	Thu, 4 Sep 2025 15:55:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhtkrh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 15:55:09 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx4o000707;
	Thu, 4 Sep 2025 15:55:08 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-3;
	Thu, 04 Sep 2025 15:55:08 +0000
From: Vegard Nossum <vegard.nossum@oracle.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
        Daniel Gomez <da.gomez@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Eric Biggers <ebiggers@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
        Vladis Dronov <vdronov@redhat.com>,
        Stephan Mueller <smueller@chronox.de>,
        Sami Tolvanen <samitolvanen@google.com>, linux-modules@vger.kernel.org,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH RFC 002/104] Revert "Revert "crypto: shash - avoid comparing pointers to exported functions under CFI""
Date: Thu,  4 Sep 2025 17:50:34 +0200
Message-Id: <20250904155216.460962-3-vegard.nossum@oracle.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250904155216.460962-1-vegard.nossum@oracle.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-04_06,2025-09-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 bulkscore=0
 adultscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2508110000
 definitions=main-2509040156
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDE1MyBTYWx0ZWRfX55+j8MHnTJUP
 vXMkcRhdabnLYMzV7IHXIi0zfRrn42blLVV8qaWS4PLToZ9kFRij1Co3uTJvFsF1qkrotP+zpvF
 oZkJioyQ7nJUcvzpeQcVGrUKnAEmhbwDfczGbZ7kRhG2+X1YzyuUeGziBl5icw8rpBT4HMO0aBo
 IEA3RW37M9HcR2ZoLwOeHjdJKoJcZN3sx5U0ZfUVgi+mCiAw0E1YhbXk6GOMwppTZbZA0pMcWqH
 RJ4LgoX3D0Apbu7bB8lwMfVPv/vQFvdMNBCsmO2/sWyEUggcsUqODWfT13S5VCgDqcPo5BKuebq
 sm8lsv+44QYDuwvqbQZF6UodtqLq6/vO/2pIg+wWMJ7hN8cWXXnis5e030t5MTH7lOAt1D1WZM9
 TBTqNdMNknUBgaOoGeobcHPpnthg5g==
X-Proofpoint-GUID: m6XhecCCCKb7K4UvbRBlj648zGdt6Pz-
X-Proofpoint-ORIG-GUID: m6XhecCCCKb7K4UvbRBlj648zGdt6Pz-
X-Authority-Analysis: v=2.4 cv=QoZe3Uyd c=1 sm=1 tr=0 ts=68b9b65e b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=JfrnYn6hAAAA:8 a=1XWaLZrsAAAA:8 a=FNyBlpCuAAAA:8
 a=yPCof4ZbAAAA:8 a=traoGK7g6qFTl0H2VNwA:9 a=1CNFftbPRP8L7MoqJWF3:22
 a=RlW-AWeGUCXs_Nkyno-6:22 cc=ntf awl=host:12068

This reverts commit c060e16ddb51a92b1f7fa84c628d287ea5799864.

For a standalone FIPS module we have the same issue as CFI: modules
won't get the same address for shash_no_setkey as the core kernel will.

A cleaner solution overall would probably be to simply use NULL when
there is no setkey and check for it as we do in most other areas of the
kernel. We can explore that later (or in later versions of this series).

Cc: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>
Cc: Eric Biggers <ebiggers@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 crypto/shash.c                 | 18 +++++++++++++++---
 include/crypto/internal/hash.h |  8 +-------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 4721f5f134f4..d45d7ec83a8c 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -34,12 +34,24 @@ static inline bool crypto_shash_finup_max(struct crypto_shash *tfm)
 	       CRYPTO_AHASH_ALG_FINUP_MAX;
 }
 
-int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
-		    unsigned int keylen)
+static int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
+			   unsigned int keylen)
 {
 	return -ENOSYS;
 }
-EXPORT_SYMBOL_GPL(shash_no_setkey);
+
+/*
+ * Check whether an shash algorithm has a setkey function.
+ *
+ * For CFI compatibility, this must not be an inline function.  This is because
+ * when CFI is enabled, modules won't get the same address for shash_no_setkey
+ * (if it were exported, which inlining would require) as the core kernel will.
+ */
+bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
+{
+	return alg->setkey != shash_no_setkey;
+}
+EXPORT_SYMBOL_GPL(crypto_shash_alg_has_setkey);
 
 static void shash_set_needkey(struct crypto_shash *tfm, struct shash_alg *alg)
 {
diff --git a/include/crypto/internal/hash.h b/include/crypto/internal/hash.h
index 6ec5f2f37ccb..e39456de57e4 100644
--- a/include/crypto/internal/hash.h
+++ b/include/crypto/internal/hash.h
@@ -92,13 +92,7 @@ int ahash_register_instance(struct crypto_template *tmpl,
 			    struct ahash_instance *inst);
 void ahash_free_singlespawn_instance(struct ahash_instance *inst);
 
-int shash_no_setkey(struct crypto_shash *tfm, const u8 *key,
-		    unsigned int keylen);
-
-static inline bool crypto_shash_alg_has_setkey(struct shash_alg *alg)
-{
-	return alg->setkey != shash_no_setkey;
-}
+bool crypto_shash_alg_has_setkey(struct shash_alg *alg);
 
 bool crypto_hash_alg_has_setkey(struct hash_alg_common *halg);
 
-- 
2.39.3

