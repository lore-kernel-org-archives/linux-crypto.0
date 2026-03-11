Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3B9D3112C1
	for <linux-crypto@vger.kernel.org>; Wed, 11 Mar 2026 11:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773229074; cv=none; b=GEh4XHMeFeVJ8nEG4JQ/m1vlaB4NXrvz/DsIzJHwS5++5UO35DQ050erruzdhRUEy5ufvJGZ7KUgKL/N1/IJNXX1k2nZuwshj9WajJ5AC9HrUUkne90M9X37xrl5OXtsa7j7RvKMEHYblgxmBdbmzkF8szB7ScdiHXR9E3T7aHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773229074; c=relaxed/simple;
	bh=ff+pXBeQYZn8RFe6o+a36HLt3pxRVxLEQHjKOdTQukQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rQJK9XkEoP6J4u+iGj0gGiWYiZELyholfZVZlIxF5YzWgtU8wlD0ZBOmOYSwFUY6mCDcSsuOp1lb7msgV3RYmszR6w0aeFNV0LmpoJpK0sRJkUC5x/xrlVV/xpsnzsmJUfbmMscZHqOp9jXErJgFjTnZoNoZvDj13qqR4nW2SWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1773229062-1eb14e06e90ada0001-Xm9f1P
Received: from zhaoxin.com (zxmail.zhaoxin.com [10.28.208.166]) by mx2.zhaoxin.com with ESMTP id nGhoytaVE1PTTgm4; Wed, 11 Mar 2026 19:37:42 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.208.166
Received: from [10.32.64.33] ([10.32.64.33] [10.32.64.33])
	by zhaoxin.com (f222c4) with ESMTPd96bc589c732e7081ec6e05da615502b
	Wed, 11 Mar 2026 19:37:41 +0800
X-Eyou-Smtpauth: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.32.64.33
X-Eyou-EnvelopeSender: AlanSong-oc@zhaoxin.com
Message-ID: <5fe5b47d-5065-4e74-b2b3-4685e74a1130@zhaoxin.com>
Date: Wed, 11 Mar 2026 19:37:39 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/3] lib/crypto: x86/sha1: PHE Extensions optimized
 SHA1 transform function
To: Eric Biggers <ebiggers@kernel.org>
X-ASG-Orig-Subj: Re: [PATCH v3 2/3] lib/crypto: x86/sha1: PHE Extensions optimized
 SHA1 transform function
Cc: herbert@gondor.apana.org.au, davem@davemloft.net, Jason@zx2c4.com,
 ardb@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
 x86@kernel.org, CobeChen@zhaoxin.com, TonyWWang-oc@zhaoxin.com,
 YunShen@zhaoxin.com, GeorgeXue@zhaoxin.com, LeoLiu@zhaoxin.com,
 HansHu@zhaoxin.com
References: <20260116071513.12134-1-AlanSong-oc@zhaoxin.com>
 <20260116071513.12134-3-AlanSong-oc@zhaoxin.com>
 <20260118003120.GF74518@quark>
 <220d9651-3edc-4dc1-9086-e3482d2d5da3@zhaoxin.com>
 <20260305191848.GE2796@quark>
Content-Language: en-US
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
In-Reply-To: <20260305191848.GE2796@quark>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Eyou-Sender: <alansong-oc@zhaoxin.com>
X-Vid: 2fb0dcdb3705844b70fe9b892319803300@zhaoxin.com
X-Barracuda-Connect: zxmail.zhaoxin.com[10.28.208.166]
X-Barracuda-Start-Time: 1773229062
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 3268
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.155697
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

On 3/6/26 03:18, Eric Biggers wrote:
> On Thu, Mar 05, 2026 at 09:37:01AM +0800, AlanSong-oc wrote:
>>> Also, the spec describes all four registers as both input and output
>>> registers.  Yet your inline asm marks %rax and %rcx as inputs only.
>>
>> Thank you for pointing this question out.
>>
>> On the one hand, when the '+' constraint modifier is applied to an
>> operand, it is treated as both an input and an output operand.
>> Therefore, %rsi and %rdi are considered input operands as well.
>>
>> On the other hand, after the instruction executes, the values in %rax,
>> %rsi, and %rcx are modified. These registers should therefore use the
>> '+' constraint modifier to inform the compiler that their values are
>> updated by the assembly code. We cannot rely on clobbers to indicate
>> that the values of input operands are modified following the suggestion
>> by gcc manual. However, since %rax is initialized with a constant value,
>> it does not need the '+' constraint modifier. It should can simply be
>> specified as an input operand.
>>
>> In addition, although %rdi itself is not modified by the instruction but
>> the memory it references may be updated, a "memory" clobber should be
>> added to notify the compiler about possible memory side effects.
>>
>> The corrected inline assembly should be written as follows:
>>
>>     asm volatile(".byte 0xf3,0x0f,0xa6,0xc8" /* REP XSHA1 */
>>                 : "+S"(data), "+c"(nblocks)
>>                 : "a"((long)-1), "D"(dst)
>>                 : "memory");
> 
> If the instruction both reads and writes %rax, then the constraint needs
> to be "+a", even if the C code doesn't use the updated value.  Otherwise
> the compiler can assume that the value stored in %rax is unchanged and
> optimize the code accordingly, for example by not reinitializing %rax if
> the constant -1 is needed again later on.
> 
> Yes, this means you'll need to move the constant -1 to a local variable.

Indeed, to ensure that the compiler generates correct binary code under
all optimization levels, the inline assembly should accurately describe
the behavior of the instruction. I will use a local variable initialized
to -1 for the instruction reads and writes %rax register in the next
version of the patch.

>>> As before, all these comments apply to the SHA-256 patch too.
>>
>> Surely, I will also apply all of the suggestions mentioned above to the
>> SHA-256 patch.
> 
> I also have to ask: are you sure you need SHA-1 to be optimized at all?
> SHA-1 has been deprecated for a long time.  Most users have moved to
> SHA-256 and other stronger algorithms, and those that haven't need to
> move very soon.  There's little value in adding new optimized code for
> SHA-1.
> 
> How about simplifying your patch to just SHA-256?  Then we can focus on
> the one that's actually important and not on the deprecated SHA-1.

It is true that SHA-1 is rarely used by most users today. However, it
may still be needed in certain scenarios. For those cases, we would like
to add support for the XHSA1 instruction to accelerate SHA-1.

Does the crypto community have any plans to remove SHA-1 support in
recent kernel versions?

Best Regards
AlanSong-oc


