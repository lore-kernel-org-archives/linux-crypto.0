Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB2022089;
	Tue, 28 May 2024 23:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716940173; cv=none; b=MtP/IA8AqTDJzbEfmnqP4VuwO7n+jXGrBUSftJDyJcxKX1ZjcDXul73sv6lzVzekmMNV1zwkDe3idvNXM2vTgcAlTzlnctVqwsXifatusITIfBzQNsiW083qoh3WCQAKYUN4E7Z3hbtCgJHJ8uV2I1w1WP1IJEztSPc65eG13OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716940173; c=relaxed/simple;
	bh=J1EVgTuwrB1/ySa+nzHrhrWiG3u4AZwOSCUgS03zuLw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=BhSvAt+4sq7di1n9oOlGsVrTITuSn0TbXxpSFGyupjXn43hLaO9UwnPTll80iMnqX4yHrImiOVlMueB5q7RHVcxwPl/lX+U2X+jM0wF2D3TcTsiXqONeS0qDsVJL8uyhWI+oeq1zkS0gVhii7exVdf1QRBmimqr9eWX8KjLyUlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=m7G5NiJI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="m7G5NiJI"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 44SKh8wX001482;
	Tue, 28 May 2024 23:49:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=I3gCoeHpm6zr3IgjiQNbpm
	ifqhZJpb/+eZbFbmBhDwU=; b=m7G5NiJIwxUDaEYRyDfX2nHTCWhNlJJHScV2MG
	DPQ2LFkcLFueOt0Hhj6vpt+AA42cWy7U8sJ5Gc/WfhKjTyIGgJbRNoOVoipZKBpi
	OdsCKWbDN2z5NlCjTl0N73c6jZJoAIg7EVM47UPYqdKH8jR//hJx0kgG5fud3i0w
	eroYU6SQ6oGtkmHF/jENLMVyhgxQUJMigvU12zndSa3xTv2FjenWU3m4rnQtbI6Z
	FpgAv0dYuRNSPFaLXNaTbxXA457rECHQF/3EtVVC4TmqOspmCsLyMVt05lVzbfSK
	tLtVRDetExKa/vR8vr7ogC0YRv/Cfyt/S2T4nS2TNTv1XYQw==
Received: from nalasppmta05.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yba1k7k9w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 23:49:28 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA05.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 44SNnS4s029343
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 May 2024 23:49:28 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Tue, 28 May
 2024 16:49:27 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Tue, 28 May 2024 16:49:23 -0700
Subject: [PATCH] lib: crypto: add missing MODULE_DESCRIPTION() macros
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240528-md-lib-crypto-v1-1-840e468d118b@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAINtVmYC/x3MTQqDMBBA4avIrDuQBk1/rlJcJHFSBzTKjC2Ke
 HfTLr/FezsoCZPCs9pB6MvKUy64XiqIvc9vQu6KwRpbm8becexw4IBRtnmZMDXW3B7O1S4lKM0
 slHj9/15tcfBKGMTn2P8uA+fPiqPXhQSO4wRHNi+nfgAAAA==
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01c.na.qualcomm.com (10.47.97.35) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: rYLM8a7Ol5Ss4jqRbu31lU5yystkKifj
X-Proofpoint-GUID: rYLM8a7Ol5Ss4jqRbu31lU5yystkKifj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-28_14,2024-05-28_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 impostorscore=0
 suspectscore=0 phishscore=0 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 spamscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2405280175

Fix the allmodconfig 'make W=1' warnings:
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/crypto/libchacha.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/crypto/libarc4.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/crypto/libdes.o
WARNING: modpost: missing MODULE_DESCRIPTION() in lib/crypto/libpoly1305.o

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 lib/crypto/arc4.c      | 1 +
 lib/crypto/des.c       | 1 +
 lib/crypto/libchacha.c | 1 +
 lib/crypto/poly1305.c  | 1 +
 4 files changed, 4 insertions(+)

diff --git a/lib/crypto/arc4.c b/lib/crypto/arc4.c
index c2020f19c652..838812d18216 100644
--- a/lib/crypto/arc4.c
+++ b/lib/crypto/arc4.c
@@ -71,4 +71,5 @@ void arc4_crypt(struct arc4_ctx *ctx, u8 *out, const u8 *in, unsigned int len)
 }
 EXPORT_SYMBOL(arc4_crypt);
 
+MODULE_DESCRIPTION("ARC4 Cipher Algorithm");
 MODULE_LICENSE("GPL");
diff --git a/lib/crypto/des.c b/lib/crypto/des.c
index ef5bb8822aba..9518658b97cf 100644
--- a/lib/crypto/des.c
+++ b/lib/crypto/des.c
@@ -899,4 +899,5 @@ void des3_ede_decrypt(const struct des3_ede_ctx *dctx, u8 *dst, const u8 *src)
 }
 EXPORT_SYMBOL_GPL(des3_ede_decrypt);
 
+MODULE_DESCRIPTION("DES & Triple DES EDE Cipher Algorithms");
 MODULE_LICENSE("GPL");
diff --git a/lib/crypto/libchacha.c b/lib/crypto/libchacha.c
index dabc3accae05..cc1be0496eb9 100644
--- a/lib/crypto/libchacha.c
+++ b/lib/crypto/libchacha.c
@@ -32,4 +32,5 @@ void chacha_crypt_generic(u32 *state, u8 *dst, const u8 *src,
 }
 EXPORT_SYMBOL(chacha_crypt_generic);
 
+MODULE_DESCRIPTION("ChaCha stream cipher (RFC7539)");
 MODULE_LICENSE("GPL");
diff --git a/lib/crypto/poly1305.c b/lib/crypto/poly1305.c
index 26d87fc3823e..5d8378d23e95 100644
--- a/lib/crypto/poly1305.c
+++ b/lib/crypto/poly1305.c
@@ -76,3 +76,4 @@ EXPORT_SYMBOL_GPL(poly1305_final_generic);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Willi <martin@strongswan.org>");
+MODULE_DESCRIPTION("Poly1305 authenticator algorithm, RFC7539");

---
base-commit: e0cce98fe279b64f4a7d81b7f5c3a23d80b92fbc
change-id: 20240528-md-lib-crypto-f520796646ff

