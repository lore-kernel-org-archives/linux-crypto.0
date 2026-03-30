Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD9E383C9C;
	Mon, 30 Mar 2026 05:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774848761; cv=none; b=gX8atkPu9eGPHp26ih63jdPV/xDWfUEV10EKZ8frAof9zHRqHae1bGJ16IWl/qVtPo8xfyCNA//4IOl4oSoq4oFRtca/nFbzHXb8FWy5wszIsrAg68Wc18hDaiUPHw2qX+Vf4BeRkFwxyA+YN9HlUfNFmDJ23JIlFdCO1IDl/I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774848761; c=relaxed/simple;
	bh=z4P9oyID9BRbkYw9uutU61ptnHn0Bu/AoOKemxJPTPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eVu/9u8JQQWxyRD28XyRMAUmz5tueKN+JJz3077cNkk7iPMCS6cPVT5b2Qt9f++ARtztcx3skKhi3qYnZGC/zH+T+HYiMvRS/tsU+rZknJNQBRiH/ws6XFe00WGe/DuxKOPKaUysu23TONRdSlOUAq/2xe+hBaAZjbEqBX1BlKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B66A768B05; Mon, 30 Mar 2026 07:32:33 +0200 (CEST)
Date: Mon, 30 Mar 2026 07:32:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Ard Biesheuvel <ardb+git@google.com>,
	linux-raid@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>, Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH 4/5] xor/arm64: Use shared NEON intrinsics
 implementation from 32-bit ARM
Message-ID: <20260330053233.GB4736@lst.de>
References: <20260327113047.4043492-7-ardb+git@google.com> <20260327113047.4043492-11-ardb+git@google.com> <20260327135051.GA739@lst.de> <cca6facc-6c37-48d0-81e6-f8568f36b91d@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cca6facc-6c37-48d0-81e6-f8568f36b91d@app.fastmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Mar 27, 2026 at 03:45:56PM +0100, Ard Biesheuvel wrote:
> On Fri, 27 Mar 2026, at 14:50, Christoph Hellwig wrote:
> > On Fri, Mar 27, 2026 at 12:30:52PM +0100, Ard Biesheuvel wrote:
> >> From: Ard Biesheuvel <ardb@kernel.org>
> >> 
> >> Tweak the arm64 code so that the pure NEON intrinsics implementation of
> >> XOR is shared between arm64 and ARM.
> >
> > Instead of hiding the implementation in a header, just split xor-neon.c
> > into two .c files, one of which could be built by arm32 as well.
> 
> That is what patch 3/5 does. This patch wires up that version into arm64, and drops the copy that has become redundant as a result.

Yeah, sorry - I misread the series a little.

> 
> > probably
> > in the arm/ instead of the arm64/ subdirectory, but we can also add a
> > new arm-common one if that's what the arm maintainers prefer.
> 
> Having the shared pure NEON version in arm/ is perfectly fine.

So here would be my preference:

 - keep all the arm/arm64 code in lib/raid/xor/arm
 - have the neon and EOR3 code in a single xor-neon.c file, with an
   ifdef CONFIG_ARM64 around the EOE3 routines

This avoid the including of .c files which is always a bit ugly.
But if there is a strong argument to prefer including of the .c file I
can live with that as well.

> 
> Building it as a separate compilation unit for arm64 should also be straight-forward, the only issue is that the 2-way NEON version needs to be shared with the EOR3 compilation unit.
> 
---end quoted text---
