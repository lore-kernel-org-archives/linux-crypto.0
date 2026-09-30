Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE2A751118E;
	Wed, 30 Sep 2026 16:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786085; cv=none; b=SpoVJt76Mf6mu1YIBdQoyjnumWVVklnHx18aoiMbJQ67gltvPkKNcqHwXn/SZnHgyo2ZnCNDIl72YP0eugoEivVio4bUfxTOZzfLRkkPK0jnrsnuG+5F0ylNHClydFl0doRa/lS8Bc/TJU1Lw3apzWtTbtPlQGcZ4sUToMoxGo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786085; c=relaxed/simple;
	bh=OJs/LQB9zLLgnfLfJGEv0OVxfbJJav4o2zLRDZC0E3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ObgNcBcsskyIvkc67+UFGt51SNK8lf9al98iRlGWXOczub3tmmjWDx7JHAF9s4tMooVCKV8X9g3U5GtYsoEAHgYGBlI26AQScXhJhrlbPC3DeYy49dx9cTl0HQOwJScYuimolWzIZFOFr2Ulu54W3euuKtbLBZuzbDz5FLZVz0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ISNKR6tC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ISNKR6tC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766C91F000FF;
	Wed, 30 Sep 2026 16:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790786083;
	bh=AtLWs5RFMuweEzvCOmYwi1Ud3EiOZVknueZEEkySwwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ISNKR6tCIUtylkXu6U+CUTjTjVhNvrDm2s3OAm/c/z37MKRf69ciB8YpqHQAne9va
	 WMSOfHZ4OIjF0/5yBgU5Q7FT1x3HVLOV8AV2V76+eG6MgXAwcxMIGwceVXgmBE7nM9
	 ui/NMexae3xGovmMBRbChSUaVvPM5x03nHF7WkGnKCTqS1z5iTtK9Ft/TE0+4xpsuw
	 izYLwqM6r9V78NhnbjSeODpl3gunTmpJq4XsO1Td3AkFFN5g3PPmJyjnnN9wYzZy2J
	 oFSHFbFL9TRSavh62grvND6FA3rl/qctTLsi1GpknR3Cgrs/eeDvphoMyTgNMMwt35
	 2d4PKU1OwXxGA==
Date: Wed, 30 Sep 2026 09:34:42 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Stian Halseth <stian@itx.no>, sparclinux@vger.kernel.org
Subject: Re: [PATCH v3] crypto: aes - Fix undesired override of some
 optimized AES modes
Message-ID: <20260930163442.GA1904@sol>
References: <20260929222752.36427-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929222752.36427-1-ebiggers@kernel.org>

On Tue, Sep 29, 2026 at 03:27:52PM -0700, Eric Biggers wrote:
> The new library APIs for AES encryption modes were wired up to the
> traditional crypto API via crypto/aes.c.  However, for now the kernel is
> still in a transitional state where various architectures still have
> architecture-optimized implementations of AES modes in arch/*/crypto/,
> wired up to the traditional crypto API only.  Because of that, the
> crypto/aes.c algorithms were given a cra_priority of only 110 to prevent
> them from overriding arch/*/crypto/ in the traditional crypto API.
> 
> However, because of how the traditional crypto API works, the
> cra_priority trick doesn't work in cases where the relevant algorithm
> isn't directly implemented by arch/*/crypto/ but rather is provided by a
> template instance using other code in arch/*/crypto/.
> 
> For example, x86 doesn't have its own "ccm(aes)" but rather relies on
> the "ccm" template constructing it from the x86-optimized "ctr(aes)".
> The existence of the library-based "ccm(aes)" prevents that, even though
> its priority is lower than what the template would produce.
> 
> Thus, "ccm(aes)" ends up using the slower single-block AES code.
> 
> Therefore, skip wiring up the relevant library-based code to the
> traditional crypto API on architectures where this problem can occur, as
> determined by what exists in arch/*/crypto/ for each architecture.
> 
> This is ugly, but it's also temporary: these conditions will go away as
> architecture-optimized implementations of AES modes are migrated into
> the library.  But until then, we need to prevent performance regressions
> by ensuring that the optimized code continues to be used.
> 
> Fixes: 20df21a482aa ("crypto: aes - Add CBC and CBC-CTS support using library")
> Fixes: 8ca62072faa1 ("crypto: aes - Add GCM support using library")
> Fixes: f70ad727d1d6 ("crypto: aes - Add CCM support using library")
> Fixes: 94efa0c9fb36 ("crypto: aes - Add XTS support using library")
> Closes: https://github.com/sparclinux/issues/issues/106
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is intended to taken through libcrypto-fixes
> 
> v3: Also suppress xts(aes) on SPARC, and improved comments
> v2: Fixed PowerPC config option, and resent as standalone patch
> 
>  crypto/aes.c | 51 +++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 47 insertions(+), 4 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
