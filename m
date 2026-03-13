Received: from mx2.zhaoxin.com (mx2.zhaoxin.com [61.152.208.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19A1C29D267
	for <linux-crypto@vger.kernel.org>; Fri, 13 Mar 2026 02:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=61.152.208.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773370702; cv=none; b=iSR4xXfEDSeeKsUoB676oj0bOyOSq5aUMtd6fL54XecPVKKq3uZ4Ug/L7gDvVJGtQqwpi5wIAulbuqs0WP+OD/jVAy8psw5xLPirtgc0SixcOLLGkeZiMu7pXEGLG+Blz8s7GaODSpcpQ+UGAQcaalu3ix1BHgUwWzUGMiiQtJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773370702; c=relaxed/simple;
	bh=IR6A1otHvf3tVVQgSCtTc/HEsus/LQOysEV3QirjPrs=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=G84luLxbdurleOT58xN/9iEPu50ptybSOk3upXlCnKIf2pwgtT0SLaEvY1kfnSCclLOHk1oQu2uqvOanALyqJrCFUWg+LlGyjj5umgWFXdEW/2zLy75tJupM60JhZ56AtOcaVOWXY7WKM+KJ75VEmGmhGqrE+p8SsG51msuB1fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com; spf=pass smtp.mailfrom=zhaoxin.com; arc=none smtp.client-ip=61.152.208.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zhaoxin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=zhaoxin.com
X-ASG-Debug-ID: 1773370690-1eb14e06e90f430001-Xm9f1P
Received: from zhaoxin.com (zxmail.zhaoxin.com [10.28.208.166]) by mx2.zhaoxin.com with ESMTP id MjeYRtkynTMtLBAv; Fri, 13 Mar 2026 10:58:10 +0800 (CST)
X-Barracuda-Envelope-From: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.28.208.166
Received: from [10.32.65.155] ([10.32.65.155] [10.32.65.155])
	by zhaoxin.com (f222c4) with ESMTPdae4bc1f931dac3f0c95d5cdb8b4502d
	Fri, 13 Mar 2026 10:58:08 +0800
X-Eyou-Smtpauth: AlanSong-oc@zhaoxin.com
X-Barracuda-RBL-Trusted-Forwarder: 10.32.65.155
X-Eyou-EnvelopeSender: AlanSong-oc@zhaoxin.com
Message-ID: <4b65047a-2a2f-4fd7-a349-525cf12d85c4@zhaoxin.com>
Date: Fri, 13 Mar 2026 10:58:07 +0800
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: AlanSong-oc <AlanSong-oc@zhaoxin.com>
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
 <5fe5b47d-5065-4e74-b2b3-4685e74a1130@zhaoxin.com>
 <20260312040349.GA2359@sol>
Content-Language: en-US
In-Reply-To: <20260312040349.GA2359@sol>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Eyou-Sender: <alansong-oc@zhaoxin.com>
X-Vid: db7c8240c37d388c8148c185a68e628300@zhaoxin.com
X-Barracuda-Connect: zxmail.zhaoxin.com[10.28.208.166]
X-Barracuda-Start-Time: 1773370690
X-Barracuda-URL: https://10.28.252.36:4443/cgi-mod/mark.cgi
X-Virus-Scanned: by bsmtpd at zhaoxin.com
X-Barracuda-Scan-Msg-Size: 2664
X-Barracuda-BRTS-Status: 1
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0000 1.0000 -2.0210
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=1000.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.3.155771
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------

On 3/12/26 12:03, Eric Biggers wrote:
> On Wed, Mar 11, 2026 at 07:37:39PM +0800, AlanSong-oc wrote:
>>> I also have to ask: are you sure you need SHA-1 to be optimized at all?
>>> SHA-1 has been deprecated for a long time.  Most users have moved to
>>> SHA-256 and other stronger algorithms, and those that haven't need to
>>> move very soon.  There's little value in adding new optimized code for
>>> SHA-1.
>>>
>>> How about simplifying your patch to just SHA-256?  Then we can focus on
>>> the one that's actually important and not on the deprecated SHA-1.
>>
>> It is true that SHA-1 is rarely used by most users today. However, it
>> may still be needed in certain scenarios. For those cases, we would like
>> to add support for the XHSA1 instruction to accelerate SHA-1.
>>
>> Does the crypto community have any plans to remove SHA-1 support in
>> recent kernel versions?
> 
> It's already possible to build a kernel without SHA-1 support.  SHA-1
> has been cryptographically broken and is considered obsolete.
> Performance-critical hashing in the kernel already tends to use SHA-256.
> 
> These patches already feel marginal, as they are being pushed without
> QEMU support, so the community will be unable to test them.  The only
> reason I would consider accepting them without QEMU support is because
> there was already code in drivers/crypto/ that used these instructions.

Sorry for the inconvenience caused by the inability to test provided
patches, as QEMU currently does not support emulation of the XSHA1 and
XSHA256 instructions.

Besides, since the previous patch adding XSHA384 and XSHA512 instruction
support was not accepted, I would like to ask whether adding emulation
support for XSHA384 and XSHA512 instructions in QEMU would help the
crypto community evaluate and accept the corresponding kernel patches.

> It also helps that they are just single instructions.  Though, even with
> that I still found a bug in the proposed code as well as errors in the
> CPU documentation, as mentioned.  And the drivers/crypto/ implementation
> that uses these instructions is broken too, as you're aware of.
> 
> Overall, it's clear that platform-specific routines like this are very
> risky to maintain without adequate testing.  Yet, correctness is the
> first priority in cryptographic code.
> 
> So I would suggest that to reduce the risk, we focus on just one
> algorithm, SHA-256.  Note that this makes your job easier, as well.

Thanks for your suggestions. I will only add XSHA256 instruction support
for the SHA-256 algorithm in the next version of the patch.

Best Regards
AlanSong-oc
