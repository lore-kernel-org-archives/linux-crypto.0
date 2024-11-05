Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235DB1D3199;
	Tue,  5 Nov 2024 13:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730815123; cv=none; b=SiPYBV6CTcr1WXEpURoZtbYb40QW/B24Gyhf7nL2wlljOs/204pFWK7SqwjTNruUV0zN7FWsEdcC9yyO+Kl/FmkOO+kfnz9FlRH5EFAls7cZ9pfCtin0RE8gDPXUZ7O7gnQeGB+8k6fE4CC4WGJxXd5bh2NkkaCy/CoMkjxSZsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730815123; c=relaxed/simple;
	bh=J7Tz+W/EmVR+Qotl0IQFhiK6Gqu11qEw4bPeI94mRWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhFxw2PNDegAILek8hnXB5FJT/9MSlGyUJyp+T6XFF8zGqvRGobz03Fbh83VgkbeloUGnSSrNnsmAymV3Hv3JSvzAY8Q337/aARvcm4I+ID95lFt5mO4chJBmlAr3AVDqc1y+ePXFXVKeTcstP9qGcpAMcXz9f4Q3lySyg+uSDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=BSdneF/M; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="BSdneF/M"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A5DdgWE024432;
	Tue, 5 Nov 2024 13:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=tMvDn8+vwttdWRSWy
	s3xeCPI0cOLKJk/hgz7UJM0RNk=; b=BSdneF/My9m2JfZ4b1P1MSL+mOpZ4xbZB
	mhzyEA2saQGQkxrBfCHGQTmrA24zdRXntNFsiUf/C25Cv/ZFdqrnoRzsL9gJAGd2
	zydxBjmUR8andq2nS/fcdaigmTUT9gJpK87gVjyF6gx5oXWHPkQJPrUrWdbTn80p
	7JRCicXd8erkv6mKU/aRGbDU6hE+JY4VnQXGFXlfkFyqolU7TyeZDHEWrupMIrM4
	yT68bqsGNGESd8eXs/v12jIn487ok/DzUcer/YJD3hFXTZoSP26q5dxQJ/IzD9py
	2OTzAEYoTti+hx5sSdhDhKnFUf+FSNzTAfMArIGmo5mVLyqdBab3Q==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42qmepg3n9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Nov 2024 13:58:38 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4A58NYHc012288;
	Tue, 5 Nov 2024 13:58:37 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42p140v5yv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Nov 2024 13:58:37 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4A5DwYXq55640572
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Nov 2024 13:58:34 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E6D082004B;
	Tue,  5 Nov 2024 13:58:33 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6AC020043;
	Tue,  5 Nov 2024 13:58:33 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.152.224.229])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 Nov 2024 13:58:33 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        hca@linux.ibm.com
Cc: linux-s390@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: [PATCH v2 2/3] s390/crypto: Add protected key hmac subfunctions for KMAC
Date: Tue,  5 Nov 2024 14:58:31 +0100
Message-ID: <20241105135833.391957-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241105135833.391957-1-freude@linux.ibm.com>
References: <20241105135833.391957-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Bw_7tiOjbO7LqCp1PvRW0IzgIFpbJwys
X-Proofpoint-ORIG-GUID: Bw_7tiOjbO7LqCp1PvRW0IzgIFpbJwys
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 adultscore=0
 mlxlogscore=592 malwarescore=0 clxscore=1015 lowpriorityscore=0
 impostorscore=0 bulkscore=0 phishscore=0 mlxscore=0 priorityscore=1501
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2411050105

From: Holger Dengler <dengler@linux.ibm.com>

The CPACF KMAC instruction supports new subfunctions for
protected key hmac. Add defines for these 4 new subfuctions.

Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 arch/s390/include/asm/cpacf.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/s390/include/asm/cpacf.h b/arch/s390/include/asm/cpacf.h
index 1d3a4b0c650f..b1c1d5f5d9a1 100644
--- a/arch/s390/include/asm/cpacf.h
+++ b/arch/s390/include/asm/cpacf.h
@@ -127,6 +127,10 @@
 #define CPACF_KMAC_HMAC_SHA_256	0x71
 #define CPACF_KMAC_HMAC_SHA_384	0x72
 #define CPACF_KMAC_HMAC_SHA_512	0x73
+#define CPACF_KMAC_PHMAC_SHA_224	0x78
+#define CPACF_KMAC_PHMAC_SHA_256	0x79
+#define CPACF_KMAC_PHMAC_SHA_384	0x7a
+#define CPACF_KMAC_PHMAC_SHA_512	0x7b
 
 /*
  * Function codes for the PCKMO (PERFORM CRYPTOGRAPHIC KEY MANAGEMENT)
-- 
2.43.0

