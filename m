Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B21A1F3B98;
	Mon, 30 Jun 2025 06:26:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751264810; cv=none; b=FO6ph2hB4AM4tdF8B0rZu30Zrm5nz55jEVawvWctasZJlQiPzf48CLLqyQLTb4YRPBTR0lNl89VJT8KYohraXdw2PS1yRHpl4a4AMr+daooq4YfFd7AJcHw+Kl8loTfBTLh1YL6Ymh+Di1XDkmtrTT72a/F9fQ/1YDcahAvMeVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751264810; c=relaxed/simple;
	bh=024+tsePLny83kMXjlh/B6haC4PUiVYsj6TcbQgaNKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=orwKlz9lA+pCDYCFF17jNinEh53geQAZEyBuL6HFpOYFkhiZePkUgCTRhgKn15fqxg7+ErFvS6LCkzC45V7lxF49BhUfQjHHkUT34a1KX6eRoaAPMrELQXb6jW9Wkl+JsD1FTBmGEShx13tt/kyFGB0FHltasLourrCYEtu3LxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=h4t0hU2n; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="h4t0hU2n"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55TLk6m9014460;
	Mon, 30 Jun 2025 06:26:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=xCIFec
	DuINPO3P7OXrAmPX6DapMVf07uBGchDv6yepU=; b=h4t0hU2nW98FYOmpUEBkXh
	nMa3nS0x79ghZXjMcWSqynGwa9/93xmESj3F/sxrpr/zxVL9Tu+5m0uNMmvUYQlv
	58GmNKJHqa/TSjHtfeVSa1AN+mNdcBt+Sr0NQeBS4bzox4pQw+PG41cibRbmyEGq
	pg64RaJ/RO+INKiuDD+0lnEFy95rHaA2x6r9UqcoSf24jeWXqYmTlXJekRQc+Pph
	59um/eIhNaLhCEwJ0oCJQLB+6hAMfnD6eHMsmqbd85oJgtAa63kADHtsxBpOSG0s
	J+CSRQ+f0UaK7YjJmoZpFM/gG8/9AM8Nbt95o1xeC1k3rPc4RwQawhgCg1mIcSYw
	==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 47j82ffcmr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Jun 2025 06:26:42 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 55U5C8fw021934;
	Mon, 30 Jun 2025 06:26:42 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 47juqpcksg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 30 Jun 2025 06:26:41 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 55U6QZY817760658
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Jun 2025 06:26:35 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2D35320043;
	Mon, 30 Jun 2025 06:26:35 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CCAF520040;
	Mon, 30 Jun 2025 06:26:34 +0000 (GMT)
Received: from [9.111.156.176] (unknown [9.111.156.176])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 30 Jun 2025 06:26:34 +0000 (GMT)
Message-ID: <73477fe9-a1dc-4e38-98a6-eba9921e8afa@linux.ibm.com>
Date: Mon, 30 Jun 2025 08:26:34 +0200
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
        Herbert Xu <herbert@gondor.apana.org.au>,
        Heiko Carstens
 <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Sven Schnelle <svens@linux.ibm.com>,
        Joerg Schmidbauer
 <jschmidb@de.ibm.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
References: <20250627185649.35321-1-ebiggers@kernel.org>
Content-Language: en-US, de-DE
From: Ingo Franzki <ifranzki@linux.ibm.com>
In-Reply-To: <20250627185649.35321-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: 3SozlaM2b1kNs7lN5sFuK7jbSlFx0d1V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjMwMDA1MSBTYWx0ZWRfX8dq51yb8OAPy IszxwUDRw5DJwpyMa5dDAioygL0sZho0zCPxC5kLxBJwGw6TjQfoeF36duqw/Y2T+mTq0TqV4JT yB8cbzbHYjPQGSMwQbX8y5ngJrpvZp7USKzCGGY5Meh7RiiNABqWBXW1VH0bFjYVkjczCBdQ+s7
 2fh4lvZzvlQUCp6Fto2KX5rlVfh/uxxsz8TjNwRtByiCXCKP29RASAaQXvUsSq9iJxHibuRawbF dHnUTqbsb8qMGCYAipofyE60p+SfnzpdsOOkBtKonyYSFDFLuqoytgIWyax82hvJDQAu/ydMTDk COPCYvydiO7k+4GVQhnZpboJrpMkef8yAu5fX/y2P0NxnL/JbvM/yOJGmUQzkrWehOSPZWQoClA
 NbYbjrMQ8/+Jc1p0eIgHkT5rR/uhIU4B5f/ee9QFIVL9XdhtreX2VMnf70aPUgjxx0WIW2un
X-Authority-Analysis: v=2.4 cv=LpeSymdc c=1 sm=1 tr=0 ts=68622e22 cx=c_pps a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=DH-6JFOhguFvv42pJtQA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 3SozlaM2b1kNs7lN5sFuK7jbSlFx0d1V
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-30_01,2025-06-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 spamscore=0 bulkscore=0 lowpriorityscore=0 adultscore=0 clxscore=1011
 impostorscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 suspectscore=0
 malwarescore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2506300051

On 27.06.2025 20:56, Eric Biggers wrote:
> Commit 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")
> added the field s390_sha_ctx::first_message_part and made it be used by
> s390_sha_update_blocks().  At the time, s390_sha_update_blocks() was
> used by all the s390 SHA-1, SHA-2, and SHA-3 algorithms.  However, only
> the initialization functions for SHA-3 were updated, leaving SHA-1 and
> SHA-2 using first_message_part uninitialized.
> 
> This could cause e.g. CPACF_KIMD_SHA_512 | CPACF_KIMD_NIP to be used
> instead of just CPACF_KIMD_NIP.  It's unclear why this didn't cause a
> problem earlier; 

The NIP flag is only recognized by the SHA3 function codes if the KIMD instruction, for the others (SHA1 and SHA2) it is ignored.

this bug was found only when UBSAN detected the
> uninitialized boolean.  Perhaps the CPU ignores CPACF_KIMD_NIP for SHA-1
> and SHA-2.  Regardless, let's fix this.  For now just initialize to
> false, i.e. don't try to "optimize" the SHA state initialization.
> 
> Note: in 6.16, we need to patch SHA-1, SHA-384, and SHA-512.  In 6.15
> and earlier, we'll also need to patch SHA-224 and SHA-256, as they
> hadn't yet been librarified (which incidentally fixed this bug).
> 
> Fixes: 88c02b3f79a6 ("s390/sha3: Support sha3 performance enhancements")

If this patch is applied on 88c02b3f79a6 then the first_message_part field should
probably set to 0 instead of false, since only since commit 
7b83638f962c30cb6271b5698dc52cdf9b638b48 "crypto: s390/sha1 - Use API partial block handling"
first_message_part is a bool, before it was an int. 

> Cc: stable@vger.kernel.org
> Reported-by: Ingo Franzki <ifranzki@linux.ibm.com>
> Closes: https://lore.kernel.org/r/12740696-595c-4604-873e-aefe8b405fbf@linux.ibm.com
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This is targeting 6.16.  I'd prefer to take this through
> libcrypto-fixes, since the librarification work is also touching this
> area.  But let me know if there's a preference for the crypto tree or
> the s390 tree instead.
> 
>  arch/s390/crypto/sha1_s390.c   | 1 +
>  arch/s390/crypto/sha512_s390.c | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/arch/s390/crypto/sha1_s390.c b/arch/s390/crypto/sha1_s390.c
> index d229cbd2ba229..73672e76a88f9 100644
> --- a/arch/s390/crypto/sha1_s390.c
> +++ b/arch/s390/crypto/sha1_s390.c
> @@ -36,10 +36,11 @@ static int s390_sha1_init(struct shash_desc *desc)
>  	sctx->state[2] = SHA1_H2;
>  	sctx->state[3] = SHA1_H3;
>  	sctx->state[4] = SHA1_H4;
>  	sctx->count = 0;
>  	sctx->func = CPACF_KIMD_SHA_1;
> +	sctx->first_message_part = false;
>  
>  	return 0;
>  }
>  
>  static int s390_sha1_export(struct shash_desc *desc, void *out)
> diff --git a/arch/s390/crypto/sha512_s390.c b/arch/s390/crypto/sha512_s390.c
> index 33711a29618c3..e9e112025ff22 100644
> --- a/arch/s390/crypto/sha512_s390.c
> +++ b/arch/s390/crypto/sha512_s390.c
> @@ -30,10 +30,11 @@ static int sha512_init(struct shash_desc *desc)
>  	ctx->sha512.state[6] = SHA512_H6;
>  	ctx->sha512.state[7] = SHA512_H7;
>  	ctx->count = 0;
>  	ctx->sha512.count_hi = 0;
>  	ctx->func = CPACF_KIMD_SHA_512;
> +	ctx->first_message_part = false;
>  
>  	return 0;
>  }
>  
>  static int sha512_export(struct shash_desc *desc, void *out)
> @@ -95,10 +96,11 @@ static int sha384_init(struct shash_desc *desc)
>  	ctx->sha512.state[6] = SHA384_H6;
>  	ctx->sha512.state[7] = SHA384_H7;
>  	ctx->count = 0;
>  	ctx->sha512.count_hi = 0;
>  	ctx->func = CPACF_KIMD_SHA_512;
> +	ctx->first_message_part = false;
>  
>  	return 0;
>  }
>  
>  static struct shash_alg sha384_alg = {
> 
> base-commit: e540341508ce2f6e27810106253d5de194b66750

Reviewed-by: Ingo Franzki <ifranzki@linux.ibm.com>


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
