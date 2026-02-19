Received: from smtpx016.webglobe.com (smtpx016.webglobe.com [62.109.154.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E07B285071
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 21:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.109.154.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771534941; cv=none; b=WfCAX2kPgaOR32JUs2l5QyV7CCXO0fQNrOVGNDJLQqMer87bLuPI+sEqEyUKygrFLA9w2j8phj+3HMZcsYh4tJReAQuMmAoma/HF9j1+Wrs36xArwnDSC7uA7vgep3edSDdEJeLgl4nL9xmOyLz8SSFvgx62ai5azNdwb6nm+xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771534941; c=relaxed/simple;
	bh=53OoLdYIcSUJq5hEYaw+c97X5DzS0HjL77gVDb0QFwU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tNdXE/EcQuFy8xpZ0T0sDSF10mvx+UyjIYKPD4wNC1JzBu1KuIdvFfffCYVibGLVuRXK3kwpZNwl/TSmHR3lGb489fHdiP//rsTwIZPL43KILVlN03mOcZHIy6kHwUpoCOJc+9s8lduVHk2MHxEKwZcg14MZ+jZ6N4SmqMKEjSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mazyland.cz; spf=none smtp.mailfrom=mazyland.cz; dkim=pass (1024-bit key) header.d=mazyland.cz header.i=@mazyland.cz header.b=UvjhN2Lt; arc=none smtp.client-ip=62.109.154.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mazyland.cz
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=mazyland.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mazyland.cz header.i=@mazyland.cz header.b="UvjhN2Lt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mazyland.cz
	; s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=o8azI3YgsVJUscq36npznEoAypbz546hIs2YUtL/GQ0=; b=UvjhN2Ltem0fw3mBm/UbG8m4rB
	32Z6UivFFLBWmHcRj/sJe+f4i39s3lWucoMcAqM7dLzzQoZzua7Hx0wfwb1wxv0Y/5z3Ih4zyqR+l
	trKQiqFflnGWdOcDfBvl7oRCbNxHjLwZRx2WlhNHPNt5ZtdXpPlCX2TF11dUfzvoVu0Y=;
Received: from [62.109.151.60] (helo=mailproxy10.webglobe.com)
	by smtpx016.webglobe.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <milan@mazyland.cz>)
	id 1vtAtH-0014JR-Ta; Thu, 19 Feb 2026 21:44:51 +0100
Received: from 85-70-151-113.rcd.o2.cz ([85.70.151.113] helo=[192.168.2.14])
	by mailproxy10.webglobe.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.94.2)
	(envelope-from <milan@mazyland.cz>)
	id 1vtAtH-009IFJ-L9; Thu, 19 Feb 2026 21:44:51 +0100
Message-ID: <b999ee17-86ac-4000-88d7-c645bab08b41@mazyland.cz>
Date: Thu, 19 Feb 2026 21:44:50 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Using aes-generic, kind-of regression in 7.0
To: Eric Biggers <ebiggers@kernel.org>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
References: <a6d69da9-2979-4b51-8560-2a554b9f7dd1@mazyland.cz>
 <20260219201119.GA2396@quark>
Content-Language: en-US
From: Milan Broz <milan@mazyland.cz>
In-Reply-To: <20260219201119.GA2396@quark>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-Id: milan@mazyland.cz
X-Mailuser-Id: 923906

On 2/19/26 9:11 PM, Eric Biggers wrote:
> On Thu, Feb 19, 2026 at 07:49:18PM +0100, Milan Broz wrote:
>> Hi Eric,
>>
>> we see failures in cryptsetup testsuite, caused by commit
>> a2484474272ef98d9580d8c610b0f7c6ed2f146c "crypto: aes - Replace aes-generic with wrapper around lib"
>>
>> TBH I am not sure this is a regression, as the internal naming (like aes-generic) was not supposed
>> to be used in userspace. Unfortunately, it happened by (perhaps my) mistake with introducing "capi" syntax in dm-crypt.
>>
>> For example this command
>>    dmsetup create test --table "0 8 crypt capi:xts(ecb(aes-generic))-plain64 7c0dc5dfd0c9191381d92e6ebb3b29e7f0dba53b0de132ae23f5726727173540 0 /dev/sdb 0"
>>
>> now fails. Replacing "aes-generic" with "aes-lib" obviously works.
>>
>> Cryptsetup tests use aes-generic to simulate some of these "capi" fu***ups.
>> (LUKS now explicitly disables using that dash driver syntax.)
>>
>> I can fix cryptsetup testsuite, but I am not sure if anyone actually use this (specifically to avoid using aes-ni or some accelerated crypto drivers).
>>
>> I am not sure what to do with that... *-generic name could be used as some defaults.
>>
>> Is it worth to introduce some compat mapping, or just document this was just not a supported thing?
> 
> The crypto "driver names" have effectively always been an implementation
> detail and not useful to specify directly.  They have changed before,
> e.g. in v4.10 "xts(aes-generic)" changed to "xts(ecb(aes-generic))".  In
> practice, what users actually want is for the kernel to select the
> "best" implementation automatically, which is done by simply specifying
> the stable name "xts(aes)" rather than a specific driver name.

Sure, just dmcrypt cannot use "capi:xts(ecb(aes))-plain64" either.
For test using "capi:xts(aes)-plain64" should be ok, I will change it.

> The change of the CPU-based driver names to *-lib, which started for
> other algorithms in v6.16, reflect a simplification to not expose
> individual CPU-based implementations in the API.  Instead the
> traditional crypto API is now just implemented on top of lib/crypto/,
> which uses the "best" implementation automatically and by default.
> 
> This is the first issue report since that started.  So clearly this
> simplified approach has generally been working fine, as expected.
> 
> In this particular case, the user is just a test script.  Also, it seems
> it doesn't actually care that it gets the generic code specifically, but
> rather it just uses a "driver name" rather than a "name" to verify that
> dm-crypt's "capi:" syntax accepts "driver names" and not just "names".
> 
> So while we could introduce an "aes-generic" alias if absolutely needed,
> I don't think this test script is enough to motivate that.  For now the
> test script should just be updated to use the new driver name, or fall
> back to the old driver name if the new one isn't supported.  And yes, I
> recommend updating the cryptsetup documentation to clarify that
> specifying crypto "driver names" isn't really supported.  Actually, if
> that is done, maybe the test case isn't even needed at all anymore.

I do not think alias is needed until someone reports this for a real use case.
As I said, we do not support this is userspace libcryptsetup.

But as seen above, dmsetup allowed it if talking directly to dm-crypt.

Thanks,
Milan

