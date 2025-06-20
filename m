Received: from psionic.psi5.com (psionic.psi5.com [185.187.169.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDF7101EE;
	Fri, 20 Jun 2025 03:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.187.169.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750388885; cv=none; b=Kn7B1uNdQpea06K5HFl85fmSnRaZtgLb6uhX/FN3RddR8oQ83rShhifp0ngQFomZ3sc208QqxFNwsBd24Rnh0XN1y9sWVTXsBo3YPzanmi0fFjNj0PB0dvnypRoK4+qRGPfI9w18qp+nJv19K6AqPqSFJVf5Eo7tNy/qPGJwkiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750388885; c=relaxed/simple;
	bh=jVnlMGB2Gp+7PhxPSzMaL1mkyfhdpjLlkrpSBTpoITk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L0aGmbxZBBkizkWDQBJmit5KemOTdBEUDNBUHzCoWkh38kkeZKT3AXYHdQyKWazvyWcEqNDWMZnxaO+mfRCT+Q3M4pna6Zk92PgstfWowmHC1kuKYLVu2ktIvuaerXcfCXNT08u3HgQ6WdDXlOlzKBw3DJbx+9QHaa2P/uKSM4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de; spf=pass smtp.mailfrom=hogyros.de; arc=none smtp.client-ip=185.187.169.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=hogyros.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hogyros.de
Received: from [192.168.43.209] (om126234060233.16.openmobile.ne.jp [126.234.60.233])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(Client did not present a certificate)
	by psionic.psi5.com (Postfix) with ESMTPSA id 6E30F3F104;
	Fri, 20 Jun 2025 05:07:45 +0200 (CEST)
Message-ID: <99c059c6-6360-47d0-8513-7171d9f2e9af@hogyros.de>
Date: Fri, 20 Jun 2025 12:07:39 +0900
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 0/2] Add support for Texas Instruments DTHE V2 crypto
 accelerator
To: Eric Biggers <ebiggers@kernel.org>, T Pratham <t-pratham@ti.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley
 <conor+dt@kernel.org>, linux-crypto@vger.kernel.org,
 devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
 Kamlesh Gurudasani <kamlesh@ti.com>, Vignesh Raghavendra <vigneshr@ti.com>,
 Praneeth Bajjuri <praneeth@ti.com>, Manorit Chawdhry <m-chawdhry@ti.com>
References: <20250603124217.957116-1-t-pratham@ti.com>
 <20250617042755.GG8289@sol>
Content-Language: en-US
From: Simon Richter <Simon.Richter@hogyros.de>
In-Reply-To: <20250617042755.GG8289@sol>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

On 6/17/25 13:27, Eric Biggers wrote:

> Numbers, please.  What is the specific, real use case in Linux where this
> patchset actually improves performance?  Going off the CPU and back again just
> to en/decrypt some data is hugely expensive.

It would be cool to get some numbers from the IBM folks as well -- the 
NX coprocessor can do AES and SHA, but it is not enabled in the Linux 
kernel, only GZIP is (where I can definitely see a benefit, usually 
somewhere between 3 to 9 GB/s depending on how hard it needs to look for 
repetitions), so I'm wondering if that is an oversight, or deliberate.

I also wonder if for some hardware, we can get a speedup by offloading 
and polling for completion instead of waiting for an interrupt. It feels 
wrong, but the thread is blocked no matter what.

The other thing to ponder would be whether we can define a data size 
threshold where the offloading overhead becomes small enough that it's 
still worth it. That would also work for fscrypt, because with 4k 
blocks, it would simply never choose the offload engine.

    Simon
