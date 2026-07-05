Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53128433E8C;
	Sun,  5 Jul 2026 19:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783281013; cv=none; b=YyuBU+msD+GbgiWHBCboCs26+ZjTqpYBh8xZKlZL6vok3cmm9DfYGXsRtchW8iv4kkI3dLRH3WAkoJrv338Yu2cBC7IVJwQ/lEzLnHx/V9r35Z2KTbuyIRCSOkSEPc7hD2KixBmHWkuW6PWcZbKNR7Kdul96xSzhdyk6muXYfhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783281013; c=relaxed/simple;
	bh=W2U/CnNdjerr2TKTbX8+3ETyURoT4rvqn0HpJKWUNBo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c7Jk3Fz+ttxfwiXpxYeHIb30Y44vagjosiScRHETyMtJB/a9mV50G/rlw0I1AARLptpEU/+Jz6RHBTgAfb4K1sDFL5eVYFQ57wKvKhe5k4qSoEwSSk+0V6B6er1QsOB3akX4cfRH8E7xH4x8L/8sZZu+yHG6EB2OcH730sNKfB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TE43ZY8U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TE43ZY8U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FEE11F000E9;
	Sun,  5 Jul 2026 19:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783281012;
	bh=yXRy09R6rHvPoHh5Zm5zC7wmHiSGViPbQiwmRYcWs08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TE43ZY8U0XgWWb4lPeDe1/F+DXNnXQUNdGRKW37m731HG/L61d89bc9TDMBjISxwL
	 i8x2kISNev5QEbzs1gpxsnaw5zg/VpqPHZDcTpx1wDnBWkIvCoU85moqSfu1Ty8PLL
	 b1ykMKaEr0q7ssWdFdBIZa3eCIa2VJ85Q7efz4cOxoziTPM+JdA0TZsVpUsB8a7JuK
	 llIWFJVXaeyTHgXVS42atISu8FomcprlxCqBK8KrxLlr5Ay+bnOmyIpSq+6k2iv+Ij
	 C0SMdKsQ9brJ6B5JJl716uYbrzvYEV2KzTMH0oFdTSPNq9iujRm+8TYa3IGem60kgE
	 EhSjdWtxxJinw==
Date: Sun, 5 Jul 2026 12:50:08 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib/crypto: md5: Remove support for md5_mod_init_arch()
Message-ID: <20260705195008.GE41916@quark>
References: <20260629032552.26100-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260629032552.26100-1-ebiggers@kernel.org>

On Sun, Jun 28, 2026 at 08:25:52PM -0700, Eric Biggers wrote:
> No definitions of md5_mod_init_arch() remain, so remove the code that
> handles it.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
