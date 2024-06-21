Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188F116E87B
	for <linux-crypto@vger.kernel.org>; Fri, 21 Jun 2024 09:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718963711; cv=none; b=pBTXUkGuCfPf4oE5xQ91hsNhrE1ZStTtGG7QW35q7NREb8fub+OM5kNwWgXPUAg2wWI78KEErLNI8R1Z9+XSW7O6mW79oMtj9fej4xE+kOVM/Vxuo3yhaohucoBQyIk7XtGA5+NgCTiPWFQN/75Xvo2FSY3rzeEgBDY0THSsFEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718963711; c=relaxed/simple;
	bh=FRuL2CPseSc9s53BNy+jdPiX2tLQS0UYvphnvcO8/q0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=gYqKpL9hS8h0IG4Fv4xXsCxSfdQHWhu86Bzj3p99tFyJzqIB7y86zkHYiJnfSM/H0yj6pplfMYpDPOyo5PSCB4vcKsHbkC+V8JSOkpg7ZV6yUT7bturcB/Ro+bWV67yda4fAdulwsHaXGV+VBz9DbXUs8zFbxpeX1qroYZyALK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=B2cgrpCA; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="B2cgrpCA"
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45L8SbWn030750;
	Fri, 21 Jun 2024 09:55:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=mFDXiXubqHw1YP3nIbbakdFdK0
	nX3ryoOdDfA+9GwJk=; b=B2cgrpCA72GxS4mSN6DH86dzQNVpacSgq7vI15jcCh
	t7PSM5CKt5t5dYFg147pTo6POAUSMZQwnMYUq22CR7K92z98wrzkNWpcv1qbMDAh
	OUq4zUQ2sh+0z7PWdnri9ZzkbC+qXebaR+wZcMMtGNiBit9b8DBwiDICchVJp736
	IKCPmZFknIFnMLaB7uYR/XmhyvgDV5I39Iq+U4MQyn05WPjVQMic2yy6M0Deo18/
	YA6t0RKbR7GHPb5Y80voz2ZKN39SzZUH6VxUSqauY5JQM5uddPcYLrYTGxaInI1i
	JfveesNaMyPVY1Xmjs4iJ+qmbGPbbUYnCbgg7GUnxyEw==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3yw61sg5qf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Jun 2024 09:55:04 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 45L9LxYq030885;
	Fri, 21 Jun 2024 09:55:04 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3yvrssxf50-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 21 Jun 2024 09:55:04 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 45L9t0qT33161760
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Jun 2024 09:55:02 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4BD942004B;
	Fri, 21 Jun 2024 09:55:00 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1601320040;
	Fri, 21 Jun 2024 09:55:00 +0000 (GMT)
Received: from funtu2.fritz.box?044ibm.com (unknown [9.171.71.218])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 21 Jun 2024 09:55:00 +0000 (GMT)
From: Harald Freudenberger <freude@linux.ibm.com>
To: linux-crypto@vger.kernel.org
Cc: herbert@gondor.apana.org.au, dengler@linux.ibm.com, Jason@zx2c4.com
Subject: [PATCH] hwrng: core - Fix wrong quality calculation at hw rng registration
Date: Fri, 21 Jun 2024 11:54:59 +0200
Message-Id: <20240621095459.43622-1-freude@linux.ibm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: ab2EObRkaO9a6oMoLsPrLKurchizZbqG
X-Proofpoint-GUID: ab2EObRkaO9a6oMoLsPrLKurchizZbqG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-06-21_03,2024-06-20_04,2024-05-17_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 clxscore=1011
 suspectscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 malwarescore=0 bulkscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2406140001 definitions=main-2406210069

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

This patch simple takes into account that a quality field value
of 0 is to be treated as 1024 and then the decision about which
hw rng to use works as expected.

Tested on s390 with two hardware rng sources: crypto cards and
trng true random generator device driver.

Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>

Reported-by: Christian Rund <Christian.Rund@de.ibm.com>
Fixes: 16bdbae39428 ("hwrng: core - treat default_quality as a maximum and default to 1024")
---
 drivers/char/hw_random/core.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 4084df65c9fa..993b8a1f1d19 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -525,6 +525,7 @@ static int hwrng_fillfn(void *unused)
 
 int hwrng_register(struct hwrng *rng)
 {
+	unsigned short rng_quality, cur_quality;
 	int err = -EINVAL;
 	struct hwrng *tmp;
 
@@ -545,8 +546,14 @@ int hwrng_register(struct hwrng *rng)
 	complete(&rng->cleanup_done);
 	init_completion(&rng->dying);
 
+	/* Quality field not set in struct hwrng means 1024 */
+	rng_quality = rng->quality ? rng->quality : 1024;
+	cur_quality = current_rng ?
+		(current_rng->quality ? current_rng->quality : 1024) :
+		0;
+
 	if (!current_rng ||
-	    (!cur_rng_set_by_user && rng->quality > current_rng->quality)) {
+	    (!cur_rng_set_by_user && rng_quality > cur_quality)) {
 		/*
 		 * Set new rng as current as the new rng source
 		 * provides better entropy quality and was not
-- 
2.34.1

