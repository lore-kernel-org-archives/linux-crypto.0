Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F69A3207;
	Sun,  2 Jun 2024 22:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717367842; cv=none; b=i7YsiPBzbmuskpni+s0UtENGC1XL4jVkC/m4+DjrrcShtezg5vE+BORg0LKMCH4fEb2AYGAvIj5w7XDeftnW82/9+ZlMNZ5cADPNENEFiHQQx0+nAJ8kkhOGOgqK9q/tffHvjboA9pRmBuxN8PHILeNgk5YeIL7WbUklnJTafhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717367842; c=relaxed/simple;
	bh=G3+pi39DXsLu5GOB3nNvWBkhX6gdL40MBr+mzLc1pEE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=e8nQUYh4jYQE+jO7IpaLTgXjyAkJO0Ds2ywCXWJgIVDePuOyJLDqfCUQoMc0JfOixcdbQVtyvUn47nANx0a6FdT30Dn10mKlb+qKQo6/1A2uyRBGa+/jtaw57jAmXnihX3afcIZ72K1F5pil7X2+DJEfHK9u79EssQecANwUUm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=VSvO28yI; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="VSvO28yI"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 452MbBIb011223;
	Sun, 2 Jun 2024 22:37:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=MmX33+HbK0PEuGl6iJkxQw
	3i/jTUFnwPy5XrXhmZi5Y=; b=VSvO28yImd+ddpkrvUb4Kqq7GR24bkT0taVCLg
	GC6ZVVv5Zt1HG6dh3vAc599LVBZxbWqJ69Kq5fDC3edWOWx1jdzwD/mnAtrYm1h9
	TFKgG2Ur/9zjML9O9tZkxjZROhF/rWmLZrts2F9/UGLhJ1f+/xhpdk0y0YUwzXJt
	XJpCsztUmgbu5g/pneNCfiDskoLk/3D/6hxFZaXk3C/Fu7SGfVOCX5LPryj3+E0o
	ORNo/Z9+YL2fZFqAVqGffRQ/k8/cLhcWL3v6IgZCd68zmwIbCk5E5DwcsK2wXVz2
	un15l95+e5PYpZLJHIzCKuM4zWdrfTeByvV6UpOpUWRfxnvA==
Received: from nalasppmta02.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3yfw6v2md6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 02 Jun 2024 22:37:11 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA02.qualcomm.com (8.17.1.5/8.17.1.5) with ESMTPS id 452MbAVh023345
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 2 Jun 2024 22:37:10 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sun, 2 Jun 2024
 15:37:09 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Sun, 2 Jun 2024 15:33:39 -0700
Subject: [PATCH] crypto: atmel-sha204a - add missing MODULE_DESCRIPTION()
 macro
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240602-md-atmel-sha204a-v1-1-ab02640a0cf2@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAELzXGYC/x3MwQrCMAyA4VcZORuosfTgq4iHbM1sYK2STBmMv
 bvV43f4/x1cTMXhOuxg8lHXZ+s4nwaYCreHoOZuoEAxpEBYM/JaZUEvTCEyZqb5wokoJoGevUx
 m3f7L2717ZBccjdtUfqNF23vDyr6KwXF8AZBNHa6BAAAA
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        Claudiu Beznea
	<claudiu.beznea@tuxon.dev>
CC: <linux-crypto@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Jeff
 Johnson" <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.13.0
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: QT5x1BqUQwaW_cE8jeMcjplxIs-Qu_z6
X-Proofpoint-ORIG-GUID: QT5x1BqUQwaW_cE8jeMcjplxIs-Qu_z6
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-06-02_15,2024-05-30_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 malwarescore=0
 impostorscore=0 mlxscore=0 suspectscore=0 adultscore=0 lowpriorityscore=0
 clxscore=1011 spamscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406020198

make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in drivers/crypto/atmel-sha204a.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 drivers/crypto/atmel-sha204a.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/atmel-sha204a.c b/drivers/crypto/atmel-sha204a.c
index 24ffdf505023..1fd836eb2d89 100644
--- a/drivers/crypto/atmel-sha204a.c
+++ b/drivers/crypto/atmel-sha204a.c
@@ -232,4 +232,5 @@ module_init(atmel_sha204a_init);
 module_exit(atmel_sha204a_exit);
 
 MODULE_AUTHOR("Ard Biesheuvel <ard.biesheuvel@linaro.org>");
+MODULE_DESCRIPTION("Microchip / Atmel SHA204A (I2C) driver");
 MODULE_LICENSE("GPL v2");

---
base-commit: a693b9c95abd4947c2d06e05733de5d470ab6586
change-id: 20240602-md-atmel-sha204a-da2f3a62246e

