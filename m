Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31ED630EF68;
	Tue, 24 Mar 2026 23:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774394865; cv=none; b=nE3ZhuBBszWtW8I7Npq0uc3BpihgwhNa3tDlW55sVFIiZEYIOy+NsIX+4jAiJ6PoQsquRLV4lIb7lDtJoWzjsyS4isuGwS2edPgkj8M4tnh6OtTeJuUGTG21DTUvOqD/j1F6WeOY3AaSkCxOCNxnqwj6rBWRnbfTNgxX031V+gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774394865; c=relaxed/simple;
	bh=LwGg7mdc6ZBQeNlfAP0RAnsDAmK+H1AR3VWEVDhcdR0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cgWU/wFthH5b19W+VvQWKuaP3nJ77xz32eoY3b2KrA9quaTBdxGIf3c6CH+W+oZ8jXmPezsW75Vi61EnINUZKhi6wEqQ/RwTNcoFBL15FC8oF7ZPZD3JFzvBa0q6M5TQvm6xdk5xFZJvFRqBUtC86jCc0Mla0xBGfEEnFVqKcJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdTzuglR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdTzuglR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9511DC19424;
	Tue, 24 Mar 2026 23:27:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774394864;
	bh=LwGg7mdc6ZBQeNlfAP0RAnsDAmK+H1AR3VWEVDhcdR0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fdTzuglRq7GV8RtzOaeiugoqwYYCbxiLUOjozPqENCi/Dqp8Rf/mD0YZLnCYuDsfq
	 xrw+pe6Ha8aXXemdL7kP8zr6lc9yuyah0H7ci9XKTbyyJNpQEjWwLs8e6FtOMs1CPe
	 P0F3HUnTWt5/XJ3opw/THQv7+LWdjG3lB/OX+earSi8vlyIAQwlxT4H9NfpYmo7vSn
	 mZs2XxqyK5IJL3f9OgYAzXHRq3740Epg1BEn8kyeGvFpVNM2Fy2znO3baQVPPyIqqi
	 DIPkGbQAhuqnnaLA97TI1n4Ga3OZu5ab6K59/SZn+1FA68pkr4+U1KaGY3Pva7MeO9
	 k0iFs7KeyQ+6w==
Date: Tue, 24 Mar 2026 16:27:43 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH] lib: Move crypto library tests to Runtime Testing menu
Message-ID: <20260324232743.GB3622@quark>
References: <20260322032438.286296-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260322032438.286296-1-ebiggers@kernel.org>

On Sat, Mar 21, 2026 at 08:24:38PM -0700, Eric Biggers wrote:
> Currently the kconfig options for the crypto library KUnit tests appear
> in the menu:
> 
>     -> Library routines
>       -> Crypto library routines
> 
> However, this is the only content of "Crypto library routines".  I.e.,
> it is empty when CONFIG_KUNIT=n.  This is because the crypto library
> routines themselves don't have (or need to have) prompts.
> 
> Since this usually ends up as an unnecessary empty menu, let's remove
> this menu and instead source the lib/crypto/tests/Kconfig file from
> lib/Kconfig.debug inside the "Runtime Testing" menu:
> 
>     -> Kernel hacking
>       -> Kernel Testing and Coverage
>         -> Runtime Testing
> 
> This puts the prompts alongside the ones for most of the other lib/
> KUnit tests.  This seems to be a much better match to how the kconfig
> menus are organized.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting the libcrypto-next tree
> 
>  lib/Kconfig.debug  | 2 ++
>  lib/crypto/Kconfig | 6 ------
>  2 files changed, 2 insertions(+), 6 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
