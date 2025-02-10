Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9170924CEF6;
	Mon, 10 Feb 2025 20:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739219707; cv=none; b=upr9m2SlPdv/bmBdKgfZIIbHGDwXy6uzbT5Lci0kHeX0oezRlb1SxA01RfkLqdedtWL1SGIxBu82Q8tZvvUhsiK9jir7ELshkT+zD976mZ4M+EmL5U7rvZZXA+kFrS1xcJNLQp2c7KPmqHq+PM08ElZ4UHvM5NqwStQ1p+X5Gi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739219707; c=relaxed/simple;
	bh=OECw0u7i4muZXytvNKEOLncdneDKdhOefhqMgPbmzfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=puDRdCx4/d+1SyzLf44Xbj70li1dhCPZikdMaFKTOaKkS1KFut8/Jj/yr7fppsZ/0rZ77cHRTSIvLoFCMo43l+wds+iszAqQrMnI4vvTqc8iesS6EIDlw3jZVjR6fhETrjlZYfswTv4RVRNIaMREUmEUMnvJl/maIf8t7KM4m58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P4mnDFPS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P4mnDFPS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF3C6C4CED1;
	Mon, 10 Feb 2025 20:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739219707;
	bh=OECw0u7i4muZXytvNKEOLncdneDKdhOefhqMgPbmzfw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P4mnDFPSEL1n4qJPB9cSa+/IjIgz2RtVcax8/3dL4uXpCEWZb0qlN881QV910ZBtJ
	 f1cI854VMlvSv2hg2dIh7uOCtJGGEdHsE8p+t/qsOF8RkrBVQRxi4DGyAHCyj484gW
	 fhXtEq5hKzPzc9IKtjBv16B8LbFMROnXsn+VJ8ZIs2JEEEWPah6Ny4yBA/4fI9DnPH
	 JW0JVz+Kwdp2gGGQEzN72I17FWjXyk/NiC7wXEea+R3FC19nw1bjFj5L5NO/vPwlAf
	 XZaK4Ycx5W9I9WjjtJ1uxL6M+1DjLOBYMiK7lOBci2ABQ0zrY7mY59QLEf9+hmWRGr
	 oSUtyQkj9gH7A==
Date: Mon, 10 Feb 2025 12:35:05 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Zhihang Shao <zhihang.shao.iscas@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org, ardb@kernel.org
Subject: Re: [PATCH v3] riscv: Optimize crct10dif with zbc extension
Message-ID: <20250210203505.GA348261@sol.localdomain>
References: <20250205065815.91132-1-zhihang.shao.iscas@gmail.com>
 <20250205163012.GB1474@sol.localdomain>
 <20250206201950.GB1237@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250206201950.GB1237@sol.localdomain>

On Thu, Feb 06, 2025 at 12:19:50PM -0800, Eric Biggers wrote:
> On Wed, Feb 05, 2025 at 08:30:12AM -0800, Eric Biggers wrote:
> > On Wed, Feb 05, 2025 at 02:58:15PM +0800, Zhihang Shao wrote:
> > > The current CRC-T10DIF algorithm on RISC-V platform is based on
> > > table-lookup optimization.
> > > Given the previous work on optimizing crc32 calculations with zbc
> > > extension, it is believed that this will be equally effective for
> > > accelerating crc-t10dif.
> > > 
> > > Therefore this patch offers an implementation of crc-t10dif using zbc
> > > extension. This can detect whether the current runtime environment
> > > supports zbc feature and, if so, uses it to accelerate crc-t10dif
> > > calculations.
> > > 
> > > This patch is updated due to the patchset of updating kernel's
> > > CRC-T10DIF library in 6.14, which is finished by Eric Biggers.
> > > Also, I used crc_kunit.c to test the performance of crc-t10dif optimized
> > > by crc extension.
> > > 
> > > Signed-off-by: Zhihang Shao <zhihang.shao.iscas@gmail.com>
> > > ---
> > >  arch/riscv/Kconfig                |   1 +
> > >  arch/riscv/lib/Makefile           |   1 +
> > >  arch/riscv/lib/crc-t10dif-riscv.c | 132 ++++++++++++++++++++++++++++++
> > >  3 files changed, 134 insertions(+)
> > >  create mode 100644 arch/riscv/lib/crc-t10dif-riscv.c
> > 
> > Acked-by: Eric Biggers <ebiggers@kernel.org>
> > Tested-by: Eric Biggers <ebiggers@kernel.org>
> > 
> > This can go through the riscv tree.
> > 
> 
> Actually, if people don't mind I'd like to take this through the crc tree.  Due
> to https://lore.kernel.org/r/20250206173857.39794-1-ebiggers@kernel.org the
> function crc_t10dif_is_optimized() becomes unused and we should remove it, which
> would conflict with this patch which adds another implementation of it.
> 

FYI, I've removed crc_t10dif_is_optimized() in the crc-next tree via
https://lore.kernel.org/r/20250208175647.12333-1-ebiggers@kernel.org

If you can rebase your patch again and address my comments, I'd be glad to apply
it to the crc tree for 6.15.  Thanks!

- Eric
