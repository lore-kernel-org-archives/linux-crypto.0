Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2572C2500C5;
	Thu,  3 Apr 2025 16:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743698628; cv=none; b=WiZvWsSQczCSlxVuwrXpI6EOoMPoRpnSd7A1MqW0agmTRMb0bOQOOfjmvhJGpyLZv/N0cWj+t95ADUSI0pk0AmQ08U+fQxe7ffdsGS8WBTarGeMcC2CSdquO79SzYE6uPTA7GHmbIrAjUbC55OQip7TBWsgsMMICWq6vkso+seQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743698628; c=relaxed/simple;
	bh=ywT3gUxg2u3h6z8cDoGMXqZ7k187ZOHtuhqQsgj9lCg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EGyXlFinENMJQc/5eqC3GhArNgtJdFLkyaifKbLagVgiojV5LCRjRVRpu1Wz5C/tvQMwCkgCaiT+o+srMOsvF+OtXuUSYlLZuN/jhlHQ/WShEUUnu/RJMhLyzVKxTeqzPtcw8RAoy3PD6t1b1aFa3Vm+x0/aQhqKukrkl6syIkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VXnTGtM4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VXnTGtM4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A23C4CEE3;
	Thu,  3 Apr 2025 16:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743698627;
	bh=ywT3gUxg2u3h6z8cDoGMXqZ7k187ZOHtuhqQsgj9lCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VXnTGtM4ayWnJdRtVerIn8ysC8TlQ0AHh6GkqGtZBK9XHsBEf0s1EgjnutGYufNLv
	 espqLA7Z48uGF1kSnOFJXd+8HbUg6VZOrLlWDxp6petls8gYZdnzYQSPioMDw7yzrI
	 nMab6GiS6UTPsBgBt/Xt20fZX8EEKT8tdMig0wKHn1GDTgH5ND5JQ83Sm4Q2EVQYWP
	 GThuhpL4xV8+DaOaKU08R+PNdGdmlrPL1znSv1bbK3svA2aDa935XqZb7eyT5kUhnO
	 aIliV/1FT5ZScLUcAaEgCKBTkfAWHpS1OoWZilyZYEAlbnecGumxgD3U+iv6QtXFhV
	 VHUJHcwGvK3aw==
Date: Thu, 3 Apr 2025 09:43:45 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Uros Bizjak <ubizjak@gmail.com>
Cc: linux-crypto@vger.kernel.org, x86@kernel.org,
	linux-kernel@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/3] crypto: x86 - Remove CONFIG_AS_SHA256_NI
Message-ID: <20250403164345.GB1241@sol.localdomain>
References: <20250403094527.349526-1-ubizjak@gmail.com>
 <20250403094527.349526-2-ubizjak@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250403094527.349526-2-ubizjak@gmail.com>

On Thu, Apr 03, 2025 at 11:44:40AM +0200, Uros Bizjak wrote:
> Current minimum required version of binutils is 2.25,
> which supports SHA-256 instruction mnemonics.
> 
> Remove check for assembler support of SHA-256 instructions
> and all relevant macros for conditional compilation.
> 
> No functional change intended.
> 
> Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> ---
>  arch/x86/Kconfig.assembler          |  4 ----
>  arch/x86/crypto/Makefile            |  3 +--
>  arch/x86/crypto/sha256_ssse3_glue.c | 10 ----------
>  3 files changed, 1 insertion(+), 16 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
