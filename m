Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74BCE279DB7;
	Tue, 21 Oct 2025 07:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761031464; cv=none; b=nYfkeAfbamiSlv8ddSUImOATfcFdf7T+LliY72F/VhuUipbmUxzx7tcRA54D72BgD4iDqxTJGV5EDk9QO9eUZvT2SDgfQ0CfCuu9k0BMOYWXo5hiWNyowVLa/7NInyJGhWSoZKUrqngKFHH+Zan+TJv9j7X7zW0q5rrxHUdb5bs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761031464; c=relaxed/simple;
	bh=8FGv4hC6mcrzGKjeCbtsNd848JfuRjL+XHZUY+SVF0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KEfqIRldUCXSt8qHDlui+yiCcUJXnlrvBOxpQpKu26BGMZZKJjUFt+Z3icb+k2wHY5F9L3587lM8IM3vNPPujOjCQZuf7xxqvyPWJMUtIpR3gER2szKgaSuYHXM6Ioalxf6CMOdwn0kuN15huyvHd1IKKrx03sz/LU5On2nU1LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=XZOn2LlO; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="XZOn2LlO"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59L20BGw018800;
	Tue, 21 Oct 2025 07:24:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=HXWI+T
	s8pCwgXlqF9ZX9c6QddSbtqcgR4wef2xM111k=; b=XZOn2LlOvM6qvoqbJmxE9I
	m4ahI8rTLcbTLW89JgfMRUd76WCDAdhV4Re0fYa4hAhVurGbx015Kr7Epp7PPM7V
	/sEofMOiX4bT05Qn7VFEvC1ZGozLmQDvCwBmlCIT6bedUFp23EDoWWr+QvGWe+Jl
	CD4lopNDsxOxxwf63UrBYeBYoE7kv4SGSrFRVb7Bh/leiIGtN7k/+yIzkuM6/oUj
	RNe4RZHvSgvZCC+cwyOfdOxZtiRk814bETwB39R5opogKq7vyFmWM3ema1j8z+cY
	IJ9xzJ8oeP1rsnMSBtqlLhEJLm1C1G52oCFyTDMcXTGNj7dpY7crPrY+iIogzO9w
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v31rwn5w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 07:24:10 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59L4iK3P011020;
	Tue, 21 Oct 2025 07:24:09 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqx11aem-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 21 Oct 2025 07:24:09 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59L7O7ts57410014
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Oct 2025 07:24:07 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9A02220043;
	Tue, 21 Oct 2025 07:24:07 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 62F4420040;
	Tue, 21 Oct 2025 07:24:07 +0000 (GMT)
Received: from [9.111.135.235] (unknown [9.111.135.235])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 21 Oct 2025 07:24:07 +0000 (GMT)
Message-ID: <29e766ca-54e4-453d-9dfc-ea47e2a1f860@linux.ibm.com>
Date: Tue, 21 Oct 2025 09:24:06 +0200
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/17] lib/crypto: s390/sha3: Migrate optimized code into
 library
To: Eric Biggers <ebiggers@kernel.org>
Cc: David Howells <dhowells@redhat.com>, Ard Biesheuvel <ardb@kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-crypto@vger.kernel.org,
        Harald Freudenberger <freude@linux.ibm.com>
References: <20251020005038.661542-1-ebiggers@kernel.org>
 <20251020005038.661542-16-ebiggers@kernel.org>
 <51fc91b6-3a6e-44f7-ae93-aef0bcb48964@linux.ibm.com>
 <20251020175736.GC1644@sol>
From: Holger Dengler <dengler@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <20251020175736.GC1644@sol>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: zT6buMclKWapWi4nnatfkPLQYCGf-j05
X-Proofpoint-GUID: zT6buMclKWapWi4nnatfkPLQYCGf-j05
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX321FNgZAcduS
 SdqJvBMeFQRxpszMW1n5bOfEQgQ8fDxDBqytFvndUsVQOND990+XWCFt88GZCq6kjsAkWj7/QNQ
 t/ffVRUrQD+NdMDPZtWYHKG/gh1Tx89yw6eZI7LyaP5ggY2hpe03aQsO4mtA1TSwbtGD4EW4C5Z
 qF50iXcsC5yaCIySujOzUY1XEwb06+DqeIyVwJ6oJqM2zcF4dy4mz4LR/Bb7cLFjwLlpcxI+8c9
 a8X68CcmXuHKYN3juKdom4GVr6bOtZoE9p5i3X599IHoUFXAowsf/3u8zvUzlc42znfcHd6O/0N
 sRUOP7jz8DffEffmRGOBvnZXcWBvK3e+PCJcLCdrR814lJngfyn0A7tVSIRNqZfQXADAq8XIDVA
 jZIjqvkuy/mbbjbUam4sMSPkFMGpAg==
X-Authority-Analysis: v=2.4 cv=IJYPywvG c=1 sm=1 tr=0 ts=68f7351a cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=otLEo-FC9tDJaZkyYbEA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-20_07,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1015 suspectscore=0 spamscore=0
 bulkscore=0 adultscore=0 impostorscore=0 malwarescore=0 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022

On 20/10/2025 19:57, Eric Biggers wrote:
> On Mon, Oct 20, 2025 at 04:00:42PM +0200, Holger Dengler wrote:
>> On 20/10/2025 02:50, Eric Biggers wrote:
>>> Instead of exposing the s390-optimized SHA-3 code via s390-specific
>>> crypto_shash algorithms, instead just implement the sha3_absorb_blocks()
>>> and sha3_keccakf() library functions.  This is much simpler, it makes
>>> the SHA-3 library functions be s390-optimized, and it fixes the
>>> longstanding issue where the s390-optimized SHA-3 code was disabled by
>>> default.  SHA-3 still remains available through crypto_shash, but
>>> individual architectures no longer need to handle it.
>>>
>>> Note that the existing code used both CPACF_KIMD_SHA3_224 and
>>> CPACF_KIMD_SHA3_256 after checking for just CPACF_KIMD_SHA3_256, and
>>> similarly for 384 and 512.  I've preserved that behavior.
>>>
>>> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
>> The current code also cover a performance feature, which allows (on
>> supported hardware, e.g. z17) to skip the ICV initialization.
> 
> I'm not sure if by "ICV" you mean "Integrity Check Value" or "Initial
> Chaining Value", but SHA-3 doesn't have either of those.  It just starts
> with a state of all zeroes.  I assume that skipping the
> zero-initialization of the state is what you're referring to?

I meant "Initial Chaining Value". On s390, this memory is set to zero by the
KIMD/KLMD instructions so that it can be skipped in the init() calls.

>> support has been introduced with 88c02b3f79a6 ("s390/sha3: Support
>> sha3 performance enhancements"). Unfortunately, this patch removes
>> this support. Was this intended?
> 
> For now, yes.  I should have explained more in the patch, sorry.
> 
> As currently proposed, lib/crypto/sha3.c supports arch-specific
> overrides of sha3_absorb_blocks() and sha3_keccakf().  Those cover the
> Keccak-f permutation which is by far the most performance critical part.
> This strategy is working well in the SHA-2, SHA-1, and MD5 libraries,
> which support the same level of arch overrides.
> 
> We could update lib/crypto/sha3.c to allow architectures to override
> more of the code.  But we need to consider the tradeoffs:
> 
> - Risk of bugs.  QEMU doesn't support the s390 SHA-3 instructions, so no
>   one except the s390 folks can test the code.  I can try to write code
>   for you, but I can't test it.  And the s390 SHA-3 code has had bugs;
>   see commits 992b7066800f, 68279380266a5, 73c2437109c3.
> 
>   The first priority should be correctness.

Let me figure out, if me and my colleagues can do the testing for you.
Unfortunately, I'll be unavailable for the next two weeks. But I'll come back
with a solution for the testing.

> - The proposed change to the init functions would cause the format of
>   'struct __sha3_ctx' to be architecture-dependent.  While we can do
>   that if really needed, it's something that's best avoided for
>   simplicity.  It opens up more opportunity for error.

Would it make sense to provide a delayed zeroize mechanism of the initial
chaining value (ICV), and architectures may implement it or not? The feature
on s390 is exactly that: a delayed zeroize of the ICV, done by the instruction.

> - As I mentioned, Keccak-f is by far the most performance critical part
>   anyway.  The initial state is just all zeroes, and initializing it is
>   very lightweight.  Also consider that these contexts are often on the
>   stack, and people increasingly set the "init all stack variables to
>   zero" kernel hardening option anyway.
> 
>   I'll also note that commit 88c02b3f79a6 has no performance data in it.
>   So it's not clear that it actually helped much.
> 
> - The library has an optimization to greatly reduce the size of the
>   context: instead of buffering data separately, it just XOR's data into
>   the state.  So, if there's a sha3_*_init() followed by a sha3_update()
>   of less than 1 block, it will have to initialize the state anyway.  We
>   can delay it until that point on s390.  But again: complexity.
> 
> - These potential additional s390 optimizations would presumably help
>   the most on short messages.  However, on short messages, merely
>   switching to the library often gives a large performance improvement
>   due to eliminating the very slow call to crypto_alloc_shash().  That's
>   actually a lot more important.
> 
> I would suggest that we drop the sha3_*_init() optimization from
> consideration for now.  Providing overrides for the one-shot functions
> sha3_{224,256,384,512}() should be simpler as well as possibly a bit
> more useful, and I would suggest exploring that.

Ok, sounds reasonable.

> I guess I can try to write the code for you again.  But again, without
> QEMU support I cannot test it.  The first priority in cryptography code
> is correctness, so that's not a great position to be in.
> 
> Note that for new optimized code I'm requiring QEMU support for the
> instructions it uses.  This one would only be allowed because code that
> used these instructions already existed in arch/s390/crypto/.

Ok, I'll come back to you on that.

>> Please also add me and Harald Freudenberger to the cc: list for this patch.
> 
> Will do, thanks.
> 
> - Eric

-- 
Mit freundlichen Grüßen / Kind regards
Holger Dengler
--
IBM Systems, Linux on IBM Z Development
dengler@linux.ibm.com

