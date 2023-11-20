Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927B213FE6
	for <linux-crypto@vger.kernel.org>; Mon, 20 Nov 2023 19:18:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nsgSdljj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA452C433C8;
	Mon, 20 Nov 2023 19:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700507938;
	bh=8GrqBpx0HG1TFaZKdiHie469Wi/VanH3SYoEwrBLjtg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nsgSdljj2y1K4QXuI0J47MilWCgnCZU0WD/Xv3w+9CbSg+ZcuApxMhkpOdOZt1BI0
	 DIjT6Y8bjiNEqkZt1fHfgRZJk+hFhaGhQ6GX0DHgUrEQuVzjCe1ulUo+ORF/SRnv08
	 Y8i4NUJIxX8INL+TH9feVjcji1HRJ1xb7eMzp64HI/Bel7W4tyPqFAXe0aOu4pvtrc
	 LcmwVK9q+9Gk1bkJkBnmmgNjIHkFyqX0hAlCIRY7KY/6iDAVv27vMul3n1eJwWkI33
	 fHAIEUPYV2vrgM2nBMzJue2p9Dow8h8rdZu2kJgg2NvmPQQTgYji09NJ/AVoNAO2FG
	 CYORXBPpNN96g==
Date: Mon, 20 Nov 2023 11:18:56 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, palmer@dabbelt.com,
	Albert Ou <aou@eecs.berkeley.edu>, herbert@gondor.apana.org.au,
	davem@davemloft.net, andy.chiu@sifive.com, greentime.hu@sifive.com,
	conor.dooley@microchip.com, guoren@kernel.org, bjorn@rivosinc.com,
	heiko@sntech.de, ardb@kernel.org, phoebe.chen@sifive.com,
	hongrong.hsu@sifive.com, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 12/12] RISC-V: crypto: add Zvkb accelerated ChaCha20
 implementation
Message-ID: <20231120191856.GA964@sol.localdomain>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-13-jerry.shih@sifive.com>
 <20231102054327.GH1498@sol.localdomain>
 <90E2B1B4-ACC1-4316-81CD-E919D3BD03BA@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90E2B1B4-ACC1-4316-81CD-E919D3BD03BA@sifive.com>

Hi Jerry!

On Mon, Nov 20, 2023 at 10:55:15AM +0800, Jerry Shih wrote:
> >> +# - RV64I
> >> +# - RISC-V Vector ('V') with VLEN >= 128
> >> +# - RISC-V Vector Cryptography Bit-manipulation extension ('Zvkb')
> >> +# - RISC-V Zicclsm(Main memory supports misaligned loads/stores)
> > 
> > How is the presence of the Zicclsm extension guaranteed?
> > 
> > - Eric
> 
> I have the addition extension parser for `Zicclsm` in the v2 patch set.

First, I can see your updated patchset at branch
"dev/jerrys/vector-crypto-upstream-v2" of https://github.com/JerryShih/linux,
but I haven't seen it on the mailing list yet.  Are you planning to send it out?

Second, with your updated patchset, I'm not seeing any of the RISC-V optimized
algorithms be registered when I boot the kernel in QEMU.  This is caused by the
new check 'riscv_isa_extension_available(NULL, ZICCLSM)' not passing.  Is
checking for "Zicclsm" the correct way to determine whether unaligned memory
accesses are supported?

I'm using 'qemu-system-riscv64 -cpu max -machine virt', with the very latest
QEMU commit (af9264da80073435), so it should have all the CPU features.

- Eric
