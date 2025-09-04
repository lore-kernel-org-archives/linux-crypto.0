Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7CB2248A4;
	Thu,  4 Sep 2025 16:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001701; cv=none; b=bQwkHgkg874nbGRKMSZ2Y7MMxHlKjIjNJC1FmJARVHXzm8I2nFEv1sk56MPczCb1GnIkAT/3KQr7L2DW8SQgy82b5Q1L/hWbB70zYjbNZXG8XGnLi7PXBoDZ3vNmq9bEb7GTh4hyUyV3VlMteSDau4unS6cU43/mWkmdK7NaEpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001701; c=relaxed/simple;
	bh=IqP8Dbe5Ys0bUSRawx5xSgm08LxvlQw+42QHMjYZ31w=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=j47KcPRKUghf1KyOLSIkRpAJiMguYA+L6PqlK1UFKnaL9oxiBBb0qeyD2rt4iUPKn/l0ONkjZ+zwpyhvSMxpsYeIwD95exKNvgpSgWCqiCpB7B0O2doCQYVzNPAJfPSqHik++Hcp1DXlaMm6WfjwJrAd4u9lYSMuyvXOIkA5gvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RV83+6iE; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RV83+6iE"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtmVW014916;
	Thu, 4 Sep 2025 16:01:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=oksZ5
	J/QyM30t5O1sA09LV84Uufcw7vQRzcR58gpscU=; b=RV83+6iEuJpwb28nWuIcQ
	X86ahj9CeI63jNABMwrfyERdrc6uxXsZVhml1Wyq8ODyOAPKsrGCJ3ylX/fsBzxk
	VNGRpxb5lRDQWFQ0YK0ZNfmxNxmSnEN3u1WMv+hDxDT/LqwljeyXD7bHz0hiKuOr
	Q9MN7UQ2BwFXkjnGS+VJ7rw4J1/M8Mu+W3uQiBgbfvwDp18CE1ks6GdcBE8IaEiu
	frKIROo5BDoeRYhWAC3LuADcZMjFAyl8zXXiWZdY2J1kex0pJpHhgmLVw+FeSDMf
	VcZk6yXHvcMi9+6PLdmKGkmwXsameJIxDGIfIntbVA66nkoBmJvoK7Nspz2T5tP8
	Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh0cmj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584EwZUo040037;
	Thu, 4 Sep 2025 16:01:17 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhttjt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:17 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx80000707;
	Thu, 4 Sep 2025 16:01:16 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-97;
	Thu, 04 Sep 2025 16:01:16 +0000
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
        Vegard Nossum <vegard.nossum@oracle.com>
Subject: [PATCH RFC 096/104] crypto: fips140: manual fixups for include/crypto/aes.h
Date: Thu,  4 Sep 2025 17:52:08 +0200
Message-Id: <20250904155216.460962-97-vegard.nossum@oracle.com>
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
 definitions=main-2509040157
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfX/NCuI9sWy6dd
 qhoiXCynK5OGUIgHXjeJATsyhvJKWwzHFvwJD1NIpObbODCEFmYg9XZUTJYeY10oLIRpIKAWbHb
 6y05Z0wYTZflbZR+09WM7jd9MN4vKxHhP0soYWpz66S34V2xx6lBoBNbaTlejp0cnov3QZ2uDxm
 HuNeWewdNZMGuWPzmZ9ZKRQU0iD62BdF/zC7cSrPMIl+GhBEJ/GiNFqrXsesWTIUkkJVha57Kks
 3IbBEBtp8TDaGxANuLCpgyWXgxVYgmHZlh9ibs40dK9+7AQskQoS9q5tFV2kPv9tkmotq/3HGN4
 xvyR4KMakDt9d00C0lO3HBzYlEa+08IwVnGewp+CGgC7gpTQFG4ksI5ow5Gj4M8vYNbmJxc36b/
 Ae6pNNpKHAPaK45I9i6bCud2DdRQ+w==
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b9b7cf b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=WAucoXOHi7s20diqjPgA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: 6S0z3aMKSju4wvXHlrIjL6VgnFLsq2PC
X-Proofpoint-ORIG-GUID: 6S0z3aMKSju4wvXHlrIjL6VgnFLsq2PC

Define fips_/nonfips_ variants of crypto_aes_*sbox when the kernel is
configured to use a standalone FIPS module.

Vegard Nossum <vegard.nossum@oracle.com>
---
 include/crypto/aes.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/crypto/aes.h b/include/crypto/aes.h
index 77f5515c49c9..fc84ffcd00a7 100644
--- a/include/crypto/aes.h
+++ b/include/crypto/aes.h
@@ -101,6 +101,16 @@ DECLARE_CRYPTO_API(aes_decrypt, void,
 	(const struct crypto_aes_ctx *ctx, u8 *out, const u8 *in),
 	(ctx, out, in));
 
+#ifdef CONFIG_CRYPTO_FIPS140_EXTMOD
+#ifdef FIPS_MODULE
+#define crypto_aes_sbox fips_crypto_aes_sbox
+#define crypto_aes_inv_sbox fips_crypto_aes_inv_sbox
+#else
+#define crypto_aes_sbox nonfips_crypto_aes_sbox
+#define crypto_aes_inv_sbox nonfips_crypto_aes_inv_sbox
+#endif
+#endif
+
 extern const u8 crypto_aes_sbox[];
 extern const u8 crypto_aes_inv_sbox[];
 
-- 
2.39.3

