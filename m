Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7610E2857F9;
	Thu, 22 May 2025 08:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747904286; cv=none; b=RMQJp8TQmBHJI174f2PNgNAManLn5yuPtZvDVmKZexVLgc3EaniO3+d9Syoc+u4ajidq+Y4VR/6rv0WcA7CFF2KUNje3JgnJ8rNYLu/JsMWdnXdD261xkmAy/SNMe5H7IxTZ0vNzZqUq3a3vgIL2vxlZ+AvpsM0VIqef45rn8j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747904286; c=relaxed/simple;
	bh=oks+1g71DfCwKPu7ESO91EmXjH8MRQ6ztme3+e0LTWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vls4Y2HMN2F/H0f0pYb8hvys9lOBFf8YwXTUFDXO0tNnDS2Sm7fpCsG+yYzBU0KVUNP9r3EZTQivMgaGzSCykHDbRrWM51X3kDZiy3pNJPY657LzaHLlvjGvfqSvSFtktbD5ZiI2nf+r2TekTX3iyK3ZSOKu0guvZzz348quY08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WfRZtEgz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WfRZtEgz"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54LNrPhN006786;
	Thu, 22 May 2025 08:58:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=3Iue9DtcFiVBrZwuD
	lbsV4WcCMNNDw5DoWnuSY0aOPc=; b=WfRZtEgz0uIhYFvD9fmDAza+FIyG08TD3
	Rg4jtRNU78CWKCAPYNy6LsrH6RaBXa3WJwdzDrq8Kk+O78Y28VJWxEdbiROHwr1Y
	qpjNhQFS22JDQxBmcFJUvlWt9eA1kx4+Rjjy23L+XdsiqqZ/rwG8FFzjypFrR0ul
	KWCgJCCOmQZKB7Al4PFOQRirRiSFEU4tBbmsPpmX4tjSETSBYwgIsmfVjc64L0X8
	rbJuYdzjm5+P0/K7UPkBAPE7FvqOkVMmFRtS5uHCH+39BR0ci9O3ozU0k9oP0zCS
	iRAUsPS++Y44AORcIV1QfWIXHyNb5x5e7Pk8+FJevg5ucWBiN6qRg==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46sg234pr0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 08:58:01 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 54M5LSFm015449;
	Thu, 22 May 2025 08:58:00 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 46rwnngp1m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 22 May 2025 08:58:00 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 54M8vvSE28443130
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 22 May 2025 08:57:57 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14CF220040;
	Thu, 22 May 2025 08:57:57 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D34C12004D;
	Thu, 22 May 2025 08:57:56 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.152.224.229])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 22 May 2025 08:57:56 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: herbert@gondor.apana.org.au, dengler@linux.ibm.com, ifranzki@linux.ibm.com
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        fcallies@linux.ibm.com
Subject: [PATCH v11 4/6] crypto: api - Add crypto_tfm_alg_get_flags() helper inline function
Date: Thu, 22 May 2025 10:57:53 +0200
Message-ID: <20250522085755.40732-5-freude@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: 3Vm_Rp2J5s0B1pNZWqKGjeqiPZvcVI63
X-Authority-Analysis: v=2.4 cv=RPmzH5i+ c=1 sm=1 tr=0 ts=682ee719 cx=c_pps a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17 a=dt9VzEwgFbYA:10 a=VnNF1IyMAAAA:8 a=Uy-dqqhFIFetn_TNvKMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIyMDA4NiBTYWx0ZWRfXw/kusNAJ95Fn OZWD7VOtL6M/+s+2dZ/Iol4x+txSij6KxiWGMW3PepH0vcPNWJy0R7fQUblygbp19XS02JXkDS0 IWJ65x5J2yqOgomO1O6usto1i5t91jhCKyLwyYezZkyzWVasSOgI4wikjdk650LSqtiBEczSyqh
 Xy8OYA011XPGR68wnSEdGdVB9EFUozJQyYXX9uj42zDI3Ny+hjMctnRfRF3rtc+kWg/YsdU59u4 lGoclBtXetFkW09ZWM6WX+T8Lnei5b3k5OhZrYIhAfvrqjxxGp/9K7FInTYjHiOqdQA+YHwCA+c lxeQu9c+ND1kAEtugr7/zoVeliEk1asdRD0zQIQVi61czpzKGMANZ7xqipLAJCsNal3FdUKPJu1
 sgL4zBvix5iGR80LpuFRvSkBJ0t4Np4tA99MiQbbPbZ7QP8JLhZIIP5Bnndqr1ToFv1WvYWy
X-Proofpoint-GUID: 3Vm_Rp2J5s0B1pNZWqKGjeqiPZvcVI63
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-22_04,2025-05-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015
 lowpriorityscore=0 impostorscore=0 adultscore=0 priorityscore=1501
 bulkscore=0 phishscore=0 mlxscore=0 malwarescore=0 spamscore=0
 mlxlogscore=655 suspectscore=0 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505160000 definitions=main-2505220086

Add a little helper inline function
    crypto_tfm_alg_get_flags()
to the crypto.h header file to retrieve the alg flags.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 include/linux/crypto.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 1e3809d28abd..a00047a53690 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -452,6 +452,11 @@ static inline unsigned int crypto_tfm_alg_alignmask(struct crypto_tfm *tfm)
 	return tfm->__crt_alg->cra_alignmask;
 }
 
+static inline u32 crypto_tfm_alg_get_flags(struct crypto_tfm *tfm)
+{
+	return tfm->__crt_alg->cra_flags;
+}
+
 static inline u32 crypto_tfm_get_flags(struct crypto_tfm *tfm)
 {
 	return tfm->crt_flags;
-- 
2.43.0

