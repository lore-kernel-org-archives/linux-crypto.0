Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D1E53A9DB6;
	Fri,  3 Apr 2026 17:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775238733; cv=none; b=U1m2njIg7LjPitabAlJipmsg3+nx/vyWon6NZmgxxe3Q6EuT7R7V2VL9RPZpwkRJpXxJ7FNKq8uw8U2tcvrHA1DHts5JonDWg1youAm7hIWR8vqAifr26Ov7VE/idMCp/SY07EGJhI9rfkBtGb1/1XgvIE4pTRVqxpSUDivA+pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775238733; c=relaxed/simple;
	bh=Js2PX2MXqPMlLFLfryUUJVMOq+yqO4nrpNcUIuNjsxI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZOMv9epXftK9fcdv76kgxDPzyPUkx5T7Utms+YS87qoj5xx+M0HJj3hb2SjkKI9lsY3bdPe/GypWrWrqEZurUDnCDxSCqaBJmLjnVgRBwSyXFQw7tPHxtAnZ6YDRAC652kCKh2FUvaHHnzU+b/hN/oNQCLeT72y5wyCqr6Mu5EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SQPiiwc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SQPiiwc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756B1C4CEF7;
	Fri,  3 Apr 2026 17:52:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775238732;
	bh=Js2PX2MXqPMlLFLfryUUJVMOq+yqO4nrpNcUIuNjsxI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SQPiiwc8NK0FIi+UDL1nJ4i6+zMpjElQLKLDKcacwAITctxPFwzyFjjcyFIxNn63X
	 LPlzrNKkrSScjzqrINSoCaTsBs4ok2TSXqwfBBk85VVtj9iRYFoTGNQQnlTs7+2gHR
	 uypZV/42tCnXGHwdwd5wczFwoJVZJn3IJs3acjUCLExag0749uGj8IzUlOW5Tkvwwn
	 nWYvYDChFYHR1vOazfkMqSMovGUNysC3DxbpIUKKASC5NWCOQEKcOodow/3dFmG+Bz
	 6G9PDEpPD8fmZ4ZGEubPhWs8YjEfDJ5vri0qa+V7jW6nqrdzaMgt5Bi7fJSeYE/cAJ
	 6mAY2y9+gXQQQ==
Date: Fri, 3 Apr 2026 11:52:09 -0600
From: Tycho Andersen <tycho@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Ashish Kalra <ashish.kalra@amd.com>,
	John Allen <john.allen@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Kishon Vijay Abraham I <kvijayab@amd.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kim Phillips <kim.phillips@amd.com>,
	Sean Christopherson <seanjc@google.com>,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v1 1/2] x86/sev: Do not initialize SNP if missing CPUs
Message-ID: <ac_-Sfa6qAhdG8rR@tycho.pizza>
References: <20260401143552.3038979-1-tycho@kernel.org>
 <70635612-76e5-488a-bb82-e66752dc9857@amd.com>
 <20260403171833.GXac_2aVdvz9gTb_DL@fat_crate.local>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260403171833.GXac_2aVdvz9gTb_DL@fat_crate.local>

On Fri, Apr 03, 2026 at 07:18:33PM +0200, Borislav Petkov wrote:
> On Fri, Apr 03, 2026 at 08:31:24AM -0500, Tom Lendacky wrote:
> > > +	if (!cpumask_equal(cpu_online_mask, cpu_possible_mask))
> > 
> > If CONFIG_INIT_ALL_POSSIBLE is set, won't that set cpu_possible_mask to
> > include all CPUs up to NR_CPUS? That would result in this always failing.

Thanks, I didn't know about this config.

> Yah,
> 
> sashiko gave another possible situation where this can fail:
> 
> https://sashiko.dev/#/patchset/20260401143552.3038979-1-tycho%40kernel.org

> disabled ACPI MADT entries for hotplug

I suppose depends on how the firmware reasons about such things too.
But it seems like the suggestion of cpus_present_mask is right.

> > Not sure if this change is worth it.
> 
> Well, it would save us a lot of effort if we can check at module load time
> whether some CPUs are offlined. A very simple use case:
> 
> echo 0 > /sys/devices/system/cpu.../online
> modprobe ccp

This is how I was testing this, but I'll see about testing the ACPI
thing too.

Tycho
