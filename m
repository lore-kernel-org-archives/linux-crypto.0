Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324B520370B;
	Tue,  4 Feb 2025 19:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738698899; cv=none; b=JqCod+qm8CvdUO+SEwuTLBhCaFHh94HlnTTyP0Aikdy/iUGM9r4IGoohBvj7kD1o+eeuqQdZRcBqZfIwlzL82GGMPPy0vxcHEQeUgMqchd7SZfCbtsZORJMrvE7UG4R79WPZC6JWjOzno56p/Fdp6eyqz8jKEAJCwsb6Ie9Bfqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738698899; c=relaxed/simple;
	bh=uRKxy03qDmELmv7F+dYS75uSo7cXy9zLdsTgSqupSRM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CvSfWUPq6LkiuZkif+WotRtVN6NdtCR/SD5LNSS/n90icNryustzcuRsVXwE2JKvQ85E+6vvNHlt9qrT8srMTEFENCP+QTXIpGuVbRtBgHWFY7eN6h5++hpfxrd1+UuKM7Nr2wI2N7er7Rf4k5OaDk0sopzsBChd8ggr7vaMV/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=adI0UEcP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="adI0UEcP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B1AC4CEDF;
	Tue,  4 Feb 2025 19:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1738698898;
	bh=uRKxy03qDmELmv7F+dYS75uSo7cXy9zLdsTgSqupSRM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=adI0UEcPSZV9Hl6eJzbMFQ/fyVbiT3XdRGhzg3dlQxvKT3PaSUwncxe8HT3npSYmZ
	 OOg0klGWK4yV5K6zbYaas4mf3vg/XMYNfF2Rp+WT0ImVluTXVCO62855SHkdOEtm0N
	 BArHbxg+Xv46fEbsPILhrcWwAvRblgIIvT0Rv2bBlkh8/KYOl4pRfR7O58zhW6Mlbs
	 0uZ82Z0nn/5Z827Kypl6I7kwdzvuiO/+nGdpzvoPupYeoUCkZru99UHyo6bPZLST3B
	 V4LyVwprVL5QolCVx+gwis5sNUnXSo1V6klSXXCx9WR3U5ETHe2b8Ojub/2dN94pFi
	 dSN/INuKC6xwg==
Date: Tue, 4 Feb 2025 11:54:56 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-block@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2 00/11] CRC64 library rework and x86 CRC optimization
Message-ID: <20250204195456.GA1385@sol.localdomain>
References: <20250130035130.180676-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250130035130.180676-1-ebiggers@kernel.org>

On Wed, Jan 29, 2025 at 07:51:19PM -0800, Eric Biggers wrote:
> This patchset applies to commit 72deda0abee6e7 and is also available at:
> 
>     git fetch https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git crc-x86-v2
> 
> This is the next major set of CRC library improvements, targeting 6.15.
> 
> Patches 1-5 rework the CRC64 library along the lines of what I did for
> CRC32 and CRC-T10DIF in 6.14.  They add direct support for
> architecture-specific optimizations, fix the naming of the NVME CRC64
> variant, and eliminate a pointless use of the crypto API.
> 
> Patches 6-10 replace the existing x86 PCLMULQDQ optimized CRC code with
> new code that is shared among the different CRC variants and also adds
> VPCLMULQDQ support, greatly improving performance on recent CPUs.
> Patch 11 wires up the same optimization to crc64_be() and crc64_nvme()
> (a.k.a. the old "crc64_rocksoft") which previously were unoptimized,
> improving the performance of those CRC functions by as much as 100x.
> crc64_be is used by bcachefs, and crc64_nvme is used by blk-integrity.

Applied patches 1-5 to
https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

I'm still working a bit on the x86 assembly and am planning to do a v3 for
patches 6-11.

- Eric
