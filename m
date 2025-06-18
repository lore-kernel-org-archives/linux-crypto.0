Received: from fllvem-ot04.ext.ti.com (fllvem-ot04.ext.ti.com [198.47.19.246])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCAFBA27;
	Wed, 18 Jun 2025 10:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.47.19.246
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750242637; cv=none; b=UobYy/c1WffGhy3Zi+tBSsgU+BeQfqTGvGNaQmofZnue1nLPLTyL+TSy7uXTql3oheTlbtSc+E/EPq6E3S7lHpGlFGCplIjiVx62QLrRrWd04xBb8of7D6H7uQs7cx+eKyfETU/PvjvH+wDu7rDtUkarRWVt8xuj2lVxITbhYm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750242637; c=relaxed/simple;
	bh=ZBNO8zEoLupIoPE/PYTkk6eaDkHBKU0qCQBdkKT4VDA=;
	h=From:To:CC:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=WJPTutyHsGPKLBbSq7XxQtVH93yNtaflY9IqBNl7l/py2hgHxUsmpIePbOX0p1VRveCS7dlbvqv21odinlg7qJJtu4Z8Mb9fljUdAzuLkoDbV8qA0sDnzr4LnEFUsZ+J0Aa12lzlnd7XN2VuNuhiNOfjYasuY+zoKadup5pmQIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com; spf=pass smtp.mailfrom=ti.com; dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b=Ub/Kaxz4; arc=none smtp.client-ip=198.47.19.246
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ti.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ti.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ti.com header.i=@ti.com header.b="Ub/Kaxz4"
Received: from lelvem-sh02.itg.ti.com ([10.180.78.226])
	by fllvem-ot04.ext.ti.com (8.15.2/8.15.2) with ESMTP id 55IAUEAE285503;
	Wed, 18 Jun 2025 05:30:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1750242614;
	bh=f6wkIpLIcAEQ8BY8G45z4AjojyUSWta3TPNhOAIvdnM=;
	h=From:To:CC:Subject:In-Reply-To:References:Date;
	b=Ub/Kaxz4fvhplIJBSiZhfasX4IPWPEvHn2tVaDgSIbIUYQWaTHwJA45HT2wqwvdQ2
	 OHlNV/sT2ik7mhKuoUweidb/VLjXXSy2CuacVEh54PZNAdBWrcGOp9BfdD+z+UUXS8
	 A4NTafOHDHIiUPB3gRuARkpeXNLWSnHM+9GV5gqo=
Received: from DFLE103.ent.ti.com (dfle103.ent.ti.com [10.64.6.24])
	by lelvem-sh02.itg.ti.com (8.18.1/8.18.1) with ESMTPS id 55IAUEpX294636
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-SHA256 bits=128 verify=FAIL);
	Wed, 18 Jun 2025 05:30:14 -0500
Received: from DFLE107.ent.ti.com (10.64.6.28) by DFLE103.ent.ti.com
 (10.64.6.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55; Wed, 18
 Jun 2025 05:30:14 -0500
Received: from lelvem-mr06.itg.ti.com (10.180.75.8) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.55 via
 Frontend Transport; Wed, 18 Jun 2025 05:30:14 -0500
Received: from localhost (kamlesh.dhcp.ti.com [172.24.227.123])
	by lelvem-mr06.itg.ti.com (8.18.1/8.18.1) with ESMTP id 55IAUD813320091;
	Wed, 18 Jun 2025 05:30:14 -0500
From: Kamlesh Gurudasani <kamlesh@ti.com>
To: Eric Biggers <ebiggers@kernel.org>, T Pratham <t-pratham@ti.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller"
	<davem@davemloft.net>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski
	<krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>, <linux-crypto@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Praneeth Bajjuri <praneeth@ti.com>,
        Manorit Chawdhry <m-chawdhry@ti.com>
Subject: Re: [PATCH v5 0/2] Add support for Texas Instruments DTHE V2 crypto
 accelerator
In-Reply-To: <20250617042755.GG8289@sol>
References: <20250603124217.957116-1-t-pratham@ti.com>
 <20250617042755.GG8289@sol>
Date: Wed, 18 Jun 2025 16:00:12 +0530
Message-ID: <87ikktgx57.fsf@kamlesh.mail-host-address-is-not-set>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-C2ProcessedOrg: 333ef613-75bf-4e12-a4b1-8e3623f5dcea

Eric Biggers <ebiggers@kernel.org> writes:

> On Tue, Jun 03, 2025 at 06:07:27PM +0530, T Pratham wrote:
>> This series adds support for TI DTHE V2 crypto accelerator. DTHE V2 is a
>> new crypto accelerator which contains multiple crypto IPs [1].
>> This series implements support for ECB and CBC modes of AES for the AES
>> Engine of the DTHE, using skcipher APIs of the kernel.
>> 
>> Tested with:
>> CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
>> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y
>> 
>> and tcrypt,
>> sudo modprobe tcrypt mode=500 sec=1
>> 
>> Signed-off-by: T Pratham <t-pratham@ti.com>
>> ---
>> [1]: Section 14.6.3 (DMA Control Registers -> DMASS_DTHE)
>> Link: https://www.ti.com/lit/ug/sprujb4/sprujb4.pdf
>
> Numbers, please.  What is the specific, real use case in Linux where this
> patchset actually improves performance?  Going off the CPU and back again just
> to en/decrypt some data is hugely expensive.
>
We don't really care about the speed here. These crypto accelerators are
from embedded system. Often less than 4 cores and this particular SOC
have variant with only one core.

ARMv8 is clocking at 1.4ghz and DTHEv2 at 400Mhz, so no way it can give
better performance number in term of speed. But crypto acclerators are
designed specifically for lower power consumption as well. ARMv8 crypto
extensions leverage SIMD registers, but dedicated crypto accelerator are
still more efficient. Think about battery operated low cost devices. 

These embedded devices are often in the open and vicinity of attacker.
Crypto accelerator are much more secure.[1]

Bottomline:
1. Crypto accelerators can deliver a higher cryptography performance.
2. Crypto accelerators can deliver better energy efficiency.
3. Cryptography hardware usually has lower timing and power side channel leakage than running
cryptography algorithms on the processor.

IPSEC and partition encryption/decryption/authentication use cases are bulk
operations and often have low setup cost than operation itself. 

[1] https://www.trustedfirmware.org/docs/Introduction_to_Physical_protection_for_MCU_developers_final.pdf

Cheers,
Kamlesh

> Note that the manual you linked to above explicitly states that the CPU supports
> the ARMv8 Cryptography Extensions.  That definitively makes any off-CPU offload
> obsolete.  But even without that, these sorts of off-CPU offloads have always
> been highly questionable.
>
> I think it's implausible that this patchset could actually be beneficial.
>
> In fact, it might actually be really harmful.  You set your algorithms to
> priority 30000, which makes them be prioritized over ARMv8 CE.  I've seen
> exactly that bug with other "accelerators", which actually regressed performance
> by over 50x compared to simply staying on the CPU.
>
> - Eric
