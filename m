Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CE662D7DC0
	for <linux-crypto@vger.kernel.org>; Mon,  6 Oct 2025 15:49:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759765798; cv=none; b=BH04Jk1H8ufTIkCkB0u1pF6bHVtgOVwAydFMIfNUfVqLpq2Voc02DMzZQUbiD/ffDc6By7x+NSBfG7qkbYz1qK1pgG67g0qCjvPhrEETSsoCaxoYmrCcoOUhd+ucUsa1T/ZcuBxMOj96R7lYfRicZAugGLLssT3gnYIPti7RuCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759765798; c=relaxed/simple;
	bh=3U0/R/tnLBInNJLLMY1j7rxaee3kMtrwjUr5IwIXF1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uSqwlbN6j2E4hyWcvo6dd4xuuuBVaWdqTulqGysrVbF4M4Mefbkig0sb6+eXU328rdj31DypO5/UM/qaQKZDvk3I2/apv/dVNtZ0rCz8QLoVdYSu8CVH+pyfLV3AKAfOOXnO5ptUV43RrYyjPKZaSTzcfxVq/wjgrtXg7n5auAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HoL0lCFy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HoL0lCFy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C65C4CEF5;
	Mon,  6 Oct 2025 15:49:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759765797;
	bh=3U0/R/tnLBInNJLLMY1j7rxaee3kMtrwjUr5IwIXF1s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HoL0lCFyTsBF5bSu7IZIg9dG2SSVNvDvSk/l6XS35Az8QJ9GziPqkKXntsfYyNA5r
	 RJ07/wS4Q5uDNXtF2ZFyPNP+vsn6VPn9Oh1q323IdcQ6Y113EJrCwt6ria3U+tagm7
	 GmRvRboY+PyQzsYUGFgHt1JEDdHuGuyq6jwArKQBV5N49MVtzUmoPsTqEp6HMQC7cq
	 aDjSyXC5OiwoNqyxWPMX9Nv+1lgCCwpd1FBEZdT5ODUPTNmUf8AwcBRmXWBcnBIFuo
	 bIEF2LX1mjrb5SUW1ZbX0etPjOaVW3fdQ8THnIPzXuCcoPEM4NLvnNRyPQq/QNd6Zy
	 p/ftWwgw/Wy1A==
Date: Mon, 6 Oct 2025 08:48:33 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Jon Kohler <jon@nutanix.com>, Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Stephan Mueller <smueller@chronox.de>,
	Marcus Meissner <meissner@suse.de>, Jarod Wilson <jarod@redhat.com>,
	Neil Horman <nhorman@tuxdriver.com>,
	John Haxby <john.haxby@oracle.com>
Subject: Re: 6.17 Regression: loading trusted.ko with fips=1 fails due to
 crypto/testmgr.c: desupport SHA-1 for FIPS 140
Message-ID: <20251006154833.GB1637@sol>
References: <20250521125519.2839581-1-vegard.nossum@oracle.com>
 <26F8FCC9-B448-4A89-81DF-6BAADA03E174@nutanix.com>
 <ec2b9439-785e-475f-b335-4f63fc853590@oracle.com>
 <C9119E6C-64C8-47D7-9197-594CC35814CB@nutanix.com>
 <20251004232451.GA68695@quark>
 <45ed5ca2-f371-4030-9fc7-0a8bfc142b41@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45ed5ca2-f371-4030-9fc7-0a8bfc142b41@oracle.com>

On Mon, Oct 06, 2025 at 12:44:09PM +0200, Vegard Nossum wrote:
> 
> On 05/10/2025 01:24, Eric Biggers wrote:
> > Submitting a broken, untested, and incomplete patch that makes the
> > kernel fail to boot and dm-crypt.ko fail to load isn't a great strategy.
> 
> Wow, that's a highly unfair characterization :-( The patch was tested,
> but the dm-crypt failure only appears in certain configurations that
> includes both the hardware and the specific kernel config. Furthermore,
> I think the underlying bug was merely exposed by the patch to deprecate
> SHA-1 but I'm not looking to point fingers so I'm not going to say more
> about that.

To be clear, the patch introduced at least two bugs that broke basic
functionality: the dm-crypt one (related to trusted_tpm1.c) where
dm-crypt.ko failed to load, and the ipv6-sr one where the kernel failed
to boot at all.

- Eric
