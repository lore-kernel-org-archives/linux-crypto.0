Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9495C30D3E8;
	Thu, 30 Jul 2026 05:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785389364; cv=none; b=oXy/5e3zKbBoJlKOZ1ql/jUZRTsg4OW4a1vyjUPGWFGC+U2uUEPCvwomGGpt0vnNK8Bthq11+mArwKjZ0K1atfZwo8jnzco1JDdFBXCBzfSeEGrkWzxlhZbdxlGLn5HELTRSpiIRgJM6KvpHoAy1PORgekZK1T4yC9B8UqsxCUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785389364; c=relaxed/simple;
	bh=JbdAVIH/V+dcCTmGJRfR0JMfgH2g71CKT+aRIBUVV0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gol/iU4Wvc+dp4kEbqcrkkCtGElVBy6VVmXaYVRVawKy35IzA3nv9/xtgnMlyA8X1U5KqK1/EoPaqS8/mMI/cfbU1Hmwi8dfqBAsp/ePMEpXjkGOjLOVLVdJCAiHe9bqipPdas4lpOZj+jT8J7ub/qb/xl+1VKJPVszKXQg5uvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JQ7XMXYR; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JQ7XMXYR"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U3mMQd1949572;
	Thu, 30 Jul 2026 05:29:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=tLbSk8vuz1zJt2j8B
	Iy4h/R21/y96gtErWLfHBvXfKs=; b=JQ7XMXYRv1JdNKxQqlIV+GAHqJzT1xfoE
	sR6NSkL0RDXj7VChq/KmHHvUc5f0ABIT+OKJXj6MO5GJB8xxZMb+FqYFNu4nYLj6
	UODJScG+nEG3Vw1+271FNIssC3H1SHMtbH/UlLZYLl+MYGVUHa/kRRTmfkmkSTIw
	f537VIMru0Iai0/69QQbipDB64n4DMNNZ2389Qui7iVr0Ntj6rbfMuuwem9CVE0L
	P+LjFBW7YbF+DZO+khrOFKHAEGPERrKte8ibkniJEbhmATrEuQQSviw6y0frXel+
	l6e6SFvFTX4FqDjfwzaTBxgkA9FChwdE5xzlwKosQCyCejJ6KKZzQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuwd5aqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 05:29:13 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66U5Qirb005750;
	Thu, 30 Jul 2026 05:29:12 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5y9mj6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 05:29:12 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66U5T8rh26280210
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 05:29:08 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8B96620040;
	Thu, 30 Jul 2026 05:29:08 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5D4172004B;
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
Subject: [PATCH v3 3/4] s390: Remove cond_resched() calls
Date: Thu, 30 Jul 2026 07:29:06 +0200
Message-ID: <20260730052907.2607026-4-hca@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: VGudwtD4UDClgJ92jE8VQpm8EyKh54Zs
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDAzMyBTYWx0ZWRfXzdi6Z7lP0mCb
 ggfv3ZS1Bf103sq01ewMyoW/K9oRFa9gZV2jSVxRoDPG76n4QPC3UbtqNwEugCIBe+wSdOQlTD8
 2OazV1OGio92Y1fnf4xfX8aVgkHm5lU=
X-Authority-Analysis: v=2.4 cv=E/z9Y6dl c=1 sm=1 tr=0 ts=6a6ae129 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8 a=rF5c3LEHrUaPZy42MJMA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDAzMyBTYWx0ZWRfX+220TOtVUQjq
 JNRVdSKpNVHcSINpb+lkT5ptpvZPintF++1U/kkUILhHQb8QmjQEdP4tE+PH+aMd6TA79UB6++P
 PI+cKYOMpK/mZIq2ms84XIV3ll4IMvV5UjqpL4lleUJuQMWyUHhvOc+DfoMYD8QYmf9yE8PVR+F
 KMfH6Zp8Hdu6Qq/KMY7Jkrv6jr7WuvPACt3fjljPOJ4gTkWvhHCDu2YGEV0IPBVVZigGe1UmnLt
 7F1jBEVLiBXXzyET5gTJHKxu7aFOldsgVz5yS5xDXa4SfuQOYzRFXBASXJJFXma28G/bgR64xcj
 +EfoRbHBdA8o06eQtRwmokOAqkSih9vYEXNYEJbZW1ofqr+ZzOtBtcSl334SZCZRNrybFxhwgpE
 4GaMBqSSr8kGMbPmUXVVdRF1kGJdHBbPYBDtOcxHIkW4TS4F2MkXwNTNyMHIZx3i1dnUKhzh8JF
 PyKQM2aqAdX1gUNehug==
X-Proofpoint-GUID: VGudwtD4UDClgJ92jE8VQpm8EyKh54Zs
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_01,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1015 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300033

Since [1] cond_resched() is a no-op on s390. Remove all calls.

[1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/kernel/perf_cpum_cf.c | 1 -
 arch/s390/mm/cmm.c              | 2 --
 arch/s390/mm/pageattr.c         | 5 -----
 arch/s390/mm/pgalloc.c          | 1 -
 arch/s390/pci/pci.c             | 4 +---
 5 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/arch/s390/kernel/perf_cpum_cf.c b/arch/s390/kernel/perf_cpum_cf.c
index 2076ac22e2c4..5f2596be6c1e 100644
--- a/arch/s390/kernel/perf_cpum_cf.c
+++ b/arch/s390/kernel/perf_cpum_cf.c
@@ -1496,7 +1496,6 @@ static int cfset_all_copy(unsigned long arg, cpumask_t *mask)
 			goto out;
 		}
 		uptr += sizeof(struct s390_ctrset_cpudata) + cpuhw->used;
-		cond_resched();
 	}
 	cpus = cpumask_weight(mask);
 	if (put_user(cpus, &ctrset_read->no_cpus))
diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index eb7ef63fab1e..d342b68ee9be 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -95,7 +95,6 @@ static long cmm_alloc_pages(long nr, long *counter,
 		(*counter)++;
 		spin_unlock(&cmm_lock);
 		nr--;
-		cond_resched();
 	}
 	return nr;
 }
@@ -134,7 +133,6 @@ static long cmm_free_pages(long nr, long *counter, struct cmm_page_array **list)
 		inc = __cmm_free_pages(inc, counter, list);
 		if (inc)
 			break;
-		cond_resched();
 	}
 	return nr + inc;
 }
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
index e6f788696dd1..1e202e3d08e7 100644
--- a/arch/s390/mm/pageattr.c
+++ b/arch/s390/mm/pageattr.c
@@ -105,7 +105,6 @@ static int walk_pte_level(pmd_t *pmdp, unsigned long addr, unsigned long end,
 		pgt_set((unsigned long *)ptep, pte_val(new), addr, CRDTE_DTT_PAGE);
 		ptep++;
 		addr += PAGE_SIZE;
-		cond_resched();
 	} while (addr < end);
 	return 0;
 }
@@ -194,7 +193,6 @@ static int walk_pmd_level(pud_t *pudp, unsigned long addr, unsigned long end,
 		}
 		pmdp++;
 		addr = next;
-		cond_resched();
 	} while (addr < end);
 	return rc;
 }
@@ -281,7 +279,6 @@ static int walk_pud_level(p4d_t *p4d, unsigned long addr, unsigned long end,
 		}
 		pudp++;
 		addr = next;
-		cond_resched();
 	} while (addr < end && !rc);
 	return rc;
 }
@@ -301,7 +298,6 @@ static int walk_p4d_level(pgd_t *pgd, unsigned long addr, unsigned long end,
 		rc = walk_pud_level(p4dp, addr, next, flags);
 		p4dp++;
 		addr = next;
-		cond_resched();
 	} while (addr < end && !rc);
 	return rc;
 }
@@ -323,7 +319,6 @@ static int change_page_attr(unsigned long addr, unsigned long end,
 		rc = walk_p4d_level(pgdp, addr, next, flags);
 		if (rc)
 			break;
-		cond_resched();
 	} while (pgdp++, addr = next, addr < end && !rc);
 	return rc;
 }
diff --git a/arch/s390/mm/pgalloc.c b/arch/s390/mm/pgalloc.c
index 7ac44543e051..9610770fcf6d 100644
--- a/arch/s390/mm/pgalloc.c
+++ b/arch/s390/mm/pgalloc.c
@@ -268,7 +268,6 @@ static int base_segment_walk(unsigned long *origin, unsigned long addr,
 			return rc;
 		if (!alloc)
 			base_pgt_free(table);
-		cond_resched();
 	} while (ste++, addr = next, addr < end);
 	return 0;
 }
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index 39bd2adfc240..2dec238f3f12 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -1173,10 +1173,8 @@ int zpci_scan_devices(void)
 		return rc;
 
 	zpci_add_devices(&scan_list);
-	zpci_bus_for_each(zbus) {
+	zpci_bus_for_each(zbus)
 		zpci_bus_scan_bus(zbus);
-		cond_resched();
-	}
 	return 0;
 }
 
-- 
2.53.0

