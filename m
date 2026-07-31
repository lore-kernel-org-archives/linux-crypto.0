Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDDB345EC9;
	Fri, 31 Jul 2026 16:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785516623; cv=none; b=dQJsI0yVLcep7q6u6JDITHqdbMLLWAP85m+8IKotEOJmaSzWjExgwYyVRBzb0usxwBM8A6o0SbYIuERubxyA4brQqBUo83DsCve7q2s+FnBbLWzUORTm5QS6husvHQqKlnspwkKQqDm3frTHSJbVBpXcCvY+ET6JXcsWdHY6udE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785516623; c=relaxed/simple;
	bh=W5JGjzJwpvcvrtpf3/h5RQS7lGYaEquEicrdWaSVLj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gPssNt6A4FI/BT7sZeLVj6mxV0UyIXuOursNa7liroB/nG1HulErEUW+NgtInBqgEASuhvcfCnGH2t4DBu230IbYWACKJgc5MTcyKj6IUBye+5uWnafh0yuWNyCmLk+7NgJJUKH8K2M+m+uvZzcz/mlEKB/zwDlO78C463MStCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=M6rlJVMl; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="M6rlJVMl"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66VFloaZ2194591;
	Fri, 31 Jul 2026 16:50:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=8+nM+Elweo7CYkzIH
	Eo80qokqh76XrP+BRCVTvP2L9E=; b=M6rlJVMludljIXcRrvYQKHuTWqHtiz9eT
	dg2bRXMNg7h136YCElbtdveve6PMgL9tl3cAaMDThvQHtJXye9MyfgysgnqrR3c+
	2MH2b+1BG22VwBVhT0fc5Dhq3RXFhIbuCwh2pot4muDj3wF5+OmQAEAuaP+Mla7z
	01GIZen+oGbtRe6hKNUbMKrH4Egl1WgabJRG7uftQDZQ4CNfLkA8cVssCMFOxOif
	a8Jl0vwwXWWD+Ij40sZp/4hQho8M4PkGy8BpES9FAOr5r3kSE7YAJxki2j4OXPde
	y/vciXxfHGlC3f48eU1dDUHIqNvN72dVTFlc2iEUCVbLZZ7GZF2BA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmv0p514s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 16:50:10 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66VGfPDC004522;
	Fri, 31 Jul 2026 16:50:09 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fn9pgrj6c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 31 Jul 2026 16:50:09 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66VGo5Ml41419246
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 31 Jul 2026 16:50:05 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 83C0A20040;
	Fri, 31 Jul 2026 16:50:05 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4D2092004B;
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
Subject: [PATCH v4 2/4] KVM: s390: Remove cond_resched() calls
Date: Fri, 31 Jul 2026 18:50:02 +0200
Message-ID: <20260731165004.2758105-3-hca@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMxMDEyOCBTYWx0ZWRfX9tytjl7q9EUP
 /+h0sxkl/4kmXzNuYrX+8PEaSiwTxxkWIM5IXwtCAHrSa1zsR9xlWOL8yFB06SRf0/KFTqd23qg
 BZ/TFNyeZUkxbz01b3g+bqbH+czrWQ8=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMxMDEyOCBTYWx0ZWRfX6UAMLlNusQjA
 8EXwnfUctxOstHdNNsfQKRc8l40Eg0UNkM0/A0bvKcTvxAw8zGsOq88LIPPbrj3mVfBuRbXz7lm
 Phry7M1dXMSpPyBUGjZWrAZ9sQOmaN+X/O+mBLd0LTCMvNtS5REW7c8W7HKL6qiSVI8dEv3HLsf
 C+pQJNtODYieP84nvCXwStlWKMnexAmUa96JNgX3T9nyCNdhtxE2ogNyFTAqFtXLuMuG1n/iCsO
 4fS2bQlRy8T0vY1f6l1pTeouRAb4qxI4t5VOl+ucaTG73ktDZZzlKx2pEBHKMGZtLo2cty/ZGVZ
 wNruQGAGL0BLpQFn5RkVoU3fXr7nV6T7nTRRkWqQhXXtT+melJHu37tVtwjKmEmnjF38Wvv1+0h
 4I0Pem+hmXopZi4Hq0bDm/tzaH3bKfUDQO2w5gNSMneUjpV75b+v3dvRYciqSIAhgUvFzUKyv1M
 cDpQP6z357O93vexrAw==
X-Authority-Analysis: v=2.4 cv=b5WCJNGx c=1 sm=1 tr=0 ts=6a6cd242 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=jYxMFs5z4BTu7tBNxzoA:9
X-Proofpoint-GUID: bV5a5nWCI-uUuNW88lYqKrHaCGXhBBHV
X-Proofpoint-ORIG-GUID: bV5a5nWCI-uUuNW88lYqKrHaCGXhBBHV
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-31_05,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 adultscore=0 malwarescore=0 impostorscore=0
 bulkscore=0 phishscore=0 suspectscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607310128

Since [1] cond_resched() is a no-op on s390. Remove all calls.

This also entirely removes uv_call_sched() and replaces all call sites
with uv_call(), since both functions are identical after the removal
of cond_resched().

[1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
---
 arch/s390/include/asm/uv.h   | 16 ++--------------
 arch/s390/kernel/uv.c        |  2 +-
 arch/s390/kvm/gaccess.c      |  8 ++------
 arch/s390/kvm/gmap.c         |  4 ----
 arch/s390/kvm/kvm-s390.c     |  1 -
 arch/s390/kvm/pv.c           | 11 +++++------
 arch/s390/kvm/vsie.c         |  1 -
 arch/s390/mm/gmap_helpers.c  |  1 -
 drivers/s390/char/uvdevice.c |  6 +++---
 9 files changed, 13 insertions(+), 37 deletions(-)

diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
index d919e69662f5..89c9bb56c7e6 100644
--- a/arch/s390/include/asm/uv.h
+++ b/arch/s390/include/asm/uv.h
@@ -454,18 +454,6 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
 	return cc;
 }
 
-/* Low level uv_call that avoids stalls for long running busy conditions  */
-static inline int uv_call_sched(unsigned long r1, unsigned long r2)
-{
-	int cc;
-
-	do {
-		cc = __uv_call(r1, r2);
-		cond_resched();
-	} while (cc > 1);
-	return cc;
-}
-
 /*
  * special variant of uv_call that only transports the cpu or guest
  * handle and the command, like destroy or verify.
@@ -480,7 +468,7 @@ static inline int uv_cmd_nodata(u64 handle, u16 cmd, u16 *rc, u16 *rrc)
 	int cc;
 
 	WARN(!handle, "No handle provided to Ultravisor call cmd %x\n", cmd);
-	cc = uv_call_sched(0, (u64)&uvcb);
+	cc = uv_call(0, (u64)&uvcb);
 	*rc = uvcb.header.rc;
 	*rrc = uvcb.header.rrc;
 	return cc ? -EINVAL : 0;
@@ -518,7 +506,7 @@ static inline int uv_list_secrets(struct uv_secret_list *buf, u16 start_idx,
 		.start_idx = start_idx,
 		.list_addr = (u64)buf,
 	};
-	int cc = uv_call_sched(0, (u64)&uvcb);
+	int cc = uv_call(0, (u64)&uvcb);
 
 	if (rc)
 		*rc = uvcb.header.rc;
diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
index a284f98d9716..62841bb00a26 100644
--- a/arch/s390/kernel/uv.c
+++ b/arch/s390/kernel/uv.c
@@ -831,7 +831,7 @@ int uv_retrieve_secret(u16 secret_idx, u8 *buf, size_t buf_size)
 		.buf_size = buf_size,
 	};
 
-	uv_call_sched(0, (u64)&uvcb);
+	uv_call(0, (u64)&uvcb);
 
 	switch (uvcb.header.rc) {
 	case UVC_RC_EXECUTED:
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
index 1beacc841ca8..54c17ddb6b11 100644
--- a/arch/s390/kvm/pv.c
+++ b/arch/s390/kvm/pv.c
@@ -429,7 +429,7 @@ static int kvm_s390_pv_deinit_vm_fast(struct kvm *kvm, u16 *rc, u16 *rrc)
 	};
 	int cc;
 
-	cc = uv_call_sched(0, (u64)&uvcb);
+	cc = uv_call(0, (u64)&uvcb);
 	if (rc)
 		*rc = uvcb.header.rc;
 	if (rrc)
@@ -746,7 +746,7 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
 	}
 	gmap_split_huge_pages(kvm->arch.gmap);
 
-	cc = uv_call_sched(0, (u64)&uvcb);
+	cc = uv_call(0, (u64)&uvcb);
 	*rc = uvcb.header.rc;
 	*rrc = uvcb.header.rrc;
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x flags %04x",
@@ -832,7 +832,6 @@ int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
 	while (offset < size) {
 		ret = unpack_one(kvm, addr, tweak, offset, rc, rrc);
 		if (ret == -EAGAIN) {
-			cond_resched();
 			if (fatal_signal_pending(current))
 				break;
 			continue;
@@ -875,7 +874,7 @@ int kvm_s390_pv_dump_cpu(struct kvm_vcpu *vcpu, void *buff, u16 *rc, u16 *rrc)
 	};
 	int cc;
 
-	cc = uv_call_sched(0, (u64)&uvcb);
+	cc = uv_call(0, (u64)&uvcb);
 	*rc = uvcb.header.rc;
 	*rrc = uvcb.header.rrc;
 	return cc;
@@ -959,7 +958,7 @@ int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user *buff_user,
 	/* We will loop until the user buffer is filled or an error occurs */
 	do {
 		/* Get 1MB worth of guest storage state data */
-		cc = uv_call_sched(0, (u64)&uvcb);
+		cc = uv_call(0, (u64)&uvcb);
 
 		/* All or nothing */
 		if (cc) {
@@ -1037,7 +1036,7 @@ int kvm_s390_pv_dump_complete(struct kvm *kvm, void __user *buff_user,
 		return -ENOMEM;
 	complete.dump_area_origin = (u64)compl_data;
 
-	ret = uv_call_sched(0, (u64)&complete);
+	ret = uv_call(0, (u64)&complete);
 	*rc = complete.header.rc;
 	*rrc = complete.header.rrc;
 	KVM_UV_EVENT(kvm, 3, "PROTVIRT DUMP COMPLETE: rc %x rrc %x",
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
 
diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
index e6a264c996ce..4d274a2ee84d 100644
--- a/drivers/s390/char/uvdevice.c
+++ b/drivers/s390/char/uvdevice.c
@@ -224,7 +224,7 @@ static int uvio_attestation(struct uvio_ioctl_cb *uv_ioctl)
 	if (ret)
 		goto out;
 
-	uv_call_sched(0, (u64)uvcb_attest);
+	uv_call(0, (u64)uvcb_attest);
 
 	uv_ioctl->uv_rc = uvcb_attest->header.rc;
 	uv_ioctl->uv_rrc = uvcb_attest->header.rrc;
@@ -291,7 +291,7 @@ static int uvio_add_secret(struct uvio_ioctl_cb *uv_ioctl)
 
 	ret = 0;
 	uvcb.addr = (u64)asrcb;
-	uv_call_sched(0, (u64)&uvcb);
+	uv_call(0, (u64)&uvcb);
 	uv_ioctl->uv_rc = uvcb.header.rc;
 	uv_ioctl->uv_rrc = uvcb.header.rrc;
 
@@ -457,7 +457,7 @@ static int uvio_retr_secret(struct uvio_ioctl_cb *uv_ioctl)
 
 	uvcb.buf_addr = (u64)buf;
 	uvcb.buf_size = buf_len;
-	uv_call_sched(0, (u64)&uvcb);
+	uv_call(0, (u64)&uvcb);
 
 	if (copy_to_user((__user void *)uv_ioctl->argument_addr, buf, buf_len))
 		goto err;
-- 
2.53.0

