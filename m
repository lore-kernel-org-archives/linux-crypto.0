Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019394;
	b=Bkc+l0YK7dFRxqIl7yOYX4WjAYjESHmzFRvYud2Z53vzyjRgq6ubawQYwPG7nJBt60sI
	 nvD9fPybZcgjwzh6U6+NOqFtpYI6bJHX7z92FWn4PBTZeg2el+gF4DZzUyD6LdYo6+yVP
	 CaC8XND9nMCgoTXitUC96YRZNcFIf3lBRvkEB2EwW9DRoeiaGOQ144UryEG7JQCTuVNJ1
	 eccYZq+awprarFDGZyO8VFek2KiT0jMcMr0oIo726D/JZpkTYNEg1Jfdj0vlxse4TyS9S
	 34ibNfkt8RWIPZoIB/grzu3sk1JfbhbiyNCG4RnwFyyN1Ed+LQvE0LXJlswuWUpIOZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019394;
	h=Received:DKIM-Signature:Received:Received:X-ME-Sender:
	 X-ME-Proxy-Cause:X-ME-Proxy:Feedback-ID:Received:X-Mailer:
	 MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type:Content-Transfer-Encoding;
	bh=mpQ14+GdLtaXBs1vAiS/H/Eb+nDbMBoHEA7knBdij5w=;
	b=Ux/fdoAfuBW5vt4hpzPMh0Oa/qKzwr37CciBdPbdaMer9KYUwSOddoFNC4m2oq1Q2++I
	 kd9OHN+AoI/kr7mSD9RrOOLoU45c7YFkpLUJqC7DqU8W9DMKQt72KR4vk0w58bHbsbXCx
	 TOaIvFl4fR+ie/+uY9bOYQexHHZ+/MVEkDi891SMnTN+HRRQTLJQm15BNhoAuNIoZD/L7
	 BzGmVAp8vPZyC13Zp9M6oiHApVCxQd3FQZgicrFwHdcwtoyJoypRCTawMZsP5Z17DbAiI
	 kpbdwV02DvZXPnqhfwbfquajMF+hR7U1wHB7LWzLP0jbhxbJ7EPs25ORfXAeku6dNkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=itVYuwkl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFA69606A331
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 16:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=itVYuwkl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A8171F000CC
	for <linux-crypto@vger.kernel.org>; Wed, 18 Nov 2026 16:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795019394;
	bh=mpQ14+GdLtaXBs1vAiS/H/Eb+nDbMBoHEA7knBdij5w=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=itVYuwklDspWlq8vJuLDAGA1BJFiROvjYjwtu00NPmaoNsGBI5pGaiAdYCY1cACQb
	 4Q18QkeAg9JWB6kAb9BJTRYWmJu6TuGhElVXjyNRk/2FXq50BAKbQhWCo/Mw4/G7uA
	 h2aMq/hHt8ZWXhgzm//Kl3bnIb4N/BjwXeNZfymnIS565TxpxZpX08OxXOfy2wvvnQ
	 /rL8F6qCgjcNq7Ri58UZB5FN45K7tzPXg6AlU8WLPppmZTNhY9netCBkEWMuVZeXey
	 vlXqRXY19PYz7uoAtqkFPfkx61Ls+RQJ7BAxD01bsi+gOafvtSGcqHdJVoo41K0Ydt
	 IfAT6oASoNycA==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id A87E1198003A;
	Wed, 18 Nov 2026 11:29:52 -0500 (EST)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Wed, 18 Nov 2026 11:29:52 -0500
X-ME-Sender: <xms:f9L9apq19Ryr7KH_yz1NKM0WVlgkqCDGn_CUqRo_i2k_5FLZJCGvZA>
    <xme:f9L9ameCTefFfKes1BM-R9tXrz_bgszNxMo5ZLiMSDewgbdcDNCX37euaSaRH3gmf
    zS0xpvH8peQmc26kIKvnoZ7FGFuTrM0RvUKcZrVKv-Myv2ttp2zUT6j>
X-ME-Proxy-Cause: dmFkZTFAAJmpZpKPLgk3sScaSkQC9ZGHxDZWVPj0UB744Jregi1PyrTsYpTk8DjlRmYKsP
    xOAibSBE6NizBm1jUjeUnR/gwFgv84q4UZhl/va8bLULEPu1wpnSDNH91/ptYGybkwB0Dq
    Ox4KpPg+B3XHmoADUyjj6eeVma37k6LJdCJcHy5+NTChCRa8M346xYL8KpAGQgupRw1wGo
    8dRYUMFha8SEb7LhMQqsuR9j0EY3+2I0jvtF1tKSC0A90KJ5D+9OBB609tR5AI/7Y9uUhH
    mb6g+leHAQJnW0pg5z7S8QEMsuSZidbg+hWP5LKuUOzm+GfxnEocEuJ0kavRDDTXLaFZis
    UBxrdwr3mDp3JUwKd1My4ExGHTn1305j6DDGwsCLWu7BERhi19AWg6jR1kUpMJgGfceqnH
    rKlzwttwcsn8AMvrToeHyk8GhLpei4aV88BwdWpcfGqv38TuGovCC80XGAJ4y3IA77r13Y
    sctkSUjnBPLQZQyZvNwKrgaKjDBWdHudkBld/UeFMLtgSsFihLLUyXz4fCr0HCoPgphNAv
    +EDMHFmSvak/PvsJ2Umd8kbKbfMzlhurPYTmk8p97dbs2uSwMu712R6CLYsppowJ00rhd5
    /ybwCsRYphByL38iPr58OTcVGPE8+cNwPOdh4WCaoJmeLiHTiSo3xlz/t+fg
X-ME-Proxy: <xmx:gNL9aq27Gkfmzrmg3I6nY_fQ-y2YnfpF_jmeU85DI41TCwERolgt6Q>
    <xmx:gNL9amCwd1jJzdM9PyO__0YykA8zNeaiuTt0bG6daqVFR-OiKNXe0g>
    <xmx:gNL9auegJWLbuu6AuBsd2oxi2u44fAhleastDa9sbIlBeXjATiTy1Q>
    <xmx:gNL9ar5N-jaGZnSsAdScJ_btqRjM_7BugcLp442Q0ratAFWEGNjx9g>
    <xmx:gNL9apUoVwK7fM7E_seOREoSGMCJFEDmhESFxB8hHtCgf9gsyQKibXxU>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 5AD05F80093; Wed, 18 Nov 2026 11:29:51 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Wed, 18 Nov 2026 17:29:30 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Shreesh Adiga" <16567adigashreesh@gmail.com>,
 "Eric Biggers" <ebiggers@kernel.org>, "Demian Shulhan" <demyansh@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Message-Id: <de1538b0-bb42-4a7f-af9d-f7311a452fe1@app.fastmail.com>
In-Reply-To: <20261118160110.1662470-1-16567adigashreesh@gmail.com>
References: <20261118160110.1662470-1-16567adigashreesh@gmail.com>
Subject: Re: [PATCH] lib/crc: Add 4-way folding in NEON crc64_nvme implementation
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


On Wed, 18 Nov 2026, at 17:01, Shreesh Adiga wrote:
> Use 4-way folding in the shared NEON crc64_nvme for AArch64
> as well as AArch32. This improves performance by about 2x for 512 byte
> data size on Cortex-X925.
>
> Add similar optimizations from x86 implementation like reducing
> the 4x to 2x and doing a tail (len >= 32) 2x fold as well as partial
> block handling to process lengths which are not multiple of 16 bytes.
>
> The partial block stage is enabled only for AArch64 as it needs the
> 128-bit TBL instruction not available in AArch32.
> Modified the loop dispatch on AArch64 to allow any len >= 128 rather
> than just multiple of 16 bytes.
>
> Modified the pmull intrinsics from crc64-neon.h to use inline
> assembly as the intrinsic usage was causing the compiler to
> generate the fold constants via mov+movk+fmov/dup which was about 10
> instructions for 16-byte constant instead of expected adrp+ld1.
>

Why is that better?
