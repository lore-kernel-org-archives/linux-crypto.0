Received: from lelvem-ot02.ext.ti.com (lelvem-ot02.ext.ti.com [198.47.23.235])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC68E1D7E26;
	Fri,  4 Apr 2025 12:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.23.235
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743770438; cv=none; b=CT1L+HZZ/snoeubfk5S6v0Yn+XcN3rXrGkjHlGJGuwur0IdKb+br96qOFVgYxdrD+J3PSQL/GP7VVhE7Swz93iAy0+uNBWe3Srwz5NyGxkWsm0gq5gtTrNW4cIni5pSMhgi+klwqXsIFdadobDgHtTZK9kxRNfLAPx8RfuhtHr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743770438; c=relaxed/simple;
	bh=89neJgVwi0h8aXKOy7swYdp7ZNkwQFPUD9cASJEE9fQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=sSRxgNETZ+SCvoD2LcvE/NCtOC0XPOabJbZIW2Hgr6Rp2ikftN+ILX83z1H5XSAlq8AiRL+GLrTOpaipOB815mjoQXvy8oK5HITaCS6fcFmTkkVQxC8WwK0FZFeP+sQBUwsHYpDkGn7uMbq5V32zW28WrhdveX/uNXwVNM7hSb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Nc9h0mu2; arc=none smtp.client-ip=198.47.23.235
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Nc9h0mu2"
Received: from fllv0034.itg.ti.com ([10.64.40.246])
	by lelvem-ot02.ext.ti.com (8.15.2/8.15.2) with ESMTPS id 534CeRr1276837
	(version=TLSv1.2 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 4 Apr 2025 07:40:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1743770427;
	bh=kxiQY3N4ykwzgDm8fvtIm0ymVAuD8xrmmIdWe4wXE+E=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=Nc9h0mu2005x2eX/OeTXzRgzeHosu9jFNEvs3fl9dJiwV/F+zSFkUG0fzYntTcc2z
	 zLjKLFaIEN4Y8Y4qtt2jCtLup26UzSQdFE1i0NphZwzq5KNA1P7d5t8m6H2NZ0pIGH
	 J9Ex0PK8am0lI78+ICJg/xvzlJXmwJAqqCPa2Y9g=
Received: from DLEE106.ent.ti.com (dlee106.ent.ti.com [157.170.170.36])
	by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 534CeRJU091168
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 4 Apr 2025 07:40:27 -0500
Received: from DLEE100.ent.ti.com (157.170.170.30) by DLEE106.ent.ti.com
 (157.170.170.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Fri, 4
 Apr 2025 07:40:26 -0500
Received: from lelvsmtp5.itg.ti.com (10.180.75.250) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Fri, 4 Apr 2025 07:40:26 -0500
Received: from [172.24.227.40] (pratham-workstation-pc.dhcp.ti.com [172.24.227.40])
	by lelvsmtp5.itg.ti.com (8.15.2/8.15.2) with ESMTP id 534CeOMb060065;
	Fri, 4 Apr 2025 07:40:24 -0500
Message-ID: <8536cdf7-f4bd-4f9a-9eaf-9e38fba67741@ti.com>
Date: Fri, 4 Apr 2025 18:10:23 +0530
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 1/2] crypto: ti: Add support for SHA224/256/384/512 in
 DTHE V2 driver
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: "David S. Miller" <davem@davemloft.net>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Vignesh Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Kamlesh Gurudasani <kamlesh@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>
References: <20250218104943.2304730-1-t-pratham@ti.com>
 <20250218104943.2304730-2-t-pratham@ti.com>
 <Z8QSVLoucZxG1xlc@gondor.apana.org.au>
 <f7105c10-7e36-4914-a9e8-e83eb61f0189@ti.com>
 <104cdd15-8763-49fc-9f4b-9b21020bd6a1@ti.com>
 <Z-5IaY0JoTYcx1JW@gondor.apana.org.au>
 <8aa65022-8adc-4c4a-a812-11bfd64e628c@ti.com>
 <Z--zFB8Rm007AMzP@gondor.apana.org.au>
Content-Language: en-US
From: T Pratham <t-pratham@ti.com>
In-Reply-To: <Z--zFB8Rm007AMzP@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea


On 04/04/25 15:53, Herbert Xu wrote:
> Yes that's a common problem with crypto hash drivers that can't
> deal with a zero-length final update.  The best solution is to
> use a fallback for the final update if it turns out to be zero-length
> rather than retaining an extra block.  Hashing a single block for
> finalisation is simply not worth the overhead of setting up DMA and
> what not.
>
> The other option is to use the fallback to hash the extra block in
> the export function.
>
> Cheers,

Although yes the hardware cannot process zero length input, the actual
reason for doing this is to support the linux framework's
init-update-final flow on the hardware.

Our hardware can accept data as multiple packets, each of which can be
of any length. The only restriction it has is that only the last packet
can have arbitrary length, rest have to be a multiple of BLOCK_SIZE. The
hardware needs a bit to be set to indicate that the packet to be
submitted is the last data packet.

Now, in the crypto framework, there is no way to know if a particular
update call is the last update or if another update call will happen
after that. Therefore I am unable to set that bit in any invocation of
the update function. So I am retaining one block of data which is sent
to hardware in the final function, a place where we know for sure that
there is no more input coming now.

Regards
T Pratham <t-pratham@ti.com>

