Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F60730C371;
	Tue,  3 Mar 2026 19:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772567944; cv=none; b=LZfEBGDoMNPTRBrV5ldVD3OIwYxb/LiXnHVf+tuLjto4mJo4D1VXqz9C79aD69U7DufSWgNMOVZe7LcFIZwZ8uP7T8YbUeY9QRElKG++5gx0DP7IWN4R14RCFqrnusftLUJKPvFgBxozc3kPDojZP5j74RZIxeoLh3ZZwZiDqKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772567944; c=relaxed/simple;
	bh=9fPUIdzfqT+sR7Yy8pvxcpYK+B8255T9ohMfYTkVnBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lIy58NDwnrsd1KQ+JES9CxPLimke8vBGHEXKuOptPNM1ZCJL12Ge1hkPG9xhQyFg7fqklfYZJttzfuUN2jm8l7yh5Whu4rRRR/PuxmUW9cvBt7ZQHnXe7c8OLsZp3CCtowCqxpnSdkm0upYh3HZMDNWrNMpMDzhaunEYZWdZ3d4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=my9qGj67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="my9qGj67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 028E2C116C6;
	Tue,  3 Mar 2026 19:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772567944;
	bh=9fPUIdzfqT+sR7Yy8pvxcpYK+B8255T9ohMfYTkVnBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=my9qGj67jv4gpyQ99UxyaYzfNAmonfJJl8oXWn43rlisUEwPsIFPshjw5r9P5dBWl
	 NIdFAccFRPIRwkCIwSJcsYKbOSo+xxqhLi2stIeK6x7z0UgTQSeQaCgVrJcqK4/Di0
	 zLAwwLJ4NfgWC0dfSZQV2kmWDvoQ4VbInwv9LYc1SBO9KrGmWdv1jZ25t9AbYOOAzM
	 0+C2IPzh7Ht75h8fB3NlsFArB7adEAUUcasH42PcXe8B8DVyv/kH+0+xH6Yn5n2PNo
	 x/Mrd7g5ugAAGAeu47gXBY5YMQj6hETQfDOJWLV1Ms1z9uXHn+Hc9LOqcYTpKrsFjD
	 9cY9wIGgk+Ybg==
Date: Tue, 3 Mar 2026 11:58:06 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Aleksander Jan Bajkowski <olek2@wp.pl>
Subject: Re: [PATCH] crypto: testmgr - Fix stale references to aes-generic
Message-ID: <20260303195806.GD2846@sol>
References: <20260302234856.30569-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302234856.30569-1-ebiggers@kernel.org>

On Mon, Mar 02, 2026 at 03:48:56PM -0800, Eric Biggers wrote:
> Due to commit a2484474272e ("crypto: aes - Replace aes-generic with
> wrapper around lib"), the "aes-generic" driver name has been replaced
> with "aes-lib".  Update a couple testmgr entries that were added
> concurrently with this change.
> 
> Fixes: a22d48cbe558 ("crypto: testmgr - Add test vectors for authenc(hmac(sha224),cbc(aes))")
> Fixes: 030218dedee2 ("crypto: testmgr - Add test vectors for authenc(hmac(sha384),cbc(aes))")
> Cc: Aleksander Jan Bajkowski <olek2@wp.pl>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting libcrypto-fixes for v7.0
> 

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
