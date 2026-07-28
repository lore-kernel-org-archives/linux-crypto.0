Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0ACE33D503;
	Tue, 28 Jul 2026 16:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785255226; cv=none; b=V7+PZ6JdJEMHzk/iJaGHkEFKrSVu4WBslWvjMpVZHrjHMfQQ1yp7oVkSOBAV6xwvom4K77Zu7znBfpmHtZlfhSNRzRji1J/PGTPOCNINkFgfpVhoNBsd0w8H59Ehj/w4OOZjAnA+O5Q9PA1v70Ab9eEuMCbeOhi6fyR71qAakuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785255226; c=relaxed/simple;
	bh=UnIavyZsCfxoCQ1+Hppm/SP0GoXjymRVCJYqB3jrp3I=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=YTb35oE/fJQO6Ua1Soso3El/5Z/VyvbeLRnuF8mlmiNBe8KnChu4GBXtPNZzIFYus436AbJCLs7nKd2YLo9DOxzkGtvAVdaWI/MFfbqoWXJDhIBAD4tP6bhhUhQBsQSCg2q8QtordQ4dwgS6SiuGN6EABcX8Bin/a9GxIwxcMR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=IPneuWKQ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="IPneuWKQ"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SElrbe1459524;
	Tue, 28 Jul 2026 16:13:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=Ju3UKVR1T6AOFfpculsveJFdgsQv264Z+bRKDWddmaU=; b=IPneuWKQwBP6
	qptsG1c2Mkg1nkZVz1wEOBN3k8tv9g21pAbkj2um7v3v7GHwOTzNOz8EtpFraY3a
	bQFY6TrrS+pI+pkSe18CWIR+maRPq9V7LhjQpzEv8NDFm6u/gKJQQJFgn7Xj5KDG
	PDfjQh5Gx9yqrHYHT9ILsgOHNsZEIe7aEHd8xqNUDqbje2jN22JGOHIb2oaG0CDg
	GhB7MXnYJKcr7/aN5UqyM/uz7D+uO3VCrmxr939eqDtE+dkN8w8CLAV8Yl+DraJc
	vXrmjxyGsZpiQTt1pRVTd8P6JH9pywcUnIydvq3gar0kfGADAMjZNspqzrtM5PYv
	cL3h/1SWgA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fmuw7e8jg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 16:13:36 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 66SGBFnr006463;
	Tue, 28 Jul 2026 16:13:35 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fn8yhamkp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 28 Jul 2026 16:13:35 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 66SGDX1e27525830
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 28 Jul 2026 16:13:33 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C847B58059;
	Tue, 28 Jul 2026 16:13:33 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10BAD58043;
	Tue, 28 Jul 2026 16:13:33 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 28 Jul 2026 16:13:32 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 28 Jul 2026 18:13:32 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Heiko Carstens <hca@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>,
        Sven Schnelle
 <svens@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian
 Borntraeger <borntraeger@linux.ibm.com>,
        Holger Dengler
 <dengler@linux.ibm.com>,
        Vineeth Vijayan <vneethv@linux.ibm.com>,
        Peter
 Oberparleiter <oberpar@linux.ibm.com>,
        Janosch Frank
 <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        David
 Hildenbrand <david@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 1/4] s390/crypto: Replace cond_resched() with msleep(1)
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20260728150412.3893933-2-hca@linux.ibm.com>
References: <20260728150412.3893933-1-hca@linux.ibm.com>
 <20260728150412.3893933-2-hca@linux.ibm.com>
Message-ID: <2cbaf523a137849d351d7393058286e2@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: VgBQ2d4R80tmrpmdv7Knm86Yqi-VpGuy
X-Proofpoint-ORIG-GUID: VgBQ2d4R80tmrpmdv7Knm86Yqi-VpGuy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI4MDE0MCBTYWx0ZWRfX5u+H2DCBGGnH
 WL1vke0YM/FQTQhjj9f5fbZLsm8BjnZLcn6KM/vKNAfl45+VYNfOYRvOs3p8FUw8fIxRmMo92dg
 R5BTpOiJbNoUt+OE3fFrgqBdPhEZiNfKTjvTlgl7T77iUkyN/+7CGCLIsjaMqCx0QiJPzM2whlN
 +lEao7KMmJOvi7iuP59W1y6Z5xZdhmWnC5jHrjIJgIz/cU/zEMuzbVECoyGj4KucFUKP6j4+tXh
 3m/8HO9QZSOoiUXk9vjv5xZNoahjHcTAP+F1f+fm7D4n1qaQLaqKyUXXXgW8Y8kIaKYTMr92fFx
 G0kJooFcaOF2VKEuhj7cpWugjB9fTnqm2FyPq084PNMU3JGjbGFOHVXTedVaKDQln0rLlL1zUYW
 ixDhQ/42hQSVNnOkJ/q1bVuxg9VLiNwz1h1nJfdUHrrNIDTeH9lM3B4pWjuCNyb9CSRdGhPZnxi
 FllvEeWOYY419frXQxA==
X-Authority-Analysis: v=2.4 cv=SKFykuvH c=1 sm=1 tr=0 ts=6a68d530 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=kj9zAlcOel0A:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8
 a=DcPO_hv44LQIqzGHYZIA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI4MDE0MCBTYWx0ZWRfX6Zuw39tXzSFa
 waHq+FWcQXft8JyDTp0q2MPE3VwpCDUQbZFIRtBuLGgOiii6EoHF2ch1J71t3DJ46ZoDGYqzYze
 LiI3hS7Lp/eis2lo3lI51ko9TNqHNw4=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-28_04,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 clxscore=1015 adultscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607280140

On 2026-07-28 17:04, Heiko Carstens wrote:
> With [1] cond_resched() is always compiled away and becomes a no-op.
> 
> The comments for all cond_resched() calls in crypto code however 
> indicate
> that the current process should be scheduled away to avoid instant
> re-invocation of a callback. This is not what cond_resched() would do 
> or
> did.
> 
> Instead of just removing the cond_resched() calls, replace them with
> msleep() calls, as suggested by Holger Dengler. This forces the current
> task to be scheduled away (sleeps) like originally intended.
> 
> [1] commit 7dadeaa6e851 ("sched: Further restrict the preemption 
> modes")
> 
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
> ---
>  arch/s390/crypto/paes_s390.c  | 8 ++++----
>  arch/s390/crypto/phmac_s390.c | 4 ++--
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/s390/crypto/paes_s390.c 
> b/arch/s390/crypto/paes_s390.c
> index 8cfe6166c193..511cb6105436 100644
> --- a/arch/s390/crypto/paes_s390.c
> +++ b/arch/s390/crypto/paes_s390.c
> @@ -555,7 +555,7 @@ static int ecb_paes_do_one_request(struct
> crypto_engine *engine, void *areq)
>  		 * To avoid immediately re-invocation of this callback,
>  		 * tell the scheduler to voluntarily give up the CPU here.
>  		 */
> -		cond_resched();
> +		msleep(1);
>  		pr_debug("rescheduling request\n");
>  		return -ENOSPC;
>  	} else if (rc) {
> @@ -821,7 +821,7 @@ static int cbc_paes_do_one_request(struct
> crypto_engine *engine, void *areq)
>  		 * To avoid immediately re-invocation of this callback,
>  		 * tell the scheduler to voluntarily give up the CPU here.
>  		 */
> -		cond_resched();
> +		msleep(1);
>  		pr_debug("rescheduling request\n");
>  		return -ENOSPC;
>  	} else if (rc) {
> @@ -1129,7 +1129,7 @@ static int ctr_paes_do_one_request(struct
> crypto_engine *engine, void *areq)
>  		 * To avoid immediately re-invocation of this callback,
>  		 * tell the scheduler to voluntarily give up the CPU here.
>  		 */
> -		cond_resched();
> +		msleep(1);
>  		pr_debug("rescheduling request\n");
>  		return -ENOSPC;
>  	} else if (rc) {
> @@ -1572,7 +1572,7 @@ static int xts_paes_do_one_request(struct
> crypto_engine *engine, void *areq)
>  		 * To avoid immediately re-invocation of this callback,
>  		 * tell the scheduler to voluntarily give up the CPU here.
>  		 */
> -		cond_resched();
> +		msleep(1);
>  		pr_debug("rescheduling request\n");
>  		return -ENOSPC;
>  	} else if (rc) {
> diff --git a/arch/s390/crypto/phmac_s390.c 
> b/arch/s390/crypto/phmac_s390.c
> index 03ca33ffe6cc..da76c7beb184 100644
> --- a/arch/s390/crypto/phmac_s390.c
> +++ b/arch/s390/crypto/phmac_s390.c
> @@ -895,7 +895,7 @@ static int phmac_do_one_request(struct
> crypto_engine *engine, void *areq)
>  			 * tell scheduler to voluntarily give up the CPU here.
>  			 */
>  			pr_debug("rescheduling request\n");
> -			cond_resched();
> +			msleep(1);
>  			return -ENOSPC;
>  		} else if (rc) {
>  			hwh_advance(hwh, rc);
> @@ -916,7 +916,7 @@ static int phmac_do_one_request(struct
> crypto_engine *engine, void *areq)
>  			 * tell scheduler to voluntarily give up the CPU here.
>  			 */
>  			pr_debug("rescheduling request\n");
> -			cond_resched();
> +			msleep(1);
>  			return -ENOSPC;
>  		}
>  		break;

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
