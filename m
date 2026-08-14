Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A36FA46EC73;
	Fri, 14 Aug 2026 14:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786717786; cv=none; b=r+qpxQaUM4FsFjVDBmDhxhWwrJiSSSt2ddyGKkjvhuMb7L6TMPD5XMZtz6O35i/RvdRVXgtAO9DrRwZhuOhTtqoGYZ60cAiROyrPDiSjwklk6SHtabzjjY/kBhCxQxdi2/zrI/D/0oYHXy8xulGUW1cx+G4v3mUay8sLyA40+g8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786717786; c=relaxed/simple;
	bh=2aU+G/pS2NFE/3biC6mmV9lmaM72FyKTbQISkXX0Q/4=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=UzcXLids9wRrCJ72WctEoSdDs5xPBzUkyDQmI6+r4+lPj6QWyNQX78cNNP5r/VVREEjQedBVQ7rdxskL6bUOhO9pb+bNFX5spHJXHo2BD+Wd/sX7CI60tNGi2g3yAaSffDol3KmHvo5CIYkvKuYz+BiWY4m+TUI7oFjjz+qw5Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PfxyB/cs; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PfxyB/cs"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67EE5nf21343028;
	Fri, 14 Aug 2026 14:29:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=4qJhkuSz8wnuBnoF/W/U8DfxFlUlqYfo/odRlcX8frI=; b=PfxyB/cs9/WX
	xihCAmY9W0vgp/z/MwfDwRsQuPMx4xo7ObCh2ybEnVBLMnXjvJxlnql/pKcEyver
	MOP5Gi0eOKx0TqFY5YZdo17XwbJaSyK0Iv8gVBlhv4u1yf2RyKXre4kT/1jxXS6/
	exR5BwJFHTfhom8yE8/wE2wOkR4Z7vCU21utJNhKZAxLg3c0TROl9maNUbVnobyj
	+DGOorBwhTrpuL0firOmR2kYH5wtjwOUJD/PJAtC2PEhGmORkGVZ465Kysd0PUOh
	SoFBczKOTiX69HZCK0XKAO91ej51oLl2aLBl8ZGXcKDtsQauujJoNf3ZVgFeX1fq
	CwhlmPYTPQ==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fwvma59h2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 14:29:31 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 67EEQLA4003961;
	Fri, 14 Aug 2026 14:29:31 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fxesqfsm0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 14 Aug 2026 14:29:30 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 67EETTlq1966736
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 14 Aug 2026 14:29:30 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A423D58053;
	Fri, 14 Aug 2026 14:29:29 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B349258043;
	Fri, 14 Aug 2026 14:29:28 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 14 Aug 2026 14:29:28 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 14 Aug 2026 16:29:28 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Holger Dengler <dengler@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Eric Biggers
 <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
        ifranzki@linux.ibm.com
Subject: Re: [PATCH v1 1/1] s390/crypto: Generate intermediate CV for API
 partial block handling
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20260814142010.259918-2-dengler@linux.ibm.com>
References: <20260814142010.259918-1-dengler@linux.ibm.com>
 <20260814142010.259918-2-dengler@linux.ibm.com>
Message-ID: <70e743d71eea0186c56b428a316a8d09@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE0MDEwNyBTYWx0ZWRfX8Zepus0mc9ia
 ChX9GR5fNxFQNxoFsSUG5ek3q6AX77COE+98SRGc86FBaOdk7gRYmyTp3D+XU45xZiKMmD4pur7
 eLSOwyXCMVOHtiQ4atqEhFP38JLnHWrxdfhH81JaA8sG/cAQZaTaNDJAS7D4Tv2hX4ewlRf0Qs6
 F431zUUAMfQk3020mB9aty33lGczxigXfLhFHaSalNozRgdy/lKcvvXfjVUZCEHiVdyT23+2oMp
 wrTLiTXRQpM1IYD+QsKly5a+cvJ4GpjhXIgv2gIAOe6HJ4YpDBDxXCXzqZHRmm4E0qOHnyHT+xD
 EbzJcFnTs2RBUNkjnybdWiDSSkFUEhduxGMOFDGKS4WwHjV8C5XupiBB4eNNwBFZ+alhnt2SctZ
 Na3gmiUonGRUFUdvsTUGXVq/kCJMvYn++/xdLqn0nz6EbQfjIXYXW2BCZeDb9AyqdNGGSXeyANR
 vjlaRD9/U6Gx3eIfMbg==
X-Proofpoint-ORIG-GUID: 7Xw-PBawIB4rUzxc_eiu2RksH-tL2JgG
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE0MDEwNyBTYWx0ZWRfX10RMPgov7drX
 SbJ/5gTNJbLICQSpoqY4WAeF1QaeYKOENNETAqX5uGS3FxXZO5hSQSc6XUE7tpM/pYxS5icrqEF
 y7FXCNX7+Wzqz+drTBe+eMqaYtSZAlg=
X-Authority-Analysis: v=2.4 cv=IfK3n2qa c=1 sm=1 tr=0 ts=6a7f264b cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=kj9zAlcOel0A:10 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=surarEuvIVbDui9BnBAA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-GUID: 7Xw-PBawIB4rUzxc_eiu2RksH-tL2JgG
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-14_05,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 priorityscore=1501 impostorscore=0 bulkscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 malwarescore=0 spamscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608140107

On 2026-08-14 16:20, Holger Dengler wrote:
> The API partial block handling requires a intermediate chaining
> value (CV). The internal function hash_data() sets the function code
> correctly, so also call cpacf_kimd() instruction for intermediate CV
> generation, as cpacf_klmd() always generate the final hash value.
> 
> Cc: stable@vger.kernel.org # 6.15+
> Fixes: 08811169ac01 ("crypto: s390/hmac - Use API partial block 
> handling")
> Signed-off-by: Holger Dengler <dengler@linux.ibm.com>
> ---
>  arch/s390/crypto/hmac_s390.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/crypto/hmac_s390.c 
> b/arch/s390/crypto/hmac_s390.c
> index f8cd09f341d4..445fa7bbd958 100644
> --- a/arch/s390/crypto/hmac_s390.c
> +++ b/arch/s390/crypto/hmac_s390.c
> @@ -150,7 +150,10 @@ static int hash_data(const u8 *in, unsigned int 
> inlen,
> 
>  #undef PARAM_INIT
> 
> -	cpacf_klmd(func, &param, in, inlen);
> +	if (final)
> +		cpacf_klmd(func, &param, in, inlen);
> +	else
> +		cpacf_kimd(func, &param, in, inlen);
> 
>  	memcpy(digest, &param, digestsize);

Reviewed-by: Harald Freudenberger <freude@linux.ibm.com>
