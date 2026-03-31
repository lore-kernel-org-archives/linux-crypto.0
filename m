Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46BCB2EC57C
	for <linux-crypto@vger.kernel.org>; Tue, 31 Mar 2026 07:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774940745; cv=none; b=ZyzrtH4pTKh+yAr8KFYN5OcmhBDzhBeoo+9WfV1QtdQx4UUC9w3rIc7i77Wg1DT65SIY6LRVgibwiJHsEl1MTBldDQ5JMQu7NN5B25KsuKfWwjZIvkEmOLgJorESUX28dq3vlL0sUuyVjwJAz+335ExNbrLtEgmaa1c+hPG7Wv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774940745; c=relaxed/simple;
	bh=Nqj656cYHLYMu8uugfANhkIu+GZROg/PNwW4UUyvLRQ=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=DfRYAXId1C2OYt+7SmRHv91Qu7xcGcSDbwnZ6Hk0oJlBmRJlMivICRi0GTiOB7Az8mB/8jJH57WoEW6jVAD2ENHMZq1BrMhyuKQnea+/fSuveq7ROviCyICAvtKWP/DKQE8Xv1cdgvSWyiYFZ/yo16x5frEoI5ELajikR/2grFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YmKa8CQh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YmKa8CQh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2891C4AF09;
	Tue, 31 Mar 2026 07:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774940745;
	bh=Nqj656cYHLYMu8uugfANhkIu+GZROg/PNwW4UUyvLRQ=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=YmKa8CQhnJDi2XWHDeBw+t9FeZO4sFlWUcRbtAxMdq5NEmpzlHFxLmCwdcsB73lH8
	 6xFzn8OGWIvfxxJc+Yx9db+z0nquN5dkWI9t4vsaCaokXeiuCZwD/2lgkOU0Dziyji
	 hNzcJHua8KhPc/vHW8HYKMvE/FkNUsG6na7lEHI3tCipx/CxkEoZ0yATTGv/iFTKh/
	 5qsEm6S9ZKIVowR5u2Gze6npYBHmJaSs+K3DCA479V9iD6lS8Uhj8r+Isj1JXOKlfy
	 JTHc9kvAWdTdLx3MZZTgBEBNCBnZdGwaFXG+Uf3zMYsNw+qmU+Mbbdy/H/OhmBs9CS
	 hnp7QRB/G3nqA==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id D0A9CF4007E;
	Tue, 31 Mar 2026 03:05:43 -0400 (EDT)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 31 Mar 2026 03:05:43 -0400
X-ME-Sender: <xms:R3LLaXxyvSy4ZnkiaKahfqH2N44pBB-qcbLcdo7HKp-pHFZqnleltQ>
    <xme:R3LLaaH6Yy_sBbTJBu8_43PoqfVXA8dzojyJHQ2Exwiu7iDQwNK3RVev2SJFjqz3J
    OaLi2RZcMkquNHaUNNe1XNY3ssdcI6QF4BIRFAR7hAj7LK2MDVLIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdefgeduvdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeekvdffkefhgfegveekfedtieffhfelgeetiedvieffhfekfeeikeetueeg
    teetteenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrugdomhgvshhmthhprghuthhhphgv
    rhhsohhnrghlihhthidqudeijedthedttdejledqfeefvdduieegudehqdgrrhgusgeppe
    hkvghrnhgvlhdrohhrghesfihorhhkohhfrghrugdrtghomhdpnhgspghrtghpthhtohep
    kedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepnhhikhhunhhjsegrmhgurdgtoh
    hmpdhrtghpthhtohepthhhohhmrghsrdhlvghnuggrtghkhiesrghmugdrtghomhdprhgt
    phhtthhopehhvghrsggvrhhtsehgohhnughorhdrrghprghnrgdrohhrghdrrghupdhrtg
    hpthhtohepvggsihhgghgvrhhssehkvghrnhgvlhdrohhrghdprhgtphhtthhopeigkeei
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgtrhihphhtohesvhhgvg
    hrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdhkvghrnhgvlhesvhhg
    vghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjrghsohhnseiigidvtgegrdgtoh
    hm
X-ME-Proxy: <xmx:R3LLaVutvVUDz5OfeDhtr9b-dcBBDrg1LbMPpnwOBZKSokHpn5WubQ>
    <xmx:R3LLaTZH87L6k5-Xv_NnSWCaa5F0LSa7nKIuG832l1TClcoWEgJ8MA>
    <xmx:R3LLadAF2L4twzirBHtwqBVceXY0GkdvIPHuDzkWpYrcDTgbMZvQlQ>
    <xmx:R3LLab8PlSRiqKHXA8Vq-hbufDun6Hzct7pcdEmJWwwTjhcfVLtMIA>
    <xmx:R3LLaZRKuG6W6I7FOT1u4jVj_3eU04UfWI0yGLNKnC-VZ8iCFDyGHJ90>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id ACC4870006A; Tue, 31 Mar 2026 03:05:43 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: A2qvLZQkzXz-
Date: Tue, 31 Mar 2026 09:05:23 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Eric Biggers" <ebiggers@kernel.org>, linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "Jason A . Donenfeld" <Jason@zx2c4.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, x86@kernel.org,
 "Nikunj A Dadhania" <nikunj@amd.com>,
 "Tom Lendacky" <thomas.lendacky@amd.com>
Message-Id: <1e04994d-4d82-48f4-8022-ea488d203653@app.fastmail.com>
In-Reply-To: <20260331050234.GA4451@sol>
References: <20260331024430.51755-1-ebiggers@kernel.org>
 <20260331050234.GA4451@sol>
Subject: Re: [PATCH] lib/crypto: aesgcm: Don't disable IRQs during AES block encryption
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

(cc Tom)

On Tue, 31 Mar 2026, at 07:02, Eric Biggers wrote:
> [Added x86@kernel.org and nikunj@amd.com]
>
> On Mon, Mar 30, 2026 at 07:44:30PM -0700, Eric Biggers wrote:
>> aes_encrypt() now uses AES instructions when available instead of always
>> using table-based code.  AES instructions are constant-time and don't
>> benefit from disabling IRQs as a constant-time hardening measure.
>> 
>> In fact, on two architectures (arm and riscv) disabling IRQs is
>> counterproductive because it prevents the AES instructions from being
>> used.  (See the may_use_simd() implementation on those architectures.)
>> 
>> Therefore, let's remove the IRQ disabling/enabling and leave the choice
>> of constant-time hardening measures to the AES library code.
>> 
...
> I just noticed the rationale in the patch series that originally added
> lib/crypto/aesgcm.c in 2022
> (https://lore.kernel.org/all/20221103192259.2229-1-ardb@kernel.org/):
>
>     Provide a generic library implementation of AES-GCM which can be
>     used really early during boot, e.g., to communicate with the
>     security coprocessor on SEV-SNP virtual machines to bring up
>     secondary cores.  This is needed because the crypto API is not
>     available yet this early.
>
>     We cannot rely on special instructions for AES or polynomial
>     multiplication, which are arch specific and rely on in-kernel SIMD
>     infrastructure. Instead, add a generic C implementation that
>     combines the existing C implementations of AES and multiplication in
>     GF(2^128).
>
>     To reduce the risk of forgery attacks, replace data dependent table
>     lookups and conditional branches in the used gf128mul routine with
>     constant-time equivalents. The AES library has already been
>     robustified to some extent to prevent known-plaintext timing attacks
>     on the key, but we call it with interrupts disabled to make it a bit
>     more robust. (Note that in SEV-SNP context, the VMM is untrusted,
>     and is able to inject interrupts arbitrarily, and potentially
>     maliciously.)
>
> So, the user of AES-GCM in arch/x86/coco/sev/ is a bit special.  It runs
> super early, before the crypto library initcalls have run and enabled
> the use of AES-NI and PCLMULQDQ optimized routines.  And apparently it
> really needs protection from timing attacks, as well.
>
> I think this patch is still the way to go, but it does slightly weaken
> the protection from timing attacks for super early users like this.  So
> I think we'll likely want to do something else as well.  Either:
>
> - Disable IRQs in the callers in arch/x86/coco/sev/.
>
> - Or, enable the AES-NI and PCLMULQDQ optimized crypto library routines
>   earlier on x86, so that they will be used in this case.  Specifically,
>   enable them in arch_cpu_finalize_init() between fpu__init_cpu() and
>   mem_encrypt_init().
>
> I'd prefer the latter.  The dedicated instructions are the proper way to
> get data and key-independent timing for AES-GCM.  It's much less clear
> that the generic C code has data and key-independent timing, even if
> it's run with IRQs disabled.
>

AIUI, if we drop the IRQ dis/enable from this code, the generic path will be taken during early boot, but later invocations will use the accelerated implementations once they become available, right?

Mounting a timing attack requires accurate timing observations and a large number of samples, and it seems unlikely to me that a hostile VMM would be able to obtain those during the time window in question.


