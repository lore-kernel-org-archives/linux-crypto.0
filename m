Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293131A6810;
	Tue,  3 Mar 2026 04:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772513993; cv=none; b=tT7eyirlbz7XSYlrkY/ay3jznIh5lfkxGCnSBt5UXDYQeW3kPiLnV/1poOwvn2hwFfsG0D+mox4QogijuOxlgnaRNyjBU5BmxGBB6M3rAKBnhpvefwKahaf+ESYoORmHMl097PnYvcFnr8UbxZBH8QgtKYPDR6EOZa1HWPyQVGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772513993; c=relaxed/simple;
	bh=GXE9B9NI78FWPwaPJo9a3b8uj3AJ5bHP6qkvPhjVU74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YZYPa0YY59i+4JfczMEW6O6VP3R/wb+PcEFsGTlam4JvCtxdk9S/n9rB823AqhVgtnvhhWDU9Al2jwwkT+n3xz5Ja3baXS1V78yZzpVXCd+qtB2eR/2wsZ7BZs10uNaT13Bf0Og4a/91NUuj1WchCbu6F2KVo84FUw7X3y8ZhLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o4sSS/dD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o4sSS/dD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82569C116C6;
	Tue,  3 Mar 2026 04:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772513992;
	bh=GXE9B9NI78FWPwaPJo9a3b8uj3AJ5bHP6qkvPhjVU74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o4sSS/dDIzT0KZGGSpg0D0ao8wm/EQ1gdu+/UCedeCy8A53/zYclcT9G9Zl/eVOuX
	 Q1J6xD2r1LnqR1U41XBgAxm/1VsNWvd1cq5DDYKMHNDJdzRvCKirtYASZSBFUaFK32
	 qzPAZ2/GAAsyc/GZYgGCcOlsnpYsc88TORS+I8XTIho4npASA3SdsU8LXmVsJguePo
	 Idkv+7/7B4mPRMp92AENEBNLfDjZttmTF6SRzmI3fXwlLZJEmb7e8+Rulwq+hgpHh3
	 0yNIdD1MO+W6uYFe3eBYDmKlnjnrD/eWjrwJ/RmL17pT4vNPytZxMW3eVrNznxFlFj
	 aHgB8RcnsQsAA==
Date: Mon, 2 Mar 2026 20:58:57 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	David Howells <dhowells@redhat.com>,
	Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v7] crypto: jitterentropy - Use SHA-3 library
Message-ID: <20260303045857.GA5238@sol>
References: <20260226010005.43528-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226010005.43528-1-ebiggers@kernel.org>

On Wed, Feb 25, 2026 at 05:00:05PM -0800, Eric Biggers wrote:
> From: David Howells <dhowells@redhat.com>
> 
> Make the jitterentropy RNG use the SHA-3 library API instead of
> crypto_shash.  This ends up being quite a bit simpler, as various
> dynamic allocations and error checks become unnecessary.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Co-developed-by: Eric Biggers <ebiggers@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This is a cleaned-up and rebased version of
> https://lore.kernel.org/linux-crypto/20251017144311.817771-7-dhowells@redhat.com/
> If there are no objections, I'll take this via libcrypto-next.

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
