Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A621DEFE9;
	Sat,  6 Dec 2025 19:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765051017; cv=none; b=rbTHptzOUYE7i1y+VLwhETFPLjfhKBXdMbYVBsVttSijUwojqsGq60wr7p36znLkGFx2vy5jIiaYW8aoBCt3QHtEL7p1xCsOmCpACaNz7CetnGfu1HZohJLxdSA9qdz6dosJdpHy1v2yhIwEgyyDIpzkRsoDCPnentVtq0aKUzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765051017; c=relaxed/simple;
	bh=9FQJgpJnEx4MT5jkFe9SlUQLuoOyH3jpPlTZf50X1Aw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uD93X2gwZOmiLd2tlmt+K4P5C7dE5EhYOZS96VrDewFPyoXih3vLWTjQ15XCAaYzmeBO4Oueh75kcrLcShRSIudMPS2ElREPR4BaIq4xSV1fQbrJS5YXQXrM6/6hFOW3igcJZFGWIA2OlM0LtqKh86n4alkq+MGF1HDvbrcuqA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vIwGAS70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vIwGAS70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFC0C4CEF5;
	Sat,  6 Dec 2025 19:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765051017;
	bh=9FQJgpJnEx4MT5jkFe9SlUQLuoOyH3jpPlTZf50X1Aw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vIwGAS70bO+OLLE6QI5bj+RkMZJVjc/ISZoeOFDhx2XbWXGUskJUyc9vaUfvFBWqj
	 fvdTtV3Jyf7JeDdbscPMBOfXtcgt2/TJyEad3UEm55z8MST7JOlbvYaSTMjTzZMF/v
	 A4L9zqZ4DQ++FcDNkIRso7ouUNOTAQJck/JpAL042RpxyK8/d+dSpGpaUeX4OwpmUD
	 Kx5W6Vyl667/1UBsHVArfvrbONXb7uxTEy26ff5LJ+9JUB24nwdDfcVUQGKli5aACl
	 eT7t/jrmHF/SNCxMBHVirzboVMuIgN3mPkg+NVq2bU2U7LUwST/EYqk9fmOJgKeaip
	 K3lrXHryD+1Ww==
Date: Sat, 6 Dec 2025 11:56:55 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Vivian Wang <wangruikang@iscas.ac.cn>,
	Jerry Shih <jerry.shih@sifive.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Han Gao <gaohan@iscas.ac.cn>, linux-crypto@vger.kernel.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: lib/crypto: riscv: crypto_zvkb crashes on selftest if no
 misaligned vector support
Message-ID: <20251206195655.GA4665@quark>
References: <b3cfcdac-0337-4db0-a611-258f2868855f@iscas.ac.cn>
 <CAMj1kXHesHJ2oFzGPewp2V=rA0-BU2Y_PffuDDhxioftOKZYHg@mail.gmail.com>
 <20251130184341.GB1395@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251130184341.GB1395@sol>

On Sun, Nov 30, 2025 at 10:43:41AM -0800, Eric Biggers wrote:
> On Sun, Nov 30, 2025 at 11:59:58AM +0100, Ard Biesheuvel wrote:
> > On Sun, 30 Nov 2025 at 10:13, Vivian Wang <wangruikang@iscas.ac.cn> wrote:
> > >
> > > Hi,
> > >
> > > We ran into a problem with chacha_zvkb, where having:
> > >
> > > - OpenSBI 1.7+ (for FWFT support)
> > > - CRYPTO_CHACHA20POLY1305=y and CRYPTO_SELFTESTS=y (and deps, of course)
> > > - Hardware with Zvkb support
> > > - Hardware *without* misaligned vector load/store support
> > >
> > > Leads to a crash on boot during selftest on a vlsseg8e32.v instruction,
> > > because it requires 4-byte alignment of the buffers.
> > >
> > > OpenSBI by default emulates vector misaligned operations, however Linux
> > > explicitly disables it with SBI FWFT while not providing vector
> > > misaligned emulation of its own.
> > >
> > > This can be reproduced by running everything in Spike without
> > > --misaligned, and is reproducible on stable 6.17.9, 6.18-rc1 and
> > > 6.18-rc7. See log at the end. Note that I had to fix chacha_zvkb
> > > somewhat to have it retain a frame pointer to get a stack trace - patch
> > > will be sent later.
> > >
> > > Setting cra_alignmask to 3 for everything in crypto/chacha.c "fixes"
> > > this, but there seems to be no obvious way to say "if use_zvkb then
> > > cra_alignmask = 3", and, not being familiar with the crypto API stuff, I
> > > can't figure out a good way to say "if riscv then cra_alignmask = 3" either.
> > >
> > > AFAICT, this problem was missed from the very start since commit
> > > bb54668837a0 ("crypto: riscv - add vector crypto accelerated ChaCha20").
> > >
> > > Please advise.
> > >
> > 
> > I'd suggest to only enable this version of the code if both Zicclsm
> > and Zvkb are supported (assuming that Zicclsm is the extension that
> > would result in these misaligned accesses to be permitted).
> > 
> > Playing with the cra_alignmask is likely insufficient, because it does
> > not fix the use cases that call the library interface directly.
> 
> Yes, we should make all the RISC-V vector crypto code (i.e., anything in
> lib/crypto/riscv/ and arch/riscv/crypto/ that uses vector instructions)
> be enabled only when the CPU supports fast misaligned vector accesses.
> That was the original intent, but it seems the check never actually made
> it into the code because it predated the core RISC-V support for
> detecting that capability.
> 
> That support later got added by the following commit:
> 
>     commit e7c9d66e313bc0f7cb185c4972c3c9383a0da70f
>     Author: Jesse Taube <jesse@rivosinc.com>
>     Date:   Thu Oct 17 12:00:22 2024 -0700
> 
>         RISC-V: Report vector unaligned access speed hwprobe
> 
> Note that Zicclsm is supposedly not the correct thing to check.  See
> https://lore.kernel.org/linux-riscv/20231122-displace-reformat-9ca68c3dc66c@spud/
> 
> It looks like all the RISC-V crypto code needs to check for
> this_cpu_read(vector_misaligned_access) ==
> RISCV_HWPROBE_MISALIGNED_VECTOR_FAST.
> But it may be in need of a helper function.
> 
> Any volunteers?  Again, many files need this, not just the ChaCha code.

Looking into this a bit more, on RISC-V the kernel actually checks and
records the vector misaligned access speed on each online CPU.  So not
only is RISC-V fragmented in whether this is supported in general, but
it can also be fragmented between different CPUs on the same system.

This means that the status of whether vector misaligned accesses are
supported and fast can change as CPUs go online and offline.

Indeed, there's already a corresponding static key for scalar misaligned
accesses that gets turned on and off as CPUs go online and offline.

But there's none for vector.  And this approach seems fundamentally
broken anyway, as it means that support for misaligned accesses can get
pulled out from underneath users.

I think we'll just need to make the RISC-V crypto code conditional on
CONFIG_RISCV_EFFICIENT_VECTOR_UNALIGNED_ACCESS=y.  Having this info be
statically known, like it is on the other architectures, is the only
reasonable way to do it.

- Eric
