Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2252B4657DF;
	Thu, 26 Feb 2026 19:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772135732; cv=none; b=P8Jx9P38ATiErGP9p2pq40JkbClPJ8WGSafIBYWI8/NiQBz049wslTb4AkikvYRiCoANTUqK5+rPSEjMs/ab39I1YQwrRhnVJyMnV3S75zMKZFoxtVk94y/NmdiaxWTUB4aOcIUI7jL/U8mL59mZRjNa/Gb/HfuqIVK4d078z9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772135732; c=relaxed/simple;
	bh=XeE4MfnoD1Gac/djppLiAsbbhx0QboJzv/ayBzFJW+w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MzcM+qlo3GKEmzP/E+7OLNSgHP8t5kWOyA4BHGMVOvJz49uEeNk8otD38Z5UgNbvK1CT3FahtDfMcNnfYIN7xutX/a99hR4Rdr0hJFTbYLIENBW48Kb4xYJwup7SnSnHfExnrr7BQNbjGfAqcsPOj7sAa3e+JJbZSv9lFyWdWqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=czHPwhZo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="czHPwhZo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E445C116C6;
	Thu, 26 Feb 2026 19:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772135731;
	bh=XeE4MfnoD1Gac/djppLiAsbbhx0QboJzv/ayBzFJW+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=czHPwhZoGRSm+Kgyl6XYimYwM4fIJga8rS3dmfAK369r5UcmBVOnW7VK/rKBZ6cQ/
	 00y5NVnM3gvp2NuboyXF2Yyg9nfIDusr/ABNdGMyrvlg1aypSalw/f1u/Ive9N2TGi
	 CMjlEfRlLrIlpTgcXxR8uAA+055iiLubCVnzY6e1r0XsNAjeciCuqZS91gyu+1q5mJ
	 CB57DbNZ7om8zQp7LejanT/27arC2kYlLg29a8hXdA+McuExMmtAP0eKfbvW63w86e
	 puhayKBx5l17mvRnCJ4URIkdn4lSH7hXLLUQMMfl1BTf1L2gXLgrZaXEEVISpbcp8C
	 fP0OIVk+krpFw==
Date: Thu, 26 Feb 2026 11:54:40 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] crypto: Drop stale usages in various help texts
Message-ID: <20260226195440.GH2251@sol>
References: <cover.1772116160.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1772116160.git.geert+renesas@glider.be>

On Thu, Feb 26, 2026 at 03:46:04PM +0100, Geert Uytterhoeven wrote:
> 	Hi all,
> 
> This patch series drops stale references to subsystems that are using
> various crypto algoritms.  It was triggered by "make oldconfig" in
> v7.0-rc1 showing new prompts about BLAKE2b, SHA-256, xxHash, and CRC32c
> algorithms.  When querying these symbols, the corresponding help texts
> incorrectly claim they are used by btrfs.
> 
> Notw that even if correct, there is no need for such references, as all
> users should select the needed symbols anyway.
> 
> Geert Uytterhoeven (5):
>   crypto: Drop stale CRYPTO_BLAKE2B usage
>   crypto: Drop stale CRYPTO_SHA256 usage
>   crypto: Drop stale CRYPTO_XXHASH usage
>   crypto: Drop stale CRYPTO_CRC32C usage
>   crypto: Drop stale CRYPTO_CRC32 usage
> 
>  crypto/Kconfig | 9 ---------
>  1 file changed, 9 deletions(-)

Thanks for cleaning this up!

If there are no objections I'd like take these through libcrypto-fixes,
given that they are related to the library conversions.

- Eric
