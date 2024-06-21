Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CDA3AC0C
	for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 15:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718982159; cv=none; b=VfUptadrcDhswl7+HrspxAptpnPpL8TfhQN2vYTf8EcyDwZDToJ6nHbIpyYrlBAVitEqUmnPfTiU5RWMZCZ1E/2JTq8o5YjYYfKgMYvwGOHzUZapxxLXhU0ceHvPuLZmEEz0SoPvJNGoRiX7TSIF69ku5kcBVllJzZuLlVc6NmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718982159; c=relaxed/simple;
	bh=kgRz3m6y98Zh7VpRXd5JWymTRvCu8XPjgG3F5Uz0lmE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=k77RUggDeRoulTDV9kEKcdeHIEDQHj3weIMIrlBcUXCgVyZSsOf6AqRC8CGzrp3PwaJXMWvnDmVwdbgDbHXgRgF41lcvhGNArMIFX+7h9LmA+fN1biKKPy6rQnPA2XhyB5vhefkrqW4YMTcvr9hEkVp+LJiUujM3KLhMh0V3llk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Dg7iy6QE; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Dg7iy6QE"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45LER0Lu030974;
	Fri, 21 Jun 2024 15:02:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=6DS2PkJnNl2U21dcPET4PKM2PF
	HCgDprnDXENxMsXYE=; b=Dg7iy6QElMd/LII6HjUTiEsqslh0er3ez5UB59jr1Q
	VUT6cDF+YIfJ8vymGOGqj6/rF/U/gy2s0OtbSDje/ZqxXorM3ZkHXn+1Ky2P+Rkh
	JEQbepVReSj4ExKp8nNvpndt01bISWmYmUFoiLGSqlfWM41daRaQOluA3jH/ZmCU
	2agGJKmsaZKCi3j7C1XLYG4HyTU0qOJvmqCgW5Io0poFcTkrgiARh/wJ/uV4B4rd
	LDgwWM+GLy+qi5GKH/KSz2NZFuZmYxW2PvoTZXUpgNzwvOArglItnTh4aa1+mD1H
	McLpXq/+ys6r3BLKZvpfd1sqVUnRbYdjJIEv66Uyd54A==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ywb2mr3e4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Jun 2024 15:02:31 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45LCEUHx019974;
	Fri, 21 Jun 2024 15:02:30 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yvrquqsc4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Jun 2024 15:02:30 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45LF2Q3748955690
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 15:02:28 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1661720043;
	Fri, 21 Jun 2024 15:02:26 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CE0DA20040;
	Fri, 21 Jun 2024 15:02:25 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.71.218])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 21 Jun 2024 15:02:25 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, dengler@linux.ibm.com, Jason@zx2c4.com
Subject: [PATCH v2] hwrng: core - Fix wrong quality calculation at hw rng registration
Date: Fri, 21 Jun 2024 17:02:24 +0200
Message-Id: <20240621150224.53886-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: py8ViBti31lKotgZBXkchTT9EKhYzFSz
X-Proofpoint-ORIG-GUID: py8ViBti31lKotgZBXkchTT9EKhYzFSz
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-21_06,2024-06-21_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 clxscore=1015 mlxlogscore=999 impostorscore=0
 adultscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406210109

When there are rng sources registering at the hwrng core via
hwrng_register() a struct hwrng is delivered. There is a quality
field in there which is used to decide which of the registered
hw rng sources will be used by the hwrng core.

With commit 16bdbae39428 ("hwrng: core - treat default_quality as
a maximum and default to 1024") there came in a new default of
1024 in case this field is empty and all the known hw rng sources
at that time had been reworked to not fill this field and thus
use the default of 1024.

The code choosing the 'better' hw rng source during registration
of a new hw rng source has never been adapted to this and thus
used 0 if the hw rng implementation does not fill the quality field.
So when two rng sources register, one with 0 (meaning 1024) and
the other one with 999, the 999 hw rng will be chosen.

As the later invoked function hwrng_init() anyway adjusts the
quality field of the hw rng source, this adjustment is now done
during registration of this new hw rng source.

Tested on s390 with two hardware rng sources: crypto cards and
trng true random generator device driver.

Fixes: 16bdbae39428 ("hwrng: core - treat default_quality as a maximum and default to 1024")
Reported-by: Christian Rund <Christian.Rund@de.ibm.com>
Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
---
 drivers/char/hw_random/core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 4084df65c9fa..f6122a03ee37 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -161,7 +161,6 @@ static int hwrng_init(struct hwrng *rng)
 	reinit_completion(&rng->cleanup_done);
 
 skip_init:
-	rng->quality = min_t(u16, min_t(u16, default_quality, 1024), rng->quality ?: 1024);
 	current_quality = rng->quality; /* obsolete */
 
 	return 0;
@@ -545,6 +544,9 @@ int hwrng_register(struct hwrng *rng)
 	complete(&rng->cleanup_done);
 	init_completion(&rng->dying);
 
+	/* Adjust quality field to always have a proper value */
+	rng->quality = min_t(u16, min_t(u16, default_quality, 1024), rng->quality ?: 1024);
+
 	if (!current_rng ||
 	    (!cur_rng_set_by_user && rng->quality > current_rng->quality)) {
 		/*
-- 
2.34.1

