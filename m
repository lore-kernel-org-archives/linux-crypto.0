Received: from skyblue.cherry.relay.mailchannels.net (skyblue.cherry.relay.mailchannels.net [23.83.223.167])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87463342505;
	Tue, 16 Dec 2025 06:27:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.223.167
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765866457; cv=pass; b=dtAkVvD3D8OFSscgUcy1r1DtE3mWNbaLqXd10WVnz+J8HF9bZi/AJ6GkDi3VndMzz+rgAhO3Oqx6iY+2ZI8dX7hEAxwhU8hmdMWLSg0BPB+VRpQZDodLRet1Gvjiiwai08s1sOpTSIjTVbI+duJqPRN2u4+WaASAcTAnBlBrhUE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765866457; c=relaxed/simple;
	bh=2HX+iyTI2nhDTetNjz1VA6cFR6d1f0jGZJJD4PYdU1Y=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=rlcMHA9FAOHe29gEqGar6c5TuhJ4AN7JPwE76zutaCIGYlljOgAla1xrh1XAVk4ZBl1lAW8Vb9WwA37HDSwKZE/fYLO7aJVZuLOLnEZvpWNTgHkOv7XvSh3ZS4iAiZqJynXVdEO3ev/mnWr+jSpmo3rnx+5ne21MZJLGtG5RrKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id; spf=pass smtp.mailfrom=kriptograf.id; dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b=oUlJAxzi; arc=pass smtp.client-ip=23.83.223.167
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kriptograf.id
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kriptograf.id header.i=@kriptograf.id header.b="oUlJAxzi"
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 154C87E147B;
	Tue, 16 Dec 2025 06:27:23 +0000 (UTC)
Received: from vittoria.id.domainesia.com (trex-green-3.trex.outbound.svc.cluster.local [100.108.222.12])
	(Authenticated sender: nlkw2k8yjw)
	by relay.mailchannels.net (Postfix) with ESMTPA id B30A97E146D;
	Tue, 16 Dec 2025 06:27:20 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1765866442;
	b=rh4jMOVvg87FPfamb9q/cP3dBCQLWaPnBg4BmOc2zl86PLsZft3YKNJ5zo8TUqyvJjFfq+
	wwOnhySI3Cus4QOFpd1oYWbBcTQEvj6wWlRTg5eaTvJJslOddYhLAXu3HwWm2AGOPjET9T
	VKFsGXtkHWXoMBT9/fmMOZuYEKZbE5j2xlcOsrlY4mmO5Fc0+BCG/A78faWipTnZCa1P/6
	kILdRMuVFH7UDuFAil2qAlXcdJyD6FZDAZFtY2FOKaswH0wyPAFRz70irYSg+1EvvP9wsn
	M3Ni8bcsyT4T4xJ5ibg7EpEdl+0/cVRT9m9OBRixikffx7wcYJXi1pZ4SMuklw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1765866442;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KorJU600z+R5PNfmucjVssTZylUXFYu4ZMCzYYIhrHM=;
	b=MftNh7o1eE4+n7JZtxFtxpiFbRWPr69q3nxQWUfjjofWz2Z17aU4weYbKcg8pSJQlGPTWZ
	7N7BMESz3vr6K8TXYU1Yq7dMpwjbOtaEieijAgHIGTwOrj0jz1F8H344jRO9JLyWo8ED4E
	pIR86vJDoopI5W7KIfhkB1f3rMtKHKTqVfjUCQKd4Kpld3jIzMGmLjB4SRiF/X4Sf3aikA
	8HFqIsFfelI9dn/DlQnrSbmQy1HbMrfHs4SFER6Jnxl5vQsWw3ZTkxNgLiYvHFSWQRPrwu
	gS/CDvu01PV/zQP9WHkE27IrMff2r+vzJvBijVArhglgOZfkkKcLTzZOCDV8Xw==
ARC-Authentication-Results: i=1;
	rspamd-6ccd5b4cc5-qqmlk;
	auth=pass smtp.auth=nlkw2k8yjw smtp.mailfrom=rusydi.makarim@kriptograf.id
X-Sender-Id: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MC-Relay: Neutral
X-MailChannels-SenderId: nlkw2k8yjw|x-authuser|rusydi.makarim@kriptograf.id
X-MailChannels-Auth-Id: nlkw2k8yjw
X-Language-Bottle: 179355a01912b46a_1765866442855_3593032431
X-MC-Loop-Signature: 1765866442855:2690762632
X-MC-Ingress-Time: 1765866442855
Received: from vittoria.id.domainesia.com (vittoria.id.domainesia.com
 [36.50.77.81])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.108.222.12 (trex/7.1.3);
	Tue, 16 Dec 2025 06:27:22 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=kriptograf.id; s=default; h=Content-Transfer-Encoding:Content-Type:
	Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=KorJU600z+R5PNfmucjVssTZylUXFYu4ZMCzYYIhrHM=; b=oUlJAxziDHKuQ6vWk7AUR9aWdA
	8Ot86AmRScHA7ZCjqaeGmNxPpqa3UteIlob6znRywrzoh24lOgVmvlSffk9ZCYr43PUBwIFv9Vnux
	AQT4iXhinsYHW+9DyK57tXDKPetiRerFOJR/uuMXP7Kai/U94Mix7dLEAlW2oLYFO4ZQfdNJPZxxb
	+1orcQYrq6EgVuX5e23PatYoiYv3nybsCjV+J3i/IAHDysyil/aptu7GUVg1fjXxXsucDekD1usKl
	Q0q0aPS8pZKMphns3Piri/KWTzoTUw2H7Ws+DEno4uiXQBCB5pt8ndltPCP5dlWNQCGN4qnAqnxv1
	Q3vSYlsg==;
Received: from [::1] (port=58966 helo=vittoria.id.domainesia.com)
	by vittoria.id.domainesia.com with esmtpa (Exim 4.99)
	(envelope-from <rusydi.makarim@kriptograf.id>)
	id 1vVOWl-0000000Ed2L-2Q3M;
	Tue, 16 Dec 2025 13:27:17 +0700
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 16 Dec 2025 13:27:17 +0700
From: "Rusydi H. Makarim" <rusydi.makarim@kriptograf.id>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller"
 <davem@davemloft.net>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Ard
 Biesheuvel <ardb@kernel.org>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org
Subject: Re: [PATCH 0/3] Implementation of Ascon-Hash256
In-Reply-To: <20251215201932.GC10539@google.com>
References: <20251215-ascon_hash256-v1-0-24ae735e571e@kriptograf.id>
 <20251215201932.GC10539@google.com>
User-Agent: Roundcube Webmail/1.6.11
Message-ID: <7920c742b3be0723119e19e323dc92bc@kriptograf.id>
X-Sender: rusydi.makarim@kriptograf.id
Organization: KriptografID
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-AuthUser: rusydi.makarim@kriptograf.id

On 2025-12-16 03:19, Eric Biggers wrote:
> On Mon, Dec 15, 2025 at 02:54:33PM +0700, Rusydi H. Makarim wrote:
>> This patch implements Ascon-Hash256. Ascon-Hash256 is a hash function 
>> as a part
>> 	of the Ascon-Based Lightweight Cryptography Standards for Constrained 
>> Devices,
>> 	published as NIST SP 800-232 
>> (https://csrc.nist.gov/pubs/sp/800/232/final).
>> 
>> Signed-off-by: Rusydi H. Makarim <rusydi.makarim@kriptograf.id>
> 
> What is the use case for supporting this algorithm in the kernel?  
> Which
> specific kernel subsystem will be using this algorithm, and why?

Ascon is a NIST standard (published in August 2025) for hashing, XOF, 
and AEAD in resource-constrained devices. Since it is a NIST standard, 
akin to AES and SHA-3, it will eventually find its way into the Linux 
kernel. It is only a matter of _when_ it becomes part of the kernel.

> There's a significant maintainence cost to each supported algorithm.  
> So
> if there's no in-kernel user, there's no need to add this.

While no direct in-kernel use as of now, adding this primitive now 
reduces the barrier for future adoption by kernel subsystems. 
Ascon-Hash256 specifically can serve as an alternative hash function to 
SHA-3 or Blake for existing use cases on devices that require more 
lightweight hashing.

The implementation of the standard starts with Ascon-Hash256 and is 
intentionally kept minimal to gather initial feedback. The final goal is 
to implement the complete NIST SP 800-232 in the kernel, which also 
includes Ascon-XOF128, Ascon-CXOF128, and Ascon-AEAD128.

> 
> - Eric

Best,
Rusydi
