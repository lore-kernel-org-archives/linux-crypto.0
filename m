Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52207209F32;
	Wed, 11 Dec 2024 09:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733908601; cv=none; b=KNt7ccWN8P8NNz3Yd8Umhb66CQOUXk8iK/QNd/jlG0vkuJY0w2Jvm9ceausWgetMY4VBu/Rjn88oIlX2AL/Prv+KhnoVz84OnTuOjgtCgLltAg1QT5uSb1eBqFsoLo3kAh4Z06wwF3NnSkywTqvwb/x9YC/3gBx40yvOIWGG8pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733908601; c=relaxed/simple;
	bh=nO2/rXlhT6z2WIEgeQu1Kh9yv+VGkoTEdmgWngBYtoc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mguv8U/8Ak175y8mUXbIzXkmBK5NEg+DhnK/o44kCF2gK8Jz8k9pb+iQNRMP5FCygLOWy0tr5Tvawxhsq7t3XBaAb5DT7qtVkEKQzvPJzlC050Ko+WdZem8+oboPZl6XM99awyrdSTfdnudMcfhWoZ47UtahRC3Wp3Wp3WLG20s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=oSGR8zXR; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="oSGR8zXR"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BB0lxqc007174;
	Wed, 11 Dec 2024 09:16:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=bOSpyn
	DVrOA2O7/zbdTQRDjiVSCatZs+bu2VrIWa9GQ=; b=oSGR8zXRNqmT1dNkkihPqJ
	LN7VDmoz4258N/CC9sv0jxHtFKZhyXvoD/bGP/XgbNuYMNzyV2mOUPl6KXh+g6fT
	dlWEw5kMm0JGjRoo3vokuyubn+VUtqX/fA4TZlUKWrCLHP8GR8TUV0GdMSc4qJjP
	u+or2VUS95gkYZ19dWoIhnArurxO6q//p8jkbSQEcCOhrd2GgY0N5Xlq8suSXUFS
	s25m2+gDzDNaDoYcxQQAHn/bdWBbqv64Wdn6bt3uHGxjLjJ49LsFK0FOurivM7ff
	YhqSzzkpvVbcQLF3KZnq39CnWhrV0B6Ot4MfPOV3rfejLL4nO+TjBzUFFss/dAXA
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43cdv8v955-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Dec 2024 09:16:32 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4BB9Al58010399;
	Wed, 11 Dec 2024 09:16:31 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43cdv8v94x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Dec 2024 09:16:31 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BB7NMP0023047;
	Wed, 11 Dec 2024 09:16:30 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 43d2wk0a23-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Dec 2024 09:16:30 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BB9GTaf20710030
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Dec 2024 09:16:30 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DEB8F58056;
	Wed, 11 Dec 2024 09:16:29 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 14D1F5803F;
	Wed, 11 Dec 2024 09:16:26 +0000 (GMT)
Received: from [9.171.85.18] (unknown [9.171.85.18])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Dec 2024 09:16:25 +0000 (GMT)
Message-ID: <e6128372-6dea-4d24-a7c7-7c3e90183836@linux.ibm.com>
Date: Wed, 11 Dec 2024 14:46:24 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv3] gcc: disable '-Wstrignop-overread' universally for
 gcc-13+ and FORTIFY_SOURCE
To: Nathan Chancellor <nathan@kernel.org>
Cc: Yury Norov <yury.norov@gmail.com>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        briannorris@chromium.org, kees@kernel.org, gustavoars@kernel.org,
        steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
        gjoyce@ibm.com, linux-crypto@vger.kernel.org, linux@weissschuh.net
References: <20241208161315.730138-1-nilay@linux.ibm.com>
 <Z1XkhhBqFYtbvQYp@yury-ThinkPad> <20241209193558.GA1597021@ax162>
 <2d9f4b56-3a8f-4fd7-a356-022f973da5e0@linux.ibm.com>
 <20241210161458.GA1305110@ax162>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20241210161458.GA1305110@ax162>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ZhhcLldIpLJJAudxb7SfMQevVa93IgNh
X-Proofpoint-ORIG-GUID: bvrRETJkKciETVaWBMKs7C8Z0MNsB_ks
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 impostorscore=0 lowpriorityscore=0 spamscore=0 clxscore=1015 mlxscore=0
 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2412110067



On 12/10/24 21:44, Nathan Chancellor wrote:
> On Tue, Dec 10, 2024 at 01:58:00PM +0530, Nilay Shroff wrote:
>> Okay so I think you (and Greg) were suggesting instead of disabling 
>> -Wstringop-overread globally or tuning it off for a particular source
>> file, lets disable it on gcc-13+ while we invoke bitmap_copy() as shown
>> below: 
> 
> I cannot speak for Greg but yes, this is generally what I had in mind, I
> have a few comments below.
> 
>> diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
>> index d0ed9583743f..e61b9f3ff6a7 100644
>> --- a/include/linux/compiler-gcc.h
>> +++ b/include/linux/compiler-gcc.h
>> @@ -139,6 +139,18 @@
>>  #define __diag_GCC_8(s)
>>  #endif
>>  
>> +#if GCC_VERSION >= 130000
>> +#define __diag_GCC_13(s)       __diag(s)
>> +#else
>> +#define __diag_GCC_13(s)
>> +#endif
>> +
>> +#if GCC_VERSION >= 140000
>> +#define __diag_GCC_14(s)       __diag(s)
>> +#else
>> +#define __diag_GCC_14(s)
>> +#endif
> 
> You do not need to add __diag_GCC_14 because __diag_GCC_13 covers
> GCC 13 and newer.
Yeah ok, I would remove __diag_GCC_14.

> 
>>  #define __diag_ignore_all(option, comment) \
>>         __diag(__diag_GCC_ignore option)
>>  
>> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
>> index 9278a50d514f..6885856e38b0 100644
>> --- a/include/linux/cpumask.h
>> +++ b/include/linux/cpumask.h
>> @@ -836,7 +836,23 @@ void cpumask_shift_left(struct cpumask *dstp, const struct cpumask *srcp, int n)
>>  static __always_inline
>>  void cpumask_copy(struct cpumask *dstp, const struct cpumask *srcp)
>>  {
>> +       /*
>> +        * Silence -Wstringop-overead warning generated while copying cpumask
>> +        * bits on gcc-13+ and CONFIG_FORTIFY_SOURCE=y. The gcc-13+ emits
>> +        * warning suggesting "we're trying to copy nbits which potentially
>> +        * exceeds NR_CPUS. Apparently, this seems false positive and might be
>> +        * a gcc bug as we know that large_cpumask_bits should never exceed
>> +        * NR_CPUS.
> 
> I think the last sentence needs to be either dropped entirely or needs
> to have more assertive language. While this might be a false positive, I
> think it is entirely unreasonable to expect GCC to know that
> large_cpumask_bits when it is nr_cpu_ids is bounded by NR_CPUS because
> it does not have the definition of nr_cpu_ids visible at this point and
> even if it did, it is still a global variable, so it has to assume that
> value could be anything in lieu of an explicit bounds check.
> 
> Maybe something like this for the full comment?
> 
> /*
>  * Silence instances of -Wstringop-overread that come from the memcpy() in
>  * bitmap_copy() that may appear with GCC 13+, CONFIG_FORTIFY_SOURCE=y, and
>  * and CONFIG_NR_CPUS > 256, as the length of the memcpy() in bitmap_copy() will
>  * not a compile time constant. Without an explicit bounds check on the length
>  * of the copy in this path, GCC will assume the length could be 0 to UINT_MAX,
>  * which would trigger an overread of the source if it were to happen. As
>  * nr_cpu_ids is known to be bounded by NR_CPUS, this copy will always be in
>  * bounds.
>  */
Okay I would update comment.
> 
>> +        */
>> +       __diag_push();
>> +       __diag_ignore(GCC, 13, "-Wstringop-overread",
>> +               "Ignore string overflow warning while copying cpumask bits");
>> +       __diag_ignore(GCC, 14, "-Wstringop-overread",
>> +               "Ignore string overflow warning while copying cpumask bits");
> 
> This __diag_ignore() can be dropped as well.
Agreed.
> 
>> +
>>         bitmap_copy(cpumask_bits(dstp), cpumask_bits(srcp), large_cpumask_bits);
>> +
>> +       __diag_pop();
>>  }
>>
>> Does the above change look good to everyone?
> 
> I think this seems reasonable to me, but it might be good to get some
> feedback from the hardening folks.
> 
> Cheers,
> Nathan

Thanks,
--Nilay
