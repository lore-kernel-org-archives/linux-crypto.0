Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4693260EC9
	for <linux-crypto@vger.kernel.org>; Wed, 29 Nov 2023 20:26:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SXjh5gO0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33903C433C8;
	Wed, 29 Nov 2023 20:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701289565;
	bh=PN5ubgLpDPuW9rHykLBRI+s3FZh6xjxWlF9+Ry84t80=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SXjh5gO079La4jU98h/gu37YvIoFwnrjoraInTxvddDeytta4VebZNQV2H+kSoxiN
	 3P939JvVZhSvqOjLYzrv5cJDl+zd5o13jLXxReDmxH0jo3ydVQlnR1skJnl+4OqPuE
	 Hh38EVOHi9+DI11WDHEtPhu2f95exDmdlCyoXg2I1Nwr3meJ5BQ40qPOAJzd1HRfO6
	 HP9okeS8J9iVDUeb1o18O3kLuYJYkJL3m76mOJBPUGxxuCRH0hgOvWysuLnJrLfAfK
	 Exa6Y9enh+emk9SzsSK2bSobP/7mJNXRsChuKM78adeE2l5ZXwdgsCn0ZbdpKPfXNC
	 II+VZoyJLkvUg==
Date: Wed, 29 Nov 2023 12:26:03 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Conor Dooley <conor@kernel.org>
Cc: Jerry Shih <jerry.shih@sifive.com>, Andy Chiu <andy.chiu@sifive.com>,
	Paul Walmsley <paul.walmsley@sifive.com>, palmer@dabbelt.com,
	aou@eecs.berkeley.edu, herbert@gondor.apana.org.au,
	davem@davemloft.net, conor.dooley@microchip.com, ardb@kernel.org,
	heiko@sntech.de, phoebe.chen@sifive.com, hongrong.hsu@sifive.com,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2 04/13] RISC-V: crypto: add Zvkned accelerated AES
 implementation
Message-ID: <20231129202603.GB1174@sol.localdomain>
References: <20231127070703.1697-1-jerry.shih@sifive.com>
 <20231127070703.1697-5-jerry.shih@sifive.com>
 <20231128-await-tipper-2094715466f2@spud>
 <20231128201228.GE1148@sol.localdomain>
 <E78B3BF9-8E49-417B-A89E-05F72690A92F@sifive.com>
 <20231129-subtitle-unlinked-c0871a28ac88@spud>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231129-subtitle-unlinked-c0871a28ac88@spud>

On Wed, Nov 29, 2023 at 11:12:16AM +0000, Conor Dooley wrote:
> On Wed, Nov 29, 2023 at 10:39:56AM +0800, Jerry Shih wrote:
> > On Nov 29, 2023, at 04:12, Eric Biggers <ebiggers@kernel.org> wrote:
> > > On Tue, Nov 28, 2023 at 05:54:49PM +0000, Conor Dooley wrote:
> > >>> +static inline bool check_aes_ext(void)
> > >>> +{
> > >>> +	return riscv_isa_extension_available(NULL, ZVKNED) &&
> > >>> +	       riscv_vector_vlen() >= 128;
> > >>> +}
> > >> 
> > >> I'm not keen on this construct, where you are checking vlen greater than
> > >> 128 and the presence of Zvkned without checking for the presence of V
> > >> itself. Can you use "has_vector()" in any places where you depend on the
> > >> presence of vector please?
> > > 
> > > Shouldn't both of those things imply vector support already?
> > 
> > The vector crypto extensions imply `V` extension. Should we still need to check
> > the `V` explicitly?
> > https://github.com/riscv/riscv-crypto/blob/main/doc/vector/riscv-crypto-spec-vector.adoc#1-extensions-overview
> 
> The check for Zkvned is only for whether or not Zvkned has been provided
> in the DT or ACPI tables, it doesn't mean that the kernel supports the V
> extension. I could see something like a hypervisor that does not support
> vector parsing the "v" out of the DT or ACPI tables but not eliminating
> every single extension that may depend on vector support.
> 
> The latter check is, IMO, an implementation detail and also should not
> be used to imply that vector is supported.

First, the RISC-V crypto files are only compiled when CONFIG_RISCV_ISA_V=y.
So in those files, we know that the kernel supports V if the hardware does.

If the hardware can indeed declare extensions like Zvkned without declaring V,
that sounds problematic.  Would /proc/cpuinfo end up with the same misleading
information in that case, in which case userspace would have the same problem
too?  I think that such misconfigurations are best handled centrally by having
the low-level architecture code in the kernel clear all extensions that depend
on missing extensions.  IIRC there have been issues like this on x86, and that
was the fix that was implemented.  See arch/x86/kernel/cpu/cpuid-deps.c

- Eric
