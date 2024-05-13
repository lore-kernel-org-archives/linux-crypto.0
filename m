Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC4204C8F
	for <linux-crypto@vger.kernel.org>; Mon, 13 May 2024 01:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715562673; cv=none; b=PX4OP7dg0iVzV3FX1sEuASGVIjG6CixtgX3zsLz+5AELmZ+DPl8syaojAuDzB0Lc6JYvwDkfXYEc5xFB3sAey9UkZbZ/a/CvSuFrpk5fCacQrMU4lXrjYBLjjs9vJZJPJZdYGecIGPjtKy5JOsH6udgT2UivfMyfTpOgtc4cVvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715562673; c=relaxed/simple;
	bh=w46W7HNvi4A6GwaS03qHKYLbQeuitaJpONRVXPd/Kyo=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=GbQjIA4UkWLER5KpyVM3DsSrvztD3+YHqUPVBgh21VArjFq4n5xVZaMzAp0p9G+56WCQHg77wrORjIdih9sDLml9dvBDwWDXOhtp7y7ikEZLvdn6a5W3DhFwaMQ+QFR+D+qnlGYes8SLgAPqRoDeJpxNcYbur4SuIQglUWtBfZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=jhinwAQl; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="jhinwAQl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1715562665; bh=w46W7HNvi4A6GwaS03qHKYLbQeuitaJpONRVXPd/Kyo=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=jhinwAQlCO36fMxw6u9Q2+2MXMpSUWtv78Kvl2RxH90mG5y06HAOnf8ynIblbCQZB
	 uQMqD29ZaW3TGW3emUddjDmXPx6KOrsm7uQ508JSOL1f4R+qeuWfRdL1xhdasz5Eg4
	 cYqBwReBBS518otMe0M/K7Uzx3Xzy4Zu4oJuOsT+aVhL1qrPZbCOnKafZgCZdmSTpR
	 N7Heopbn7Vk5TlezgJF/yxvs8znFOO9qBitWNsmshHv5G2PK0fx2ankIosyhdy80Dt
	 DP+vgMBgeZaE6l3m828DyYPm9rpkeB06mRjHVI+OvwzEzozDXblQtoyQ4I19+pzVFk
	 E0ETljWYULVVQ==
Message-ID: <70b6dbf0-eb54-4e23-a295-6f7f0d02a23c@jvdsn.com>
Date: Sun, 12 May 2024 20:11:03 -0500
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
Content-Language: en-US
In-Reply-To: <D181O1G1V18T.1SFRUIEFUPCQI@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/12/24 6:11 PM, Jarkko Sakkinen wrote:
> On Sat May 11, 2024 at 9:23 AM EEST, Joachim Vandersmissen wrote:
>> v4: FIPS_SIGNATURE_SELFTEST_RSA is no longer user-configurable and will
>> be set when the dependencies are fulfilled.
>>
>> ---8<---
> This is in wrong place. If the patch is applied it will be included to
> the kernel git log. Please put your log before diffstat.
I will keep it in mind for the next round.
>
>> In preparation of adding new ECDSA self-tests, the existing data is
>> moved to a separate file. A new configuration option is added to
>> control the compilation of the separate file. This configuration option
>> also enforces dependencies that were missing from the existing
>> CONFIG_FIPS_SIGNATURE_SELFTEST option.
> 1. Please just call the thing by its name instead of building tension
>     with "the new configuration option".
> 2. Lacks the motivation of adding a new configuration option.
The configuration option is there to ensure that the RSA (or ECDSA) 
self-tests only get compiled in when RSA (or ECDSA) is actually enabled. 
Otherwise, the self-test will panic on boot. I can make this more 
explicit in the commit message.
>
>> The old fips_signature_selftest is no longer an init function, but now
>> a helper function called from fips_signature_selftest_rsa.
> This is confusing, please remove.
Fair enough, I'll remove it from the commit message.
>
> So why just send this and not this plus the selftest? Feels incomplete
> to me.

Do you mean the ECDSA self-test? I didn't include that one here because 
I didn't want to make the commit too big.

>
> BR, Jarkko
>
