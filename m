Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34EEF79D2
	for <linux-crypto@vger.kernel.org>; Tue, 14 May 2024 02:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715654224; cv=none; b=HTT8HWKDA6G+o09kZOBkflpzc9zoOkpQi8iO/IJAP/nbIFTMU8TjnqJrgU65gpDj4ymDy+ZPR/P0J6K5HDL8UkKUMqrgqXWR7xsh1U3kd5aldZdam7IoDalMNpVxdVjREXPG1k8Xc6uzt9ztPJwkd388hwtyMoA3yvpT7GZTF64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715654224; c=relaxed/simple;
	bh=rnilAhcWeWPeF5qGzTqdMNMJZHqt8jgjKl8BwAtyqr4=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=H/rZQWpXBX9T064BVrcqBBhwC+cU+GfUe3TvPcRMywUKBHx2GA0AOFp8abNSAq5PN2DoDyY+zFVvzP40O5NLUT2dF7WmwLk3bKpkOm35pJDwxJF2vdiLrVzUvHHqcPEnZVjJFF/ydMocD/wMErUGse7XjqQCQSGB13k78ZjMQKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=pIZfIpTd; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="pIZfIpTd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1715654216; bh=rnilAhcWeWPeF5qGzTqdMNMJZHqt8jgjKl8BwAtyqr4=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=pIZfIpTdP4UlRyPWQCcf+wLl0OSAqTKnrr2UgwQVaY1i1JXZRa0wWygil4q+kTryr
	 QvTPrVuwUy4/oNSC9YTScqMu1haGe2lHbhRSA7ItylqqJIb6Xr8XPHktO0pkswJjil
	 Fx51FtClNaetlBdHKPZ/SS11TnMl0kps5fQCTcH8G6lu5NOllWyBelTAwEvVm1Zl7/
	 Q+OyR39Xq6gVmgVh/Tg6lso36xxO0HHf8b5TLFwktTXxP5rCO4ezxQMvjGZMxN22sn
	 TFEKw+85Zrn2YG8MfDIKnPXwP2zx6YN/8ooLE2NwrY/9URIEehTQm8L0k/AnUDg/Pe
	 FwYhpejFGlkyw==
Message-ID: <d65279ed-20cb-4e23-866c-43b6291f51e2@jvdsn.com>
Date: Mon, 13 May 2024 21:36:55 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Joachim Vandersmissen <git@jvdsn.com>
Subject: Re: [PATCH v5 1/2] certs: Move RSA self-test data to separate file
To: Jarkko Sakkinen <jarkko@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-crypto@vger.kernel.org,
 Simo Sorce <simo@redhat.com>, Stephan Mueller <smueller@chronox.de>
References: <20240513045507.25615-1-git@jvdsn.com>
 <D18SS8X9VV7L.28F9PNZ1PM96L@kernel.org>
Content-Language: en-US
In-Reply-To: <D18SS8X9VV7L.28F9PNZ1PM96L@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/13/24 3:26 PM, Jarkko Sakkinen wrote:
> On Mon May 13, 2024 at 7:55 AM EEST, Joachim Vandersmissen wrote:
>> +	pkcs7 = pkcs7_parse_message(sig, sig_len);
>> +	if (IS_ERR(pkcs7))
>> +		panic("Certs %s selftest: pkcs7_parse_message() = %d\n", name, ret);
> Off-topic: wondering if Linux had similar helpers for PKCS#1 padding
> (and if not, are they difficult to add)?
PKCS#7 here refers to the message container format, rather than the 
padding. Internally, the PKCS#1 v1.5 padding scheme will be used (see 
software_key_determine_akcipher). Unless you are referring to PSS 
padding (also defined in PKCS#1)?
>
> Anyway, looks good to me:
>
> Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
>
> BR, Jarkko
