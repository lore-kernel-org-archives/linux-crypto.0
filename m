Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8298C1F;
	Sat,  9 May 2026 20:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778358281; cv=none; b=H2jkkgC+XbOQLnZvqnyXx7Nc2IENuP0cgQhnWB/Tr4JBzRl7XpbG62HQgqGK++lvz9j7amnBSBsfOHA6aRD4YPoR/Til9Yg6sWbdgQLZSS7OyPLZ8x4PV3W1bL6PL1uw1K3yeBgyYjJVEZjV8oiWA04/4eAvcJKwVFT+gWWSj1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778358281; c=relaxed/simple;
	bh=kKWh3Ax64/du+5vhX0vAjVHPv0l4sBuI+ks7VTd/Lkw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sHMlZVRcgVjdAFCmYnlbXBPNKNfx9fTEJq6jNxKVjf+x1Y5ePQr1ll7r2YuNStvn17bDdeCylWlsS5V8RnEu25jHnCH9VlIoOGnCiDIJu/TnfccgaIxe1JrmkBzMCfXZ6xdk8QFuEImd3m8B08MP/86Ps/Y3dCZ6A18nSpiAvhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=shZOE2pV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="shZOE2pV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F57EC2BCB2;
	Sat,  9 May 2026 20:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778358280;
	bh=kKWh3Ax64/du+5vhX0vAjVHPv0l4sBuI+ks7VTd/Lkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=shZOE2pVpx5LAwKbDSqYjkqU3e5ZgIBDTpaNBPpdxKFnn7hy81myAkpSA+zI1NOjy
	 +lCtIM2W21mDt+l3OF+B+pL6zjn3w28574nppg08u0KqlgRXdvAkRbO0G0oWB1uOto
	 jurZzH1+Cd/vfNOQTM9pKWMYYNG4HiO8Sh0B55lhaS4+rgi07zTcEBESprQlU41IE4
	 vFiUSg49UFiqrg3tyQkj6J+wmzNc6SyfV+8nCiAnTOkcEi8iLsgzKaJMAahzCtfg77
	 2MaiR67kIZf0F5sTVlTruJXAgamxbEsnq9e5QVxG+RGOtuUl5FVZyf2t/vtmBZqubE
	 M9kJNzwTG944g==
Date: Sat, 9 May 2026 13:23:54 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Ard Biesheuvel <ardb+git@google.com>,
	linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
	linux-raid@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Russell King <linux@armlinux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 7/8] lib/raid6: Include asm/neon-intrinsics.h rather than
 arm_neon.h
Message-ID: <20260509202354.GD11883@quark>
References: <20260422171655.3437334-10-ardb+git@google.com>
 <20260422171655.3437334-17-ardb+git@google.com>
 <20260423074712.GC31018@lst.de>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260423074712.GC31018@lst.de>

On Thu, Apr 23, 2026 at 09:47:12AM +0200, Christoph Hellwig wrote:
> On Wed, Apr 22, 2026 at 07:17:03PM +0200, Ard Biesheuvel wrote:
> > From: Ard Biesheuvel <ardb@kernel.org>
> > 
> > arm_neon.h is a compiler header which needs some scaffolding to work
> > correctly in the linux context, and so it is better not to include it
> > directly. Both ARM and arm64 now provide asm/neon-intrinsics.h which
> > takes care of this.
> 
> 
> This could potentially clash with the raid6 library rework I'm doing
> for 7.2. Although git has become pretty good about renamed files, so
> maybe it won't be so bad.
> 

I think this patch also breaks the userspace build of lib/raid6/.  Which
is going away in Christoph's series anyway, but maybe it would make
sense to drop this patch (and patch 8 which depends on this, I think)
from this series for now?  That would make it a bit easier to take the
rest through crc-next.

- Eric
