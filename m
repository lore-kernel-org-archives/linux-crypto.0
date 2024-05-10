Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5AB481C0
	for <linux-crypto@vger.kernel.org>; Fri, 10 May 2024 13:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715347131; cv=none; b=s8P6NwPls01/AB3X9IZDo8s2ZlEHbzZajfOw8KBaD/29bIA6ugbTJ3OTIMPKKR71lR12I1ZF7WjynjT7sEuuV17kw4i5e3FAd70NlWKcWib3Kqa/5lWKGDbKwHIBLxL0cEpc8pAmaQSqVpcrwVSlX9xEIzIj/lmbFv5WYR7yrfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715347131; c=relaxed/simple;
	bh=8voDxsXaWLfJmyIdei9zJXj+2XIuBxIzLnROKTgnVLY=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=XMMPsFvhK0/72rhU8wA1pwUkm8Dx07yj2zjGiM0/yj6AoVmBcmUbgROikzEbM8g8lqqRwPDBy4hsL3JmgrcmrU97wOSqvCOOicsxkpxGIAMIhREnFZMlQ3JVEYrL4t0w5etyr23BYdPp7ulOOvNp2LtY74s+D0OBU1q6SbspuwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=hKpA7b/C; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="hKpA7b/C"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1715347123; bh=8voDxsXaWLfJmyIdei9zJXj+2XIuBxIzLnROKTgnVLY=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=hKpA7b/Ck+8zyIghr64nl2nyf92zWvj5UaY6UQr+j3na4/TQLwmrzrP+zleMv5z3m
	 e1Vu1ZBWY3EkvbqlR6KAye8oG+krGn9VojknR34zFiJzojpI27tB7zBWH+JoLQ51EU
	 fLe7Mv9+d7xaKs7S/mlsO7iLEaoXCeg9yYI0XoLtlX4yrZsqX2dCJQS858W06Q2BmZ
	 hjULJoxHyuZC26bO0/AkfcMwbWfI3CMcMYSJx/1w5cyBEG5IDRB+ZTx4Rxph0aCR4L
	 ZSA7UK0TKtiYLYQ2AypMwgx5LYtK7/iWKtlPkI3NSjzA1Ww2cwPEz3KhC/DYTUlXH0
	 fMB/iih72mFGg==
Message-ID: <3303fb03-a2a7-4a2c-9b87-bb349b219d39@jvdsn.com>
Date: Fri, 10 May 2024 08:18:41 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Joachim Vandersmissen <git@jvdsn.com>
Subject: Re: [PATCH v3 1/2] certs: Move RSA self-test data to separate file
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
 Simo Sorce <simo@redhat.com>, Stephan Mueller <smueller@chronox.de>,
 Jarkko Sakkinen <jarkko@kernel.org>
References: <20240503043857.45515-1-git@jvdsn.com>
 <Zj3XtsHcwRAv_EvT@gondor.apana.org.au>
Content-Language: en-US
In-Reply-To: <Zj3XtsHcwRAv_EvT@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Herbert,

On 5/10/24 3:15 AM, Herbert Xu wrote:
> On Thu, May 02, 2024 at 11:38:56PM -0500, Joachim Vandersmissen wrote:
>> diff --git a/crypto/asymmetric_keys/Kconfig b/crypto/asymmetric_keys/Kconfig
>> index 59ec726b7c77..68434c745b3c 100644
>> --- a/crypto/asymmetric_keys/Kconfig
>> +++ b/crypto/asymmetric_keys/Kconfig
>> @@ -86,4 +86,14 @@ config FIPS_SIGNATURE_SELFTEST
>>   	depends on PKCS7_MESSAGE_PARSER=X509_CERTIFICATE_PARSER
>>   	depends on X509_CERTIFICATE_PARSER
>>   
>> +config FIPS_SIGNATURE_SELFTEST_RSA
>> +	bool "Include RSA selftests"
> Please don't ask questinons in Kconfig that we can avoid.  In
> this case I see no valid reason for having this extra knob.
>
> One question for FIPS_SIGNATURE_SELFTEST is enough.
Just to clarify, you'd like to see FIPS_SIGNATURE_SELFTEST_RSA 
automatically set based on the values in FIPS_SIGNATURE_SELFTEST, 
CRYPTO_RSA, etc.?
>
> Oh and please cc Jarkko Sakkinen <jarkko@kernel.org> since he
> picked up two earlier fixes for this and it's best if this went
> through his tree.
Will do, thanks.
>
> Thanks,
