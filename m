Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF4323890E7;
	Tue,  3 Mar 2026 19:31:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772566318; cv=none; b=CoIhOBhTsWSor18rxTNgWMvwJP7+hwcxGLLvUo02K+jO0G3xlLiBmjkJjv2e1/kGXBvcOcXF3PadwJ4T0dpNWLZBNKG5+719r9FekZmzkQ7+ht8psQgNfYhGAIMKwDAYZSYg8cxBXjz6IUfmq4YrsmMAJrkSOdu75g6CedbHPVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772566318; c=relaxed/simple;
	bh=i9EZozHW8XRAVLe8EAr2xfM/6NutGAKezx67stLre7Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P+oLoGgaRcRNmJQWA+2+7gEICEqbyN+klesFLf4ZYxVMsbCGSlE0pr+2NrsKDyESfz00eUaR5fAmykn92R0CElSnksCVWUzCj0qPZdveJnlMqcllnhJnq9aoaztQyQKCxNsZfiM3boXt7gfPbcBmQESWLKZ0y0cnjuHSTRZekN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LBMtiYqd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LBMtiYqd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAD2DC2BCB2;
	Tue,  3 Mar 2026 19:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772566318;
	bh=i9EZozHW8XRAVLe8EAr2xfM/6NutGAKezx67stLre7Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LBMtiYqdzTeup8FJVWXxT6ukyG6zRobBUe/9Mx8IhAhFrfRxHAAIym3RpikfeMD8m
	 v+A2VcjZ21cSREjyMLdsu4gGu0wL0kRMhC4IlX1qyyeULlbBGl5uw6UGuBBquOolxm
	 Row+8ruBmAX+JL+HmOC80eEVQkVtrtMP8DP02cDIuI7a5crnsN/KD8SglZtR0sV8T2
	 FSzBQStrg4lKjjyetLh5Js0XceJBji3eyotTabSoV8O5Bg2+oeRAjkkb6HQGmyyYd8
	 IiX+5wsaOMUgS37UEGItnTYawAACGA3cYTgx4ebBRCK2MxWOXqEBOSJPb1mhDQEhyr
	 p8K4qxyCPAlBg==
Date: Tue, 3 Mar 2026 11:31:02 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Joachim Vandersmissen <git@jvdsn.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	linux-crypto@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev
Subject: Re: [PATCH] crypto: testmgr - block Crypto API xxhash64 in FIPS mode
Message-ID: <20260303193102.GA2846@sol>
References: <20260303060509.246038-1-git@jvdsn.com>
 <aab5ptuamQ7d_tTi@infradead.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aab5ptuamQ7d_tTi@infradead.org>

[+Cc dm-devel@lists.linux.dev]

On Tue, Mar 03, 2026 at 07:09:26AM -0800, Christoph Hellwig wrote:
> On Tue, Mar 03, 2026 at 12:05:09AM -0600, Joachim Vandersmissen wrote:
> > xxhash64 is not a cryptographic hash algorithm, but is offered in the
> > same API (shash) as actual cryptographic hash algorithms such as
> > SHA-256. The Cryptographic Module Validation Program (CMVP), managing
> > FIPS certification, believes that this could cause confusion. xxhash64
> > must therefore be blocked in FIPS mode.
> > 
> > The only usage of xxhash64 in the kernel is btrfs. Commit fe11ac191ce0
> > ("btrfs: switch to library APIs for checksums") recently modified the
> > btrfs code to use the lib/crypto API, avoiding the Kernel Cryptographic
> > API. Consequently, the removal of xxhash64 from the Crypto API in FIPS
> > mode should now have no impact on btrfs usage.
> 
> It sounds like xxhash should be removed the crypto API entirely.
> There's no user of it, it's not crypto, and doing xxhash through
> the userspace crypto API socket is so stupid that I doubt anyone
> attempted it.

dm-integrity, which uses crypto_shash and accepts arbitrary hash
algorithm strings from userspace, might be relying on "xxhash64" being
supported in crypto_shash.  The integritysetup man page specifically
mentions xxhash64:

     --integrity, -I algorithm
         Use  internal  integrity  calculation (standalone mode). The integrity
         algorithm can be CRC (crc32c/crc32), a non-cryptographic hash function
         (xxhash64) or a hash function (sha1, sha256).

         For HMAC (hmac-sha256), you must specify  an  integrity  key  and  its
         size.

Maybe the device-mapper maintainers have some insight into whether
anyone is actually using xxhash64 with dm-integrity.

If yes, then dm-integrity could still switch to using the library API
for it.  dm-integrity would just need to gain some helper functions that
call either the xxhash64 library or crypto_shash depending on the
configured algorithm.  If the full set of algorithms being used can be
determined, then dm-integrity could even switch to the library APIs
entirely, like many other kernel subsystems such as btrfs have.

- Eric
