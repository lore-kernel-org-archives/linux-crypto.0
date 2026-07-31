Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3594819DF62;
	Fri, 31 Jul 2026 16:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785516623; cv=none; b=ObTr7vt5j9C1cVEJHwPS6ZfhBg7XMmwx4/sqcgCSTQwTjus89aG1PKN1wQwYBhH4AU5/V0K9J8NHO1MWcCoM9+ANpTM3y2SqhFb/2WKxkDdJ2IDk2TkK+T1TkHzk11yKZsrh1LT8nAir8ZObAtRyHji2GLGGOWwlAN3mjxMUYao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785516623; c=relaxed/simple;
	bh=JbdAVIH/V+dcCTmGJRfR0JMfgH2g71CKT+aRIBUVV0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LByOO8xnBYupw2Hzb9PxdQV5KbxjJJLPUJRMYSMsfJTUK1KgdTr08qJrrq+GiiHOQsMhaAB93FmYL+wlltIZze4niOXUCC6/D7LAZ35a3AlnwBAnFNSbVfdgCKzdxFajYLuGrex/id43dWDuAnt11Q3jVGGWgQl3nwM2ZctFKcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eFfG8lED; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eFfG8lED"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VFm0J02193162;
	Fri, 31 Jul 2026 16:50:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=tLbSk8vuz1zJt2j8B
	Iy4h/R21/y96gtErWLfHBvXfKs=; b=eFfG8lED4LAkeiooPSeEe+ReELNNUjuZY
	ii0wPIpnKStKZOi9UI4zDLfXPvIIKfT9EZr9irQRZ0j38sK+HnSnbFAkE4a3//tc
	eHvnON8ae/7PIQTh+vq5mAmqioNeZnnfETOEd+IWYii5aEQNSX2ZNLgYCvItZrjQ
	RHTS4plKANHdmO/vbHRSxmTIlG6BFQa7djWXI1enr6bbx1Wl06Jq2r76jbTcjin8
	vzZQ+JuQdXgE2MYiz392O1sXA4hETRxG3LUuw8HYYoRAJermuPGwP6vWtwAUHf4P
	tZe4QGz5rvphSxOMECk8f2fl0xfFFkc+qG66+JKXqZYkutW/hKgmQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyjn1y8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 16:50:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66VGfNqJ000465;
	Fri, 31 Jul 2026 16:50:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5ygfwh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 16:50:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66VGo5hH50200908
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 16:50:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B97D420040;
	Fri, 31 Jul 2026 16:50:05 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8863620043;
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
Subject: [PATCH v4 3/4] s390: Remove cond_resched() calls
Date: Fri, 31 Jul 2026 18:50:03 +0200
Message-ID: <20260731165004.2758105-4-hca@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEyOCBTYWx0ZWRfX/IQLodZq2p/B
 WYkTCanc8oik67wClWhbNxS5TA8CyLjHq6b5R5zD1q37FjSgsDKaHlDQcVnh2qGHrgYPz7jk7fO
 UGLnbbvGG2di26dnfMQDnLN8Ow36U3o=
X-Proofpoint-GUID: EmnMLjP07Lbq0G3a9vF0QKvRt9vn8cTe
X-Proofpoint-ORIG-GUID: EmnMLjP07Lbq0G3a9vF0QKvRt9vn8cTe
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEyOCBTYWx0ZWRfX0yLfq8wcpRMw
 oIYN7ZehrlveFzEVDMcqKloBXeR9rWaAyPfMGqfzp25Wkmh/FGt708FjGCh5iiKneTQEicngGzw
 U5vpSOl82QpGDak1Ap46QODmrn5mHtit7WA9YLFW49QtDv5gStHb9bbb+wrRLnO5KHl8wSgc427
 aY4BimEFEELK5E6VMzNkxfgtIOT9++3zuPsl6+u7XTXXLcSbTBaCh0D+sZCx9qxoTaOsc/TZ7+M
 S9WM+/0KgyANK4loc5gwviBoFgQhaw5QKtPQsIMduZQIAbkwBzShGqNOQY0fnIuo53YdpWgg3z2
 0FGJ6yJe2iPn/EwAP/j4A96YSPum3idhN4FjZt0CTGeEZVNt/D9oLqoXVfaOi+ixyuZmaFWD3sw
 ja/15uKQrA0GuvYDe/389H0itpCXv5Qu4nn06N3mOB7EKDKLsfEq7oJQXqtQccguxuOfgYOQ+0D
 27ObH6TCqj6/5dsk50Q==
X-Authority-Analysis: v=2.4 cv=X5Vi7mTe c=1 sm=1 tr=0 ts=6a6cd242 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=rF5c3LEHrUaPZy42MJMA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607310128

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

