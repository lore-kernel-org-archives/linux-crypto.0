Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C343F63BC
	for <linux-crypto@vger.kernel.org>; Fri, 10 Nov 2023 04:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kkmb1yV3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF575C433C8;
	Fri, 10 Nov 2023 04:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1699590899;
	bh=luMWNgUgOzDCukfqCzpzbeoC/xYIuvR4tlh8y8BriOI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Kkmb1yV3cX8ZqC2Ugs56PrhNzF27vOjUHj7Zi9Am2rWheYaIW6PoIBxdQXrExYQ6d
	 /M+jhxGhYDtOneLSN0nlDZyHowUbNauRO+fyhNafAl1Y0X7jzGFlyJ+klNa7Lnat+y
	 49Yxbwrr+8p5wcA6XhOK34zy5ZlTMKxY4d7CSJYRNS14I1K2tao9RwYjCPJilMg4Fl
	 TMDeMHKmxFrCqUeQbLDaIJMxJecWs33mXwwUJ6mX2FdYgr8bPk0PBecmLBjtz8C+Pt
	 CUpVSOZvKNwscrCaq03QH8fQk86sPy/9dHwK9zdoOj2sp1EaZiVN3g3RVC/Z5zqJZe
	 TM6yuwOERH10w==
Date: Thu, 9 Nov 2023 20:34:57 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jerry Shih <jerry.shih@sifive.com>
Cc: Paul Walmsley <paul.walmsley@sifive.com>, palmer@dabbelt.com,
	Albert Ou <aou@eecs.berkeley.edu>, herbert@gondor.apana.org.au,
	davem@davemloft.net, andy.chiu@sifive.com, greentime.hu@sifive.com,
	conor.dooley@microchip.com, guoren@kernel.org, bjorn@rivosinc.com,
	heiko@sntech.de, ardb@kernel.org, phoebe.chen@sifive.com,
	hongrong.hsu@sifive.com, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH 06/12] RISC-V: crypto: add accelerated
 AES-CBC/CTR/ECB/XTS implementations
Message-ID: <20231110043457.GA6572@sol.localdomain>
References: <20231025183644.8735-1-jerry.shih@sifive.com>
 <20231025183644.8735-7-jerry.shih@sifive.com>
 <20231102051639.GF1498@sol.localdomain>
 <39126F19-8FEB-4E18-B61D-4494B59C43A1@sifive.com>
 <20231109071623.GB1245@sol.localdomain>
 <659DE1CF-4F42-4935-9DFD-E127269CEC54@sifive.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <659DE1CF-4F42-4935-9DFD-E127269CEC54@sifive.com>

On Fri, Nov 10, 2023 at 11:58:02AM +0800, Jerry Shih wrote:
> On Nov 9, 2023, at 15:16, Eric Biggers <ebiggers@kernel.org> wrote:
> > On Tue, Nov 07, 2023 at 04:53:13PM +0800, Jerry Shih wrote:
> >> On Nov 2, 2023, at 13:16, Eric Biggers <ebiggers@kernel.org> wrote:
> >>> On Thu, Oct 26, 2023 at 02:36:38AM +0800, Jerry Shih wrote:
> >>>> +static int ecb_encrypt(struct skcipher_request *req)
> >>>> +{
> >>> 
> >>> There's no fallback for !crypto_simd_usable() here.  I really like it this way.
> >>> However, for it to work (for skciphers and aeads), RISC-V needs to allow the
> >>> vector registers to be used in softirq context.  Is that already the case?
> >> 
> >> The kernel-mode-vector could be enabled in softirq, but we don't have nesting
> >> vector contexts. Will we have the case that kernel needs to jump to softirq for
> >> encryptions during the regular crypto function? If yes, we need to have fallbacks
> >> for all algorithms.
> > 
> > Are you asking what happens if a softirq is taken while the CPU is between
> > kernel_vector_begin() and kernel_vector_end()?  I think that needs to be
> > prevented by making kernel_vector_begin() and kernel_vector_end() disable and
> > re-enable softirqs, like what kernel_neon_begin() and kernel_neon_end() do on
> > arm64.  Refer to commit 13150149aa6ded which implemented that behavior on arm64.
> > 
> > - Eric
> 
> The current kernel-mode-vector implementation, it only calls `preempt_disable()` during
> vector context. So, we will hit nesting vector context issue from softirq which also use
> kernel-vector.
> https://lore.kernel.org/all/20230721112855.1006-1-andy.chiu@sifive.com/
> 
> Maybe we could use the `simd_register_aeads_compat()` wrapping as x86 platform
> first in a simpler way first.

The "crypto SIMD helpers" (simd_register_*() in crypto/simd.c) are quite complex
and have some disadvantages such as marking the resulting algorithms as
"asynchronous".  I expect that a much better approach would be to align RISC-V
with arm64 by disabling softirqs while the kernel vector unit is in use.

- Eric
