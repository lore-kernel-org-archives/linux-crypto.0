Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085223596A
	for <linux-crypto@vger.kernel.org>; Fri,  6 Jun 2025 07:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749194378; cv=none; b=n6JH/gOsocN5a3KSO8jx3kaFqR16/wIbci5DyH/2WzQzcpLUd4SvevHbC5wfbj3qo4p9Cq72x5xf+zJEkDDjfwSnESjghZ1NxfYyC4WEec7nBErX9h1DFO7Z2NNnD+HhZbNn8dbf0c0ZMG6nDZi3iMocV+cnchbNIjnDaG3Ii9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749194378; c=relaxed/simple;
	bh=T/ql8rJvxDj2UlFWx6OlfUXdimfGfwJbm8DbCK0CZiE=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=QzIJPV+qDr7/ev/ZzPcVAwPZtV+TrJNpdOSrW5m10DhRtCdXHg91c1oFM2W31JnljvMkPQelx+eLe9D4GviVRfNlVMPQ5caqS6PROSfjFXKAEai+drDg5olhq4h10w2p/hHCcZsGXf5IeJwf4TUX/j/tsgTyG/0jq3WdIc9Hz98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eVUARr+7; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eVUARr+7"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5563iHrw000602;
	Fri, 6 Jun 2025 07:19:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:reply-to:subject:to; s=pp1;
	 bh=pABEG7jkQjvD9VGBSmw9DtZwsEMzOyC8iBj5hWz9Tfc=; b=eVUARr+7ID23
	B6/pwWWj/bA59sJ1c/kp3pnn2wityml1MpLaHAhO59GaUS0lrwFkVIvs0v6D3n0V
	wbnanH3qDIfrKOSCgiMJa1pln9g42WTr9XZKEgpgy2D90rBGQNEetMcNRzluXd1Y
	ewI9TYinHvijBRXGbmPKDqCWpGhHk5xf+eERU4EDR3Y1JryHBrbvvigFmMJRw7F9
	hXxhpH8BRwJ+abQ1OScyzIpeNK4exNEdw43TyY/wK1/Zp9k9Zx2cUumctqQJ42dA
	y9NOr1BKd/4EcOWRS8b8fnm2EKq3jk5F3PrLqbGLP/toIuiOaMuiMrV6lvFPisqA
	BKvsRpcKXg==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47332ypn0g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Jun 2025 07:19:21 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55674Zlf024776;
	Fri, 6 Jun 2025 07:19:21 GMT
Received: from smtprelay06.dal12v.mail.ibm.com ([172.16.1.8])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 470dkmra06-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Jun 2025 07:19:21 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay06.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5567JKuA29491788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Jun 2025 07:19:20 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DDD0058050;
	Fri,  6 Jun 2025 07:19:19 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5891558056;
	Fri,  6 Jun 2025 07:19:19 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.5.196.140])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Jun 2025 07:19:19 +0000 (GMT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Fri, 06 Jun 2025 09:19:18 +0200
From: Harald Freudenberger <freude@linux.ibm.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ingo Franzki <ifranzki@linux.ibm.com>,
        Herbert Xu
 <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, dengler@linux.ibm.com
Subject: Re: CI: Another strange crypto message in syslog
Reply-To: freude@linux.ibm.com
Mail-Reply-To: freude@linux.ibm.com
In-Reply-To: <20250605142641.GA1248@sol>
References: <d4520a75-c765-406b-a115-a79bbdf8d199@linux.ibm.com>
 <20250605142641.GA1248@sol>
Message-ID: <66d4c382f0fbe4ca5486ccfa1f0a4699@linux.ibm.com>
X-Sender: freude@linux.ibm.com
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 2fdqEx9Wp2CX1YzB7XMHnEXRcPMDkL3L
X-Proofpoint-ORIG-GUID: 2fdqEx9Wp2CX1YzB7XMHnEXRcPMDkL3L
X-Authority-Analysis: v=2.4 cv=SO9CVPvH c=1 sm=1 tr=0 ts=6842967a cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=kj9zAlcOel0A:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=FNyBlpCuAAAA:8 a=FRACuIAxF-nezQ5b0g0A:9 a=CjuIK1q_8ugA:10
 a=RlW-AWeGUCXs_Nkyno-6:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjA2MDA2NCBTYWx0ZWRfXyHcXNxOuQwEa HSmoeEbsHN4Wj2TljYH2eVYUg78mINMuRAb2ib0L9xOTBkkHptNswKfE0SpWFMjNxQupHlFJ0r5 +J2Iu8JyiUagXjs313APubg7FZDvPFi0q+MhbytUQwlTxxC1UynF0SQZJhfM2I/fJ8AZg0CVajE
 pbkdHAOFzU56cKfncetG4XSUnyj5qnv0wKyh2FWk11JD0wxrR3H0BzpHYG+C3kqNZlL/qOCIC4z Op+OSXYwlDeexmx4RobQWXo0LymJFmAfxoJKQW+TvQUHSpBOgd5Rnz7W1WTtAq70jeh4KlfVCaK RVggjc3JPmwMivkw4YHPr90MAlrM/RqNFiyOjZCbx48UO0XsX/v0wQtmWVGjwbZiJ47PHuApPK7
 sPwN9YAKCeNaDLL/wRQz16zXoNe29n9Xg78/JrQTuYRVES7dxXB6YVY8c/fNiY9/qqOLZZoe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-06-06_01,2025-06-05_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 impostorscore=0 phishscore=0 priorityscore=1501 adultscore=0
 mlxlogscore=999 clxscore=1015 spamscore=0 lowpriorityscore=0 bulkscore=0
 mlxscore=0 suspectscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506060064

On 2025-06-05 16:26, Eric Biggers wrote:
> On Thu, Jun 05, 2025 at 01:26:34PM +0200, Ingo Franzki wrote:
>> Hi Herbert,
>> 
>> we see the following error messages in syslog on the current next 
>> kernel:
>> 
>> Jun 05 13:15:20 a35lp62.lnxne.boe kernel: basic hdkf 
>> test(hmac(sha256)): failed to allocate transform: -2
>> Jun 05 13:15:20 a35lp62.lnxne.boe kernel: alg: full crypto tests 
>> enabled.  This is intended for developer use only.
>> 
>> The first one seem to be failure, but I can't tell where..... I don't 
>> see any other typical selftest failure messages.
>> -1 is ENOENT. It might be related to the recent changes with sha256 
>> being now in a library...
> 
> No, it's from the following commit:
> 
>     commit ef93f1562803cd7bb8159e3abedaf7f47dce4e35
>     Author: Herbert Xu <herbert@gondor.apana.org.au>
>     Date:   Wed Apr 30 16:17:02 2025 +0800
> 
>         Revert "crypto: run initcalls for generic implementations 
> earlier"
> 
> That moved the crypto_shash support for hmac and sha256 from 
> subsys_initcall to
> module_init, which put at the same level as crypto_hkdf_module_init 
> which
> depends on it.
> 
> I guess we just move crypto_hkdf_module_init to late_initcall for now.
> 
>> The second one is probably because the full selftests are now enabled 
>> by
>> default. Does it make sense to output this message now anymore at all?
> 
> The crypto self-tests remain disabled by default; there's just no 
> longer a
> difference between the "regular tests" and the "full tests".  The 
> warning makes
> sense to me.  There should be an indication that the tests are running 
> since
> they take a long time and should not be enabled in production kernels.
> 
> If this is s390, arch/s390/configs/defconfig has 
> CONFIG_CRYPTO_SELFTESTS=y.  Is
> that really what you want?  I tried to remove it as part of
> https://lore.kernel.org/linux-crypto/20250419161543.139344-4-ebiggers@kernel.org/,
> but someone complained about that patch so I ended up dropping it.  But 
> maybe
> you still want to remove it from arch/s390/configs/defconfig.  There's 
> already
> arch/s390/configs/debug_defconfig that has it enabled too, and maybe 
> you only
> want tests enabled in the "debug" one?
> 
> - Eric

Looks like we have no other options than disabling the selftests in 
defconfig.
We have debug_defconfig - with all the now huge set of test running in 
CI.
But for my feeling it was making total sense to have a subset of the 
tests
run with registration of each crypto algorithm even in production 
kernels.
However, as wrote ... there is no choice anymore.
