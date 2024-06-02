Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FD8800;
	Sun,  2 Jun 2024 23:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717370238; cv=none; b=gDdbWasfJoilZH+9/ZurrDnf+dTxhvt2dXv1HS845Qku6/zX3BV02a+gbWsM/aH5Tbi2206qGIJBvKYEyJv1BJetX2csIWaobmcEu17rDl45cf6fxxr7UslV7GI7RToCGLT9y8fKUfh8weIZZeLoJiI1RUMyhtxFuQMz/2tbU+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717370238; c=relaxed/simple;
	bh=zA+UHl8rsgzi/wBzjJl2SBYZeq4/CuFliR2VPQ1lj/Q=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=tNBzph2PhBMB46XRvptWDdFzMPwccwxdN5m6Zp5P7owi1PeowqBdnliaK2cgCCnEDwyPelVVOSYG3BkaVe/PkySrItETMA/Htq7wJQKKb+VfFkF933aFJPu7Z9tctuF3jv7brBf0R+840hdTUm4gy+OuDdq4Pfg01W3d87V6RLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=FrjkqIMH; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="FrjkqIMH"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 452M0dfq019002;
	Sun, 2 Jun 2024 23:17:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=sHwcuGv1pD8cCwUqqZeIpk
	6cczmz7NL6BY5HgMJ3UIY=; b=FrjkqIMHsHfYbrRwEVCsd+BgvpGtNOH8DAj9AT
	eIwbrqIIgCiuSG6bwEdqPkBVr22RBf5PeKKMiDqio+2s8ABIZ0AzdmpEAX6Bz35I
	bKDNx4/NOtJQ2ZBONNVKspenPtTzHsu464lzR42paNTsChuEF0+QhyZxllsmvtlF
	8XsJ7+w3YMsjdWJ7ZRuwqRs0xzOMMckdhKxJHH79MCpzDuT1nvXg8M3HxPt89Xsv
	T9tZ7WvKmoo2zyMHY93ApIg8iQ14JScCQnEoen2V9DAf9xr5xa3fx5HG+NhwQfZi
	kezTT9RxNkZAgEspv1ZKzzQqhGgDDrw7zXz+Z9ysv/IHogXQ==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yfw6v2np0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 02 Jun 2024 23:17:10 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 452NH9P9020089
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 2 Jun 2024 23:17:09 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sun, 2 Jun 2024
 16:17:08 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Sun, 2 Jun 2024 16:17:08 -0700
Subject: [PATCH] crypto: xilinx - add missing MODULE_DESCRIPTION() macro
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240602-md-zynqmp-aes-gcm-v1-1-e431cb9b558e@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAHP9XGYC/x3MwQ6CMAyA4VchPdtkDsKMr2I8lFGhiau4qkEI7
 870+B3+fwXjLGxwrlbI/BGThxYcDxXEkXRglL4YvPONa53H1OPy1WeakNhwiAlj07pw8qGug4P
 STZlvMv+fl2txR8bYZdI4/k530feMiezFGbZtB/bxcXGCAAAA
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Michal Simek <michal.simek@amd.com>
CC: <linux-crypto@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Jeff
 Johnson" <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: 3TCLYvxciTwv76JBPNSX0i9aD_7sHTFr
X-Proofpoint-ORIG-GUID: 3TCLYvxciTwv76JBPNSX0i9aD_7sHTFr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-02_15,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1011 spamscore=0 priorityscore=1501 mlxlogscore=948 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406020204

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/crypto/xilinx/zynqmp-aes-gcm.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 drivers/crypto/xilinx/zynqmp-aes-gcm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/xilinx/zynqmp-aes-gcm.c b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
index e61405718840..7f0ec6887a39 100644
--- a/drivers/crypto/xilinx/zynqmp-aes-gcm.c
+++ b/drivers/crypto/xilinx/zynqmp-aes-gcm.c
@@ -446,4 +446,5 @@ static struct platform_driver zynqmp_aes_driver = {
 };
 
 module_platform_driver(zynqmp_aes_driver);
+MODULE_DESCRIPTION("Xilinx ZynqMP AES Driver");
 MODULE_LICENSE("GPL");

---
base-commit: a693b9c95abd4947c2d06e05733de5d470ab6586
change-id: 20240602-md-zynqmp-aes-gcm-c46078273370

