Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F8162882DA;
	Thu, 22 May 2025 08:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747904287; cv=none; b=p05VOBl6calDtcLKi2rW13bIKRpIoxGxDqlvCAjy1vCfwomm4JUup/PWiiP7FYVm6Lbt/Dw31xcwDkY2qrBVQlXv6rKMBnbprCFhTmUEXur9kwpEZiV8ER4nhP5A5aGpo+OFP4ufbXaHn4fGtL/TWWhqEmmdlDVnpEWR22CUKA8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747904287; c=relaxed/simple;
	bh=uh6o7nqqrQyI4M5JpcgaHSm6sNXuiY6tBXOE2qQRV0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYJdqWOFlwZSeK6nENhSBNoPhBncIjru/UiLUJISYXPZyC13LIe2BGmj1V6Xco8C9mn5K7oTOIRR0rXGHg+2PItcQ40pNFH4L/5+fV+BYu53H+x3l4mzbjvCv8fHy46mdZIKnoK9JdiuDJxXgvcGuZjyrejfKaw0c6rJHUpnUOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=rwWSVvGO; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="rwWSVvGO"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54M6JnIM031689;
	Thu, 22 May 2025 08:58:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=TR8fLmrx/0VNd92Tb
	FI0992Nup43AbUnhdp1N6djg6M=; b=rwWSVvGOzm3VRelXuvTVw+Jw/ylEGjiJv
	jidxn9cVVTvIQdbwwq70BsvxOGn5YRibD2S3QT1vDo36Dh8gaWwNzhuPCjTuxjHL
	v2cp5WNqZuC0iQkwxjAM8RIS62ysm/DIfmiG1kWEj6Yli328BXzV+y88Wh41h+bD
	aH4xwbOS2HYzBBqgrkmA5ozUGP2NyQkTHnVGPVAo7oPAi2ZKfUhVPBW2MYZQnM7P
	r7/JDVOYWCQl/Kxw4dFzjh7KpNF5/HEuyyPt6pT2NP3pvwfxksQMJM5P2ApEtPGl
	EAWeExNpu6tMzOTgBkVtOSUChwnGxUilv8Lj9eqB1QRUx9kNbUA9A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sc1j5xp9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 08:58:02 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M5bDNt015431;
	Thu, 22 May 2025 08:58:01 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnngp1n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 08:58:01 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54M8vvxG29884856
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 08:57:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A1F1520040;
	Thu, 22 May 2025 08:57:57 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 695D92004D;
	Thu, 22 May 2025 08:57:57 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.152.224.229])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 08:57:57 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, dengler@linux.ibm.com, ifranzki@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        fcallies@linux.ibm.com
Subject: [PATCH v11 6/6] crypto: testmgr - Enable phmac selftest
Date: Thu, 22 May 2025 10:57:55 +0200
Message-ID: <20250522085755.40732-7-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250522085755.40732-1-freude@linux.ibm.com>
References: <20250522085755.40732-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: XZB2oEIHWxcFwXKk4TWoilQTZX5MgaN4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDA4NiBTYWx0ZWRfX+Lbu04CiW79+ 4bg8o2tkvBD77Y3vSPdvIqG+UssDvM1IPKVIb2rIIqcBv4y36FVhgniMQhkLSri/Q4xQNTSrcVA Xw6+d4s0lM8D1t6tRcXuFRCWVpptVJwdXd4hNTxrFyrfAHNIQ8q3vHiwk4eZrJXxw30C/P1iAN2
 v5QkuRjnf1Iq9zVC9Llo6vEpmQyxuPcW6iGa0ULuU+nHjPrsU3jjqu97aqczGTRODpZQWgv+0lf C0APB0icw91JflDrWYxnPw3X+woSDmJFZPi11v9OQbc0HJbm1ZmfivQOyvzTfqEIbwHe1QbcZFm tdSGSikCGPizfxeqA7p16AO+E3mw7Trrr6KpMquIDAguo1Oz0WldC1pKV/rbYw8LHxsYqcLleZD
 //M2BaJ/v1By8m1ONPqhlTLz/RYEQjttk3cmN2EP3boBz+9S95doyfdIbLqPefT6LYPhpWt9
X-Authority-Analysis: v=2.4 cv=GpdC+l1C c=1 sm=1 tr=0 ts=682ee71a cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=ud-KSx1zIYYy2-pHJA4A:9
X-Proofpoint-GUID: XZB2oEIHWxcFwXKk4TWoilQTZX5MgaN4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 bulkscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505220086

Add phmac selftest invocation to the crypto testmanager.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 crypto/testmgr.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index abd609d4c8ef..243dbe8f02e3 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5385,6 +5385,36 @@ static const struct alg_test_desc alg_test_descs[] = {
 			.cipher = __VECS(fcrypt_pcbc_tv_template)
 		}
 	}, {
+#if IS_ENABLED(CONFIG_CRYPTO_PHMAC_S390)
+		.alg = "phmac(sha224)",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = __VECS(hmac_sha224_tv_template)
+		}
+	}, {
+		.alg = "phmac(sha256)",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = __VECS(hmac_sha256_tv_template)
+		}
+	}, {
+		.alg = "phmac(sha384)",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = __VECS(hmac_sha384_tv_template)
+		}
+	}, {
+		.alg = "phmac(sha512)",
+		.test = alg_test_hash,
+		.fips_allowed = 1,
+		.suite = {
+			.hash = __VECS(hmac_sha512_tv_template)
+		}
+	}, {
+#endif
 		.alg = "pkcs1(rsa,none)",
 		.test = alg_test_sig,
 		.suite = {
-- 
2.43.0

