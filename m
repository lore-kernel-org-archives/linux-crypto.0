Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AF982E06DB;
	Tue, 17 Jun 2025 13:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167892; cv=none; b=T7tBYxkih3/CFa4PcP9jxHnRMQOXLQyVAFVyW3nwI5Ey9YON7jz1mE1xhKjt9vCokaQ9u3ltMOOU02TwgsxADbxQgxi2Z42t7LafruVA4ux+YN7QNmcCdSKJdYl63NLr+wsIWwsm8M96dhpjCqXPhmPKqq+fvZYMaoF9PUjNbls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167892; c=relaxed/simple;
	bh=pVkUkD7MNFdcuBQ69OW9O24KSZ7R9CAlgCDaCFMGaiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5LLTVSE6So1msSU+oD1Nf+KFy+qEwzhrjf0/nfxQIlpmfZmweTEQ40Ep+ZL6FIqWoAbawjQ2UgJhA/ZyJzkhMThjIOPR+/SOg8nrdJmAoPQWBwhvQm4OhpJtfp33Gutktdlp9VxhmFXjMHSjByCCnozvhY6Htrn53gqIWNXa4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sOlp29k5; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sOlp29k5"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55HDAkev022514;
	Tue, 17 Jun 2025 13:44:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=lLs7qzLT5eBhrmUy0
	7X7p3Yd+cd5B3wNISxpKQ/SSsk=; b=sOlp29k5G9kON0prUDaHXzk2bsZoaR2js
	KvMQWrRtlcQ7LHfx1OVoNU4XQGH5YFrwaSev326lMfIrC7eIvn0c6O+OujC1qwca
	WRbxDGVuryByR69i/h+Ga2R49KNBX7AHdFeHSGiSXE04Ii4AhoW9kqY5MP6fN9xv
	jOFFJIXvvwhyQmcNkbzzRrwLZBC1GatMnZjoieTvxvMGATgXW4HnPQj9VWGRvrA9
	gjpHsgSTF0g2Z3KbwEqlBulfFqeWCz3YDRGKyKZQNZf4Ksb4RPseWnoXos00kitr
	hfdrdjAE4Z4ge2pG//OHe3KxwO/OX6vXweOHyvnN8DcW0SwUOaXLQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4790s4gq7h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 13:44:48 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55HANEaO014275;
	Tue, 17 Jun 2025 13:44:47 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 479p42bcka-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Jun 2025 13:44:47 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55HDihg559048430
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Jun 2025 13:44:44 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D988820040;
	Tue, 17 Jun 2025 13:44:43 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8751A2004D;
	Tue, 17 Jun 2025 13:44:43 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.111.71.86])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Jun 2025 13:44:43 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        dengler@linux.ibm.com, ifranzki@linux.ibm.com, fcallies@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: [PATCH v12 6/6] crypto: testmgr - Enable phmac selftest
Date: Tue, 17 Jun 2025 15:44:40 +0200
Message-ID: <20250617134440.48000-7-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250617134440.48000-1-freude@linux.ibm.com>
References: <20250617134440.48000-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjE3MDEwNSBTYWx0ZWRfXwQWALA/eXfpD 2O1nbw8+EO2SkQk8A6tH82lZUi0SmTk308cqC1R0IQbrpPh4E6EN8ml71zHZiH8/Fdogv1qJ6HP JsDsvt/zesrs3oICGqj+uFsh8D+G5Sprr/Zt2ETMhf6J3emmRPubmW9SWfTS+uMZOkl/MNZbhVt
 DRJPUj+OIdKuzicmDHEtkAHYGnEsx7DZLvnTtjstEEjeadwxpudqeN5aYsUdBkYIysLGYggZVGR CayoiEqWXl98MJE+s9n26uiBskOD4exvFlxWgv44I+iAlpg8LiPDbi5qB1llyd7/voRkBZkv1zH Crqi7oyEJF4vxQgfi9n+1U54miRvR6c+cU5HPQRMP4f7lmPV5N82bYkS6REBDV0iqZCQVzJA7Bo
 gpQRfStDHEIdiO/+PmdtGYLXqJHI9otNiQ3GENxJH5/g3IMMwdi57YXi2XsfC0aMiPIBUsWB
X-Proofpoint-ORIG-GUID: QBZzufnEEy1fr1vNKXQi1slLfHgGULkr
X-Authority-Analysis: v=2.4 cv=Qc9mvtbv c=1 sm=1 tr=0 ts=68517150 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=6IFa9wvqVegA:10 a=VnNF1IyMAAAA:8 a=XBO_9mDnZf_6bpFOmuAA:9
X-Proofpoint-GUID: QBZzufnEEy1fr1vNKXQi1slLfHgGULkr
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-17_05,2025-06-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 spamscore=0 impostorscore=0 phishscore=0 mlxscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 bulkscore=0 mlxlogscore=999
 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506170105

Add phmac selftest invocation to the crypto testmanager.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Acked-by: Holger Dengler <dengler@linux.ibm.com>
---
 crypto/testmgr.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index a4ad939e03c9..b42112a208ff 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -5306,6 +5306,36 @@ static const struct alg_test_desc alg_test_descs[] = {
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

