Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2460227B50F
	for <linux-crypto@vger.kernel.org>; Wed,  1 Apr 2026 16:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775062131; cv=none; b=MEaFHIQeYtPDrA07aPAVdYrbporvM43NWYDyjaJW4zRRe8mBejjGgTSCLrgnGZ1BbISudiBnWzN2UjZUSgYoKEdDzWLjlCDpPrFDEV7RWeZjLLfRyvtYrSwRM9pzqyQNvf2UBEsR0TZKm3Mo7wUX/zEYPREHUoOY+jxXjdJeq4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775062131; c=relaxed/simple;
	bh=gQj+QgzcJJQt8oGoQE05yGLbjAMd3D2jR9zdzGyP7VQ=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=rdmLhcgHw6GzZHNFJ/4pHzLC7KGdfqqNZYiu2TQiswaOceKHYqo9mUnzjS0TKPoRWK7uTIeBaowCyY5DrxGMMPEbR88OnA0a5H4ND+b745afU4TrYVO7IiHh1xvhQyotZ0PwX0hyrd5Re9nSCzSXjlrkBRZCphTx7X+M4BjEpH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WOkCEne4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WOkCEne4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854D7C19421;
	Wed,  1 Apr 2026 16:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775062130;
	bh=gQj+QgzcJJQt8oGoQE05yGLbjAMd3D2jR9zdzGyP7VQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=WOkCEne4MKb3ffUPUTYBMtcBemO8LVSwA4luETTlhoNlwQd4IP8iCp54clr7Q4KfN
	 kaShlDIhOeNIldAqh8RUK+ZoEgLHnmhQvgvTWRIZeTNtykZC8+KQaIWwcifMesdCDD
	 LLAtCoGqL7HqSSzw1YasXd0kO6YCoU06f1TdMzyfItmNpE18fgMyO04po9nPnM+h2s
	 VeVv5YsMffmx2c4E5MLDADPX5lXjfCfeeJLMEew6v+GxdWTPIdaKXtaB2Fq5FjPVZf
	 pp+mIPsptV68J4UGumhFYMWUf1mEtre8M8jlQQbJDLeqqN0sKkuYeWM3gBeChI+DiK
	 RdQqeFYszwf1A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 6E6BFF4006A;
	Wed,  1 Apr 2026 12:48:49 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Wed, 01 Apr 2026 12:48:49 -0400
X-ME-Sender: <xms:cUzNaaFOzwFEV3Zclvi8j3J7RxPbaxlhgxcDhpulXgrjerTov9Fw5Q>
    <xme:cUzNaWL04_vqDWaQnIJctHOjv9bJCJFI9QeVaVbPHor2USwNjUbJhsx1teU06UCHl
    JR_IgBIiGQEH9KaBhaVCi_tFDuO7rAsaXFBMQLgsJgTMTqvsCd70CcK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdefieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceurghi
    lhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurh
    epofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcuuehi
    vghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeeijeef
    udenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrh
    guodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeelqdef
    fedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrhgurd
    gtohhmpdhnsggprhgtphhtthhopeegpdhmohguvgepshhmthhpohhuthdprhgtphhtthho
    peguvghmhigrnhhshhesghhmrghilhdrtghomhdprhgtphhtthhopegvsghighhgvghrsh
    eskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhinhhugidqrghrmhdqkhgvrhhnvghl
    sehlihhsthhsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoheplhhinhhugidqtg
    hrhihpthhosehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:cUzNaZMOJKK4YGzwooSGw8QYTQFKqCsAvr6z5KrxmaSDGKUWolZA-Q>
    <xmx:cUzNaXaUjKYZPZXrmb-XePklSx8yuI9UY0XbB5IYEbXYbm-D6GapCw>
    <xmx:cUzNabxN8O-05KqrlF5bsH6sw9gb0GT5qEXuqphVrtUZkju5pYOuuA>
    <xmx:cUzNaaLnpNsxT-sV8oK5YrpVXuAIp_a9pxQOUgHHoujrMufs2amyug>
    <xmx:cUzNadq-vFV0hhkvISmW5Nlt2HO9Ls58wkdZiV7rxFMuUStlUhS0Oh-1>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 4DACB700065; Wed,  1 Apr 2026 12:48:49 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A8AYNq7FA6_V
Date: Wed, 01 Apr 2026 18:48:28 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 "Demian Shulhan" <demyansh@gmail.com>
Message-Id: <e3f27e82-604c-4744-a2e9-bbf72dbafa44@app.fastmail.com>
In-Reply-To: <20260331224156.GB45047@quark>
References: <20260330144630.33026-7-ardb@kernel.org>
 <20260330144630.33026-12-ardb@kernel.org> <20260331224156.GB45047@quark>
Subject: Re: [PATCH 5/5] lib/crc: arm: Enable arm64's NEON intrinsics implementation of
 crc64
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Wed, 1 Apr 2026, at 00:41, Eric Biggers wrote:
> On Mon, Mar 30, 2026 at 04:46:36PM +0200, Ard Biesheuvel wrote:
>> Enable big-endian support only on GCC - the code generated by Clang is
>> horribly broken.
> [...]
>> +#if defined(CONFIG_ARM) && defined(CONFIG_CC_IS_CLANG)
>> +static inline uint64x2_t pmull64(uint64x2_t a, uint64x2_t b)
>> +{
>> +	uint64_t l = vgetq_lane_u64(a, 0);
>> +	uint64_t m = vgetq_lane_u64(b, 0);
>> +	uint64x2_t result;
>> +
>> +	asm("vmull.p64	%q0, %1, %2" : "=w"(result) : "w"(l), "w"(m));
>> +
>> +	return result;
>> +}
>
> Perhaps omit big endian support, and use the inline asm implementation
> of these functions with both gcc and clang?  The more unique
> combinations need to be tested to cover all the code, the higher the
> chance of one being missed in testing.
>

Yeah that should work.

> Also, leaving shared code in lib/crc/arm64/ will be confusing.  How
> about lib/crc/arm-common/, and crc64_nvme_arm64_c => crc64_nvme_neon()?
> Or even just put crc64-neon.c directly in lib/crc/.
>

Yeah the latter seems the most straight-forward.
