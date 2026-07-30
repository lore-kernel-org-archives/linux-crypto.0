Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959F13E3D92;
	Thu, 30 Jul 2026 09:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785402866; cv=none; b=l3rTKfb9+4jp2k/So8WDjGzNjLe19H3xI4QeVNme7iTRvFrqjsIxdZsNm0WPtA4Iv8WvfF/uYyr6JqbVyx4OtuBaAlJuQNP1VpnrvebbYkj2/A8fG517auZcPVyn60UfgxRJWP+igPoDqIFBHJq8+T9pMNWfuBH3A8Bf0SQ3tIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785402866; c=relaxed/simple;
	bh=Y2s+FUoxf7rXsAXnyxX+KPShL6yCdNLQHV8XAGatcrM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lY6nYmwmNgi1eADXALoN86am/lOIatNTM5pQKKlxyWDL/om7QkdspuwHJRiBwE1iymcvEmwbomQIY1dbr0KavQzCm+PyFYYNQXtDYN2RJtIw/3vYcUACC8G+3gQKXWu2K1saHZc028KupwlPi1ws6+gaTn41SWuxHlXd+66LVOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QQQoxYGh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QQQoxYGh"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66U6m2bP2316588;
	Thu, 30 Jul 2026 09:14:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=W5wlSw
	YG2NyrYMN8amAngT2KfXZy+ehSDNB3XN3WQ04=; b=QQQoxYGh4vgHgOB9Pi80HM
	pLOJ2KflWlS9dunCk7my83XHvjM9Z3A4BBGjl0taioMug4Z+9jcBiTbBtGFzWJuo
	SM6kkG7pWjgqmsvrQrsH6k11HImn/gCWECnTD+OnMGU3V+imnmZVNDwN3YRSl8xk
	lowM58Rtr7EBWIo4SMQcNgMwBBIZkuEbN1mSjzLPRVmE9uys7zbhHzJL1wSOOMlt
	Lnwhy4Ra2myJp4vv0rk6jBRFeTZ3A5msAtyBqYAvn/fUBeSTYMoaWE5U774IA/zk
	Glrv0JHqxVWfUakSawgmal2Kz4LDgx8TDMJmgERynpfOU/s4peh2T5fIrAJ65/XA
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuwd640v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 09:14:13 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66U9BVId010218;
	Thu, 30 Jul 2026 09:14:13 GMT
Received: from smtprelay02.fra02v.mail.ibm.com ([9.218.2.226])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fna5yac5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 30 Jul 2026 09:14:13 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay02.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66U9E9Xk52887840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Jul 2026 09:14:09 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 845492004D;
	Thu, 30 Jul 2026 09:14:09 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4A05A20040;
	Thu, 30 Jul 2026 09:14:08 +0000 (GMT)
Received: from p-imbrenda (unknown [9.111.80.248])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with SMTP;
	Thu, 30 Jul 2026 09:14:08 +0000 (GMT)
Date: Thu, 30 Jul 2026 10:51:21 +0200
From: Claudio Imbrenda <imbrenda@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Harald Freudenberger
 <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Vineeth
 Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter
 <oberpar@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        David
 Hildenbrand <david@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v3 2/4] KVM: s390: Remove cond_resched() calls
Message-ID: <20260730105121.3dd5c400@p-imbrenda>
In-Reply-To: <20260730052907.2607026-3-hca@linux.ibm.com>
References: <20260730052907.2607026-1-hca@linux.ibm.com>
	<20260730052907.2607026-3-hca@linux.ibm.com>
Organization: IBM
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uGeCF_RT_7fgEu9JL2akTQK933OobWQ-
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzMwMDA2MyBTYWx0ZWRfXwr/aYuy3i5ve
 vikcAWZjSJev27ieTiDv2WEi3tpIOKyz//zTmv+H1WOIuEbBsqd4nX45hpABSx52O1XGS8H/uie
 g9BDt6aA3GdejG36qwISEXr9Iimvhd0=
X-Authority-Analysis: v=2.4 cv=E/z9Y6dl c=1 sm=1 tr=0 ts=6a6b15e6 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=RzCfie-kr_QcCd8fBx8p:22 a=VnNF1IyMAAAA:8
 a=ne4xOJbHfJve2HjgNyoA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzMwMDA2MyBTYWx0ZWRfX24NmTInUFNpv
 9COLkUrVuVKS44onZc/UKYlH/+YCn5Jg8Jp4gMNuN3mX1RHoRDODerbh2VNGg18pw4hYIOLzzWA
 M53a4KiSUwhInUZ9Ws5NXarDKaPN+DQCgtnDv2AODovdxEGlBE81l2OQjF/nIC2tKTDZFPXj3rf
 SrbyHtp7zpWzozlW0jxS2eiRXsYZZXx9bl4iyJIs1hzpJK0AEyyq7N3YzS7WG4+6o7by7ljXvZC
 RzggCQt2FIXah0JcpEgbcHDd0oh3EfiliKVgA6pDXzrWYmjBiolTi78E5P33IKDHiG/aX9Vuvnc
 Q2eboenap9HmvGEqrdp7qG22PnA1hDUmoGLx/JBsO3gKS//8QQ+74mAptbfG07HQTgPTYbMj4Oh
 EGQhSI3CpcR/iFghmAW5jgD0EiaBqIaXEMgT+/S5B8UwX7LJi1XdIJ4A8cVQus8yI9vgEBNr+yY
 jWxpdQBTUFQ2vjeFJRQ==
X-Proofpoint-GUID: uGeCF_RT_7fgEu9JL2akTQK933OobWQ-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-30_02,2026-07-29_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 spamscore=0 clxscore=1011 phishscore=0
 lowpriorityscore=0 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607300063

On Thu, 30 Jul 2026 07:29:05 +0200
Heiko Carstens <hca@linux.ibm.com> wrote:

> Since [1] cond_resched() is a no-op on s390. Remove all calls.
> 
> This also entirely removes uv_call_sched() and replaces all call sites
> with uv_call(), since both functions are identical after the removal
> of cond_resched().
> 
> [1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Reviewed-by: Claudio Imbrenda <imbrenda@linux.ibm.com>

> ---
>  arch/s390/include/asm/uv.h   | 16 ++--------------
>  arch/s390/kernel/uv.c        |  2 +-
>  arch/s390/kvm/gaccess.c      |  8 ++------
>  arch/s390/kvm/gmap.c         |  4 ----
>  arch/s390/kvm/kvm-s390.c     |  1 -
>  arch/s390/kvm/pv.c           | 11 +++++------
>  arch/s390/kvm/vsie.c         |  1 -
>  arch/s390/mm/gmap_helpers.c  |  1 -
>  drivers/s390/char/uvdevice.c |  6 +++---
>  9 files changed, 13 insertions(+), 37 deletions(-)
> 
> diff --git a/arch/s390/include/asm/uv.h b/arch/s390/include/asm/uv.h
> index d919e69662f5..89c9bb56c7e6 100644
> --- a/arch/s390/include/asm/uv.h
> +++ b/arch/s390/include/asm/uv.h
> @@ -454,18 +454,6 @@ static inline int uv_call(unsigned long r1, unsigned long r2)
>  	return cc;
>  }
>  
> -/* Low level uv_call that avoids stalls for long running busy conditions  */
> -static inline int uv_call_sched(unsigned long r1, unsigned long r2)
> -{
> -	int cc;
> -
> -	do {
> -		cc = __uv_call(r1, r2);
> -		cond_resched();
> -	} while (cc > 1);
> -	return cc;
> -}
> -
>  /*
>   * special variant of uv_call that only transports the cpu or guest
>   * handle and the command, like destroy or verify.
> @@ -480,7 +468,7 @@ static inline int uv_cmd_nodata(u64 handle, u16 cmd, u16 *rc, u16 *rrc)
>  	int cc;
>  
>  	WARN(!handle, "No handle provided to Ultravisor call cmd %x\n", cmd);
> -	cc = uv_call_sched(0, (u64)&uvcb);
> +	cc = uv_call(0, (u64)&uvcb);
>  	*rc = uvcb.header.rc;
>  	*rrc = uvcb.header.rrc;
>  	return cc ? -EINVAL : 0;
> @@ -518,7 +506,7 @@ static inline int uv_list_secrets(struct uv_secret_list *buf, u16 start_idx,
>  		.start_idx = start_idx,
>  		.list_addr = (u64)buf,
>  	};
> -	int cc = uv_call_sched(0, (u64)&uvcb);
> +	int cc = uv_call(0, (u64)&uvcb);
>  
>  	if (rc)
>  		*rc = uvcb.header.rc;
> diff --git a/arch/s390/kernel/uv.c b/arch/s390/kernel/uv.c
> index a284f98d9716..62841bb00a26 100644
> --- a/arch/s390/kernel/uv.c
> +++ b/arch/s390/kernel/uv.c
> @@ -831,7 +831,7 @@ int uv_retrieve_secret(u16 secret_idx, u8 *buf, size_t buf_size)
>  		.buf_size = buf_size,
>  	};
>  
> -	uv_call_sched(0, (u64)&uvcb);
> +	uv_call(0, (u64)&uvcb);
>  
>  	switch (uvcb.header.rc) {
>  	case UVC_RC_EXECUTED:
> diff --git a/arch/s390/kvm/gaccess.c b/arch/s390/kvm/gaccess.c
> index 36102b2727fb..0d389a302a70 100644
> --- a/arch/s390/kvm/gaccess.c
> +++ b/arch/s390/kvm/gaccess.c
> @@ -151,10 +151,8 @@ static void ipte_lock_simple(struct kvm *kvm)
>  	ic = &kvm->arch.sca->ipte_control;
>  	old = READ_ONCE(*ic);
>  	do {
> -		if (old.k) {
> -			cond_resched();
> +		if (old.k)
>  			goto retry;
> -		}
>  		new = old;
>  		new.k = 1;
>  	} while (!try_cmpxchg(&ic->val, &old.val, new.val));
> @@ -189,10 +187,8 @@ static void ipte_lock_siif(struct kvm *kvm)
>  	ic = &kvm->arch.sca->ipte_control;
>  	old = READ_ONCE(*ic);
>  	do {
> -		if (old.kg) {
> -			cond_resched();
> +		if (old.kg)
>  			goto retry;
> -		}
>  		new = old;
>  		new.k = 1;
>  		new.kh++;
> diff --git a/arch/s390/kvm/gmap.c b/arch/s390/kvm/gmap.c
> index 8abb4f55b306..3758e4009709 100644
> --- a/arch/s390/kvm/gmap.c
> +++ b/arch/s390/kvm/gmap.c
> @@ -941,7 +941,6 @@ void gmap_split_huge_pages(struct gmap *gmap)
>  		scoped_guard(read_lock, &gmap->kvm->mmu_lock)
>  			start = _dat_walk_gfn_range(start, asce_end(gmap->asce), gmap->asce,
>  						    &ops, DAT_WALK_IGN_HOLES, gmap);
> -		cond_resched();
>  	} while (start);
>  }
>  
> @@ -963,7 +962,6 @@ static int _gmap_enable_skeys(struct gmap *gmap)
>  	do {
>  		scoped_guard(write_lock, &gmap->kvm->mmu_lock)
>  			start = dat_reset_skeys(gmap->asce, start);
> -		cond_resched();
>  	} while (start);
>  	return 0;
>  }
> @@ -1019,7 +1017,6 @@ int gmap_pv_destroy_range(struct gmap *gmap, gfn_t start, gfn_t end, bool interr
>  						    DAT_WALK_IGN_HOLES, NULL);
>  		if (interruptible && fatal_signal_pending(current))
>  			return -EINTR;
> -		cond_resched();
>  	} while (start && start < end);
>  	return 0;
>  }
> @@ -1138,7 +1135,6 @@ void _gmap_set_cmma_all(struct gmap *gmap, bool dirty)
>  			gfn = _dat_walk_gfn_range(gfn, asce_end(gmap->asce), gmap->asce, &ops,
>  						  DAT_WALK_IGN_HOLES,
>  						  &gmap->kvm->arch.cmma_dirty_pages);
> -		cond_resched();
>  	} while (gfn);
>  }
>  
> diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
> index 150b5dd2170e..2ede8f035a38 100644
> --- a/arch/s390/kvm/kvm-s390.c
> +++ b/arch/s390/kvm/kvm-s390.c
> @@ -1027,7 +1027,6 @@ static int kvm_s390_set_mem_control(struct kvm *kvm, struct kvm_device_attr *att
>  		do {
>  			scoped_guard(read_lock, &kvm->mmu_lock)
>  				start_gfn = dat_reset_cmma(kvm->arch.gmap->asce, start_gfn);
> -			cond_resched();
>  		} while (start_gfn);
>  		ret = 0;
>  		break;
> diff --git a/arch/s390/kvm/pv.c b/arch/s390/kvm/pv.c
> index 1beacc841ca8..54c17ddb6b11 100644
> --- a/arch/s390/kvm/pv.c
> +++ b/arch/s390/kvm/pv.c
> @@ -429,7 +429,7 @@ static int kvm_s390_pv_deinit_vm_fast(struct kvm *kvm, u16 *rc, u16 *rrc)
>  	};
>  	int cc;
>  
> -	cc = uv_call_sched(0, (u64)&uvcb);
> +	cc = uv_call(0, (u64)&uvcb);
>  	if (rc)
>  		*rc = uvcb.header.rc;
>  	if (rrc)
> @@ -746,7 +746,7 @@ int kvm_s390_pv_init_vm(struct kvm *kvm, u16 *rc, u16 *rrc)
>  	}
>  	gmap_split_huge_pages(kvm->arch.gmap);
>  
> -	cc = uv_call_sched(0, (u64)&uvcb);
> +	cc = uv_call(0, (u64)&uvcb);
>  	*rc = uvcb.header.rc;
>  	*rrc = uvcb.header.rrc;
>  	KVM_UV_EVENT(kvm, 3, "PROTVIRT CREATE VM: handle %llx len %llx rc %x rrc %x flags %04x",
> @@ -832,7 +832,6 @@ int kvm_s390_pv_unpack(struct kvm *kvm, unsigned long addr, unsigned long size,
>  	while (offset < size) {
>  		ret = unpack_one(kvm, addr, tweak, offset, rc, rrc);
>  		if (ret == -EAGAIN) {
> -			cond_resched();
>  			if (fatal_signal_pending(current))
>  				break;
>  			continue;
> @@ -875,7 +874,7 @@ int kvm_s390_pv_dump_cpu(struct kvm_vcpu *vcpu, void *buff, u16 *rc, u16 *rrc)
>  	};
>  	int cc;
>  
> -	cc = uv_call_sched(0, (u64)&uvcb);
> +	cc = uv_call(0, (u64)&uvcb);
>  	*rc = uvcb.header.rc;
>  	*rrc = uvcb.header.rrc;
>  	return cc;
> @@ -959,7 +958,7 @@ int kvm_s390_pv_dump_stor_state(struct kvm *kvm, void __user *buff_user,
>  	/* We will loop until the user buffer is filled or an error occurs */
>  	do {
>  		/* Get 1MB worth of guest storage state data */
> -		cc = uv_call_sched(0, (u64)&uvcb);
> +		cc = uv_call(0, (u64)&uvcb);
>  
>  		/* All or nothing */
>  		if (cc) {
> @@ -1037,7 +1036,7 @@ int kvm_s390_pv_dump_complete(struct kvm *kvm, void __user *buff_user,
>  		return -ENOMEM;
>  	complete.dump_area_origin = (u64)compl_data;
>  
> -	ret = uv_call_sched(0, (u64)&complete);
> +	ret = uv_call(0, (u64)&complete);
>  	*rc = complete.header.rc;
>  	*rrc = complete.header.rrc;
>  	KVM_UV_EVENT(kvm, 3, "PROTVIRT DUMP COMPLETE: rc %x rrc %x",
> diff --git a/arch/s390/kvm/vsie.c b/arch/s390/kvm/vsie.c
> index eea24562e7db..6dcd3b110c17 100644
> --- a/arch/s390/kvm/vsie.c
> +++ b/arch/s390/kvm/vsie.c
> @@ -1434,7 +1434,6 @@ static int vsie_run(struct kvm_vcpu *vcpu, struct vsie_page *vsie_page)
>  		}
>  		if (sg)
>  			sg = gmap_put(sg);
> -		cond_resched();
>  	}
>  	if (sg)
>  		sg = gmap_put(sg);
> diff --git a/arch/s390/mm/gmap_helpers.c b/arch/s390/mm/gmap_helpers.c
> index 4bf7c9012feb..d564cdefb90f 100644
> --- a/arch/s390/mm/gmap_helpers.c
> +++ b/arch/s390/mm/gmap_helpers.c
> @@ -272,7 +272,6 @@ static int __gmap_helper_unshare_zeropages(struct mm_struct *mm)
>  		 * truncation. In that case, the shared zeropage would be gone
>  		 * and we can simply retry and make progress.
>  		 */
> -		cond_resched();
>  		goto retry;
>  	}
>  
> diff --git a/drivers/s390/char/uvdevice.c b/drivers/s390/char/uvdevice.c
> index e6a264c996ce..4d274a2ee84d 100644
> --- a/drivers/s390/char/uvdevice.c
> +++ b/drivers/s390/char/uvdevice.c
> @@ -224,7 +224,7 @@ static int uvio_attestation(struct uvio_ioctl_cb *uv_ioctl)
>  	if (ret)
>  		goto out;
>  
> -	uv_call_sched(0, (u64)uvcb_attest);
> +	uv_call(0, (u64)uvcb_attest);
>  
>  	uv_ioctl->uv_rc = uvcb_attest->header.rc;
>  	uv_ioctl->uv_rrc = uvcb_attest->header.rrc;
> @@ -291,7 +291,7 @@ static int uvio_add_secret(struct uvio_ioctl_cb *uv_ioctl)
>  
>  	ret = 0;
>  	uvcb.addr = (u64)asrcb;
> -	uv_call_sched(0, (u64)&uvcb);
> +	uv_call(0, (u64)&uvcb);
>  	uv_ioctl->uv_rc = uvcb.header.rc;
>  	uv_ioctl->uv_rrc = uvcb.header.rrc;
>  
> @@ -457,7 +457,7 @@ static int uvio_retr_secret(struct uvio_ioctl_cb *uv_ioctl)
>  
>  	uvcb.buf_addr = (u64)buf;
>  	uvcb.buf_size = buf_len;
> -	uv_call_sched(0, (u64)&uvcb);
> +	uv_call(0, (u64)&uvcb);
>  
>  	if (copy_to_user((__user void *)uv_ioctl->argument_addr, buf, buf_len))
>  		goto err;

