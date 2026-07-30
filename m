Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B10CE3B0591;
	Thu, 30 Jul 2026 05:29:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785389372; cv=none; b=fKJrGp73AVrykRAfEiW7pwhoQtXusSNOqfe8wkXSiU4v9K+jkwyIOozxjAn39aXnQHbuwFN5UwFWfT1ryMDMcv+HK0rYaCngvczGFWkrwt/mbqruvLi7K7uCyHH/FVPfqrIKuspT9anOkfwhn5lUpEBuJPop6rXcLAFSsF8OYo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785389372; c=relaxed/simple;
	bh=+48OdW2c+eMcu7qH9gjWRZnUcX90oCow45HZ5Uma/8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KdVfMHDhJJLZ4ch6jOc0THiJUu/EwLJvUKhrjO9/iMM644l7xWr3YbmJ5hl7AAJtS/tj8zu7A6tMgCcawf1STueIfTdl1dGHZITtsAo0mGNu76DaIxbmC/mMiaTdGPB0ahf7HKn+POrd2Gh/uIYHUdKeWW/P/ORQqdsCiXd7XxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RVMLSTev; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RVMLSTev"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U3lbAV037522;
	Thu, 30 Jul 2026 05:29:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=GsS/PcaiZHkSIqKAt
	n0OpAFt9rSX4OlSrapO6SOezxA=; b=RVMLSTev/6WJX4w+df3G8sJf8lznLSCzu
	y3vLDzKjD4ZrFyWIAAErv+s3sjeZ++egFJ1mnTBHuHBHkB6x/7Ta8aB7G9csDalW
	KUIpNTrUEldMBe9/ts/QusgqLkM9lSyFQMSL8ZeGKewlhcGajGxrqhTVJ1sSQw0N
	TG/emgyHih2CYRzvT1kFbnwVnuOS9ZaqEd3WZy94buKQk5wshz1uIpCT+u5kCQO1
	mLWwqYYnQcV/DR19WIZMOqOccCcr94HJe8wvb1jFDyOMyHqkIuQW1rH65MNiZYFy
	89Cre1EDIjGHPfCeCypeLStpvmZ6/m7nV6QFrfynL53+Tz99j8dsg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuycp379-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 05:29:14 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66U5QJNN005190;
	Thu, 30 Jul 2026 05:29:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8yhht4c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 05:29:12 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66U5T89426280218
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 05:29:08 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C6EF320040;
	Thu, 30 Jul 2026 05:29:08 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F9732004D;
	Thu, 30 Jul 2026 05:29:08 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 30 Jul 2026 05:29:08 +0000 (GMT)
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
Subject: [PATCH v3 4/4] s390/cio: Remove cond_resched() calls
Date: Thu, 30 Jul 2026 07:29:07 +0200
Message-ID: <20260730052907.2607026-5-hca@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730052907.2607026-1-hca@linux.ibm.com>
References: <20260730052907.2607026-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 8B7U-78mlGFTjwtsAt3a0tWbBIPUeUMA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAzMyBTYWx0ZWRfX+sAlQljUvAAw
 4I1/75GA5ZgrmHxSjzkZf5twRDRsDY/bN/W0rg0ft1MVcrtSxAWdmI8YR3Yt5aQ7d+xijqcJSCD
 66BfrsQeiz9wDsaLDnY55qTJ2PPB1MrcCiBxu9hf6KxQ6Bc3avvut2i6RA0m1uH7R/+RmF90dM6
 AKCeLXtX2bJ+cJRKNeGBzyUjjLGGJKzUW2iHvJBvZM/Hb6XnEYd8Gy4Zf9f9StpOjj+D1umnBN7
 UeXk8WUaY0aTiZOZMgO3GCoUxljIaKOGAjaHv6HBEALpJ/LfpfHG9Q5RXI+Xnu4CdrCsMkZFG9M
 sX9XgTRp+9f/WbVWoRHMzQYJSEdUn0soelOZe6F0NaX+CJBRU5TTO1ZP2FybiHlOYjtlX+fvtou
 2EBvtmr9uL9ONi6+HIcyeaVgqrp3A6ePmDCYnSmL9MGDjp59hra+hoMNl6jB5AJLyhCNO90Dz4R
 7csFJHEifkTthFNlkqA==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAzMyBTYWx0ZWRfXwcaopS+HXSiC
 Z5y07MsAwuQnyCbPK++Qe57I6t+uxvLhymmc1wm7Mx9HBa5ds4GDcSfGIvwV0ApYhg5Lv7VHBY4
 iBREfg374ihP8IKHp2dZdt3cp/CXvsk=
X-Authority-Analysis: v=2.4 cv=AZeB2XXG c=1 sm=1 tr=0 ts=6a6ae12a cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VnNF1IyMAAAA:8 a=yDFob_ultygKJmZAZNUA:9
 a=O8hF6Hzn-FEA:10
X-Proofpoint-GUID: 8B7U-78mlGFTjwtsAt3a0tWbBIPUeUMA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_01,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 phishscore=0 adultscore=0 impostorscore=0
 clxscore=1015 malwarescore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300033

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

