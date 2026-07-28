Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8580B46A5FA;
	Tue, 28 Jul 2026 15:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785251072; cv=none; b=FnJIzSD1DF/XJ9t6k9bkCyI/i/GQ2w0HQCquY7aCYu8b4zPSyCPOah6PUK6qhdAWXJOEOMmQUo8qddSVkFcaY8d6AMOM838P848OskDuIv9EJDY5gUE/ZspHEPPtv5pmV6u89Ln4Wpv+sAgmc7RVlynjRDiggxxqCHWjseXdCA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785251072; c=relaxed/simple;
	bh=yb9Xcmeh8e+eZYpmvMOdBYnbjV+KLEbxmwzpjNRvpa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p8NALHkwQ7sjcqAjXPWWQzTGfL36KzRla0SL178qbBVmhxX7GUrZwDB/DbgqEEgGZDMY/4LDIIjk96Gfj54xnyfrMDlZagVfHpbAZSzrQ7M8O2YJfs0L/e6zs1L4kqXz9JNotKs8o5H7iAU9cCyIQ2NDCwET82PYxZlcArv7njg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qkz3rTcC; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qkz3rTcC"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SElgch1380153;
	Tue, 28 Jul 2026 15:04:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=9E1TLQNZxnid8pnyt
	59uUgIAQmffeBAIXW/c6KkUCjw=; b=qkz3rTcChidhHP78ei44kaDhw/jcdjX9x
	HhlyqYiVs8hBVK8121bjorGPuASnJ33fn6hcp2PrBeLCPoWQwzB6lsA8iWQ2s24u
	dskpAMeX0EEAwzVPHRjDxpqhbqwxqYgeMrJsgr0kie2ur8iJw891FNWPiPmR5jWg
	pOg7RNbhwipoc7gdTi1+UJXs38r7w1kAjEOubo4iTPgHFOwK8t8ilZcMRyzoGPnU
	1WYsuwz0TnAdtZ8aNtNn2+V1apDyDQVM2UYGPZw2oge7ZxDEi4dtYjDZGpL7uUAK
	iQDlcDsJOIRAxD8BclUnQnxb+dsawefPCy/ckvwFcR1C7fpU69Ecg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuyj59qn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 15:04:18 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66SEuFlD029088;
	Tue, 28 Jul 2026 15:04:17 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8fk2dg2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 15:04:17 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66SF4DvF35848700
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jul 2026 15:04:13 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 507AA20040;
	Tue, 28 Jul 2026 15:04:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D93D20043;
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
Subject: [PATCH v2 2/4] KVM: s390: Remove cond_resched() calls
Date: Tue, 28 Jul 2026 17:04:10 +0200
Message-ID: <20260728150412.3893933-3-hca@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDEzMiBTYWx0ZWRfXz57IeYNjOfc0
 G3Lc2AIs50T3pVs+6BzG726rSd0YXzgaN01WRYNKo/N2mqebCVuoShNUFw9N1rAuqYQyFnUXdzF
 Ydppw9ms3GqlinrIyd97HSI5BMWniSA=
X-Proofpoint-GUID: RSm6YV_cuVZ8s_YbuRvE0SZS8gK7wXWb
X-Proofpoint-ORIG-GUID: RSm6YV_cuVZ8s_YbuRvE0SZS8gK7wXWb
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDEzMiBTYWx0ZWRfX6rejKyxgWRlc
 Osbn/+yTkBI6offvmU/tRngB6n3SJpEuqKDSRWvlvW3Idu7PCsKPUhLsah08JxIMW1EtC5XMj8I
 nAPLw862CUs8JYkvbK8wHPff/vXKQkXbk3OjPpt8J2fEmTeTUgnfgNGQaS9QBCXrmeBUX5ZkgL3
 Z23gxOwT+XqhKwrLv7pk9TLv6vzsaArRYc8Wyusxgyj3hn9BJ8kDNOvGTIE91nxoaATJHbNJJbg
 D9Zby4P2dCJ6Pw5wF1z0dnHG1ccJHxCGWe80hrj9tqGFwTwKY5KB1ryv02tCZ7LFoNsLkzt7CH9
 PhW8Lz40Re6LpitkjN0oUq37LgPD0W/TQnWfeW49TxlS+At7rHh9eqwyb1PNJqWO6ero8pkWfvQ
 4W2jUgDVKdEKaNVkeQqhm1aGNMFmHOGojscA3/liweYKrP1QvYLXE7+9YhFqR+2TyRJd+nza5sX
 5wrTVc4Nh9iD6eDsT9Q==
X-Authority-Analysis: v=2.4 cv=X5Vi7mTe c=1 sm=1 tr=0 ts=6a68c4f2 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VnNF1IyMAAAA:8 a=cu7Gx01AU9FYDFtBg_UA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_04,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 impostorscore=0 lowpriorityscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607280132

Since [1] cond_resched() is a no-op on s390. Remove all calls.

[1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")

Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/uv.h  | 1 -
 arch/s390/kvm/gaccess.c     | 8 ++------
 arch/s390/kvm/gmap.c        | 4 ----
 arch/s390/kvm/kvm-s390.c    | 1 -
 arch/s390/kvm/pv.c          | 1 -
 arch/s390/kvm/vsie.c        | 1 -
 arch/s390/mm/gmap_helpers.c | 1 -
 7 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index d919e69662f5..795da130342a 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -461,7 +461,6 @@ static inline int uv_call_sched(unsigned long r1, unsigned long r2)
 
 	do {
 		cc = __uv_call(r1, r2);
-		cond_resched();
 	} while (cc > 1);
 	return cc;
 }
diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
index 36102b2727fb..0d389a302a70 100644
--- a/arch/s390/kvm/gaccess.c
+++ b/arch/s390/kvm/gaccess.c
@@ -151,10 +151,8 @@ static void ipte_lock_simple(struct kvm *kvm)
 	ic = &kvm->arch.sca->ipte_control;
 	old = READ_ONCE(*ic);
 	do {
-		if (old.k) {
-			cond_resched();
+		if (old.k)
 			goto retry;
-		}
 		new = old;
 		new.k = 1;
 	} while (!try_cmpxchg(&ic->val, &old.val, new.val));
@@ -189,10 +187,8 @@ static void ipte_lock_siif(struct kvm *kvm)
 	ic = &kvm->arch.sca->ipte_control;
 	old = READ_ONCE(*ic);
 	do {
-		if (old.kg) {
-			cond_resched();
+		if (old.kg)
 			goto retry;
-		}
 		new = old;
 		new.k = 1;
 		new.kh++;
diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
index 8abb4f55b306..3758e4009709 100644
--- a/arch/s390/kvm/gmap.c
+++ b/arch/s390/kvm/gmap.c
@@ -941,7 +941,6 @@ void gmap_split_huge_pages(struct gmap *gmap)
 		scoped_guard(read_lock, &gmap->kvm->mmu_lock)
 			start = _dat_walk_gfn_range(start, asce_end(gmap->asce), gmap->asce,
 						    &ops, DAT_WALK_IGN_HOLES, gmap);
-		cond_resched();
 	} while (start);
 }
 
@@ -963,7 +962,6 @@ static int _gmap_enable_skeys(struct gmap *gmap)
 	do {
 		scoped_guard(write_lock, &gmap->kvm->mmu_lock)
 			start = dat_reset_skeys(gmap->asce, start);
-		cond_resched();
 	} while (start);
 	return 0;
 }
@@ -1019,7 +1017,6 @@ int gmap_pv_destroy_range(struct gmap *gmap, gfn_t start, gfn_t end, bool interr
 						    DAT_WALK_IGN_HOLES, NULL);
 		if (interruptible && fatal_signal_pending(current))
 			return -EINTR;
-		cond_resched();
 	} while (start && start < end);
 	return 0;
 }
@@ -1138,7 +1135,6 @@ void _gmap_set_cmma_all(struct gmap *gmap, bool dirty)
 			gfn = _dat_walk_gfn_range(gfn, asce_end(gmap->asce), gmap->asce, &ops,
 						  DAT_WALK_IGN_HOLES,
 						  &gmap->kvm->arch.cmma_dirty_pages);
-		cond_resched();
 	} while (gfn);
 }
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 150b5dd2170e..2ede8f035a38 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -1027,7 +1027,6 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
 		do {
 			scoped_guard(read_lock, &kvm->mmu_lock)
 				start_gfn = dat_reset_cmma(kvm->arch.gmap->asce, start_gfn);
-			cond_resched();
 		} while (start_gfn);
 		ret = 0;
 		break;
diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
index 1beacc841ca8..935fe308a050 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -832,7 +832,6 @@ int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
 	while (offset < size) {
 		ret = unpack_one(kvm, addr, tweak, offset, rc, rrc);
 		if (ret == -EAGAIN) {
-			cond_resched();
 			if (fatal_signal_pending(current))
 				break;
 			continue;
diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
index eea24562e7db..6dcd3b110c17 100644
--- a/arch/s390/kvm/vsie.c
+++ b/arch/s390/kvm/vsie.c
@@ -1434,7 +1434,6 @@ static int vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
 		}
 		if (sg)
 			sg = gmap_put(sg);
-		cond_resched();
 	}
 	if (sg)
 		sg = gmap_put(sg);
diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
index 4bf7c9012feb..d564cdefb90f 100644
--- a/arch/s390/mm/gmap_helpers.c
+++ b/arch/s390/mm/gmap_helpers.c
@@ -272,7 +272,6 @@ static int __gmap_helper_unshare_zeropages(struct mm_struct *mm)
 		 * truncation. In that case, the shared zeropage would be gone
 		 * and we can simply retry and make progress.
 		 */
-		cond_resched();
 		goto retry;
 	}
 
-- 
2.53.0

