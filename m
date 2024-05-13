Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B2DDF5B
	for <linux-crypto@vger.kernel.org>; Mon, 13 May 2024 01:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715564591; cv=none; b=FBTm30dAV028vJdWjv4ZX2BEcKWjRwecKOqmlZjMKy9jh0J7uNNihXDm1sKe0FDjxDs7aB1B7At+eRoO2ycFxva4lPDOJ9QURbwCa3yUq4LATsZ2PzgGDH5Jx6qxofDxRV08Glb7ez0h6XX6ilLCTXucqDz3VEMrjJz5N4jVcW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715564591; c=relaxed/simple;
	bh=zKZSziTUJTmrTnuQY0zdC2nbMNcolZRpm/qwf5CBgQE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=YW03RHrlxIeP5EXmcMO+VLWG1BJ8HH+OG7m6zfAkhIXJhHAULzlEDUCh/GgIi3Tsd65/erjxS91znjOby0iPFbFbuOTW8/Au8DetgyU3rdiL7Br8rb7d/5dWwQ3MEENUpaT+DLRvVuAQmo24pQMMfUo7kMMQ6tzAu/vQmXmiXfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=J0KPPhHH; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="J0KPPhHH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1715564589; bh=zKZSziTUJTmrTnuQY0zdC2nbMNcolZRpm/qwf5CBgQE=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=J0KPPhHHqXr5a2TnUcoQN9KAdFW34zDAgAUvmZU+I+lH4tTjWJc7o+B4GBT0P0Ahq
	 xLbOCVmONWtn9XGc548JHqaj5EQRhheWqetDp+DyFnDvORk3Lf7ZqZ+n5bfIpv0MuR
	 lVriKnoYTLgx5JteIAv1VJWh86LajkYPAzFOovoNy7C1bgQPOxooNQoxna3ESJ+p+7
	 WP+kjV5XWh2QuU+kONrqiRC0V/+RYoDIXmUCG5vRv8sk8i8pD7uPE9q2bSsIr4aEqu
	 RXgxXzrANeWxlLqULrc5ASrbKEYXjIhZJoVv/x+Smsp0fEtGEaF6hhV0YpczWba7xu
	 VooAzNVBCnLmA==
Message-ID: <29254c3b-7d99-4c60-9652-671921367a96@jvdsn.com>
Date: Sun, 12 May 2024 20:43:08 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Joachim Vandersmissen <git@jvdsn.com>
Subject: Re: [PATCH v4 1/2] certs: Move RSA self-test data to separate file
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>,
 David Howells <dhowells@redhat.com>, Simo Sorce <simo@redhat.com>,
 Stephan Mueller <smueller@chronox.de>
References: <20240511062354.190688-1-git@jvdsn.com>
 <D181O1G1V18T.1SFRUIEFUPCQI@kernel.org>
 <70b6dbf0-eb54-4e23-a295-6f7f0d02a23c@jvdsn.com>
 <D184NU1V1GK5.38B7O2NKVESUE@kernel.org>
Content-Language: en-US
In-Reply-To: <D184NU1V1GK5.38B7O2NKVESUE@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/24 8:32 PM, Jarkko Sakkinen wrote:
> On Mon May 13, 2024 at 4:11 AM EEST, Joachim Vandersmissen wrote:
>> On 5/12/24 6:11 PM, Jarkko Sakkinen wrote:
>>> On Sat May 11, 2024 at 9:23 AM EEST, Joachim Vandersmissen wrote:
>>>> v4: FIPS_SIGNATURE_SELFTEST_RSA is no longer user-configurable and will
>>>> be set when the dependencies are fulfilled.
>>>>
>>>> ---8<---
>>> This is in wrong place. If the patch is applied it will be included to
>>> the kernel git log. Please put your log before diffstat.
>> I will keep it in mind for the next round.
>>>> In preparation of adding new ECDSA self-tests, the existing data is
>>>> moved to a separate file. A new configuration option is added to
>>>> control the compilation of the separate file. This configuration option
>>>> also enforces dependencies that were missing from the existing
>>>> CONFIG_FIPS_SIGNATURE_SELFTEST option.
>>> 1. Please just call the thing by its name instead of building tension
>>>      with "the new configuration option".
>>> 2. Lacks the motivation of adding a new configuration option.
>> The configuration option is there to ensure that the RSA (or ECDSA)
>> self-tests only get compiled in when RSA (or ECDSA) is actually enabled.
>> Otherwise, the self-test will panic on boot. I can make this more
>> explicit in the commit message.
>>>> The old fips_signature_selftest is no longer an init function, but now
>>>> a helper function called from fips_signature_selftest_rsa.
>>> This is confusing, please remove.
>> Fair enough, I'll remove it from the commit message.
> Yeah, I mean it is good to enough to have a code change no need to
> document it here :-)
>
>>> So why just send this and not this plus the selftest? Feels incomplete
>>> to me.
>> Do you mean the ECDSA self-test? I didn't include that one here because
>> I didn't want to make the commit too big.
> So, I'd suggest to make a patch set with the second patch containing
> the tests.
I think this is part of a patch set, is it not? There should be a 2/2 
patch ("Add ECDSA signature verification self-test"), you should be on 
CC for that one too.
>
> BR, Jarkko
>
