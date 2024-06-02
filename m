Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A77F2232B;
	Sun,  2 Jun 2024 23:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717369444; cv=none; b=juCkmhvwFrwPVFRi8wk/OUGt8X/L621RO05xwVh8qPi20fxkFTXwPRo5wkqg6itWUiYLWe0brClkNj7DPz40HEUPxoutAywiB+710eKWHSpYXOzGejB6oDRZcIRBvPnYMtf4mr9enrekw1vxGUYLn6HS9IU2arRIUQXD+QH3YXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717369444; c=relaxed/simple;
	bh=ZOALy1t+4RTIifpPkkNIxH66T0COawLvTd8pvZT4ILg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=puLZCrmkEdjWBBvsxkOke95VEcQfR2q4bP4qV1qlGHtC9+szPm/FvYCb/aStRecNJySqgy8n9hOVOR8JS5e81gmSRG7BNN8yQxdienyLICacCslqPRNl4+hXkpiuPbWs/LrtDGGSr9d45myZ8i4AYnJs1uxm5ZqRoJklbdnF7es=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=ejNx9c1+; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="ejNx9c1+"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 452Mb09H002754;
	Sun, 2 Jun 2024 23:03:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=4aKW/wTZD8T4tplibG4C+R
	VT/GFDNuDPw6FhCBkzuMs=; b=ejNx9c1+uiVjOsSzS1jEaxZgNAz0HTA3x4Ut7d
	lh0Xk54F2zNjUVHzZavkItUHZ1oY2+4DYc84tdZ6h5iXBHz1GcqIbeLuOQjI8EKD
	1hjrBHTrBqviNmc9u4k9uNoqTPDQN2rLfKNfcNtM8dxqpf4WJFWKhQ48YAX9dq71
	SjbWSN9G1DYr1QlHRzRIS1mgGwp+o58UGyBfLEffV28r/JGKxwnv/ATE0jQfwyPf
	pJYNXkmnIMxf/PPMGHHZabPuyNvzMxzl6eg4PQmQ9KrvbgGtVaUINur1ymR3tM8x
	zB4CtPIUtcuthb88erxvpKnyrpdFBi9feF6GEYQREyD6AA3A==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yfw5t2fbc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 02 Jun 2024 23:03:55 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 452N3swT006021
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 2 Jun 2024 23:03:54 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sun, 2 Jun 2024
 16:03:54 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Sun, 2 Jun 2024 16:03:54 -0700
Subject: [PATCH] crypto: keembay - add missing MODULE_DESCRIPTION() macro
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240602-md-keembay-ocs-hcu-v1-1-22741e1c3d13@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAFn6XGYC/x3MQQrCMBBA0auUWTuQxqDoVcTFJJ2YQZNKxkql9
 O6NXb7F/wsoV2GFa7dA5a+ojKWhP3QQEpUHowzNYI115mQs5gGfzNnTD8egmMKE0fXnC0WmoyN
 o4btylHmf3u7NnpTRVyoh/VcvKdOMmfTDFdZ1A/6WnxODAAAA
To: Daniele Alessandrelli <daniele.alessandrelli@intel.com>,
        Declan Murphy
	<declan.murphy@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David
 S. Miller" <davem@davemloft.net>
CC: <linux-crypto@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>,
        Jeff Johnson <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-ORIG-GUID: 7mi913pG-nTtbapVTGpdtstJiLtCNEZ0
X-Proofpoint-GUID: 7mi913pG-nTtbapVTGpdtstJiLtCNEZ0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-02_15,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 bulkscore=0
 spamscore=0 suspectscore=0 priorityscore=1501 impostorscore=0
 clxscore=1011 malwarescore=0 phishscore=0 mlxscore=0 lowpriorityscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2405170001 definitions=main-2406020201

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/crypto/intel/keembay/keembay-ocs-hcu.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 drivers/crypto/intel/keembay/ocs-hcu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/intel/keembay/ocs-hcu.c b/drivers/crypto/intel/keembay/ocs-hcu.c
index deb9bd460ee6..55a41e6ab103 100644
--- a/drivers/crypto/intel/keembay/ocs-hcu.c
+++ b/drivers/crypto/intel/keembay/ocs-hcu.c
@@ -837,4 +837,5 @@ irqreturn_t ocs_hcu_irq_handler(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
+MODULE_DESCRIPTION("Intel Keem Bay OCS HCU Crypto Driver");
 MODULE_LICENSE("GPL");

---
base-commit: a693b9c95abd4947c2d06e05733de5d470ab6586
change-id: 20240602-md-keembay-ocs-hcu-f4179afea34a

