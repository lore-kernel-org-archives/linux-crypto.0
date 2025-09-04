Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3A71F4262;
	Thu,  4 Sep 2025 16:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757001687; cv=none; b=oOO7jCMdXRPhfHUBBBb2XyOn5A7z3s7TnmU/I28VMrJlaWWQuZHbI8E+UzwsWdq+HkMfrWE6AKeeBmAlDcYxxsYGerywwoBV44hLG0k71JnIBmVQFaVI43Yr8r0XLvuKV41yMcP9gSIFUsSnQw2bZ4louWdaavotHQVwDCNmPLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757001687; c=relaxed/simple;
	bh=e8/1lKAX5PwC8X/GG4Qv3sf+PyzbO7WoAvolSFIupno=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OLNqpqPSTbFeNS5FcY7Q1wmCskzsZZ4VEnvuAQEpTC8HZOxWkEZcRw3+LH0w1CelS/d5jaPySU7czpaW8Rfz9tRjc5y0poAdDADE2w/xdB64wIiqPv3q6jKoIUwBpEzvhm2L2SG2qX21uSD527uTFtZa1YldKNPnXkFHg5gyIjc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mSGe59N3; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mSGe59N3"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 584FtoTU014940;
	Thu, 4 Sep 2025 16:01:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=SY+zp
	2xvWqe+FN4HwyudqiMZ1e/IblXQfzDCIeFM/nA=; b=mSGe59N32AIFCZMU8VMyN
	UEsLA8xUuXKPiZSwqdHj3BSNLZ5QK7npOaqisyxHFCr7fX2vDvz1i3C4P1cbpUFh
	tkjGsJQMj075XxHsswi9j1EScp47TXcmA2awDemJG4v4GFrjRHAay4FlYhuBdDys
	4q2J716Pre8bd2PqEC+Pp+a3BWrGc+3ZXH/ur0gUzl9EBxatS1IsM5mZMWlvYaF7
	+8TO+7Pw6PnHaVyQrZbS8EK65NSFrRQCn6JH/VCI7bts/knennyNWk5sgDDlaoTQ
	+lRbo96/3Db7osZ9xxDSnLlkMKoFlVRmfDiNwkLjXHYCvmRL8eIWxVru8Byb8hkK
	g==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ybmh0cmc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 584EwZUi040037;
	Thu, 4 Sep 2025 16:01:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqrhttcr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 04 Sep 2025 16:01:09 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 584Fsx7u000707;
	Thu, 4 Sep 2025 16:01:09 GMT
Received: from localhost.localdomain (dhcp-10-154-122-161.vpn.oracle.com [10.154.122.161])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqrhtkds-95;
	Thu, 04 Sep 2025 16:01:09 +0000
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
Subject: [PATCH RFC 094/104] crypto: fips140: manual fixups for include/crypto/internal/ecc.h
Date: Thu,  4 Sep 2025 17:52:06 +0200
Message-Id: <20250904155216.460962-95-vegard.nossum@oracle.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA0MDEzMiBTYWx0ZWRfX/rQnCS9ab5Yo
 qAuJZt31lzJln72FBaAwRAV7EMs6mHjrU3ccKTm0yShs8h5zlju4Pqx/OS3qTSQNP04E0D0H5rx
 rc69lCbZ5eBteXLHU5qSFKpkA7o1tH7LDuyqBlR7REG5Y54JIc/JROowVW8FRevN1JoCT0ir8JO
 HaD4Tbhhw8ru+au1SsNUN25pKnHmLRmgbLqmzEGOG/YySsjGR1YjfwqI9TcBRDHY7E2QYO0oyp9
 N1xlW+InODrbNhyhlPzkte7w0Em4cARDOdVo+p5C8DmxAyA1ncL/ASgzgBhgtojLWiqXZxsCxll
 dwmxOFi3wqt5oAcfFuoDRZa+ObEcz7UHdUb3RIcHOEhc5mGvtcFhb+vk5OduZ4qtOJPVrtUjzmk
 gXasweHNkMtDGtwJwb8ebn6zvmObTA==
X-Authority-Analysis: v=2.4 cv=Z8PsHGRA c=1 sm=1 tr=0 ts=68b9b7c8 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=yJojWOMRYYMA:10 a=yPCof4ZbAAAA:8 a=7mo2PKruRViNE_zVYmoA:9 cc=ntf
 awl=host:12068
X-Proofpoint-GUID: 41InMUD2Il3Tm1mcUOwiMZKC10rScQEO
X-Proofpoint-ORIG-GUID: 41InMUD2Il3Tm1mcUOwiMZKC10rScQEO

Define fips_/nonfips_ variants of ecdsa_*_tmpl when the kernel is
configured to use a standalone FIPS module.

Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
---
 include/crypto/internal/ecc.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/crypto/internal/ecc.h b/include/crypto/internal/ecc.h
index 906d1443de96..b8ce202530de 100644
--- a/include/crypto/internal/ecc.h
+++ b/include/crypto/internal/ecc.h
@@ -30,6 +30,16 @@
 #include <crypto/ecc_curve.h>
 #include <linux/unaligned.h>
 
+#ifdef CONFIG_CRYPTO_FIPS140_EXTMOD
+#ifdef FIPS_MODULE
+#define ecdsa_x962_tmpl fips_ecdsa_x962_tmpl
+#define ecdsa_p1363_tmpl fips_ecdsa_p1363_tmpl
+#else
+#define ecdsa_x962_tmpl nonfips_ecdsa_x962_tmpl
+#define ecdsa_p1363_tmpl nonfips_ecdsa_p1363_tmpl
+#endif
+#endif
+
 /* One digit is u64 qword. */
 #define ECC_CURVE_NIST_P192_DIGITS  3
 #define ECC_CURVE_NIST_P256_DIGITS  4
-- 
2.39.3

