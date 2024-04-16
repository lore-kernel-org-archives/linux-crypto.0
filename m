Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C54D312BF2A
	for <linux-crypto@vger.kernel.org>; Tue, 16 Apr 2024 13:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713274774; cv=none; b=rJv1JDWZLxB/NP152tbfb+MLDYBOdA9zel8oiy7xNa+XL9cENIav2/L5vJwhETox3J6gt6HAq0Eb6V4vIbrS9f+ZWEWs49a4RsVW9oRwEG+9p0k+WtXIDsL+++fBdTiIBMvzbGMGyk6L1eBVZ2wNXUdDd9KRXhveoB4eKSqCecg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713274774; c=relaxed/simple;
	bh=F9OFq/z74eWlMFBmDXJjb+g1/GnbUwvIHWMar0bLRUI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=M98nfqzc5FmqR+n5bcsGsBcKweC+zxtEIZ6PHWEkkMgiKHLJxpb+1sLdZnsM+j4Uzu45Bfgj/9ueYrAqr9tIbTJkIO5rm3Pyz2zNAtmpnJ4vUEnzK6KETPS+OuSWggwY/pZJEVL8GmQ/u+X3TlQr2uL0g7rPUDj5a2GM4LOK2/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=L2PkLp0S; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="L2PkLp0S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1713274770; bh=F9OFq/z74eWlMFBmDXJjb+g1/GnbUwvIHWMar0bLRUI=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=L2PkLp0SQsZq5fzawv5SZt58Ks/G0uMgIV1v1B6xsx36aWfg8IxiITa0qo8jkGHV2
	 11K4n8QDgWRFp3uLnJ59xeWYAz5G87zdAPMNF5Qd/ndNjizmcqUPEOT1XrSpNy7f2R
	 loA1RixDmcI/zuqMoJ7TwnYc4jFrP7U6qdP0Cj40uqUwb0oGk4YuuTI26x1V519k9c
	 UEHCJndOdKIE9vwh4tiCEFpx6CssP/7QYQXnHT7QuRP9AjNoiNM5pHCiJMw+wX1y3W
	 lJXqlH8r3OeZrBt4A9sEFouLJ2N3vusZXDb5atklppL6BYqWRbwLD4SJDt11oTT3WO
	 fOzgQ8/CO7XdA==
Message-ID: <65bb88b5-5071-4836-9923-939218d9a883@jvdsn.com>
Date: Tue, 16 Apr 2024 08:39:28 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Joachim Vandersmissen <git@jvdsn.com>
Subject: Re: [PATCH 2/2] certs: Guard RSA signature verification self-test
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
 Simo Sorce <simo@redhat.com>, Stephan Mueller <smueller@chronox.de>
References: <20240416032347.72663-1-git@jvdsn.com>
 <20240416032347.72663-2-git@jvdsn.com> <Zh494tFvPQhxJ8j4@gondor.apana.org.au>
Content-Language: en-US
In-Reply-To: <Zh494tFvPQhxJ8j4@gondor.apana.org.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Herbert,

On 4/16/24 3:59 AM, Herbert Xu wrote:
> On Mon, Apr 15, 2024 at 10:23:47PM -0500, Joachim Vandersmissen wrote:
>> Currently it is possible to configure the kernel (albeit in a very
>> contrived manner) such that CRYPTO_RSA is not set, yet
>> FIPS_SIGNATURE_SELFTEST is set. This would cause a false kernel panic
>> when executing the RSA PKCS#7 self-test. Guard against this by
>> introducing a compile-time check.
>>
>> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>
> The usual way to handle this is to add a select to the Kconfig file.

I did consider that initially, but I was unsure if this was the right 
path. From a conceptual standpoint, this module doesn't need the RSA (or 
ECDSA) functionality. If the algorithm is not present, it would be 
perfectly valid for the module to do nothing. However, I'm not opposed 
to removing the current check and adding the select to the Kconfig.

If I add a `select CRYPTO_RSA` to FIPS_SIGNATURE_SELFTEST, do you think 
I should do something similar for ECDSA as well (considering the other 
patch in this series)?

>
> Thanks,
