Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FC6B442B03;
	Mon, 17 Aug 2026 14:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976223; cv=none; b=ffEBluzdbOSK3sK+BoZY5Uq+mdikKP6Z5UtRruc83dKseZS2GDSWDGVszAFQaHE2hcE+vGs9azcA7epEvy8TO7PjPYRUUSRDnjxArrNmrH7SFSWkVrPQCZPsqsT484PlxH9/drQncqkjvtSFlwD72jCQ8pjAqmOf01wb93FTXXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976223; c=relaxed/simple;
	bh=iccAUhJJQGY24bDoIpBSRRtiexT/+hxDHHgs3HsioKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUScvvp8lAjTUAW5fH1icJtb2Y9eDBOkJUPzNh2kIDezIISfERoRE7+esWtSUwSW899yoyD0oLdA8hAEcxrIntzJK1KWvntR6xnYfYCVK9s0hrgdy1CF7PXGPoPhMG59dlBNnZhNpQU630AOvmDwGyCG3CymXXuT+unodBkMpDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=S0aCOsun; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="S0aCOsun"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67HCVnPF1348389;
	Mon, 17 Aug 2026 14:17:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=gGoe6eNQ6IptscX7X
	57NYRHS1L70fTdd2A+/Gk0Uw+0=; b=S0aCOsunUmSBuFBKhKY45Ng+STuiDQrJ+
	TUin6exg+Je6cB1/oz3XK4KedFsYicb1iWZRMbSH1HwRStTyBAMoglqdvApoFyU1
	R5EhchJpD8CiR3VS11lZkkuUphSxWoODTJitmFyELC+lk0farhHZRvgYYA06IOzM
	k7xhXe+5DUrKckSWmDGWtgAo5rXbjcAYc4Mrw8ByZZ/f+rKTO5qtKuYIPs5xvgsS
	X4eGhE1qT6orTjlYz+CNMSxUkubjyIRpVMbjizzwbHPTp0+BLPAQB2dujOWQEKJ8
	DxoItxHG+SXp4/dqfeRo+TdBRG3Sqt6OoBuEs3Or3oRBWXLd3c7dg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4g2fm3jpug-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 14:17:00 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67HEBNeF023460;
	Mon, 17 Aug 2026 14:16:59 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4g33ejxbnh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 17 Aug 2026 14:16:59 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67HEGtY951184050
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 17 Aug 2026 14:16:55 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6771220043;
	Mon, 17 Aug 2026 14:16:55 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 460FA2004B;
	Mon, 17 Aug 2026 14:16:55 +0000 (GMT)
Received: from funtu2.ibm.com (unknown [9.111.162.247])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 17 Aug 2026 14:16:55 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: dengler@linux.ibm.com, fcallies@linux.ibm.com, ifranzki@linux.ibm.com
Cc: freude@linux.ibm.com, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        linux-crypto@vger.kernel.org
Subject: [PATCH v3 5/6] s390/crypto: Fix handling of EBUSY in PAES when req is pushed to crypto engine
Date: Mon, 17 Aug 2026 16:16:53 +0200
Message-ID: <20260817141654.77940-6-freude@linux.ibm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260817141654.77940-1-freude@linux.ibm.com>
References: <20260817141654.77940-1-freude@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GXv4riIi0LoxCdWZR1i6TIIe8EMnOniW
X-Proofpoint-ORIG-GUID: GXv4riIi0LoxCdWZR1i6TIIe8EMnOniW
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE3MDEwNyBTYWx0ZWRfX1ftRIDwABjRI
 6R3hQkW/I2LRG0uoX8GgRg81+nN0D4zQv5WNioDyGzJx3J7Hq5b3bNvRx3QBdzDBgERfRPgR8qe
 2BuEtDPN01gmRzM3PQNhvCO4vXEv3m8=
X-Authority-Analysis: v=2.4 cv=WtQb99fv c=1 sm=1 tr=0 ts=6a8317dc cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8
 a=YK5uc4L07YnpXEDg8LIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE3MDEwNyBTYWx0ZWRfX9hHY4/Ln5a+O
 VMrw4E9HId3LvMOd+8v3vePX6J2Snn5BHDG88L7Z4DxW9pTg7WFY7ZQuSoIUckDnLuVbosqpjrQ
 3LLKVq7o8dGN+VdlowTCiWxTnb2VXZ1iDGiaX7YjrNQ5Ry5HZaydDoI6LGOjsqj0tur14sB/3G8
 UAZX+tF7F1apx+m/DL2gV2MpjwoPTCn9JuoNfKXefrk1Bb5unuRM15L71aA70l505BiuNndcN7r
 Kbt6y50EppZNZV9ErSzCRlcalLpoon+j0liEhsJMrMNwtIkgZdGFrlXkSgzZ2CGmjg5ZubfqM2q
 whtfeinTdGD5EFZrTPbHCTZHT3wcbtRaOh6LNKQZDoacTxtjhwWCBVTIeWVTVfayVvV7VK229+d
 Pwk+u5BV74GHfDOtTZcmeOjLaUOPb5VC6GDErcemoHvQmfWhL0RBBg1+7ehlmjLA7UcKlN4ZYI3
 gJtjaG42T3mLzEdcaHQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-17_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 spamscore=0 malwarescore=0 suspectscore=0 phishscore=0
 lowpriorityscore=0 clxscore=1015 adultscore=0 priorityscore=1501
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608170107

When a request is transferred to the engine via
crypto_transfer_skcipher_request_to_engine() there are two return
codes signaling a successful transfer: EINPROGRESS and EBUSY. However
the correct handling of EBUSY was missing and has been added as a
return code indicating a successful transfer to the crypto engine.

Fixes: 6cd87cb5ef6c ("s390/crypto: Rework protected key AES for true asynch support")
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Cc: stable@vger.kernel.org # 6.16+
---
 arch/s390/crypto/paes_s390.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/s390/crypto/paes_s390.c b/arch/s390/crypto/paes_s390.c
index 03446bfac37f..1dd48f7a1bdf 100644
--- a/arch/s390/crypto/paes_s390.c
+++ b/arch/s390/crypto/paes_s390.c
@@ -494,6 +494,8 @@ static int ecb_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
+		if (rc == -EBUSY)
+			rc = -EINPROGRESS;
 		if (rc != -EINPROGRESS)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
@@ -763,6 +765,8 @@ static int cbc_paes_crypt(struct skcipher_request *req, unsigned long modifier)
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
+		if (rc == -EBUSY)
+			rc = -EINPROGRESS;
 		if (rc != -EINPROGRESS)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
@@ -1089,6 +1093,8 @@ static int ctr_paes_crypt(struct skcipher_request *req)
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
+		if (rc == -EBUSY)
+			rc = -EINPROGRESS;
 		if (rc != -EINPROGRESS)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
@@ -1529,6 +1535,8 @@ static inline int xts_paes_crypt(struct skcipher_request *req, unsigned long mod
 	if (rc == 0 || rc == -EKEYEXPIRED) {
 		atomic_inc(&ctx->via_engine_ctr);
 		rc = crypto_transfer_skcipher_request_to_engine(paes_crypto_engine, req);
+		if (rc == -EBUSY)
+			rc = -EINPROGRESS;
 		if (rc != -EINPROGRESS)
 			atomic_dec(&ctx->via_engine_ctr);
 	}
-- 
2.43.0

