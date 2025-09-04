Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF11A2C08C2;
	Thu,  4 Sep 2025 21:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757021724; cv=none; b=JHsILf9e+qI+XWusMMSuV3ASc2687lx/TdWG0ivs2mIpXOz7TnAnTNSwlcNZQw9t6oEZQd8IoVQZahAHET9aIy9T/RTwanRJkR9mptGwVYgecCEua9G3jgMXlho7TbC166wWwt9mBSeo6z3v3p8cj+8majU6mMAt4lpKjyZy7BA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757021724; c=relaxed/simple;
	bh=6I7/mA9gB2+JiSRcUEE6kjw9Wz8T/nLD4+EwH1IlDF0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H9vZjrR1CwnuJwC45i+9ZJBnu7kkFLeWDOHGBn2VeV32QuSpghYPY9Vx0OH0/MPGdWexYrzRTYKauZirF+MW1bWXLJ5tmBTPk7lFXGV7kyRNmVq/O6HqEDnxQUViXe/H8w0M06pZ9JqDo8czTBsNtUOvXvTfu1tq5M//iQkBmSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XVZfXezC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XVZfXezC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C997BC4CEF0;
	Thu,  4 Sep 2025 21:35:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757021723;
	bh=6I7/mA9gB2+JiSRcUEE6kjw9Wz8T/nLD4+EwH1IlDF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XVZfXezCLo+iVSoaoIkx0bpxjFsrPcP8CVfcCDEcbTL9NtIvi0uGhegyFOqrZKHQf
	 SBCOpNaQ8nOKLCwO5eDMjiA/5mexHAMtOb6zIGJn7Y+Gf908wTyvlEbYf1scYf7l5+
	 sJD5zd4gnM8bjGOEsp8oW2bXlIfuCLQHD0qNnz2n0AUDF+6lCIpVTdx9OCto9wqEwu
	 drjfAzkvnzDGj4F60yrjN5FvfHkw8k01r8iLBM1LvT8ApUu7d7S/iw1ikbOXkUbJrT
	 CjBwnlV3XSFHe2S2qZbYbPqr+6pjfgUp6tYB1dl1WKaOr0P/Qw+8S7Ah20kuzonfb7
	 qwFfJOKcbEX9w==
Date: Thu, 4 Sep 2025 21:35:21 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Vegard Nossum <vegard.nossum@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Wang, Jay" <wanjay@amazon.com>, Nicolai Stange <nstange@suse.com>,
	Vladis Dronov <vdronov@redhat.com>,
	Stephan Mueller <smueller@chronox.de>,
	Sami Tolvanen <samitolvanen@google.com>,
	linux-modules@vger.kernel.org
Subject: Re: [PATCH RFC 097/104] crypto: fips140: manual fixups for
 lib/crypto/sha256.c
Message-ID: <20250904213521.GE854551@google.com>
References: <20250904155216.460962-1-vegard.nossum@oracle.com>
 <20250904155216.460962-98-vegard.nossum@oracle.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250904155216.460962-98-vegard.nossum@oracle.com>

On Thu, Sep 04, 2025 at 05:52:09PM +0200, Vegard Nossum wrote:
> Don't build arch-specific SHA256 code yet when building the FIPS 140
> standalone module.

I'm afraid you can't just not support the architecture-optimized crypto
code.  It's usually much faster than the generic C code (often more than
an order of magnitude faster), and it's really important to include.
This applies to all algorithms.

- Eric
