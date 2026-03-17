Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BD0322A00;
	Tue, 17 Mar 2026 16:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773764966; cv=none; b=tMHjWWtIXhAUHUpK52eRpvMI4uFHT70h1efKJLHHIe9gprvIGOdt+LG1taBcyXh8E9bSlwWCrmXh9aZXoKjluOEqHhnz+H+O/Zgmr87f08zQiYAVYqInPaflYyvPdNVOyeb7Khw/p++u3uS6lFLgjfa6nFLu3T6K82mLmt5jzpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773764966; c=relaxed/simple;
	bh=IhHFU2XjpSVShyKbiRl4NfYWjArEyXN0qLILNP0KZHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AOUPgPmE4N45qnhiOgSLqh+eurRX73FEDtq3Yt8i4OHpdbl55IHS7dnwOtcDGlvdWHxd4vllgP6VLkC8oCG+GExgg0yJ/CHxdDwLvbBSy8XaPhMsbWYtCPB6qgsuvjlmQxxGb+fKYePJNebT/1L4uol9RFVRJVy9gd0Ma3iWrqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=abFBVl0p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="abFBVl0p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46312C4CEF7;
	Tue, 17 Mar 2026 16:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773764966;
	bh=IhHFU2XjpSVShyKbiRl4NfYWjArEyXN0qLILNP0KZHk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=abFBVl0ptWtdbUyTpoO0VxFTxIRzTg5qX/2ODVHJIiXWyjLWfD0SlJ3EgXKhypcNo
	 g4ZiN3Ljw7n4OKh5HPrL1xcm42Y2PCsGXTbGTeY1mQCa3pz4Xf7Z7HD6IWETYvILjc
	 YnZ+PVKdim8atbyiulwIrIDfG5tHiOtzgSBmFW4P9XIlCq0RD1w5+0TVuPoaWJSYv1
	 UrO4DA7YmiWt/prOAzwU61NWL1fYiwji9m04S3SdgcRqk1mfRWvavCTaS6JTsy39ZZ
	 0cIdK12Jv+QYpCl4EGrUWBz/Z1zgAvUcPd+5roM248kGV+vyqFa2o02iejQ1NvEUt7
	 op0M8RZWpSAcA==
Date: Tue, 17 Mar 2026 09:28:26 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] lib/crypto: powerpc: Add powerpc/aesp8-ppc.S to
 clean-files
Message-ID: <20260317162826.GA2931@sol>
References: <20260317044925.104184-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317044925.104184-1-ebiggers@kernel.org>

On Mon, Mar 16, 2026 at 09:49:25PM -0700, Eric Biggers wrote:
> Make the generated file powerpc/aesp8-ppc.S be removed by 'make clean'.
> 
> Fixes: 7cf2082e74ce ("lib/crypto: powerpc/aes: Migrate POWER8 optimized code into library")
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  lib/crypto/Makefile | 3 +++
>  1 file changed, 3 insertions(+)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
