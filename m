Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9247F13AF2;
	Mon,  7 Jul 2025 06:47:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751870881; cv=none; b=KcVL7Fy1Iw0J0w/lfIUL/KqJ+AbDPfN9N+/vOW8RhpNOnPTzK5WvsQwZpd2PZZtloB41JaDfiyZjsLr0H2JuF8hlIObC2ul6n0LlmMvc6DsJZ/qHdQt1gxJmR3v5+b9VPNOaOZVG89VoYq0GJYKdil6HRKkJvip0pMptw2MC/Kw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751870881; c=relaxed/simple;
	bh=yqjGONfEVTT7qruYx6XGVxkfroAmgEahVUULQjcwk7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EJdOx3dirpwdXEpXpco0ETY48SqqEf+4RQMtjjooGUw3NzXVVY7YNXNOQd749fKMlbinY8ymHIVoCk6ejYRqua3ByzJ+03EfOSZigVwhqUY+KQ1qVll0bEeqLrJCLdCpoRJuxJA9Wy+23z5MAyzoZKztTK5Z4ASx1Z+bHJisSEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=k/IoXyEd; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="k/IoXyEd"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 566LsOCa000560;
	Mon, 7 Jul 2025 06:47:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=C6SFfQ
	5N16J80f8wETQkLOQv2hbA4g31/sA9BAGHgEY=; b=k/IoXyEdMvnjwzzDGIlHrV
	MXeMK7qI+p1BcF3mxVOQakZvYIcxnYFGPojv5YgmJuUtouIEP6teiNujqJzuTDYH
	0pfqbhMjikPFuW/J2LsGbU+MBna5jqyDgQdWqPy7MhRHu8iDO+vxlkOtymRkWn9h
	DEV+W2EmGpLFI7fYd/DvBOsBwApZK5aG5zHMd72ESI64IgPqT3yV+qc/l5B6eU3p
	RQQQogz890X5SU4V2Tgzc0qBePsfOXuue0++HPq6w+1gjJvhLoO8gjX4NsKNe7MP
	JPaUufUkviirXBls9i8IlnEn/tnporM/L32HhJGtvIcSLttPMWILx5YUUVQMcFbg
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47ptjqqmdm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Jul 2025 06:47:53 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5676ILuB024284;
	Mon, 7 Jul 2025 06:47:15 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 47qh324hwx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 07 Jul 2025 06:47:15 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5676lC5v41484716
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 7 Jul 2025 06:47:12 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E693220043;
	Mon,  7 Jul 2025 06:47:11 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B5DF520040;
	Mon,  7 Jul 2025 06:47:11 +0000 (GMT)
Received: from [9.111.159.38] (unknown [9.111.159.38])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  7 Jul 2025 06:47:11 +0000 (GMT)
Message-ID: <4f939109-60b8-441f-b9c5-b27fa9efd9f4@linux.ibm.com>
Date: Mon, 7 Jul 2025 08:47:11 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] crypto: s390/sha - Fix uninitialized variable in SHA-1
 and SHA-2
To: Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>,
        Holger Dengler <dengler@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>, stable@vger.kernel.org
References: <20250627185649.35321-1-ebiggers@kernel.org>
 <20250703172032.GA2284@sol>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <20250703172032.GA2284@sol>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=GL8IEvNK c=1 sm=1 tr=0 ts=686b6d99 cx=c_pps a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=60ngpZ1s_TQx9FQ4v-QA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: P-8VuKcr_hXJCPy2aGgZlGXQVItTCWWs
X-Proofpoint-GUID: P-8VuKcr_hXJCPy2aGgZlGXQVItTCWWs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzA3MDAzNyBTYWx0ZWRfX7tkR9rx0uRZj MN2n67xReVirI58bh8hc3WredlwTtcLzqRXwW3Od1n+GY9i7SlV1JSD0OvBWJUA80SwVyoloQkj BlTQo+1s9T+GSabYcd7c9xpzvqZhG14VzO/DZGaHs6YYPBKK09fFFhW6gkBIRCR8JF7PVSTIaK4
 0GbQX71MzuUR3rTlZ4wgIckeZv41vFSta7R+zo5fhbqLegih+zbgPEoKVKXsrienQlObgjGx7ok P59i5nsiSzFtm1/UnR0N4xYsqIzItiJLW3y7JlkZ/b783TLO3i3ZjCTF051jFNwxmEXD/Uj8ynk 6dy7/st55VBHigFF6A8sES3PwuzrUjoTRp9XJYpj/z3HWtRRqUSAf9cZh96dI8d9sgUDBP10Cqg
 EpVgAMRTb+xt1cPgr2kP3Tq535G6T6Voeoocu7tHPBQHEyeHUsHYof2tgBaSQmgbeG2I/Quv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-07_01,2025-07-06_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0 phishscore=0
 clxscore=1015 impostorscore=0 suspectscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 mlxscore=0 spamscore=0 mlxlogscore=999
 lowpriorityscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507070037

On 03.07.2025 19:20, Eric Biggers wrote:
> On Fri, Jun 27, 2025 at 11:56:49AM -0700, Eric Biggers wrote:
>> Commit 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
>> added the field s390_sha_ctx::first_message_part and made it be used by
>> s390_sha_update_blocks().  At the time, s390_sha_update_blocks() was
>> used by all the s390 SHA-1, SHA-2, and SHA-3 algorithms.  However, only
>> the initialization functions for SHA-3 were updated, leaving SHA-1 and
>> SHA-2 using first_message_part uninitialized.
>>
>> This could cause e.g. CPACF_KIMD_SHA_512 | CPACF_KIMD_NIP to be used
>> instead of just CPACF_KIMD_NIP.  It's unclear why this didn't cause a
>> problem earlier; this bug was found only when UBSAN detected the
>> uninitialized boolean.  Perhaps the CPU ignores CPACF_KIMD_NIP for SHA-1
>> and SHA-2.  Regardless, let's fix this.  For now just initialize to
>> false, i.e. don't try to "optimize" the SHA state initialization.
>>
>> Note: in 6.16, we need to patch SHA-1, SHA-384, and SHA-512.  In 6.15
>> and earlier, we'll also need to patch SHA-224 and SHA-256, as they
>> hadn't yet been librarified (which incidentally fixed this bug).
>>
>> Fixes: 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
>> Cc: stable@vger.kernel.org
>> Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
>> Closes: https://lore.kernel.org/r/12740696-595c-4604-873e-aefe8b405fbf@linux.ibm.com
>> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
>> ---
>>
>> This is targeting 6.16.  I'd prefer to take this through
>> libcrypto-fixes, since the librarification work is also touching this
>> area.  But let me know if there's a preference for the crypto tree or
>> the s390 tree instead.
>>
>>  arch/s390/crypto/sha1_s390.c   | 1 +
>>  arch/s390/crypto/sha512_s390.c | 2 ++
>>  2 files changed, 3 insertions(+)
> 
> I just realized this patch is incomplete: it updated s390_sha1_init(),
> sha384_init(), and sha512_init(), but not s390_sha1_import() and sha512_import()
> which need the same fix...  I'll send a v2.

Good finding. Yes the import functions also need the fix.
Your updates in "[PATCH v2] crypto: s390/sha - Fix uninitialized variable in SHA-1 and SHA-2" look good.

> 
> - Eric


-- 
Ingo Franzki
eMail: ifranzki@linux.ibm.com  
Tel: ++49 (0)7031-16-4648
Linux on IBM Z Development, Schoenaicher Str. 220, 71032 Boeblingen, Germany

IBM Deutschland Research & Development GmbH
Vorsitzender des Aufsichtsrats: Gregor Pillen
Geschäftsführung: David Faller
Sitz der Gesellschaft: Böblingen / Registergericht: Amtsgericht Stuttgart, HRB 243294
IBM DATA Privacy Statement: https://www.ibm.com/privacy/us/en/
