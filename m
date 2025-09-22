Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 484A430FC1F
	for <linux-crypto@vger.kernel.org>; Mon, 22 Sep 2025 13:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758548484; cv=none; b=A+GXqLPOs+Xxk8DAkve5ZNCKj9Kkxwxd5+jOw58knWWt29N61xJDE/70BdArj35x3V0/JjRO3byCVWilhCDAoKrAJ/twW1H51h+aEtFyN90ur1SNchNhP+5zv3YkTKi1Vah8jnVGHjREUM6sBK+ruia37PHhPZVL8rE91PWFEH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758548484; c=relaxed/simple;
	bh=3pffxAPW82e3AhNxnHqcp8O73gt6PCCosSGmkEMfSu4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DhMr8JRnl8eNDxFBgJ2R3LTtTJq7C/8/pBTy+iZ97wddN1SAjzsBUDOZT9gNDduR4+A5HB2si2A6nZeSWeupZrlCM11/mJcw/9ggm6VuSHyIJgrGBcMbqApp9JBfDK/No0nMANCmrjnhAH9znPTVtWxOAEuTDyOSMYFydJHvAps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=LK9oR6wz; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="LK9oR6wz"
Received: from [100.96.64.209] (unknown [52.167.112.163])
	by linux.microsoft.com (Postfix) with ESMTPSA id D9493201CEF4;
	Mon, 22 Sep 2025 06:41:15 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D9493201CEF4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1758548476;
	bh=ylETBWja8EbUsasSnjGC+nQTkKTblQhcblXxQog/jPQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LK9oR6wzabYaJEgz7arCXUYxgKJJ+lE5OKb1RYV/1wj6VR+pnnfURTtAaOGV+tuCd
	 QrQvxJCzIJRh0kQRmfUFm8OihYkCpoh0tMjinHq6FRJAzbroIxm6WPGituqaq5m5Ha
	 GD6iEvQqurs1J8OB+aBTNjVAgJB1yvQ4UtjM/Ubs=
Message-ID: <141f5673-ec0d-425e-8c02-29bc0e950fb1@linux.microsoft.com>
Date: Mon, 22 Sep 2025 09:41:14 -0400
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: FIPS requirements in lib/crypto/ APIs
To: Theodore Ts'o <tytso@mit.edu>, Eric Biggers <ebiggers@kernel.org>
Cc: Joachim Vandersmissen <joachim@jvdsn.com>, linux-crypto@vger.kernel.org,
 simo@redhat.com
References: <0b7ce82a-1a2f-4be9-bfa7-eaf6a5ef9b40@jvdsn.com>
 <20250918163347.GB1422@quark>
 <3e06f746-775e-4b9e-93c9-d1f51f77148f@jvdsn.com>
 <20250918180647.GC1422@quark> <20250919152216.GH416742@mit.edu>
Content-Language: en-US
From: Jeff Barnes <jeffbarnes@linux.microsoft.com>
In-Reply-To: <20250919152216.GH416742@mit.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 9/19/25 11:22, Theodore Ts'o wrote:
> On Thu, Sep 18, 2025 at 01:06:47PM -0500, Eric Biggers wrote:
>>> I'm more trying to figure out a general approach to address these kinds of
>>> requirements. What I usually see in FIPS modules, is that the FIPS module
>>> API is as conservative as possible, rather than relying on the callers to
>>> perform the FIPS requirement checks.
>> Aren't these distros including the modules within their FIPS module
>> boundary too?  It seems they would need to.
>>
>> Either way, they've been getting their FIPS certificates despite lib/
>> including non-FIPS-approved stuff for many years.  So it can't be that
>> much of an issue in practice.
> What I would recommend for those people who need FIPS certification
> (which is a vanishingly small percentage of Linux kernel users, BTW),
> that the FIPS module use their own copy of the crypto algorithms, and
> *not* depend on kernel lib/crypto interfaces.
>
> Why?  Because FIPS certification is on the binary artifact, and if
> there is a high-severity vulnerability. if you are selling into the US
> Government market, FEDRAMP requires that you mitigate that
> vulnerability within 30 days and that will likely require that you
> deploy a new kernel binary.
That *must* not be the recommendation of the kernel crypto team. Why 
bother developing and deploying a kernel that boots in fips mode at all 
if you recommend users not use it? More below.
>
> So it would be useful if the FIPS module doesn't need to change when
> your FEDRAMP certification officer requires that you update the
> kernel, and if the FIPS module is "the whole kernel", addressing the
> high-severity CVE would break the FIPS certification.  So it really is
> much better if you can decouple the FIPS module from the rest of the
> kernel, since otherwise the FIPS certification mandate and the FEDRAMP
> certification mandate could put you in a very uncomfortable place.

While the FIPS module is "the whole kernel", re-validation for most 
types of kernel upgrades may not prompt a full submission for FIPS 
certification. A CVE re-validation can be as simple as re-filing a 
description of the change to the module or worst case, a re-test of any 
crypto functions that were changed to support the CVE fix. The most 
expensive re-validation (other than a full submission) is the UPDT 
re-validation submission. In either case, the overhead of the 
re-validation is mostly with the CSTL, not with the government. The 
lion's share of the time for a FIPS 140-3 FS (full submission) 
certificate comes *after* the CSTL submits the validation to NIST.

And to be clear, the FedRAMP requirement is that FIPS certifications or 
re-validation be *filed* (not awarded) within 6 months of release of the 
crypto module ("the whole kernel"). The caveat here is that you have to 
have a certificate to file for a re-validation submission. Given NIST 
backlog, it doesn't seem likely that you'll avoid a full submission if 
you don't already have a 140-3 certificate.


> It's also why historically many companies who need to provide FIPS
> certification will carefully architect their solution so it is only
> dependent on userspace crypto.  A number of years ago, I was involved
> in a project at a former employer where we separated the crypto core
> of the OpenSSL library from the rest of OpenSSL, so that when there
> was a buffer overrun in the ASN.1 DER decoding of a certificate (for
> example), we could fix it without breaking the FIPS certification of
> the crypto core.  And we didn't even *consider* trying add a kernel
> crypto dependency.

IMO, this is an optimal solution for a specialized distro; 
general-purpose OS's *should* update and use the actively developed 
crypto api.

BTW, I agree with you that fewer Linux kernel users need to certify at all.

>
> One of the important things to remember is that as far as FIPS
> certification is concerned, the existence of remote privilege attacks
> don't matter, so long as you meet all of the FIPS certification
> security theatre.  But in the real world, you really want to fix high
> severity CVE's....
Please see FedRAMP's differentiation between update stream and 
validation module stream. 
https://www.fedramp.gov/resources/documents/FedRAMP_Policy_for_Cryptographic_Module_Selection_v1.1.0.pdf
>
> Cheers,
>
> 					- Ted
