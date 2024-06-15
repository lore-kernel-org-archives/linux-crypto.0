Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8051C2561D;
	Sat, 15 Jun 2024 23:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718495223; cv=none; b=V+z8SPW+/aArsUzwtael4mwVEFPRxFtx0SmkWrPNWkIe4aZJQzh61dNCcHzqA1lAhFS7RN5v1mUUjoQ6F4X0L4PeyuCxtLuXr/vNko492p6mi1mCFLTHjamm6tLriyixBB9+lbmT35qM3SRDFWKYKX+fdCvrLmBv12ojXRYzqPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718495223; c=relaxed/simple;
	bh=N4FN2DClt/Y/uIf72OrDc+dyQD9gXFv5s3nVG1ZLfpQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-ID:To:CC; b=HtUd/LEJ0T5nRHtbFFAWga8W82H3h0gQcYTLD3olkceyIZ3vYPjYYsEXx6OnoyAyzMFi0IsiX6DczXR0XEN6cPkwlQF7Afm83Ik0rIiHAnZm5w2ZMov2LO/rORlnW10yYt2HxMXUoIvTiLCa5ApNbsFZQEO2To/G2xVSt2qrBms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com; spf=pass smtp.mailfrom=quicinc.com; dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b=kNrCuU2e; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=quicinc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=quicinc.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=quicinc.com header.i=@quicinc.com header.b="kNrCuU2e"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45FNe228011298;
	Sat, 15 Jun 2024 23:46:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=I7Lc5U98nkYM7nfAMMRFt+
	f1kBIlp8rfa2dgQU7QCN0=; b=kNrCuU2e3KGJpM+6xE65exzy8ExTgYiBC+5tLF
	R1KFPN46vx4bKJRJl4BdSoqW1odctlu3nz8DfHrVhJBehf8y9bN/1OpjOiXZYRS+
	sjx4q/CJ0eJe5c0RkFs7sgK9sHJvt4RuZR3gNv+dGGzXV57SE5APy204pjcd0E8s
	g9mMoUpUP7uavH8OeK6G3aTHYVPX84lUQh1EfDA9myLIs7k23Aky4vqtcTGC84F/
	Hxxej2Jf7eot1jOdnVZ3DNrKsWZWdDkWy8AGt5+bBQN96jxKWZ+sxzurCr9aoAW5
	9ZfLdwbapogMsXk0vpY7g/6es7YBmlSPDzp5cbqv/gw3ztqQ==
Received: from nalasppmta01.qualcomm.com (Global_NAT1.qualcomm.com [129.46.96.20])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 3ys0an1d74-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 15 Jun 2024 23:46:53 +0000 (GMT)
Received: from nalasex01a.na.qualcomm.com (nalasex01a.na.qualcomm.com [10.47.209.196])
	by NALASPPMTA01.qualcomm.com (8.17.1.19/8.17.1.19) with ESMTPS id 45FNkqI2003841
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sat, 15 Jun 2024 23:46:52 GMT
Received: from [169.254.0.1] (10.49.16.6) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.9; Sat, 15 Jun
 2024 16:46:51 -0700
From: Jeff Johnson <quic_jjohnson@quicinc.com>
Date: Sat, 15 Jun 2024 16:46:50 -0700
Subject: [PATCH] s390/crc32: add missing MODULE_DESCRIPTION() macro
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-ID: <20240615-md-s390-arch-s390-crypto-v1-1-7120d406e7c7@quicinc.com>
X-B4-Tracking: v=1; b=H4sIAOknbmYC/yXMyw6CQAyF4VchXdtkQC7RVzEsykxxmshAWjQYw
 rs76u58i/PvYKzCBtdiB+WXmMwpozwV4COlO6OEbKhcVbu2bHAKaOeLQ1If/8vre1ln7Bpmpja
 Moash3xflUbZf+tZnD2SMg1Ly8Rt8SHpuOJGtrHAcH/9QTBOJAAAA
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik
	<gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        "Christian
 Borntraeger" <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>
CC: <linux-crypto@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>,
        "Jeff
 Johnson" <quic_jjohnson@quicinc.com>
X-Mailer: b4 0.14.0
X-ClientProxiedBy: nalasex01b.na.qualcomm.com (10.47.209.197) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-QCInternal: smtphost
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=5800 signatures=585085
X-Proofpoint-GUID: h_P0oKot1Z1TRdcEgnqXmvPciXnZokLG
X-Proofpoint-ORIG-GUID: h_P0oKot1Z1TRdcEgnqXmvPciXnZokLG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-15_17,2024-06-14_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 spamscore=0 clxscore=1011
 suspectscore=0 mlxscore=0 adultscore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2405170001
 definitions=main-2406150181

With ARCH=s390, make allmodconfig && make W=1 C=1 reports:
WARNING: modpost: missing MODULE_DESCRIPTION() in arch/s390/crypto/crc32-vx_s390.o

Add the missing invocation of the MODULE_DESCRIPTION() macro.

Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
---
 arch/s390/crypto/crc32-vx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/s390/crypto/crc32-vx.c b/arch/s390/crypto/crc32-vx.c
index 74f17c905d12..89a10337e6ea 100644
--- a/arch/s390/crypto/crc32-vx.c
+++ b/arch/s390/crypto/crc32-vx.c
@@ -297,6 +297,7 @@ module_cpu_feature_match(S390_CPU_FEATURE_VXRS, crc_vx_mod_init);
 module_exit(crc_vx_mod_exit);
 
 MODULE_AUTHOR("Hendrik Brueckner <brueckner@linux.vnet.ibm.com>");
+MODULE_DESCRIPTION("CRC-32 algorithms using z/Architecture Vector Extension Facility");
 MODULE_LICENSE("GPL");
 
 MODULE_ALIAS_CRYPTO("crc32");

---
base-commit: 83a7eefedc9b56fe7bfeff13b6c7356688ffa670
change-id: 20240615-md-s390-arch-s390-crypto-75eeea6dfd74

