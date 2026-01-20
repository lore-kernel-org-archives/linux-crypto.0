Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B7A32BF43;
	Tue, 20 Jan 2026 22:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768946606; cv=none; b=szwfubhlTCp3fZppOp8yARRq5pYtOQ8rWy0wya3jOyd98s3cCx6wLzQGfrBAAODvg77zsjQuEtamBLfg4v4ygBggw3RFKgcL5I1ZXbtZh0zInIDyQKgjpfQMREo7TnnijUqm0ULh4LsAluYnm3e/CBMjbDqG6jS+doxvXGShhuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768946606; c=relaxed/simple;
	bh=pXeX6+6IzzGCUIZ6OongI+PLe4NHGNNdUP78LQsAv/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=joaQL/TqtQqWkwUOtCquAzFVS3IkC91KCKRc81ioXmd4ftsko6YJpBmzCrSJfQI9q/F7pDp/k2b7CWRpuNss6pTtN7b1/LY2UqmMvfn87IhXSDq2RyMtUakRaR7wpRD1D9fjwToUjRx89znjfbOTyt8t+3nrUkTtP8EE3IcX9DQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XfzOhhSn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XfzOhhSn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E1E4C16AAE;
	Tue, 20 Jan 2026 22:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768946605;
	bh=pXeX6+6IzzGCUIZ6OongI+PLe4NHGNNdUP78LQsAv/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XfzOhhSnh4wtPt0axUq2u9Z2svXL3sUAVDOBI2b8/ekHPHWwm9VfAUyt3jNN7kfqL
	 Y4ObIaTRFDJTtZs1B6zeBC61Vui6FeBxIDrnzMWOIi1Uue7TsoZFA4ErwSvIUflteA
	 mZT0o3bgQeFv6WpKZd/EtWIFUg+oZqe8DtdcOwYW9VGHLJVybqmA/EGpaWMQJvds3h
	 RJ494aCLeihHOI0sA35SBTLCS++no9EZnlBC0ewLuMCKgxgtV08v01XCvm4foUpnGr
	 HycAL+wztaiIwzgDawdrbI/bLaZIl953Et8JRGp6XXvs32Zh8+uhDQ6wtA6HT7r4aI
	 vfLUASv088Ohw==
Date: Tue, 20 Jan 2026 14:03:21 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Lukas Wunner <lukas@wunner.de>, Ignat Korchagin <ignat@cloudflare.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Petr Pavlu <petr.pavlu@suse.com>,
	Daniel Gomez <da.gomez@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Stephan Mueller <smueller@chronox.de>, linux-crypto@vger.kernel.org,
	keyrings@vger.kernel.org, linux-modules@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v12 06/10] crypto: Add supplementary info param to
 asymmetric key signature verification
Message-ID: <20260120220321.GA6191@quark>
References: <20260115215100.312611-1-dhowells@redhat.com>
 <20260115215100.312611-7-dhowells@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260115215100.312611-7-dhowells@redhat.com>

On Thu, Jan 15, 2026 at 09:50:48PM +0000, David Howells wrote:
> Add a supplementary information parameter to the asymmetric key signature
> verification API, in particular crypto_sig_verify() and sig_alg::verify.
> This takes the form of a printable string containing of key=val elements.

As I'm sure you're aware, C has native support for function parameters.
No need to serialize to a string on the caller side and then deserialize
in the callee.

This is yet another example of a case where trying to fit different
algorithms into a generic API doesn't work well.

We should just have a library API for each signature algorithm, with
each algorithm taking the parameters it needs.

- Eric
