Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CB6422EE3
	for <linux-crypto@vger.kernel.org>; Wed,  1 May 2024 03:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714532492; cv=none; b=DW6aaDL3/VXDDMPuasnU7HaPcd3qSCW3OrHyGWvMPsKKA0VYNJpoo/vtHvtFp60stbpHR+YuyRULjlaknfvtr1NGnLZldnCaa3u/6KZ+W9knq3h3wS1Zg0dKnC2cj9hv+S4BNpCnP6e5OxsFKhBxQCXWhVqumm/Fejp1D66qgMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714532492; c=relaxed/simple;
	bh=bDo4oRYbf4croWUFPynRoDuzCOPy3dg5iCM6HULHCvQ=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=trHdelwYq/Hxc4wnQbLK5SBsGxDIZX3uZagJ95FZu/M1g1KzRW9Q9eZpGJP/2/JFy8b0tdhUgaewrFuM+hmL6THjIKn8xXY5YhGgE9wHdaC9q+jV9AofsY7uxychYZkiD+qMtBK8mr/Q22P/dipUBCrTydalSnn2OGGgsQzyEkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=xuz3s0CY; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="xuz3s0CY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1714531966; bh=bDo4oRYbf4croWUFPynRoDuzCOPy3dg5iCM6HULHCvQ=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=xuz3s0CYI/nZ5qALiN6WqISD/SBQQRMeEW4syYI5GvZJCaWfTismLD2F8uAs0Ammu
	 MGmEcOvWLUWaNvpOsVUihlbWqSz2OvH8Ytc0bUsiOCLXpO98vFLwZi8hmMHaa422wz
	 FpWMIsqdudq8OwM+46laiM4NcgrSHgT/mgVo2LatoxsfypDsczY5Jy4TO4lvgKw6UT
	 GJCccSlCSz0exeIW0CsuqWVpXogB54PqdiFQeOoNKc689Ftd3oVNmus3m56txI7wmR
	 C08H4tiJjfub0T738tDyJJqs3zV/pRWOFJ14skq1uIixn5zoB8K8Z1z/TPponR126h
	 3AtfjydsmfnOQ==
Message-ID: <b2787b62-fd1e-4815-a1c1-6b2d567ab977@jvdsn.com>
Date: Tue, 30 Apr 2024 21:52:44 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Joachim Vandersmissen <git@jvdsn.com>
Subject: Re: [PATCH v2 1/2] certs: Move RSA self-test data to separate file
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
 Simo Sorce <simo@redhat.com>, Stephan Mueller <smueller@chronox.de>
References: <20240420054243.176901-1-git@jvdsn.com>
 <Zinnl2Y11i0GHLEO@gondor.apana.org.au>
Content-Language: en-US
In-Reply-To: <Zinnl2Y11i0GHLEO@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Herbert,

On 4/25/24 12:18 AM, Herbert Xu wrote:
> On Sat, Apr 20, 2024 at 12:42:42AM -0500, Joachim Vandersmissen wrote:
>> Herbert, please let me know if this is what you had in mind. Thanks.
> Thanks, it's pretty much what I had in mind.
>   
>> diff --git a/crypto/asymmetric_keys/Makefile b/crypto/asymmetric_keys/Makefile
>> index 1a273d6df3eb..4db6968132e9 100644
>> --- a/crypto/asymmetric_keys/Makefile
>> +++ b/crypto/asymmetric_keys/Makefile
>> @@ -24,6 +24,7 @@ x509_key_parser-y := \
>>   	x509_public_key.o
>>   obj-$(CONFIG_FIPS_SIGNATURE_SELFTEST) += x509_selftest.o
>>   x509_selftest-y += selftest.o
>> +x509_selftest-$(CONFIG_CRYPTO_RSA) += selftest_rsa.o
> This doesn't work if RSA is a module.  So you need to play a bit
> more of a game with Kconfig to get it to work.  Perhaps define
> an extra Kconfig option for it:
>
> config FIPS_SIGNATURE_SELFTEST_RSA
> 	def_bool (FIPS_SIGNATURE_SELFTEST=m && CRYPTO_RSA!=n) || CRYPTO_RSA=y
>
> and then
>
> x509_selftest-$(CONFIG_FIPS_SIGNATURE_SELFTEST_RSA) += selftest_rsa.o

After thinking about it for a while, I understand what you mean now. The 
current behavior of the patch seems to be that, if 
FIPS_SIGNATURE_SELFTEST=y but CRYPTO_RSA=m, the RSA signature self-test 
will not be executed. I believe your suggestion would explicitly encode 
that behavior in the Kconfig?

The most correct solution in that case would probably be executing the 
PKCS#7 self-test when the RSA module is loaded, but I don't think that's 
feasible in the current architecture.

Another option would be to simply add CRYPTO_RSA and CRYPTO_ECDSA as 
explicit dependencies to FIPS_SIGNATURE_SELFTEST, as Eric Biggers 
proposed. Perhaps nowadays everyone includes ECDSA already.

I'm currently leaning towards adding FIPS_SIGNATURE_SELFTEST_RSA (and 
similarly FIPS_SIGNATURE_SELFTEST_ECDSA) as user-facing configuration 
options that depend on CRYPTO_RSA (and CRYPTO_ECDSA) and 
FIPS_SIGNATURE_SELFTEST. Then, it is up to the user to select the 
correct self-tests they need. It would still allow the user to create 
the same configuration "error" where FIPS_SIGNATURE_SELFTEST=y and 
FIPS_SIGNATURE_SELFTEST_RSA=m, but I think that users which care about 
FIPS_SIGNATURE_SELFTEST are doing it in the first place for FIPS 
compliance reasons. In that case, a FIPS laboratory should review the 
configuration to verify that the correct self-tests are executed at the 
correct time.

>
> Thanks,
