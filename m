Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBE5433D5
	for <linux-crypto@vger.kernel.org>; Wed, 30 Oct 2024 16:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730305369; cv=none; b=VpaUWPDAOXDaNYPiI66DQ3pcOlUDRcoK02naafMLMtcgE0qwyjSBEc+tN18NCh8SWrGNzEghoRS55s+z/1sgrXN5sR8oOTif89nDElOKp0yXIw8XZu6J556ADVvM5uE9ebbwBdNx3/VZIdhDzQ/yKADVddxv1U4uBnr2zNH+rpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730305369; c=relaxed/simple;
	bh=qwPZQ66hoxKAEy2NkV6Ol/s0GPihdhCs8T1EZl/kdrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCXcLGmh4qQOYz5iM3+P6Vd+JnW7Pc6hLAAB9Odp+BO1gII3DLSwHGq0ssE7RSmwCd9IjjnwMCHJn+ryQmJDBpXojnUBFcYU4+AqKLHRtIByreVWLewrEzE1liGNlrxu/6NeV/EaFEIIt9MPeVgZYk0NtC+eYqkk/MOKDvgoLYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=V/0ehH6P; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="V/0ehH6P"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49UDw6Li002041;
	Wed, 30 Oct 2024 16:22:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=0kpq9yd4jSYLbMq4q
	VyJV5+8mJaEyncRrw/vnNIIbZw=; b=V/0ehH6POIFQwtSs4GHxhzfy7QFe+3ppZ
	3F/TrTK4JW/ZmKBM/asHx/qruU+HDd3X0lExYS6E9EY2EyD5o+CqmP6N9uNX4Exm
	H08Aj9g7nerc1j6RGuypchEFuVFLwwH6ZmRxxEXfGifBNZz4YChwYFWfj/QH2nYN
	yIJ06VGU82jN1XY9XaKDevRtAzM5PvAJShRe90f+Jg3DJvVL8bd8y+9M3Nj5Woyc
	WcCTyz56+sIGJ1og7JM8rtUsM1oT1zL9Tmdj1aOSF8ty6IQSv+/+l3UrdKJ9fGdF
	HjdjgtDIBNL2N98wUDLzxu1KMsmLO1rrnA83rkZb+UEp3lcgUutzA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42kkbn1hf8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 16:22:41 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49UDI7F4015814;
	Wed, 30 Oct 2024 16:22:41 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 42hdf1gfbx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Oct 2024 16:22:40 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49UGMbr154133094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Oct 2024 16:22:37 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 77FED2004B;
	Wed, 30 Oct 2024 16:22:37 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D31AB20043;
	Wed, 30 Oct 2024 16:22:36 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.179.18.237])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Oct 2024 16:22:36 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, herbert@gondor.apana.org.au, davem@davemloft.net,
        hca@linux.ibm.com
Cc: linux390-list@tuxmaker.boeblingen.de.ibm.com, linux-crypto@vger.kernel.org
Subject: [PATCH v1 2/3] s390/crypto: Add protected key hmac subfunctions for KMAC
Date: Wed, 30 Oct 2024 17:22:34 +0100
Message-ID: <20241030162235.363533-3-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20241030162235.363533-1-freude@linux.ibm.com>
References: <20241030162235.363533-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ZJJjqaxBTQ7aWjIi5c3_DdY9SCtfSSkP
X-Proofpoint-GUID: ZJJjqaxBTQ7aWjIi5c3_DdY9SCtfSSkP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=612
 impostorscore=0 malwarescore=0 priorityscore=1501 adultscore=0 bulkscore=0
 suspectscore=0 lowpriorityscore=0 clxscore=1015 spamscore=0 phishscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410300127

From: Holger Dengler <dengler@linux.ibm.com>

The CPACF KMAC instruction supports new subfunctions for
protected key hmac. Add defines for these 4 new subfuctions.

Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 arch/s390/include/asm/cpacf.h | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/s390/include/asm/cpacf.h b/arch/s390/include/asm/cpacf.h
index 1d3a4b0c650f..5fcde9a7bc07 100644
--- a/arch/s390/include/asm/cpacf.h
+++ b/arch/s390/include/asm/cpacf.h
@@ -119,14 +119,18 @@
  * function codes for the KMAC (COMPUTE MESSAGE AUTHENTICATION CODE)
  * instruction
  */
-#define CPACF_KMAC_QUERY	0x00
-#define CPACF_KMAC_DEA		0x01
-#define CPACF_KMAC_TDEA_128	0x02
-#define CPACF_KMAC_TDEA_192	0x03
-#define CPACF_KMAC_HMAC_SHA_224	0x70
-#define CPACF_KMAC_HMAC_SHA_256	0x71
-#define CPACF_KMAC_HMAC_SHA_384	0x72
-#define CPACF_KMAC_HMAC_SHA_512	0x73
+#define CPACF_KMAC_QUERY		0x00
+#define CPACF_KMAC_DEA			0x01
+#define CPACF_KMAC_TDEA_128		0x02
+#define CPACF_KMAC_TDEA_192		0x03
+#define CPACF_KMAC_HMAC_SHA_224		0x70
+#define CPACF_KMAC_HMAC_SHA_256		0x71
+#define CPACF_KMAC_HMAC_SHA_384		0x72
+#define CPACF_KMAC_HMAC_SHA_512		0x73
+#define CPACF_KMAC_PHMAC_SHA_224	0x78
+#define CPACF_KMAC_PHMAC_SHA_256	0x79
+#define CPACF_KMAC_PHMAC_SHA_384	0x7a
+#define CPACF_KMAC_PHMAC_SHA_512	0x7b
 
 /*
  * Function codes for the PCKMO (PERFORM CRYPTOGRAPHIC KEY MANAGEMENT)
-- 
2.43.0

