Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D09F23D7F0;
	Fri, 31 Jul 2026 16:50:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785516621; cv=none; b=X8i78PVA5ASlS21lUG5vMIr01PIhPVKraC7YnlrELQWLhdj/ydSMXeqkgHAh6LnhYhoxMnsgNxqony/gEBlIC+VbBcFmiZUq25myZQN4FFqHMTRtRGB47I25bnKgSHXsmSJvwzlmsB3yfIIdtDplkOESJEvapLkQn/L29IlyeaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785516621; c=relaxed/simple;
	bh=+48OdW2c+eMcu7qH9gjWRZnUcX90oCow45HZ5Uma/8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0ZDjmTVRNS0/pFEbv060H7j1nbqsAWdqdl92nrmdhHLRbL7+hX/Pt+z9Ofy8POcRJU+2G6b+cbL/T3B5IGpHbRkryqf8Iv3wfVq0SZYYpWcF0qEAFLqvQa6hvgtBSuPBDZ3/vwjPz1zFV7ZQZO/4ugMk/XLU4AMqvSW8BoLIDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IMb/w1CY; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IMb/w1CY"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VFlsEM402627;
	Fri, 31 Jul 2026 16:50:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=GsS/PcaiZHkSIqKAt
	n0OpAFt9rSX4OlSrapO6SOezxA=; b=IMb/w1CYyhHKxPnAWfdJTgT5+4+WjaNZH
	zMP866HxbW1oP0l3C2CcCOlSz5IEJy8al08wA2hn7GQ5gsmfFk21xEDvb+QauD2q
	3ynI+U1Y8Hn+IHyz1HJyJ/KWclD0Jw4sxTLHM6Zf1OyDYjTPPgmhfK+DTR4ZvJm1
	PHYJWU8G1tHlB5F0Si9WIj+h2ja9kZKGqAwi7l3e4aNXubDgmMJqiL2lNtn108bL
	/p8zswMVTaGQvtcBVwKP0oDoetqfwb+Gd6P4Z1JA0JO1ERnXTQpTURGLuXTn1wgl
	lL8h/2GnwkxgHy8wyrbKkWiTdOVl/ifbBOtsFL0gUead8tYXjL2sA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuycx1bw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 16:50:11 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66VGfNbd000455;
	Fri, 31 Jul 2026 16:50:10 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5ygfwk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 16:50:10 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66VGo63P45875616
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 16:50:06 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 00EA920040;
	Fri, 31 Jul 2026 16:50:06 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE2F72004B;
	Fri, 31 Jul 2026 16:50:05 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 31 Jul 2026 16:50:05 +0000 (GMT)
From: Heiko Carstens <hca@linux.ibm.com>
To: Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH v4 4/4] s390/cio: Remove cond_resched() calls
Date: Fri, 31 Jul 2026 18:50:04 +0200
Message-ID: <20260731165004.2758105-5-hca@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731165004.2758105-1-hca@linux.ibm.com>
References: <20260731165004.2758105-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: LybXybKLUth0mOxJgDxmIWx26iJTIbRS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEyOCBTYWx0ZWRfX6bmlGG4+qc/p
 lKr1t6aMhXCXaRYJEe5r4wVITX859DvFdB6S017vaLQMPWzIpv+1UhA95MFTQx7yn8E1AOKdH1h
 /6+seTBNTb3ONI7xkB0Oq9jHRXh1PMA4HAjRJtxwwPmGiT5MVfh/YPyUt7t8oEzImxTYWlTDrCn
 CBtXKIA7r6aZle0MDh8uqxEh5f9tULhNBjX1crn8IDHyAq7Q/eLtMBVYsLIKSWYGy1HyP6JPAIg
 A6XWoyhPcrbToNm4pNGS2c9QKZlYx+xzsmiAdbMzuN8JxrC21jPmhXZmTv716dPDxpmSctfwhkj
 IdJLZIStS7UgIodVyNUFnQ9Tn29NlNmvf3S3nxDvvUkeB7eFo2IF7zhxAkZAzSbGPSJekyID/z2
 JF+F0gNe+ezk89iUJ8oT5pnqBI8ttPbpVlLctXKYCiXErHyLmNHZyV6NGnlFW2KJLO+04Lgs5g8
 BNfmz6Ba5U/EePAjRyg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEyOCBTYWx0ZWRfXy7tO6DTI2rwe
 kLxIsbB2NXhZM47O1Y4UJS4rTclQJAwd4oezfDguvm0Mwuo7h9SfbR8aNObUzC+b9pDAlRC1nr5
 87vVJ38CXJwGkIYyQdoaB8CkcueM7B0=
X-Authority-Analysis: v=2.4 cv=AZeB2XXG c=1 sm=1 tr=0 ts=6a6cd243 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=yDFob_ultygKJmZAZNUA:9
 a=O8hF6Hzn-FEA:10
X-Proofpoint-GUID: LybXybKLUth0mOxJgDxmIWx26iJTIbRS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310128

Since [1] cond_resched() is a no-op on s390. Remove all calls.

[1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")

Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 drivers/s390/cio/css.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/s390/cio/css.c b/drivers/s390/cio/css.c
index e5a0ec6b4e3e..54b8b8639694 100644
--- a/drivers/s390/cio/css.c
+++ b/drivers/s390/cio/css.c
@@ -618,11 +618,6 @@ static int slow_eval_known_fn(struct subchannel *sch, void *data)
 		rc = css_evaluate_known_subchannel(sch, 1);
 		if (rc == -EAGAIN)
 			css_schedule_eval(sch->schid);
-		/*
-		 * The loop might take long time for platforms with lots of
-		 * known devices. Allow scheduling here.
-		 */
-		cond_resched();
 	}
 	return 0;
 }
@@ -654,9 +649,6 @@ static int slow_eval_unknown_fn(struct subchannel_id schid, void *data)
 		default:
 			rc = 0;
 		}
-		/* Allow scheduling here since the containing loop might
-		 * take a while.  */
-		cond_resched();
 	}
 	return rc;
 }
-- 
2.53.0

