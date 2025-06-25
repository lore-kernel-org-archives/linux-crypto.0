Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE521288522;
	Wed, 25 Jun 2025 09:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750842277; cv=none; b=dN0Fboy1ESqjyO95pEkQotz7H4wX7pY94po2s+wrjeF+gCpKmMRjvXBXqy43WwpUqs8pSdY8LFdGuNuHl4IHC8EAgxk6S3l94Ph4G6U+SjYcB0NYejQRdPL8VKIybxcsJG2TInjj6wUneL3HtipekcAx6fzt0jQd78xgKxPQj4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750842277; c=relaxed/simple;
	bh=WdiIrHoADamdWORs6cfgjdz8tQS8h1F+y/Kl7Dd5l6M=;
	h=MIME-Version:Date:From:To:Cc:Subject:Message-ID:Content-Type; b=qC4lC64wGt8XyBuzQQYEwwO6zjxbcl/h68dKjVs8TqkAySKjDKKuxJRDkqh3+xIq+8uswuLbtYcr8b1cmrUvzbpwU5W2lAJmk+7DQfVtS0diQ1Hb1MJdqIapFqzf2BwuSRBniOT52Q4SqI7Eb7hBU+5PX2V5xocWMJMgRzwoNIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Kw99ET6D; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Kw99ET6D"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55P72MVu008999;
	Wed, 25 Jun 2025 09:04:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:reply-to:subject:to; s=pp1; bh=EYxURk3qiOhJNpHGxh+
	ApOrzBsA8Z9Gcj5Z6PlWI7lg=; b=Kw99ET6Dp15dk8N5nRWXwDNWZ+ejxDjFGbA
	UVp1J04vekdKUQnF2co9zIY08b8pyshOOcYsqaWX5c1XSXohkb01bHFiB+LHe7pW
	YLYTOQAz9yRwUrYrg3C4LiFFoH9RE9Lw01VatbrplHwsbkf9bFilb1I0L/cFKpZv
	o9JxCCPprWKm7fJuBnmtwAJx8eGuHW5VvSAZMnWaawwZ+y/3fNk8INt15czcc5JC
	OqEA0eiCaGSvkvlD2eReCb5pHZKLItR9PIXUmHHBw0OrqpxYam1Jt33y3+/H8D0T
	s+CGp48oPoBtE302MRF6L04uyk+3VB0ihR3nnyrttfwd6xHstvg==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47dmf35wuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Jun 2025 09:04:31 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55P5qaEb030476;
	Wed, 25 Jun 2025 09:04:31 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 47e7f00m75-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Jun 2025 09:04:31 +0000
Received: from smtpav01.wdc07v.mail.ibm.com (smtpav01.wdc07v.mail.ibm.com [10.39.53.228])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55P94TVC33030714
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 09:04:30 GMT
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B512458063;
	Wed, 25 Jun 2025 09:04:29 +0000 (GMT)
Received: from smtpav01.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0064F58055;
	Wed, 25 Jun 2025 09:04:29 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav01.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 25 Jun 2025 09:04:28 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 25 Jun 2025 11:04:28 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, linux-s390@vger.kernel.org,
        dengler@linux.ibm.com, ifranzki@linux.ibm.com, fcallies@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, agordeev@linux.ibm.com
Subject: Re: [PATCH v12 0/6] New s390 specific protected key hmac
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
Message-ID: <247f28660259444c0293e24b151f508c@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=M5FNKzws c=1 sm=1 tr=0 ts=685bbb9f cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=lVIXu-gtx-SDQUWcvXYA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDA2MSBTYWx0ZWRfXxyI9moGGAEiy dVehTYP9m9I+rujGfCy1E8M28EeCaeZMY2gVwoLHwKMMoqnutjuCmmCQkVYPP34UNa4bVbX5uxm Rm/Yn4BqwKiS4W6BqpqHWxHhmeL+9FLqO3xtSZoVL9DfDl0+9a4k3Ew6JwPyNRJZBkXosOPpwmg
 USx42POwIl2tBqmz5uzoW9uyiUDFACAee6OUMeqNY2sQAyfHtVRml6DcLYhX0e+P3gT5ZyRPH3c FTyAlF4lWkCO5iBIH3i8DttLZzBFXQYDvrPb1hwW02PLAjGWLTK/0TLLrnIYAU/KlNps7aKrNJ2 xAd/NTu5/GMFN3nwrWKV7EyNr4Qd0TicPGLeJ9aAI/or5sagzk9ufaZdcGFjHmExQloPJuzPi4f
 wJwoBX1o3/uYC97A+2jYol+iJoTc/zqHghR23+h6ZbXPsZ4n215sbTfj+SQN5lj9tHmxvIyc
X-Proofpoint-GUID: 6l7y9mxVlCKq7nD6Hj4Va9jI-PAZDdE5
X-Proofpoint-ORIG-GUID: 6l7y9mxVlCKq7nD6Hj4Va9jI-PAZDdE5
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-25_01,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 priorityscore=1501 phishscore=0 spamscore=0 clxscore=1015 adultscore=0
 mlxscore=0 mlxlogscore=550 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506250061

On 2025-06-24 13:37, Herbert Xu wrote:
> On Tue, Jun 24, 2025 at 01:34:41PM +0200, Harald Freudenberger wrote:
>> 
>> as the phmac implementation uses the newly introduced 
>> CRYPTO_ALG_NO_FALLBACK
>> flag, we can't deliver this patch series via s390. I talked with Heiko
>> about that and there are two options:
>> 1) We (s390) pick your patch 4ccd065a69df ("crypto: ahash - Add 
>> support for
>>    drivers with no fallback") together with my patch series for the 
>> next
>>    kernel's merge window.
>> 2) You (crypto) pick my patch series into your cryptodev-2.6 for next
>>    kernel's merge window.
>> I would prefer option 2 as most of the patches anyway deal with crypto
>> and Heiko and I do not expect unsolvable merge conflicts with the next
>> kernel's merge.
>> So what is your opinion?
> 
> Sure I can do that if you wish.  Is it just that series or are
> there other dependencies that I need first?
> 
> Cheers,

Thanks this would be great.
No there are no other dependencies, all required code has been merged
into 6.16 already. So for the 6.17 merge window the phmac patch series
v12 has all tags correct and should apply without any problems.


