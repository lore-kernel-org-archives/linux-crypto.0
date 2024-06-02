Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0733F2232B;
	Sun,  2 Jun 2024 23:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717369887; cv=none; b=IXvhH4YOlKR+vOuzHgFDW24wIg372l4hM2DFMe17pB9p0/wL+HsTm9M+K5OBmCXuIqyjo8AevegF80B8UYSCkDsE5FLRCqIpR2xWKtGFqKSWQ5UwfD7bsL/J1t1eQHqJ0m+Ak1c9oSwaiuYJG9eBPgJDkBWM7gIjIMUpiWeGXVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717369887; c=relaxed/simple;
	bh=Qw6fY4/TBGGx/+tXsOZHHO/bwwpE6EquP1e5YuY3SNY=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=qJ3XxkRxfYtDzGICcrNhLMtmzi2KO8UBXcnUGBUV+9OFDBCqWTlGy1voaHJ2LCrGXkee3HBLIR+DY0T8Z4jbbrUYfxwbNmIwjS5JIOSENVg887EK2DXF2yC3Sovj/xzMX+ttl/AVIFMWS/TtojV4fWK4AKm5VMsB4MGZSOwUjws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=RAzW49+E; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="RAzW49+E"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 452Ll2dT013025;
	Sun, 2 Jun 2024 23:11:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=O0vtnyL5zLJl7z5I/6lnQb
	DJBavDkQR2p9hgA5ecqvs=; b=RAzW49+Ev3Ts6/kjy2n8E4G6EbPsiNr2sSWhDb
	C6nf3/s9AbJe5anatpu6z0Qc89YwcXrL4CAXJe8629b+T4IHc2+H3U/iWCrRZ3q3
	HKhVRBJp4uwdKnSY6+6o57zJBnNWaPT3/RxHLgoIKKt4lN7gkZUyPmM63ZRRst5r
	9qppXIuWP9bnLYZFONfQOEgS8zT+4YLQisayvTQ7y6CLbZ2yK6GdB0c5PwTCj5yb
	loU90EqvzZhKDt7Yp/7rRimEl72NpN+xEVOi9ibS9uePX2hF2db9bxXi6EOSSI+S
	M7d8gFiZvaak+pGr548DlouB1Tg/3MWNPLisNXBeJXrJAm6A==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yfw4ajqb6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 02 Jun 2024 23:11:19 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 452NBImi013060
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 2 Jun 2024 23:11:18 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sun, 2 Jun 2024
 16:11:18 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Sun, 2 Jun 2024 16:11:17 -0700
Subject: [PATCH] crypto: sa2ul - add missing MODULE_DESCRIPTION() macro
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240602-md-crypto-sa2ul-v1-1-78f8a3112221@quicinc.com>
X-B4-Tracking: v=1; b=H4sIABT8XGYC/x3MQQ6CMBBA0auQWTtJW0WIVzEuSjuVSaCQGTAYw
 t2tLN/i/x2UhEnhUe0g9GHlKRfYSwWh9/lNyLEYnHE3czcOx4hBvvMyoXq3Dti0MVmbqKmvLZR
 qFkq8ncfnq7jzStiJz6H/fwbO64aj14UEjuMH1h/qZoAAAAA=
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: C1alT08KRoL6Z6szjg8c5cMCfg8MKuOu
X-Proofpoint-ORIG-GUID: C1alT08KRoL6Z6szjg8c5cMCfg8MKuOu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-02_15,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 malwarescore=0 priorityscore=1501
 suspectscore=0 mlxscore=0 bulkscore=0 spamscore=0 adultscore=0
 clxscore=1015 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406020203

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/crypto/sa2ul.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 drivers/crypto/sa2ul.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/sa2ul.c b/drivers/crypto/sa2ul.c
index 78a4930c6480..461eca40e878 100644
--- a/drivers/crypto/sa2ul.c
+++ b/drivers/crypto/sa2ul.c
@@ -2496,4 +2496,5 @@ static struct platform_driver sa_ul_driver = {
 		   },
 };
 module_platform_driver(sa_ul_driver);
+MODULE_DESCRIPTION("K3 SA2UL crypto accelerator driver");
 MODULE_LICENSE("GPL v2");

---
base-commit: a693b9c95abd4947c2d06e05733de5d470ab6586
change-id: 20240602-md-crypto-sa2ul-78df11fe7538

