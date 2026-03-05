Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6094F3195EA;
	Thu,  5 Mar 2026 07:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772695182; cv=none; b=KYRt3ENyi0C2zne8dZp2ulvFrmtTpe0HPobLK8B1zP/vteT5lwozT89XJ78pv/yddgxoWIb3gFghEXLKyi/KoGV+J63pn2trC/WA0D7B8G131tzRzqdRGULAH5RYHHloHAZGa3OShqDDHUMm5MsfpGTCtghjF4YSBssljOjzGA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772695182; c=relaxed/simple;
	bh=28Ie8QvorUqaeXyfBFib6Vpgd0CWzIv1/GxcOBEm6QM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qUaMZIsl+qgg1NZNx0NiIqR+cd/JUR2AaBUFVzTYHFI0YIR+0vSlgyEFZaMaBD6HtBAh+pJJWoKL1d6KQtOK3E0djmix7na4scecF0Dg3FtTQ3VlZHI2fnSDgpoTonMKDCAUtFBrgG/hJ75fgpdWQ9Bf8ol0/z/ol6QQvFSdzyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=4I6+dhHD; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="4I6+dhHD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1772695175; bh=28Ie8QvorUqaeXyfBFib6Vpgd0CWzIv1/GxcOBEm6QM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=4I6+dhHDnhoRF7n6JWdDE9O8fP3gN5EuF5Xg0PY1SoG7hZdINWPSf07YIsZbAfKUk
	 0RPU5iLbNHN5ZnGGUdWbVsEgJwbODOeQfmR0zkezNU4GngmeiKycX9nL4CzMY3a2ct
	 /YG+DJ/Fq7W0L4DmDNuUvVgsDmUPMR5Y4X676dsBNeygIP+Ce/g/WyZI9+3pRxI4pP
	 dNZ0TSX+Txu6tsTapGlZbfNVcNYCwDsTZ4ltdkSFo2Et32FQeyLliS+bY4IJqOzFY4
	 oSFlKqqhbmeq4y352WuXhw6/4KcvQdyYp725I00E8PYmA85ikTdLWMLw2+RKW/2OIg
	 ubv1nyl7WwjKA==
Message-ID: <952df8bf-0393-48a3-a844-e3acf13fd770@jvdsn.com>
Date: Thu, 5 Mar 2026 01:19:34 -0600
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH] crypto: testmgr - block Crypto API xxhash64 in FIPS mode
To: Christoph Hellwig <hch@infradead.org>, Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Alexandre Torgue <alexandre.torgue@foss.st.com>,
 linux-crypto@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev
References: <20260303060509.246038-1-git@jvdsn.com>
 <aab5ptuamQ7d_tTi@infradead.org> <20260303193102.GA2846@sol>
 <aagvBY-XMfPIqkDO@infradead.org>
Content-Language: en-US
From: Joachim Vandersmissen <git@jvdsn.com>
In-Reply-To: <aagvBY-XMfPIqkDO@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks for the discussion below, it sounds like I need to ensure 
dm-integrity can use lib/crypto (at least for xxhash64) before blocking 
it in the crypto API.

On 3/4/26 7:09 AM, Christoph Hellwig wrote:
> On Tue, Mar 03, 2026 at 11:31:02AM -0800, Eric Biggers wrote:
>>> It sounds like xxhash should be removed the crypto API entirely.
>>> There's no user of it, it's not crypto, and doing xxhash through
>>> the userspace crypto API socket is so stupid that I doubt anyone
>>> attempted it.
>> dm-integrity, which uses crypto_shash and accepts arbitrary hash
>> algorithm strings from userspace, might be relying on "xxhash64" being
>> supported in crypto_shash.  The integritysetup man page specifically
>> mentions xxhash64:
> Oh, ok.  So at least for now we need it, although it would be nice to
> convert dm-integrity to lib/crypto/ and limit it to the advertised
> algorithms (including xxhash).
>
>
