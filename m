Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1151328B70;
	Wed, 26 Nov 2025 13:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764162006; cv=none; b=J77mZH7JGGgfcIrbhk+FkrMHYFX2msQBNXz+ph8gz5hx/KA9E3Ke/bM3MAps8qaHTz9w9EvpBRsBH4eLoYi4C2993whAiXOxvUGlK5jNOe8mD8ERwSH/3sicNJFNg3B0XH6J3CkcJbps0dIL+fpKTZssj9MfPUmOs5xSWgsq5h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764162006; c=relaxed/simple;
	bh=jUqpCDIZwPVSRPtJdQpy0TPLmnfdKzNPkcBe0a7YjD8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F5dIQX4ngMphOW3Y91LJ3vyUA/nsApZY76165M1RczW8lXAVJlbjyt0nEAMM+gXm3A476mTUyNqTZdPyBvdiIxQPeqsG7bmvwfPJrNgLEDUnPPTQXoAjD8GVETB3F9BbT+AC5gIla7sHKMMpqYzhrgqECcb/x2ERj6g9Fq12HpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UaRkS7kJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UaRkS7kJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E99C113D0;
	Wed, 26 Nov 2025 13:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764162003;
	bh=jUqpCDIZwPVSRPtJdQpy0TPLmnfdKzNPkcBe0a7YjD8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UaRkS7kJTFqy04jxn66rIXLVHe3E2T+WBadeFQZqU+QEeRTOTSQAeOpherpGuTZk6
	 7vOl3RI25L3rxKsHhvPaUyqG5w7JxyWM+rUGJ8oWJ/Eblnri6zdhm0z2KBtKFZRhBW
	 IlZ1WahRv3ueWBdlBQrLSQZohow/kazHl2KxyaeCIOvbmjMPw1jZVw4bPAVRt9TXkT
	 ckFNMPmgSkUkUZMsG6kei7MQjbR7jwGrw13TymLUzISw1CAQ2STW/EIc1vXJnDTssK
	 wE4VICScH5teXR8zQXWeCkhKppKFOtRYzla99oMe5kGi7r1evCuHUL125SgwNd+TZB
	 P0e3FG+L1tz6A==
Message-ID: <3d44957f-8c09-47f3-93e0-78a1d34adfd0@kernel.org>
Date: Wed, 26 Nov 2025 13:59:59 +0100
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: CAAM RSA breaks cfg80211 certificate verification on iMX8QXP
To: Vitor Soares <ivitro@gmail.com>, linux-crypto@vger.kernel.org,
 linux-kernel@vger.kernel.org, imx@lists.linux.dev
Cc: horia.geanta@nxp.com, pankaj.gupta@nxp.com, gaurav.jain@nxp.com,
 herbert@gondor.apana.org.au, john.ernberg@actia.se,
 meenakshi.aggarwal@nxp.com
References: <b017b6260075f7ba11c52e71bcc5cebe427e020f.camel@gmail.com>
 <ac727d79bdd7e20bf390408e4fa4dfeadb4b8732.camel@gmail.com>
Content-Language: en-US
From: Ahmad Fatoum <ahmad@kernel.org>
In-Reply-To: <ac727d79bdd7e20bf390408e4fa4dfeadb4b8732.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hello Vitor,

On 26.11.25 11:55, Vitor Soares wrote:
> ++imx@lists.linux.dev
> 
> On Mon, 2025-11-24 at 19:03 +0000, Vitor Soares wrote:
>> I’m currently investigating an issue on our Colibri iMX8QXP SoM running kernel
>> 6.18-rc6 (also reproducible on v6.17), where cfg80211 fails to load the
>> compiled-in X.509 certificates used to verify the regulatory database
>> signature.
>>
>> During boot, I consistently see the following messages:
>>  cfg80211: Loading compiled-in X.509 certificates for regulatory database
>>  Problem loading in-kernel X.509 certificate (-22)
>>  Problem loading in-kernel X.509 certificate (-22)
>>  cfg80211: loaded regulatory.db is malformed or signature is missing/invalid
>>
>> As part of the debugging process, I removed the CAAM crypto drivers and
>> manually
>> reloaded cfg80211. In this configuration, the certificates load correctly and
>> the regulatory database is validated with no errors.
>>
>> With additional debugging enabled, I traced the failure to
>> crypto_sig_verify(),
>> which returns -22 (EINVAL).
>> At this stage, I’m trying to determine whether:
>>  - This is a known issue involving cfg80211 certificate validation when the
>> CAAM
>> hardware crypto engine is enabled on i.MX SoCs, or
>>  - CAAM may be returning unexpected values to the X.509 verification logic.
>>
>> If anyone has encountered similar behavior or can suggest areas to
>> investigate—particularly around CAAM—I would greatly appreciate your guidance.
>>
>> Thanks in advance for any insights,
>> Vítor Soares
> 
> Following up with additional debugging findings.
> 
> I traced the -EINVAL to rsassa_pkcs1_verify() in the PKCS#1 v1.5 verification
> path. The check that fails expects a leading 0x00 byte in the RSA output buffer.
> To investigate further, I poisoned the output buffer with 0xAA before the RSA
> operation. CAAM RSA operation returns success, but the output buffer is never
> written to.
> 
> During debugging, I loaded cfg80211 multiple times and observed that
> sporadically one of the certificates gets verified correctly, but never both.
> 
> I confirmed that other CAAM operations work correctly by testing hwrng via
> /dev/hwrng, which produces valid random data.
> 
> Given that CAAM reports success but does not populate the RSA output buffer, the
> problem appears to be somewhere in the RSA execution flow (possibly in how the
> result buffer is handled or returned), but I don’t have enough insight into
> CAAM's RSA implementation or firmware interaction to pinpoint the exact cause.
> 
> As noted previously, blacklisting caam_pkc to force rsa-generic resolves the
> issue.

Just a shot in the dark, because I have no experience with i.MX8 beyond i.MX8M:

Is the CAAM cache-coherent on your SoC? If so does the DT specify dma-coherent
as it should? On i.MX8M, it's not cache-coherent, but on Layerscape it was and
the mismatch with the DT leads to symptoms matching what you are observing.

Off-topic remark: If you have performance comparison between running with and
without CAAM RSA acceleration, I'd be interested to hear about them.
At least for the hashing algorithms, using the Cortex-A53 (+ CE) CPU was a lot
faster than bothering with the CAAM "acceleration".

Cheers,
Ahmad



> 
> Regards,
> Vítor
> 
> 

