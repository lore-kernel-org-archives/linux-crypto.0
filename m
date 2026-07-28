Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A815F46A605;
	Tue, 28 Jul 2026 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785251071; cv=none; b=ryn/v9rmm2kgz5Ay7lu+jXHJfpaOjPv7X+9wWJTVW9QCS0wtHyvnfUBkX88zGIuxgoPAEsnvSiyakCGSSLyYO8EBRta66Meru05YBENG3xoz0ADPXR985l8620dSUhhVWojPIDm9g68mvuM7L8DDCG2KezmcNo/TvH4YX4Ujq5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785251071; c=relaxed/simple;
	bh=+48OdW2c+eMcu7qH9gjWRZnUcX90oCow45HZ5Uma/8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eW8WYpbgi56zPDTGLIktODenBJi6XmBHXH8R8ejtIssuhLL56YiCfYhe6PMjcqVlv59bjrmd3grVnxIhVvg+NkPVMu0L5IwGcz+LSjAIt3hbYyfeNVEsiYdOwBgRsDtbvsKz4BKHohZDC+cWddGX3V2JtnL94y1uXNCrP1oukcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=DweI5B7K; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="DweI5B7K"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SElfsM1381160;
	Tue, 28 Jul 2026 15:04:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=GsS/PcaiZHkSIqKAt
	n0OpAFt9rSX4OlSrapO6SOezxA=; b=DweI5B7KBfAda9Int4XzTEv/UT+RcbumM
	TDzm7geq3f/2oQxZLmm6M7UZHmE9ZU+ypxAA2UiKYlkBOwKKHcsow8waK3kh/8nW
	USegVdJNfLXz6T6T7ac2/IQDbdJiumQ5nrfRuiPuewyU9ehUf3R0cX0te2R9pini
	Wb9DObIOD4/3beEm7XIY06/OTO/KN9yJgM03hWyLsYekpFXiv2x1fD55G2ggMpin
	JVoQWJRVJktAYB99IBTgZx7TT8lI1b5/O8WpqIvdTCm9ZegckGo4Qr159ynohuun
	5NBQVUhnfmg2bmICWUoBcXJwDY1SabfjGH0Pjrh9e6FBA0LJ0HfCg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0nn90w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 15:04:18 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66SEuFlE029088;
	Tue, 28 Jul 2026 15:04:17 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8fk2dg5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 15:04:17 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66SF4DBw51708346
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jul 2026 15:04:13 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C140820040;
	Tue, 28 Jul 2026 15:04:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89EC320043;
	Tue, 28 Jul 2026 15:04:13 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Jul 2026 15:04:13 +0000 (GMT)
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
Subject: [PATCH v2 4/4] s390/cio: Remove cond_resched() calls
Date: Tue, 28 Jul 2026 17:04:12 +0200
Message-ID: <20260728150412.3893933-5-hca@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260728150412.3893933-1-hca@linux.ibm.com>
References: <20260728150412.3893933-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDEzMiBTYWx0ZWRfX4KenkURZ/Hhh
 ndlfXOoCvo4vJM4XXYyy92Kx/OQtERI1SiZjzI4lkF2vymO/F9RpXVOivhbMVsoyj90hkpnNRxo
 pSbqmyi0YNHHAh8/NCMXr0W6XcdpDbA=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDEzMiBTYWx0ZWRfX0w9Y0UITFZxJ
 k+Yp0ntAet1LE5C8NwP1VvhJFqC/QfGVOgeANZ0y+IQ6HvbV4j/YQz5h6Xx6fPP9ugEZYla4TfQ
 U9Nq+Oz2yRaAtKn6Oh8sL4+Rvh/m088eXkUPEQFT02zv57KMd8LMBNma3ss83PtaGrj/XquD+Ey
 sfWUCHdVrkJnNatYXSlKB7T/NLCH2jBoTfmkUQuS9BaPFzG5hoQ9pbE00SYcLwu3EzQAXz+psQk
 YSEvD2ihcFsKnfuyoIeAOvHRsI2krg5/v3gAa3MEt+brAcx+O2vFgNqHjHP7P9xSXqZa40+FSRX
 kF0ez0Iggxz/OaIAzmXq4EJgt5Po/RO/yra74qTvjzIf8HpLQhj9MxnrLCxFPJD8pBDqmrKNQlh
 3o3Jda7IUReVaSffVJcyjZ7SdlaSH0IIDWkGF9l8Rt/qroUISB4TAxSkEydoG7T0GshpNGjHW1t
 euIeWsjUwtt7y5vitiw==
X-Authority-Analysis: v=2.4 cv=b5WCJNGx c=1 sm=1 tr=0 ts=6a68c4f2 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=yDFob_ultygKJmZAZNUA:9
 a=O8hF6Hzn-FEA:10
X-Proofpoint-GUID: AGWpykg8PSNvjfGKhiPVKLTw7N8DnrSD
X-Proofpoint-ORIG-GUID: AGWpykg8PSNvjfGKhiPVKLTw7N8DnrSD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_04,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607280132

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

