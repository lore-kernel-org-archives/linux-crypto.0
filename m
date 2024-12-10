Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F354230981;
	Tue, 10 Dec 2024 08:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733819305; cv=none; b=VMIye3P5kODeDgJihUZdtKaMMAioqTMeS/QI4RGrMt0og13Sw0lR/9NxLtVKeoWK+r87BjN0DGNzwxYG3crX4qmiubHXwuyad8Nvq2OHl4OVJz3Ds30o9UMuE2xaEk6DressYT9gvuVYiniXtFElRxn1UI7VnlhDc0jrEji0ln0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733819305; c=relaxed/simple;
	bh=66MXR0/oHc09p9Kz0kaQudwk3AXN670HjvTIXe3SwAA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=B5XqG4VRwcf4skcDR8Vpl01zu85EcuJwj/sdDxlKQRdgZelvm3YERgxEudhIo5eIBpSERdP7y1W+oENOoRvGYfiawjRDB0kL28q7VzF7AeslfGUl+w33rCY+eqMYM6TJSzj8gvwfv6uGrPCF7ZusUCpfY8rDUkdIYpG5oT1UDvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=SJGfHCIh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="SJGfHCIh"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA3F4oT017416;
	Tue, 10 Dec 2024 08:28:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=8WSWOy
	BcNUItJX264tnEFBP6PfrClcLOGPcVK+msEDs=; b=SJGfHCIhgvq+ox+LY1en3n
	p9d+yzu08j67OlWv6wBI8Ab50pSensJN+GROmPEey859f0O/hd260yx4myAYONQH
	wQwycu0r6pJ/KE/qx7B2EnJfKiArEYbsX+w6yEh9NQhQhNsxNJGkCdSCKeObvEAM
	GU+wvxlai8IjSh1d9gyHOj0HgJTTpWdSFYMKF7iU6hNdFmn0bYK4q0xu958gsOmV
	M7orfu8FNEXxKL7ThgrZZXoFG3sDMGaQGhQHWwb59Uha4LBRUt1i/NoItQUqi1Zv
	RBvxsQ+poqdoL06kVjn9IgvHenWsSP5X/QS8YSW4DJXBHXXVRPMeAWlI7v32ihcw
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ccsjcypx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 08:28:08 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 4BA8OXQA026914;
	Tue, 10 Dec 2024 08:28:08 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 43ccsjcypt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 08:28:07 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA841XH018605;
	Tue, 10 Dec 2024 08:28:07 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 43d26kanh2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 10 Dec 2024 08:28:07 +0000
Received: from smtpav04.dal12v.mail.ibm.com (smtpav04.dal12v.mail.ibm.com [10.241.53.103])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4BA8S63M28115650
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 08:28:06 GMT
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BFF958056;
	Tue, 10 Dec 2024 08:28:06 +0000 (GMT)
Received: from smtpav04.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A43B958052;
	Tue, 10 Dec 2024 08:28:02 +0000 (GMT)
Received: from [9.109.198.241] (unknown [9.109.198.241])
	by smtpav04.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 10 Dec 2024 08:28:02 +0000 (GMT)
Message-ID: <2d9f4b56-3a8f-4fd7-a356-022f973da5e0@linux.ibm.com>
Date: Tue, 10 Dec 2024 13:58:00 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv3] gcc: disable '-Wstrignop-overread' universally for
 gcc-13+ and FORTIFY_SOURCE
To: Nathan Chancellor <nathan@kernel.org>, Yury Norov <yury.norov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        briannorris@chromium.org, kees@kernel.org, gustavoars@kernel.org,
        steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
        gjoyce@ibm.com, linux-crypto@vger.kernel.org, linux@weissschuh.net
References: <20241208161315.730138-1-nilay@linux.ibm.com>
 <Z1XkhhBqFYtbvQYp@yury-ThinkPad> <20241209193558.GA1597021@ax162>
Content-Language: en-US
From: Nilay Shroff <nilay@linux.ibm.com>
In-Reply-To: <20241209193558.GA1597021@ax162>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Ldc9jEk1QtghVU4RJxAykfFfcir9OufY
X-Proofpoint-ORIG-GUID: uByhjdP35Dfqrs2VIJY8vnqYfgIwXmor
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 adultscore=0
 impostorscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0 mlxlogscore=999
 mlxscore=0 priorityscore=1501 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2411120000
 definitions=main-2412100061



On 12/10/24 01:05, Nathan Chancellor wrote:
> On Sun, Dec 08, 2024 at 10:25:21AM -0800, Yury Norov wrote:
>> On Sun, Dec 08, 2024 at 09:42:28PM +0530, Nilay Shroff wrote:
>>> So the above statements expands to:
>>> memcpy(pinst->cpumask.pcpu->bits, pcpumask->bits, nr_cpu_ids)
>>> memcpy(pinst->cpumask.cbcpu->bits, cbcpumask->bits, nr_cpu_ids)
>>>
>>> Now the compiler complains about "error: ‘__builtin_memcpy’ reading
>>> between 257 and 536870904 bytes from a region of size 256". So the
>>> value of nr_cpu_ids which gcc calculated is between 257 and 536870904.
>>> This looks strange and incorrect.
>>
>> Thanks for the detour into internals. I did the same by myself, and
>> spent quite a lot of my time trying to understand why GCC believes
>> that here we're trying to access memory beyond idx == 256 and up to
>> a pretty random 536870904.
>>
>> 256 is most likely NR_CPUS/8, and that makes sense. But I have no ideas
>> what does this 536870904 mean. OK, it's ((u32)-64)>>3, but to me it's a
>> random number. I'm quite sure cpumasks machinery can't be involved in
>> generating it.
> 
> That can also be written as (UINT_MAX - 63) / 8, which I believe matches
> the ultimate math of bitmap_size() if nbits is UINT_MAX (but I did not
> fully verify) in bitmap_copy(). I tried building this code with the
> in-review -fdiagnostics-details option from GCC [1] but it does not
> really provide any other insight here. UINT_MAX probably comes from the
> fact that for this configuration, large_cpumask_bits is an indeterminate
> value for the compiler without link time optimization because it is an
> extern in kernel/padata.c:
> 
> | #if (NR_CPUS == 1) || defined(CONFIG_FORCE_NR_CPUS)
> | #define nr_cpu_ids ((unsigned int)NR_CPUS)
> | #else
> | extern unsigned int nr_cpu_ids;
> | #endif
> | ...
> | #if NR_CPUS <= BITS_PER_LONG
> |   #define small_cpumask_bits ((unsigned int)NR_CPUS)
> |   #define large_cpumask_bits ((unsigned int)NR_CPUS)
> | #elif NR_CPUS <= 4*BITS_PER_LONG
> |   #define small_cpumask_bits nr_cpu_ids
> |   #define large_cpumask_bits ((unsigned int)NR_CPUS)
> | #else
> |   #define small_cpumask_bits nr_cpu_ids
> |   #define large_cpumask_bits nr_cpu_ids
> | #endif
> 
> From what I can tell, nothing in this callchain asserts to the compiler
> that nr_cpu_ids cannot be larger than the compile time value of NR_CPUS
> (I assume there is a check for this somewhere?), so it assumes that this
> memcpy() can overflow if nr_cpu_ids is larger than NR_CPUS, which is
> where that range appears to come from. I am able to kill this warning
> with
> 
> diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
> index 9278a50d514f..a1b0e213c638 100644
> --- a/include/linux/cpumask.h
> +++ b/include/linux/cpumask.h
> @@ -836,6 +836,7 @@ void cpumask_shift_left(struct cpumask *dstp, const struct cpumask *srcp, int n)
>  static __always_inline
>  void cpumask_copy(struct cpumask *dstp, const struct cpumask *srcp)
>  {
> +	BUG_ON(large_cpumask_bits > NR_CPUS);
>  	bitmap_copy(cpumask_bits(dstp), cpumask_bits(srcp), large_cpumask_bits);
>  }
>  
> 
> although I am sure that is not going to be acceptable but it might give
> a hint about what could be done to deal with this.
> 
> Another option would be taking advantage of the __diag infrastructure to
> silence this warning around the bitmap_copy() in cpumask_copy(), stating
> that we know this can never overflow because of <reason>. I think that
> would be much more palpable than disabling the warning globally for the
> kernel, much like Greg said.
> 
Okay so I think you (and Greg) were suggesting instead of disabling 
-Wstringop-overread globally or tuning it off for a particular source
file, lets disable it on gcc-13+ while we invoke bitmap_copy() as shown
below: 

diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index d0ed9583743f..e61b9f3ff6a7 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -139,6 +139,18 @@
 #define __diag_GCC_8(s)
 #endif
 
+#if GCC_VERSION >= 130000
+#define __diag_GCC_13(s)       __diag(s)
+#else
+#define __diag_GCC_13(s)
+#endif
+
+#if GCC_VERSION >= 140000
+#define __diag_GCC_14(s)       __diag(s)
+#else
+#define __diag_GCC_14(s)
+#endif
+
 #define __diag_ignore_all(option, comment) \
        __diag(__diag_GCC_ignore option)
 
diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index 9278a50d514f..6885856e38b0 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -836,7 +836,23 @@ void cpumask_shift_left(struct cpumask *dstp, const struct cpumask *srcp, int n)
 static __always_inline
 void cpumask_copy(struct cpumask *dstp, const struct cpumask *srcp)
 {
+       /*
+        * Silence -Wstringop-overead warning generated while copying cpumask
+        * bits on gcc-13+ and CONFIG_FORTIFY_SOURCE=y. The gcc-13+ emits
+        * warning suggesting "we're trying to copy nbits which potentially
+        * exceeds NR_CPUS. Apparently, this seems false positive and might be
+        * a gcc bug as we know that large_cpumask_bits should never exceed
+        * NR_CPUS.
+        */
+       __diag_push();
+       __diag_ignore(GCC, 13, "-Wstringop-overread",
+               "Ignore string overflow warning while copying cpumask bits");
+       __diag_ignore(GCC, 14, "-Wstringop-overread",
+               "Ignore string overflow warning while copying cpumask bits");
+
        bitmap_copy(cpumask_bits(dstp), cpumask_bits(srcp), large_cpumask_bits);
+
+       __diag_pop();
 }

Does the above change look good to everyone?

Thanks,
--Nilay
