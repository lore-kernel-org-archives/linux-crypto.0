Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38642C158E;
	Wed, 29 Apr 2026 19:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777489349; cv=none; b=lisHuJxk1zXqgbFRDqIRaCGYIu9TM40t16zQODULDHts1aprjCVUo/oCnBZa9iG6NRRFg7jqRiPz4mDvUEDawIosd2n/nm3w9cf28Oqyxwz8FmwMCTCM2+fozHwJEZmTSUvrjZep+Mn4Mum6gVj4iDaoI4C1RfpP1e84cUq3jsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777489349; c=relaxed/simple;
	bh=mFdw1TM4+qBu81X7eO2RNL1zoe35xDBWXlgZyZZ3uVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RVwtYURz8jJ69zkjXpBATXZKQBMuQmISk5Ms+qD6iZ81/386Gry8U57tbezF7hDo2KzIwlb9eB0pLurkN5ZY61BJINqNzcB9RNWrKrx43/R+N9yh0On6f1EAbw9A2z+6culmYgKB8rUEeYHdJ8qAXWpfFMO5jM7o6Bs0/i8YbEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f7XEDseU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f7XEDseU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D19C19425;
	Wed, 29 Apr 2026 19:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777489348;
	bh=mFdw1TM4+qBu81X7eO2RNL1zoe35xDBWXlgZyZZ3uVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f7XEDseUDcyaifOQfEVR25Rqyfxk51Jun+TDa2LXua57G7or+Dw5YX6MxM00/aCII
	 8dxuuxi2KHk5KKGg9owrrXSVmWPav33CA4ZxzbGaQ+1QvrBWpH0aPKmG5IwoJSNAND
	 tiD+eapPeiOD2AdU71VTlt1it6vIrmLxgYDydsZgP7FW1fNScdg17/n+/CsNjabW18
	 M++1icSKCL5TZaRu2gPOO6fmj3amEfFP2Bu4J7f87zuSmRCJ2wG/jnUA31OUKln6xK
	 sP5hS0UAy9fSN7BD9i/geDp/PCZb1qcGLyu4VGIlMgFFz3LwRnG9CNC0LQuMyc59V3
	 tCKBpr/Yo7Rhw==
From: Simon Horman <horms@kernel.org>
To: ebiggers@kernel.org
Cc: 'Simon Horman' <horms@kernel.org>,
	netdev@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	edumazet@google.com,
	ncardwell@google.com,
	kuniyu@google.com,
	davem@davemloft.net,
	dsahern@kernel.org,
	kuba@kernel.org,
	pabeni@redhat.com,
	ardb@kernel.org,
	Jason@zx2c4.com,
	herbert@gondor.apana.org.au,
	0x7f454c46@gmail.com
Subject: Re: [PATCH net-next v2 1/5] net/tcp-ao: Drop support for most non-RFC-specified algorithms
Date: Wed, 29 Apr 2026 19:58:29 +0100
Message-ID: <20260429185828.1539480-2-horms@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260427172727.9310-2-ebiggers@kernel.org>
References: <20260427172727.9310-2-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: 'Simon Horman' <horms@kernel.org>

This is an AI-generated review of your patch. The human sending this
email has considered the AI review valid, or at least plausible.
Full review at: https://sashiko.dev
---
Subject: net/tcp-ao: Drop support for most non-RFC-specified algorithms

This change restricts the algorithms accepted by setsockopt(TCP_AO_ADD_KEY)
to cmac(aes128)/cmac(aes)+keylen=16, hmac(sha1) and hmac(sha256), returning
-ENOENT for anything else.  The selftest algorithm table and its Kconfig
fragment are updated to drop FIPS detection and rmd160.

A few questions inline below.

> diff --git a/net/ipv4/tcp_ao.c b/net/ipv4/tcp_ao.c
> index a97cdf3e6af4..b21bd69b4e82 100644
> --- a/net/ipv4/tcp_ao.c
> +++ b/net/ipv4/tcp_ao.c
> @@ -1563,6 +1563,10 @@ static struct tcp_ao_key *tcp_ao_key_alloc(struct sock *sk,
>  	/* RFC5926, 3.1.1.2. KDF_AES_128_CMAC */
>  	if (!strcmp("cmac(aes128)", algo))
>  		algo = "cmac(aes)";
> +	else if (strcmp("hmac(sha1)", algo) &&
> +		 strcmp("hmac(sha256)", algo) &&
> +		 (strcmp("cmac(aes)", algo) || cmd->keylen != 16))
> +		return ERR_PTR(-ENOENT);

Is this a uAPI regression for existing users of TCP_AO_ADD_KEY?

Before this change, tcp_ao_add::alg_name accepted any crypto_ahash
algorithm name.  The commit message itself notes "arbitrary HMAC algorithms
probably do work", and the selftest prior to this patch exercised
hmac(sha512), hmac(sha384), hmac(sha224), hmac(sha3-512), hmac(rmd160) and
hmac(md5), which demonstrates those configurations were functional in
practice.

A setsockopt call that previously succeeded with e.g. alg_name =
"hmac(sha512)" now returns -ENOENT after a kernel upgrade, with no
deprecation window, no Kconfig opt-in, and no runtime toggle.  HMAC-SHA512
in particular seems like a plausible choice that a deployment may already
rely on.

Would it make sense to keep hmac(sha512) (and possibly hmac(sha384)) in the
accepted list, or to gate the removal behind a Kconfig/sysctl while warning
for a few releases?

Also, -ENOENT is the same error returned when the crypto module for an
otherwise-accepted algorithm is simply not built in.  Should a distinct
errno (for example -EOPNOTSUPP) be used here so userspace can tell
"algorithm rejected by policy" apart from "algorithm module missing"?

> diff --git a/tools/testing/selftests/net/tcp_ao/config b/tools/testing/selftests/net/tcp_ao/config
> index f22148512365..47228a7d0b90 100644
> --- a/tools/testing/selftests/net/tcp_ao/config
> +++ b/tools/testing/selftests/net/tcp_ao/config
> @@ -1,6 +1,5 @@
>  CONFIG_CRYPTO_CMAC=y
>  CONFIG_CRYPTO_HMAC=y
> -CONFIG_CRYPTO_RMD160=y
>  CONFIG_CRYPTO_SHA1=y
>  CONFIG_IPV6=y
>  CONFIG_IPV6_MULTIPLE_TABLES=y

Should CONFIG_CRYPTO_SHA256=y (and possibly CONFIG_CRYPTO_AES=y) be added
here?

> diff --git a/tools/testing/selftests/net/tcp_ao/key-management.c b/tools/testing/selftests/net/tcp_ao/key-management.c
> index 69d9a7a05d5c..d86bb380b79f 100644
> --- a/tools/testing/selftests/net/tcp_ao/key-management.c
> +++ b/tools/testing/selftests/net/tcp_ao/key-management.c

[ ... ]

> -const char *test_algos[] = {
> -	"cmac(aes128)",
> -	"hmac(sha1)", "hmac(sha512)", "hmac(sha384)", "hmac(sha256)",
> -	"hmac(sha224)", "hmac(sha3-512)",
> -	/* only if !CONFIG_FIPS */
> -#define TEST_NON_FIPS_ALGOS	2
> -	"hmac(rmd160)", "hmac(md5)"
> -};
> +const char *test_algos[] = { "cmac(aes128)", "hmac(sha1)", "hmac(sha256)" };

With the FIPS/algorithm-probing logic removed and roughly one third of
generated keys now using hmac(sha256), and with the kernel side now
returning -ENOENT for non-whitelisted algorithms, tcp_sigpool_alloc_ahash()
will fail for every hmac(sha256) key on a kernel built from this config
unless CRYPTO_SHA256 is selected.

CRYPTO_SHA256 is not implied by CRYPTO_HMAC or TCP_AO, so on a kernel built
strictly from tools/testing/selftests/net/tcp_ao/config the tests would
appear to fail rather than be skipped.  Can the config fragment be updated
to match the new required algorithm set?

One more question, on the commit message and documentation rather than the
diff: Documentation/networking/tcp_ao.rst still describes TCP-AO as "May
support any hashing algorithm" and does not mention the newly enforced
whitelist or the -ENOENT failure mode.  Should tcp_ao.rst be updated in
this patch to list the accepted algorithm strings and the rationale (e.g.
the 20-byte TCP option MAC cap), so userspace has a documented contract?
