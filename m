Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=80.12.242.24
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793135842;
	b=HIUjELti3YO43ayYVFe5rtOFRgCa3S3Uc3JRG5k9Qs2QnuGEhPta3dj8GTBmS5vlEUzZ
	 AyGexJ3O3mhNY+5/SM0pESXabajz9x9WFp4Gp5FM2oq6RaIn6FUQC1eBxs8GaQvrT2qHT
	 DGIteQqV1WIQVh+oR90M/HtIugRRIzkQCO3x4kqo6mGd0C9yc55OVV9Ff9UXcO4D4uYLT
	 vDLWnzYaL6i4OoIwMNOrFXsIRZ1zXNY5zXR4Cy4vg/f3W38PshIOWgC6B2N48ur7NK/1X
	 48DlchIZyQnyMgz7/tPBB1I15Qp379Y3vZLL0xalPyR0WmCFNEse6iJScms7ve5xrNw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793135842;
	h=DMARC-Filter:Received:DKIM-Signature:X-ME-Helo:X-ME-Auth:X-ME-Date:
	 X-ME-IP:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=t7WWjDmCABciWDe9nArkCPlp3bT8ioJksoHBjAnN3e0=;
	b=5eV4XvRKB1UWHsvLmbFZkSvgLGeHM+ax7usP2F5kqfIy03asi9Oiw0iNX8ahhVFTJ4Ur
	 h9AeGnBJs4/oLNtUDXBg8SPMiSwiNkF6ZoIVok3kr6Az3S2qHQkckpKpNwcoorUxZEBq/
	 uNb+FZrC+FWSa0PmFBKoxHweRUf86nmaVTUy+clAGo/imItIUpe5DZYefwpfz3rAMJuC4
	 htq7/X9w8RQ5B1eydY2p7yQty8PIaHFWBvF7fa79q2kdsiX5SuP4JnnPzAvB5glNwCI8L
	 klgQScYZqYSJuPBtDq5Sy4gAKGgFJJVQafEkGLKMIE5RTRfbkSRrmWta1v88Lo5LH+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wanadoo.fr;
	spf=pass smtp.mailfrom=wanadoo.fr;
	dkim=pass header.d=wanadoo.fr header.i=@wanadoo.fr header.a=rsa-sha256 header.s=t20230301 header.b=NuScA407;
	arc=none smtp.remote-ip=80.12.242.24
Received: from smtp.smtpout.orange.fr (smtp-24.smtpout.orange.fr [80.12.242.24])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A91A606A31A;
	Tue, 27 Oct 2026 21:17:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A91A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wanadoo.fr header.i=@wanadoo.fr header.a=rsa-sha256 header.s=t20230301 header.b=NuScA407
Received: from [IPV6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e]
 ([IPv6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e])
	by smtp.orange.fr with ESMTPSA
	id LoXcx90ADnRVmLoXcxscA3; Tue, 27 Oct 2026 22:17:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1793135833;
	bh=t7WWjDmCABciWDe9nArkCPlp3bT8ioJksoHBjAnN3e0=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=NuScA407MaytI8sNKey5dKys2nzV031i0kQJskb5kYu7wpvUhmqIKYNBt+ZPpzsd0
	 DT0DZ9gZetlvID0jrwFNxkm9WFwuPiPxFFd+b1P3xOBrXS2wBkqWHl+Kfo3M9Uypst
	 h0AdaWLVjKpaeXyYDucWVk8lmqA0p0t8BnaMsQ3l9C5sDXzjAhNUU1fayTw8UM3Zjm
	 hAlBowVqPXcBcsb6FJbUFLpgTi/NtP6NdvyNOeSixsEybcWVodSh5EznCUkqbQvFST
	 3iqqggjvUsABV0DnuIar+cOvRf9awJ2zWGrET1NADJbrL8wHsfjqPCDTCLdTtl3Sho
	 EuNhg/xEDcQDA==
X-ME-Helo: [IPV6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Tue, 27 Oct 2026 22:17:13 +0100
X-ME-IP: 2a01:cb10:785:b00:26fb:aefb:6cd2:db0e
Message-ID: <67844d9d-d4d4-4026-9549-73589afcc1ff@wanadoo.fr>
Date: Tue, 27 Oct 2026 22:17:07 +0100
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] hwrng: cctrng - Fix an error handling path in
 cctrng_probe
To: Martin Kaiser <martin@kaiser.cx>
Cc: Hadar Gat <hadar.gat@arm.com>, Olivia Mackall <olivia@selenic.com>,
 Herbert Xu <herbert@gondor.apana.org.au>, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org, linux-crypto@vger.kernel.org
References: <b66b3df3d178a04b35690d0eb36dee409a95aa5d.1792782868.git.christophe.jaillet@wanadoo.fr>
 <auBfVkwtsMUdgyG9@akranes.kaiser.cx>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Content-Language: en-US, fr-FR
In-Reply-To: <auBfVkwtsMUdgyG9@akranes.kaiser.cx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 27/10/2026 à 09:22, Martin Kaiser a écrit :
> The sashiko review makes sense to me. We should probably call
> pm_runtime_put_noidle after post_pm_err.
> 
> Best regards,
> Martin
> 

I agree that my patch looks broken.

I've not followed all sashiko explanation, but usually I try to stay 
away from pm code, which most of the time looks too tricky for me.

So should something be fixed here, I'll leave it to you.

CJ

> Thus wrote Christophe JAILLET (christophe.jaillet@wanadoo.fr):
> 
>> If an error occurs after a successful cc_trng_pm_init() call, it must be
>> undone by a corresponding cc_trng_pm_fini() call.
> 
>> The commit in Fixes has erroneously updated the error handling path if
>> cc_trng_pm_get() fails.
> 
>> Fixes: 8bcd96893848 ("hwrng: cctrng - let devres enable the clock")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> ---
>> Compile tested only.
> 
>> This patch also undo the clean-up done by commit a7ea3d63e897 ("hwrng:
>> cctrng - simplify cctrng_probe()"). Keeping an error path makes sense with
>> 2 users. But if preferred, the missing cc_trng_pm_fini() could also be
>> added after the test for errors in cc_trng_pm_get().
>> ---
>>   drivers/char/hw_random/cctrng.c | 14 ++++++++++----
>>   1 file changed, 10 insertions(+), 4 deletions(-)
> 
>> diff --git a/drivers/char/hw_random/cctrng.c b/drivers/char/hw_random/cctrng.c
>> index 03401ee59a8e..608b3321c05a 100644
>> --- a/drivers/char/hw_random/cctrng.c
>> +++ b/drivers/char/hw_random/cctrng.c
>> @@ -524,8 +524,10 @@ static int cctrng_probe(struct platform_device *pdev)
> 
>>   	/* increment device's usage counter */
>>   	rc = cc_trng_pm_get(dev);
>> -	if (rc)
>> -		return dev_err_probe(dev, rc, "cc_trng_pm_get returned %x\n", rc);
>> +	if (rc) {
>> +		dev_err_probe(dev, rc, "cc_trng_pm_get returned %x\n", rc);
>> +		goto post_pm_err;
>> +	}
> 
>>   	/* set pending_hw to verify that HW won't be triggered from read */
>>   	atomic_set(&drvdata->pending_hw, 1);
>> @@ -534,8 +536,7 @@ static int cctrng_probe(struct platform_device *pdev)
>>   	rc = devm_hwrng_register(dev, &drvdata->rng);
>>   	if (rc) {
>>   		dev_err(dev, "Could not register hwrng device.\n");
>> -		cc_trng_pm_fini(drvdata);
>> -		return rc;
>> +		goto post_pm_err;
>>   	}
> 
>>   	/* trigger HW to start generate data */
>> @@ -548,6 +549,11 @@ static int cctrng_probe(struct platform_device *pdev)
>>   	dev_info(dev, "ARM cctrng device initialized\n");
> 
>>   	return 0;
>> +
>> +post_pm_err:
>> +	cc_trng_pm_fini(drvdata);
>> +
>> +	return rc;
>>   }
> 
>>   static void cctrng_remove(struct platform_device *pdev)
>> -- 
>> 2.56.0
> 

