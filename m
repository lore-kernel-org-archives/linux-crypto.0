Received: from mail.schwermer.no (mail.schwermer.no [49.12.228.226])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD210229B3D
	for <linux-crypto@vger.kernel.org>; Thu, 27 Feb 2025 10:49:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.12.228.226
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740653343; cv=none; b=cuQAOayquuAw3S8iE+GLuNd9yxjIFpH4jsFAT1hoI2oryt8VCc/GdgqsHYRHjkyUQCH+fh3hYoPBOTwEkhLhVdepApYkOSQeBFlof7bp4VhrKFKqB0fvKiGwIhk/pBXVXrKiFn0K7KjWgKZHsA34et0N3sZPcP0k2+A2pTfANA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740653343; c=relaxed/simple;
	bh=XFvITTT61Tv/+qqv77dTQmqL4vvdN5yvzPbBOCi9ogA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RyYvlXajxfoKXRN4uaZn4UFrP49H7EiYQUN0awAIKBIZXzpBcIgkmx9GILIIFlHHpNgKodUAqBanCnmwgMnuL3lFH32vSE5+fq1sAbeXFrQEivoTXNU+OLs9oxnuAhflWFvr2Of5vSRlWbWuuAT8LWvqLMmLozFronfr4uY56Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=svenschwermer.de; spf=pass smtp.mailfrom=svenschwermer.de; dkim=pass (2048-bit key) header.d=svenschwermer.de header.i=@svenschwermer.de header.b=I0SPPhL/; arc=none smtp.client-ip=49.12.228.226
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=svenschwermer.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=svenschwermer.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=svenschwermer.de header.i=@svenschwermer.de header.b="I0SPPhL/"
X-Virus-Scanned: Yes
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=svenschwermer.de;
	s=mail; t=1740653332;
	bh=XFvITTT61Tv/+qqv77dTQmqL4vvdN5yvzPbBOCi9ogA=;
	h=Subject:To:Cc:References:From:In-Reply-To;
	b=I0SPPhL/w6IL2Bl0YsVQbvaIIiJdoi/f8cWvdGxumek3ABzNZ9ZNWGSRuFxU3OzNM
	 ZyPJ/Am5levr7iK1BFcrSYFKRklRVmYJBFUtUGb39pwoZ5HETCfX+7qc3LdsGq0ZM1
	 pja92eNlS4H9dYOttQVHzeKGLA/EK3lyQ0pgjV8F4HPcFm7yChOq2XS+e9M3jZUyM7
	 MjbvYpMssWQ8S/99xFwkNcEQUDipTdk7ww5WFlDwjwZiA7wRk2r7NnUJ5WI8724WCt
	 w3JNGMMsF6ho0YQgUEaTWMHYxQznIPbmvaAYkgPVKxqAIxXJtMgKpnED/80lzOCPnk
	 lk/IW6ZIMwALw==
Message-ID: <97804db1-8c82-45dd-b4ed-569fc3fa7785@svenschwermer.de>
Date: Thu, 27 Feb 2025 11:48:51 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [PATCH 0/1] mxs-dcp: Fix support for UNIQUE_KEY?
To: David Gstir <david@sigma-star.at>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, shawnguo@kernel.org,
 s.hauer@pengutronix.de, "kernel@pengutronix.de" <kernel@pengutronix.de>,
 festevam@gmail.com, imx@lists.linux.dev, Richard Weinberger
 <richard@nod.at>, David Oberhollenzer <david.oberhollenzer@sigma-star.at>
References: <20250224074230.539809-1-sven@svenschwermer.de>
 <FDAF33B1-DE06-4A1F-BE9A-4E3E5EDE03D5@sigma-star.at>
Content-Language: en-US
From: Sven Schwermer <sven@svenschwermer.de>
In-Reply-To: <FDAF33B1-DE06-4A1F-BE9A-4E3E5EDE03D5@sigma-star.at>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi David,

I actually found documentation supporting my findings in the mean time:

 From the i.MX6ULL Security Reference Manual (section 5.3.4):

The OTP key (CRYPTO KEY) can be selected using the DCP_Control1[OTP_KEY] 
bit in the control field of the packet descriptor _or_ by using the key 
select 0xFF in the CTRL1 field of the descriptor.

However, this seems to be contradict by what's later stated in section 
5.3.6.4.2:

If the OTP_KEY value is set, the KEY_SELECT field from the Control1 
register indicates which OTP key is to be used.

After your test, I'll send a v2 with a reworded commit message 
incorporating this.

Sven

On 2/27/25 10:55 AM, David Gstir wrote:
> Hi Sven,
> 
>> On 24.02.2025, at 08:42, Sven Schwermer <sven@svenschwermer.de> wrote:
>>
>> Hi there,
>>
>> I'm not 100% certain about this patch but trial and error seems to
>> confirm that this patch makes it indeed possible to use UNIQUE_KEY which
>> I was not able to do with the current implementation.
>>
>> I would appreciate if somebody with access to this hardware could test
>> this independently, e.g. the folks at sigma star who authored the
>> original patch (3d16af0b4cfac).
> 
> thanks for the patch! I’ll test this on my end and will report back ASAP.
> 
> - David
> 
> 

