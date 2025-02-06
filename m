Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E577A1A9B46;
	Thu,  6 Feb 2025 20:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738873193; cv=none; b=iOAjI96Gw4n9hJdbIV6C4U/bqeSwmZEjmVqZrWkdnVZkjhyvlIe4WunClaADTx0dcwoqD45CCjSaL7h+BgmyvE21TxMhaec+NBtDVJGrL87/BzkBXpL3F3OFoDz2pZyRA/l37xnOqM+liMwwFrR8YV+SOfr+BwJOxpiutBhOhv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738873193; c=relaxed/simple;
	bh=TGiyvQ51HFtyJBq0YnBFDewmoBrpiEOd9OQdDKub0WE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LD20TfjuZ9PtlkUQw55aW3RqX8X7azFNhf1glvWRdCWCw0hplPAlPprGaOPHe+iciJuEKSQSj0l8rA3VFzkcEux1aJEevyxUW9WnLy3keMNkcH5Q3O4T++raf6qXWEA1Nl+0Z+QDvlo+7G+KZXy1fHHhJ9PFQYag1u47H2BjJGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cVdcUcpU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cVdcUcpU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42548C4CEDF;
	Thu,  6 Feb 2025 20:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738873192;
	bh=TGiyvQ51HFtyJBq0YnBFDewmoBrpiEOd9OQdDKub0WE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cVdcUcpUobxy6SfDVGH4G4PrZf5gYd101Gee2hXInzg8n2QNMCGhGCCZCfuEp1kyZ
	 +k7mr0e/Ds6JDFRXvN8UrnftlB8tgX6sciecmFLyccGOMZ0Ry7CfAqSky5Pz0qmnjI
	 u59mhtxLhESJfrESolO0CGmw5U/npV6jpWpr0Qp/1530qY/MZYZ9cTecOAiYbjhYie
	 yAx7B6stHzx2b/FNXRay2tcYLeiAOXYT2sHLmt5UnN6C6hORQXOiyBO2Pw4fytnu1F
	 /7cLUmT7IjsTeQQPZLp8AOT84kfaDDz2I4ZF94AHP8HCtoNCZ7KgPH33SW/Xe8Owfw
	 W182OAF05gCfA==
Date: Thu, 6 Feb 2025 12:19:50 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Zhihang Shao <zhihang.shao.iscas@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, ardb@kernel.org
Subject: Re: [PATCH v3] riscv: Optimize crct10dif with zbc extension
Message-ID: <20250206201950.GB1237@sol.localdomain>
References: <20250205065815.91132-1-zhihang.shao.iscas@gmail.com>
 <20250205163012.GB1474@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250205163012.GB1474@sol.localdomain>

On Wed, Feb 05, 2025 at 08:30:12AM -0800, Eric Biggers wrote:
> On Wed, Feb 05, 2025 at 02:58:15PM +0800, Zhihang Shao wrote:
> > The current CRC-T10DIF algorithm on RISC-V platform is based on
> > table-lookup optimization.
> > Given the previous work on optimizing crc32 calculations with zbc
> > extension, it is believed that this will be equally effective for
> > accelerating crc-t10dif.
> > 
> > Therefore this patch offers an implementation of crc-t10dif using zbc
> > extension. This can detect whether the current runtime environment
> > supports zbc feature and, if so, uses it to accelerate crc-t10dif
> > calculations.
> > 
> > This patch is updated due to the patchset of updating kernel's
> > CRC-T10DIF library in 6.14, which is finished by Eric Biggers.
> > Also, I used crc_kunit.c to test the performance of crc-t10dif optimized
> > by crc extension.
> > 
> > Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>
> > ---
> >  arch/riscv/Kconfig                |   1 +
> >  arch/riscv/lib/Makefile           |   1 +
> >  arch/riscv/lib/crc-t10dif-riscv.c | 132 ++++++++++++++++++++++++++++++
> >  3 files changed, 134 insertions(+)
> >  create mode 100644 arch/riscv/lib/crc-t10dif-riscv.c
> 
> Acked-by: Eric Biggers <ebiggers@kernel.org>
> Tested-by: Eric Biggers <ebiggers@kernel.org>
> 
> This can go through the riscv tree.
> 

Actually, if people don't mind I'd like to take this through the crc tree.  Due
to https://lore.kernel.org/r/20250206173857.39794-1-ebiggers@kernel.org the
function crc_t10dif_is_optimized() becomes unused and we should remove it, which
would conflict with this patch which adds another implementation of it.

- Eric
