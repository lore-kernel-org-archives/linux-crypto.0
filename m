Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729C8747F;
	Fri, 14 Jun 2024 00:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718326645; cv=none; b=ofHve5gDyAk1fgFPPHk3bjTXitNtez1qxCS6jsht2CwXWzb0NAVIZNG9sATYzF0Ehn4Ks4Wws0zA8fs4zq6SHwfmK2U1gGbDJxISDWKP6rSziyxuPtfVwFtChf+llq//doeucuMUC2qX+KiSDpF4aiXlDRUJ2c+xPsCSA82NKfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718326645; c=relaxed/simple;
	bh=W6dTjhNZLpBrK0RRWMPGMGKOmBXlM4gKHYHgemT1grg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=WEEuqjAkwPnFuAj5MHW/1ECwf8lV+myGa8zigDZU3TDXcFv0rxEmrLh1YlIT94ltb4pkQtqQ8xxpH822lYfdldE1PwqTWIWS+SBbzoXiUScz3BarXtfq+kjSGDJLcI9ZlbmLoZV9nnVn0WeAUQ/2ESR1nO8VshdftezUc4h1RyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=g7Ro8ChF; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="g7Ro8ChF"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45DJGLAs024061;
	Fri, 14 Jun 2024 00:57:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=bRFeewEwMNiMGeLXutzGjm
	ayJp3qx1DIPrWEsnXUmIY=; b=g7Ro8ChFRG1Q7jUmNzmiNq2uL2N98+vG3pELUA
	GGRCDVspFcO9GJWhrUQ+Svg4qLSrrZYaioigkxEJB2NYL6XlKE45GOrLbwO/sEJv
	LMNt1x4m8qUsYECwSkuiNWbw/ITDSmf1QzSdf4CwFgoo2ghZjv3AKrY3OOhK1ZBW
	SroWBv/z+KGARUv+g7slxArkRVbn5sd1W0OP3QclQfwB931ojzjORzuVduKx5cQZ
	g9xSnDwn5AhSc4bVEXLan99rIcYMKZbNvf/HASZjj5qKFzjFVZ7eEviNhX9xT8TR
	mdlM3HaCCioQguZqULvO019L9s0SkBCzTecAZvDPyORX0JBg==
Received: from nalasppmta03.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yr6q4rnxk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Jun 2024 00:57:09 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA03.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45E0v7j9026453
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Jun 2024 00:57:07 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Thu, 13 Jun
 2024 17:57:07 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Thu, 13 Jun 2024 17:57:05 -0700
Subject: [PATCH] crypto: arm/poly1305 - add missing MODULE_DESCRIPTION()
 macro
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240613-md-arm-arch-arm-crypto-v1-1-0ff745c4220a@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAGGVa2YC/x2MQQ6CQAxFr0K6tgkgYvQqxkVnpjpNnIG0aCCEu
 zOy+Ml/i/dWMFZhg3u1gvJPTIZcoDlV4CPlN6OEwtDWbVf3zRlTQNJU5uNxvC7jNCBdO+Zwc3Q
 JPRR5VH7JfIQfz8KOjNEpZR//uY/k74yJbGKFbdsB9lNEn4cAAAA=
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>
CC: <linux-crypto@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Jeff
 Johnson" <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: qaVeR0gxAaDztVQ1jXA_61ERLfKSp8Yi
X-Proofpoint-GUID: qaVeR0gxAaDztVQ1jXA_61ERLfKSp8Yi
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-13_15,2024-06-13_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 suspectscore=0
 impostorscore=0 adultscore=0 malwarescore=0 priorityscore=1501
 mlxlogscore=999 lowpriorityscore=0 phishscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406140003

With ARCH=arm, make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/arm/crypto/poly1305-arm.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 arch/arm/crypto/poly1305-glue.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/crypto/poly1305-glue.c b/arch/arm/crypto/poly1305-glue.c
index c31bd8f7c092..8482e302c45a 100644
--- a/arch/arm/crypto/poly1305-glue.c
+++ b/arch/arm/crypto/poly1305-glue.c
@@ -267,6 +267,7 @@ static void __exit arm_poly1305_mod_exit(void)
 module_init(arm_poly1305_mod_init);
 module_exit(arm_poly1305_mod_exit);
 
+MODULE_DESCRIPTION("Accelerated Poly1305 transform for ARM");
 MODULE_LICENSE("GPL v2");
 MODULE_ALIAS_CRYPTO("poly1305");
 MODULE_ALIAS_CRYPTO("poly1305-arm");

---
base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
change-id: 20240613-md-arm-arch-arm-crypto-a74eed9ba5d6

