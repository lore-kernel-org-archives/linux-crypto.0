Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112468BFF;
	Sun,  8 Jun 2025 23:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749426046; cv=none; b=iBWeXbPLkxP3hJQH1GCmznkaMue8/65/zPl4fKyJ1sjU2qmG8c0rUbzqMyBP4oJa6OXMD44CL4uBohGH9OTrZcBp5Scvcu14A3GxW9A/HAeHs53aqu95zEJqPEooYu0K+t+p3NusensYEjJ2ZpvtH48wgyGMM4NGg+WHOZksbw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749426046; c=relaxed/simple;
	bh=zMnGB/uw54aGGftMtsnbXQl67ZRuiKgaQ+FozbI+YVA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=vCCEGBEDSVs+b5pXnCPo31mDY2ssKs3/JE5k5Q14SqxKNuJulyIt5+rjcRd2aGGgtp3MsJhf4M5FTGN1EATm0T3Lr7UwKw2gktpG0vHY0ASh7VnhbV4X1p/zc01R7hNXLyqsOILP+QLPIRv6dfdqP/qakHIM04MoAruAsYJ5rOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JbobBeK2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JbobBeK2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB8AC4CEEE;
	Sun,  8 Jun 2025 23:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749426045;
	bh=zMnGB/uw54aGGftMtsnbXQl67ZRuiKgaQ+FozbI+YVA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JbobBeK2wkVfsRCilUH1JTJAJo/qQt0oHXUIt1pYo+ejoDIU+4sI2aPAmhndbyGRA
	 1qd9t+v2nKUn7V+/OSwF0aBpHk3GNlXmNT+CZ0lgkbPyXTkabDiGH9/jIlu4+k1atX
	 eM6viyeHjWFeMO26Q1ClMDwKOzyuO66tKi/o/DSF73rPVP8DQaWFOGOlwH0iG8wUAb
	 Ujq/NoC3cipqz0iNvej9F7jw0JTW9nGfHc6xiUHZTdhbK5suOhQ1PJ5yK9x4GrCWef
	 gQYTfZ7s3sXNAJX1NSVq4IvRgSkhFbzw8ejj7p8iJqTsVM8IKQFtk9pbdxFrLAA5px
	 zDwV95MKLQfnA==
Date: Sun, 8 Jun 2025 16:40:24 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, x86@kernel.org
Subject: Re: [PATCH] x86/crc: drop checks of CONFIG_AS_VPCLMULQDQ
Message-ID: <20250608234024.GA1259@sol>
References: <20250531211318.83677-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250531211318.83677-1-ebiggers@kernel.org>

On Sat, May 31, 2025 at 02:13:18PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Now that the minimum binutils version supports VPCLMULQDQ (and the
> minimum clang version does too), there is no need to check for assembler
> support before compiling code that uses these instructions.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> I'd be glad to apply this to the crc tree.  Arnd, let me know if you'd
> like to instead go with a patch that handles all of arch/x86/ at the
> same time.  That would be fine with me too.
> 
>  arch/x86/lib/crc-pclmul-template.S | 7 -------
>  arch/x86/lib/crc-pclmul-template.h | 3 +--
>  2 files changed, 1 insertion(+), 9 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=crc-next

- Eric
