Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5AA2399354;
	Mon, 30 Mar 2026 19:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774899470; cv=none; b=gasYN05HSCF4TfnV8kKFpJ3GFArgFdWHIBQrcthO8Ltihbv8Epx/nln9hvZFB1nK4TIPG62pwsrL/CqlV9IwmsY1yUAOFI7WkCbLIkE5rv2pHt2hujnF0L+HEqlPBep72i/tc6H18z6d3gX6I+vYJ3a6JeBi9YbHegKPTHrOunA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774899470; c=relaxed/simple;
	bh=HcPfb3mUQYlrygZRolUZecA4/UgyE3xPkjXDPzjCIFY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jYWm3vVAhx0e0sJZf+cQnPa+vKR5wDIcYdx4ducSY/TIIqOVHv/09O6eNnjYC0YKbNCPveFx09/rSumBzrkdIG19uy69jtuHDWtMaRF+JoTdqdffIi+9VGZMXXbYdpbZeA2w4pDIEVvAEV/5wW3kLOoeVHrhs3+xea8wxls/xLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gVzLr6Co; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gVzLr6Co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B3BC4CEF7;
	Mon, 30 Mar 2026 19:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774899470;
	bh=HcPfb3mUQYlrygZRolUZecA4/UgyE3xPkjXDPzjCIFY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gVzLr6CoWsODYt4pAj5Te3R7GDslta5b4Y/aFJhhgL3KYA43wvsEEfPe+SIPALhbv
	 XLL3sGO43tDRylb3UmTW0L3qGHOQda1GzCibZ98EbnDOJEtqw7W0Mtc2FaRuOPEm70
	 t89447QRzczhqaBB6G9G2bM0BqEtekkrk82HdGCGZjjVauES57xOP/70qqsw9gEhKZ
	 DRD76dYpU31snBzJwqpaqWUCLS+vKus6OcCkP2qxK3/HuDzlPR/q/X16VNDAOCFEbF
	 1ROp3fme6zygQAveKSOD+L44cg1FA80CZXZb9vfyj6Uw9kSoONiQYU1HgjNoji/s6I
	 sB5CHNpFJJwFw==
Date: Mon, 30 Mar 2026 12:36:41 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linux-mips@vger.kernel.org,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH] lib/crypto: mips: Drop optimized MD5 code
Message-ID: <20260330193641.GA4303@sol>
References: <20260326204824.62010-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326204824.62010-1-ebiggers@kernel.org>

On Thu, Mar 26, 2026 at 01:48:24PM -0700, Eric Biggers wrote:
> MD5 is obsolete.  Continuing to maintain architecture-optimized
> implementations of MD5 is unnecessary and risky.  It diverts resources
> from the modern algorithms that are actually important.
> 
> While there was demand for continuing to maintain the PowerPC optimized
> MD5 code to accommodate userspace programs that are misusing AF_ALG
> (https://lore.kernel.org/linux-crypto/c4191597-341d-4fd7-bc3d-13daf7666c41@csgroup.eu/),
> no such demand has been seen for the MIPS Cavium Octeon optimized MD5
> code.  Note that this code runs on only one particular line of SoCs.
> 
> Thus, let's drop it and focus effort on the more modern SHA algorithms,
> which already have optimized code for the same SoCs.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting libcrypto-next

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
