Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BABF54BF5
	for <linux-crypto@vger.kernel.org>; Tue, 21 Nov 2023 23:37:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OczUUkhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E285C433C8;
	Tue, 21 Nov 2023 23:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700609865;
	bh=bmtlZPe6HRvoqFtBNOxqiOuOPnz7I9kdhgGgVtH1RBM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OczUUkhbcsyD+OnEaKiPo0eYCn/bsbWnHoaDchnGxAkffAOyOOioHOYl3xC8ONEhh
	 4ImjoXjIelG7PdgZEluQLCmZxSOO8czzHqi1Psoq5Larss8FDmSx1LNErTILXGFJ2s
	 M6QlsMPuOaGYOmYSyzqPMseEjwOopUldyDA/xpUfkMJRRBRNZ5352JhjswqhKyQOlH
	 0ZCu6Kl3ltfza8nyoINplyaa/ep/m0WAymkAYkb3iDiol2xMTmEQavpjMxfJRlG4zz
	 d7ZMpQ9pJscFNDAp8b1/ELlKJNiFG4TYXduD/2nE75aKWvQ5B4Qox6j7KjdgIGvrea
	 uSsiDzI6H8IFg==
Date: Tue, 21 Nov 2023 15:37:43 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Conor Dooley <conor.dooley@microchip.com>
Cc: Jerry Shih <jerry.shih@sifive.com>,
	Paul Walmsley <paul.walmsley@sifive.com>, palmer@dabbelt.com,
	Albert Ou <aou@eecs.berkeley.edu>, herbert@gondor.apana.org.au,
	davem@davemloft.net, andy.chiu@sifive.com, greentime.hu@sifive.com,
	guoren@kernel.org, bjorn@rivosinc.com, heiko@sntech.de,
	ardb@kernel.org, phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH 12/12] RISC-V: crypto: add Zvkb accelerated ChaCha20
 implementation
Message-ID: <20231121233743.GD2172@sol.localdomain>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-13-jerry.shih@sifive.com>
 <20231102054327.GH1498@sol.localdomain>
 <90E2B1B4-ACC1-4316-81CD-E919D3BD03BA@sifive.com>
 <20231120191856.GA964@sol.localdomain>
 <9724E3A5-F43C-4239-9031-2B33B72C4EF4@sifive.com>
 <20231121-knelt-resource-5d71c9246015@wendy>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231121-knelt-resource-5d71c9246015@wendy>

On Tue, Nov 21, 2023 at 01:14:47PM +0000, Conor Dooley wrote:
> On Tue, Nov 21, 2023 at 06:55:07PM +0800, Jerry Shih wrote:
> > On Nov 21, 2023, at 03:18, Eric Biggers <ebiggers@kernel.org> wrote:
> > > First, I can see your updated patchset at branch
> > > "dev/jerrys/vector-crypto-upstream-v2" of https://github.com/JerryShih/linux,
> > > but I haven't seen it on the mailing list yet.  Are you planning to send it out?
> > 
> > I will send it out soon.
> > 
> > > Second, with your updated patchset, I'm not seeing any of the RISC-V optimized
> > > algorithms be registered when I boot the kernel in QEMU.  This is caused by the
> > > new check 'riscv_isa_extension_available(NULL, ZICCLSM)' not passing.  Is
> > > checking for "Zicclsm" the correct way to determine whether unaligned memory
> > > accesses are supported?
> > > 
> > > I'm using 'qemu-system-riscv64 -cpu max -machine virt', with the very latest
> > > QEMU commit (af9264da80073435), so it should have all the CPU features.
> > > 
> > > - Eric
> > 
> > Sorry, I just use my `internal` qemu with vector-crypto and rva22 patches.
> > 
> > The public qemu haven't supported rva22 profiles. Here is the qemu patch[1] for
> > that. But here is the discussion why the qemu doesn't export these
> > `named extensions`(e.g. Zicclsm).
> > I try to add Zicclsm in DT in the v2 patch set. Maybe we will have more discussion
> > about the rva22 profiles in kernel DT.
> 
> Please do, that'll be fun! Please take some time to read what the
> profiles spec actually defines Zicclsm fore before you send those patches
> though. I think you might come to find you have misunderstood what it
> means - certainly I did the first time I saw it!
> 
> > [1]
> > LINK: https://lore.kernel.org/all/d1d6f2dc-55b2-4dce-a48a-4afbbf6df526@ventanamicro.com/#t
> > 
> > I don't know whether it's a good practice to check unaligned access using
> > `Zicclsm`. 
> > 
> > Here is another related cpu feature for unaligned access:
> > RISCV_HWPROBE_MISALIGNED_*
> > But it looks like it always be initialized with `RISCV_HWPROBE_MISALIGNED_SLOW`[2].
> > It implies that linux kernel always supports unaligned access. But we have the
> > actual HW which doesn't support unaligned access for vector unit.
> 
> https://docs.kernel.org/arch/riscv/uabi.html#misaligned-accesses
> 
> Misaligned accesses are part of the user ABI & the hwprobe stuff for
> that allows userspace to figure out whether they're fast (likely
> implemented in hardware), slow (likely emulated in firmware) or emulated
> in the kernel.
> 
> Cheers,
> Conor.
> 
> > 
> > [2]
> > LINK: https://github.com/torvalds/linux/blob/98b1cc82c4affc16f5598d4fa14b1858671b2263/arch/riscv/kernel/cpufeature.c#L575
> > 
> > I will still use `Zicclsm` checking in this stage for reviewing. And I will create qemu
> > branch with Zicclsm enabled feature for testing.
> > 

According to https://github.com/riscv/riscv-profiles/blob/main/profiles.adoc,
Zicclsm means that "main memory supports misaligned loads/stores", but they
"might execute extremely slowly."

In general, the vector crypto routines that Jerry is adding assume that
misaligned vector loads/stores are supported *and* are fast.  I think the kernel
mustn't register those algorithms if that isn't the case.  Zicclsm sounds like
the wrong thing to check.  Maybe RISCV_HWPROBE_MISALIGNED_FAST is the right
thing to check?

BTW, something else I was wondering about is endianness.  Most of the vector
crypto routines also assume little endian byte order, but I don't see that being
explicitly checked for anywhere.  Should it be?

- Eric
