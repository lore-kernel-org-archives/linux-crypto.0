Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010504028EE;
	Mon,  3 Aug 2026 11:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785757113; cv=none; b=f1t1i5r61WmND6GVxXt4ZmmGQvfKRF7bEGYQqqOJejJcU7OXN8QXpnzELQVGAg+0iUu03Nd8Q8IVrQgU0olpdrCzSzBXR/Np5oJAGxzjQYOkOYHGt41ruO0JV0/Sz2PsP8t8+JcvXkQKAsjprXk6VrEH0dBctnx1P8pS1nyqy5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785757113; c=relaxed/simple;
	bh=GY5YWYQyJy3BbgXwU8pSx/yzP24RBD0kX2M3BbVvyDM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jRA9LtewiD0xCAOc6yAqN9z3m/QNnjU2Q/TTqCj7Ww4381vQMMDkudR6CcPFZdw/ZtgRKTG2J5pVVLLsZmxoXW9Ss+PSap0+c4WfJ4Aj6+WCtJW1XpXuNJI5Ux4rcxGoX8kbHiL/QG6E+BYfEgMJ+AVkx+58D7QXYvh7xNFLVOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Pr2hQiZz; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Pr2hQiZz"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 672LlepU159787;
	Mon, 3 Aug 2026 11:38:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=xRAawKgKKSyq+gqpRznkn/pNIqLhVh
	nWgH2UQbsXDYU=; b=Pr2hQiZzBTemNLIglGDlrlS6SqPjpmHkotm7o3SPkFpI/w
	7twQDyNvGeOJNOSxEgHNhw+Jcv7Mb4NNNhEN8SPwcU2KZ6Bg3719b4sPh+lhB68J
	PDdVGR/hThZq/RO4ioI0A2KZCmUt9OQKNuLsuUiRVru/NjaIC2ZJeHR24I/NyROZ
	tBJGX4UJI5IFxTtiM4DWfjwj4+0oJKtgYjhTYRKw14y5SVKWewqnkex240EvVGll
	YeQObuYLEVq84sHduBwTDR/gvyoQpStZsFVmkEzj4lSBIwhy0siW0YQjuqrQo3C+
	GWKS7W6QeQBUSZ3S3ZGd4bSvoxiactUAr+n4temg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs67hgewm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 11:38:23 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 673BBIxu019454;
	Mon, 3 Aug 2026 11:38:22 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsvmh539m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 03 Aug 2026 11:38:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 673BcIhL14614932
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 3 Aug 2026 11:38:18 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 999EF2004B;
	Mon,  3 Aug 2026 11:38:18 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 213AC20043;
	Mon,  3 Aug 2026 11:38:18 +0000 (GMT)
Received: from localhost (unknown [9.87.133.185])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon,  3 Aug 2026 11:38:18 +0000 (GMT)
Date: Mon, 3 Aug 2026 13:38:16 +0200
From: Vasily Gorbik <gor@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter Oberparleiter <oberpar@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David Hildenbrand <david@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v4 0/4] s390: Remove or replace cond_resched() calls
Message-ID: <ttj6yzs@ub.hpns>
References: <20260731165004.2758105-1-hca@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260731165004.2758105-1-hca@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAzMDEwMSBTYWx0ZWRfX2J38FIiYHVl9
 uvon9kaxXgf3di8/mkVK+iUfr5NdAMT1jmp1NdZxb54skoLQKhckLo0r6mpaMva7Bl6NQa3QA4g
 tHvd7uKOJqb0pgS4o/UGpH4G486Wqtc=
X-Authority-Analysis: v=2.4 cv=I7VVgtgg c=1 sm=1 tr=0 ts=6a707daf cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=hlTv3zeCCfZNwghm1VgA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAzMDEwMSBTYWx0ZWRfXyhSEQNzf1u+L
 /5UtqgDoGuP8xU3hbjdwLWXfN2ZnfDzLuNu+dc5zBpXfH2SxxHPhTj2gJUJFDzwUGKIfej2URM+
 46BPIz+u8fYTpImoCAShiM0FDIedzAinL0Eay/PXleHeO5M7m+Q5l1E+t62woLF5i8rzio6/WGB
 7b7bhR/Gb1d2dis/BXCuFfobNPEYQCWWapykx4F8B0S/pUhw8GAVVChYnORFbTxloVIaAj9fQXa
 JMk7hv/39ORliBGrW+J5fcQbN9jRzVXOJirBMP+GMx2Og1f1gCOFYxY2AW9sGiZ2u1ZOHAYb9Qg
 vs0AcsZthl/JwFjPIFQrTqoIIx2imeEp1YnSl1bygCad5WuCL7Ctvi4AgStFFp0g03hHRwOCDD5
 nveMdVwXDAgXf+fKJI4yGNznPWtm2pb4JGZ7oEiuYLM0cOAUL7vLOX8ExbHqaHXIvuX97PaCBOA
 XpWrTkrsd77IirJpMTg==
X-Proofpoint-ORIG-GUID: 3-VbYSLjONI99MKwuUiEwIMc5bszb3HW
X-Proofpoint-GUID: 3-VbYSLjONI99MKwuUiEwIMc5bszb3HW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_06,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 clxscore=1011 priorityscore=1501 suspectscore=0
 malwarescore=0 adultscore=0 lowpriorityscore=0 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608030101

On Fri, Jul 31, 2026 at 06:50:00PM +0200, Heiko Carstens wrote:
> v4:
> - Replaced first patch with version from Peter Zijlstra
> 
> v3:
> - Drop uv_call_sched() [Claudio Imbrenda]
> 
> v2:
> - Use msleep() in crypto code (Holger Dengler)
> - Add Reviewed-by tag from Peter Oberparleiter
> 
> v1:
> Since [1] it is only possible to select the PREEMPT or PREEMPT_LAZY
> preemption models for s390. This has caused some minor problems, but
> everything has been addressed.
> 
> Given that for both preemption models cond_resched() is a no-op remove
> or replace it everywhere.
> 
> [1] commit 7dadeaa6e851 ("sched: Further restrict the preemption modes")
> 
> Heiko Carstens (3):
>   KVM: s390: Remove cond_resched() calls
>   s390: Remove cond_resched() calls
>   s390/cio: Remove cond_resched() calls
> 
> Peter Zijlstra (1):
>   s390/crypto: Replace cond_resched() with msleep(1)
> 
>  arch/s390/crypto/paes_s390.c    | 44 +++------------------------------
>  arch/s390/crypto/phmac_s390.c   | 25 +++----------------
>  arch/s390/include/asm/pkey.h    | 16 ++++++++++++
>  arch/s390/include/asm/uv.h      | 16 ++----------
>  arch/s390/kernel/perf_cpum_cf.c |  1 -
>  arch/s390/kernel/uv.c           |  2 +-
>  arch/s390/kvm/gaccess.c         |  8 ++----
>  arch/s390/kvm/gmap.c            |  4 ---
>  arch/s390/kvm/kvm-s390.c        |  1 -
>  arch/s390/kvm/pv.c              | 11 ++++-----
>  arch/s390/kvm/vsie.c            |  1 -
>  arch/s390/mm/cmm.c              |  2 --
>  arch/s390/mm/gmap_helpers.c     |  1 -
>  arch/s390/mm/pageattr.c         |  5 ----
>  arch/s390/mm/pgalloc.c          |  1 -
>  arch/s390/pci/pci.c             |  4 +--
>  drivers/s390/char/uvdevice.c    |  6 ++---
>  drivers/s390/cio/css.c          |  8 ------
>  18 files changed, 37 insertions(+), 119 deletions(-)

Applied, thank you!
