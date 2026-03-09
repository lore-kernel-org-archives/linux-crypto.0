Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1CCF33C1AD;
	Mon,  9 Mar 2026 20:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773088134; cv=none; b=MIt46+NiGgDd59ToIkI86ARiuAAiwqIoOmlJ0I4POjg4zO6cVPSJLP9XZ9PL0Hr3B1cAm16VqTS+e5M5jRywN8wlOYA+C6uevRJe1jvKK+EjBkbAABQUcyqN1zF1XZ4utfPLAArAlXlB0FlOjzvVLDqwcq2kypeWhZMESFh1PLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773088134; c=relaxed/simple;
	bh=2ADTOeDzMyU/IdqDwS4kW7ACQAAk1gTeS2bm36vP3gQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P/6BpyPr/c7dP3vwbmb0jOxqnwUAdf7ZdBJCgWT1+XZaSOUhCmXNbg9A5tohzSohAepBq06aXwJoxp4+WUPjircXpL9DLUGlk+rmQHtjJ/c8KaS+2n/Qhc7mOmtgYcohLPReNDOJjdr1tJ/Qq55KCY+dBaI/kyGQExb4VCvCTQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sz1t21Yc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sz1t21Yc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FDDC4CEF7;
	Mon,  9 Mar 2026 20:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773088133;
	bh=2ADTOeDzMyU/IdqDwS4kW7ACQAAk1gTeS2bm36vP3gQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sz1t21YcHfdErcnWDign6akX+9+rZjuAbPqmj8FWwLZXciUDQpXhjkhaGWY2Xv9dn
	 +1o/3xpORjti5aAGfUEtN+7xsVHqS6HvC8Tlof74dpVMpo+e0hjhiKyblCRkWQUdP4
	 KdWBU+YgBytAjpYe47oQPjf/HdKbcGFtTNonRHcUk+weVHWfYSv8kjmRPBYiC8IRAM
	 nbd8TdMCHqyRhj4rpDoaY2332484KxVEgi5G0tG0jPCXRr2OLEsUzsqtJQVEbOhabt
	 u5HkhxynErL0usBRDItp6CWu0uohI3MU4bHanZKnG9zp4roVpOphvCL6K5IUCmAZGt
	 Q1BrP8TTg1w8A==
Date: Mon, 9 Mar 2026 13:28:51 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: tests: Fix aes_cbc_macs dependency and add
 to kunitconfig
Message-ID: <20260309202851.GA2048@quark>
References: <20260306001917.24105-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306001917.24105-1-ebiggers@kernel.org>

On Thu, Mar 05, 2026 at 04:19:17PM -0800, Eric Biggers wrote:
> Update the dependency of CRYPTO_LIB_AES_CBC_MACS_KUNIT_TEST to match the
> new convention established by commit 4478e8eeb871 ("lib/crypto: tests:
> Depend on library options rather than selecting them"), and add this
> test to the kunitconfig file added by commit 20d6f07004d6 ("lib/crypto:
> tests: Add a .kunitconfig file").
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This is targeting libcrypto-next.  This patch is needed because the
> aes_cbc_macs test is queued for 7.1 and wasn't handled by the commits
> mentioned above which were merged into 7.0.
>  
>  lib/crypto/.kunitconfig  | 3 +++
>  lib/crypto/tests/Kconfig | 3 +--
>  2 files changed, 4 insertions(+), 2 deletions(-)

I folded this into "lib/crypto: tests: Add KUnit tests for CBC-based
MACs", since it's a fix for that commit.

- Eric
