Received: from smtp.jvdsn.com (smtp.jvdsn.com [129.153.194.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5832BEC52
	for <linux-crypto@vger.kernel.org>; Thu, 18 Sep 2025 16:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.153.194.31
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758211249; cv=none; b=YBdRif6Plvig2xzzPUCUZT+ER9IOL65Mq74tnXqFJ1qE+xugYTakSAttpBf9NsFokRgbAomxyfEhr497KwZzInl1yOFDyQ/mbY/jZWRx5NvV0r9HRdc1RLE7nIoRh7rulsx0X42+EXQq9Nab4mdWeON5lq2BAGHurOrERq+KgQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758211249; c=relaxed/simple;
	bh=0GPdeU/qRjh5tWLuMbBylkFq7w6TBaUwp9I9W1xLQr8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=WtiEBUTwFyBN9Duc0bMDGZ4qFUKWK0t/Wfcnerx+iBGLpQjT7wuJTZW7TurHEO3NCWj4e8oaem+sGhjXf01adA1gnZQ0UTrACP9kyjY2MBSNeDL2T957Vw9VPUH467HwQpHRmlorbr2Gmi0CgLp/Pc7ajemHVGCbaBsJVkHjOZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com; spf=pass smtp.mailfrom=jvdsn.com; dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b=uqwIL/8Y; arc=none smtp.client-ip=129.153.194.31
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jvdsn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jvdsn.com header.i=@jvdsn.com header.b="uqwIL/8Y"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=jvdsn.com; s=mail;
	t=1758211247; bh=0GPdeU/qRjh5tWLuMbBylkFq7w6TBaUwp9I9W1xLQr8=;
	h=Date:To:Cc:From:Subject;
	b=uqwIL/8YO6W0SKjDsOYxXq8p3cHV5Y4XVGRxcLVB29nTn6y1IhO+04WG6Nuwt7s2z
	 6igXeRWZGB/fxFW4eTXSimLvIj6Aa5EZHD91DKC3tzAT7ZyX6qD+24ze5zRoHyidP8
	 4/Mwn6H7MBd0gOWuXR+ZeIKX322u029cZvHiifFy2K4ZF1RrvbvpaFo82joC9L9yO4
	 j/JcsMwXEzZnXz2h7DloNNjFhglrlblHNCOucm0KfoyJNZMOKO24z26emIF/vL3ah7
	 y+30imDwbHlgSAk7pp8CPgIdMCQxd26/pcaRW4YPxyi00zKDtqB/+fN701KhKj2zlD
	 aMVwqyPj9ud+A==
Message-ID: <0b7ce82a-1a2f-4be9-bfa7-eaf6a5ef9b40@jvdsn.com>
Date: Thu, 18 Sep 2025 11:00:45 -0500
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: en-US
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, simo@redhat.com
From: Joachim Vandersmissen <git@jvdsn.com>
Subject: FIPS requirements in lib/crypto/ APIs
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Eric,

I'm starting a new thread since I don't want to push the SHAKE256 thread 
off-topic too much.

One simple example of a FIPS requirement that I currently don't see in 
lib/crypto/ is that HMAC keys must be at least 112 bits in length. If 
the lib/crypto/ HMAC API wants to be FIPS compliant, it must enforce 
that (i.e., disallow HMAC computations using those small keys). It's 
trivial to add a check to __hmac_sha1_preparekey or hmac_sha1_preparekey 
or hmac_sha1_init_usingrawkey, but the API functions don't return an 
error code. How would the caller know anything is wrong? Maybe there 
needs to be a mechanism in place first to let callers know about these 
kinds of checks?

It would be great to have your guidance since you've done so much work 
on the lib/crypto/ APIs, you obviously know the design very well.

Kind regards,
Joachim

