Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AC72798F3;
	Sun,  1 Feb 2026 04:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769920897; cv=none; b=DIJrKgMi43CEfClzNgR2MPQU4k3RKcdAlIk2iEdopqIOIVLOqCNwFIH+kPhOL2h5Kk9fB/yu/Yfh6ulNOMnW+H7jhyy8rxXpUWo1K3StGNGtxg4nuUxbGglKL58bBFQCp0R9fjUvBZiJYIBN4c+agms7JPfV6HAIq0ULW8cESmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769920897; c=relaxed/simple;
	bh=4KOknl6N+EMg91T+4Jdta0Y0/KymmFiMN0hN8qyOIw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=swlnIYE37nO7FbWonHHVYohJT09PRgqMFQI6GY1xnD8gZjr+DgGWgJcYjCyE3HjVpnCP7PJd6UbU3Rj5d1zfFTex890+CJ2v8MHWXdDNLFCaoB5xEcuccuQxjqAJCPkkLonmGskpiMqVX7ajEi2eE0vc7IdC3G4Pw7EwEtH/jMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M7Sh4Nb6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M7Sh4Nb6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06ED2C4CEF7;
	Sun,  1 Feb 2026 04:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769920897;
	bh=4KOknl6N+EMg91T+4Jdta0Y0/KymmFiMN0hN8qyOIw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M7Sh4Nb6tcAfbCKRvtDS40Gp5TOnZnJkzBJYvyG4zEG5Q7cdSaZex4+jz2kWUaF15
	 0EKZQrhtRfPFSR2Pe6Oi9ho3V1oACRb+hLhirPSBi4gLSGOCbluzqsdv9jBOQxXJ7C
	 UscecSuKR3JpyRyom+X1Ubtz6kPfcUgbsGhKQ2NdUAnOL6eRkK7o8ibuYYFiEQRGYo
	 lug8gIY1ftUnyaouZNJt3X5d1tZwyutCTqDrT1hLeK2DGF0fWDrAzUhYohQUchwdMb
	 NY1WVqGHHir5eOs5e1Z77lq6zdwnzWDHQhttLEgJNJmd0Gy9qzVSifbBTdg7gdmZr3
	 K3bTrAJm7PeIA==
Date: Sat, 31 Jan 2026 20:41:35 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Daniel Hodges <hodgesd@meta.com>
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@cloudflare.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>, keyrings@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: pkcs7 - use constant-time digest comparison
Message-ID: <20260201044135.GA71244@quark>
References: <20260201035503.3945067-1-hodgesd@meta.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260201035503.3945067-1-hodgesd@meta.com>

On Sat, Jan 31, 2026 at 07:55:03PM -0800, Daniel Hodges wrote:
> This creates a timing side-channel that could allow an
> attacker to forge valid signatures by measuring verification time
> and recovering the expected digest value byte-by-byte.

Good luck with that.  The memcmp just checks that the CMS object
includes the hash of the data as a signed attribute.  It's a consistency
check of two attacker-controlled values, which happens before the real
signature check.  You may be confusing it with a MAC comparison.

- Eric
