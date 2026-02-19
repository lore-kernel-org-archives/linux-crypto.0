Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5FF212F98
	for <linux-crypto@vger.kernel.org>; Thu, 19 Feb 2026 20:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771531881; cv=none; b=uRzGvXks2rgluCvjckC8lwV+Xgb9oEWrGyrcW9+yfi2gp1UkR2G8m6EFihLYNP9fQZ46EuUFl/j8guM1YkyeFPRflMcOAarxYczXhoHvvO9Y+Mljd/EHC5aMqkbyKg8l7r9G13+uXwTT6sBlLjRtTyrA88MK+hYvtyilNo8VDag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771531881; c=relaxed/simple;
	bh=2gjTIl7iw/eDVEU3VZLbdNnk8T0TNaTPcoGyx9n87NA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WhcO7ouFD5sCbP73EcNIjrq67v1V/2a/d/DlD79mpti/l/cADVlSfgf9Aq9FDFQZZwIYxxTEB2HRowiGRm+4dgUcaGYAWnqfbqxktc4rviffxC4/BIn4xXrj98OH7th5zI+n6A0KQqCr/AfDnGXi/4JrUnte0R+aFSXnkpjAPKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D+BbOlHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D+BbOlHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6173C4CEF7;
	Thu, 19 Feb 2026 20:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771531881;
	bh=2gjTIl7iw/eDVEU3VZLbdNnk8T0TNaTPcoGyx9n87NA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D+BbOlHnEkXlmX7uCUVsbs7SmwEafeqT1qN36UthMHhuc7FLOYKl3/yAE+Q2dG+5a
	 oevoky/WKlGg1dnjmWWDJlEghhXRd/V9Cj3l62WobMHsiHANryF+OCNrf7yMUVt87t
	 O+57FaXS7mIHVtjZ1DVy9+rBTWaqewKXvLKK9NEGlRi46CWC71Ek2XB8lJaHn5VqYM
	 8dfyOo+LngEHTNspj8wTWcpWhTc06SXdTbrmV5mRI2z5fuTzkYVA1bVi4lLq07Xug4
	 uZfqVGhu4VM/Z5nCp27B9B+3RyIaZzIpsdfI0wB7w2TLKspxWc2xWvsbpleYGqw77Q
	 lpkU+WgKeUKKQ==
Date: Thu, 19 Feb 2026 12:11:19 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Milan Broz <milan@mazyland.cz>
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: Using aes-generic, kind-of regression in 7.0
Message-ID: <20260219201119.GA2396@quark>
References: <a6d69da9-2979-4b51-8560-2a554b9f7dd1@mazyland.cz>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6d69da9-2979-4b51-8560-2a554b9f7dd1@mazyland.cz>

On Thu, Feb 19, 2026 at 07:49:18PM +0100, Milan Broz wrote:
> Hi Eric,
> 
> we see failures in cryptsetup testsuite, caused by commit
> a2484474272ef98d9580d8c610b0f7c6ed2f146c "crypto: aes - Replace aes-generic with wrapper around lib"
> 
> TBH I am not sure this is a regression, as the internal naming (like aes-generic) was not supposed
> to be used in userspace. Unfortunately, it happened by (perhaps my) mistake with introducing "capi" syntax in dm-crypt.
> 
> For example this command
>   dmsetup create test --table "0 8 crypt capi:xts(ecb(aes-generic))-plain64 7c0dc5dfd0c9191381d92e6ebb3b29e7f0dba53b0de132ae23f5726727173540 0 /dev/sdb 0"
> 
> now fails. Replacing "aes-generic" with "aes-lib" obviously works.
> 
> Cryptsetup tests use aes-generic to simulate some of these "capi" fu***ups.
> (LUKS now explicitly disables using that dash driver syntax.)
> 
> I can fix cryptsetup testsuite, but I am not sure if anyone actually use this (specifically to avoid using aes-ni or some accelerated crypto drivers).
> 
> I am not sure what to do with that... *-generic name could be used as some defaults.
> 
> Is it worth to introduce some compat mapping, or just document this was just not a supported thing?

The crypto "driver names" have effectively always been an implementation
detail and not useful to specify directly.  They have changed before,
e.g. in v4.10 "xts(aes-generic)" changed to "xts(ecb(aes-generic))".  In
practice, what users actually want is for the kernel to select the
"best" implementation automatically, which is done by simply specifying
the stable name "xts(aes)" rather than a specific driver name.

The change of the CPU-based driver names to *-lib, which started for
other algorithms in v6.16, reflect a simplification to not expose
individual CPU-based implementations in the API.  Instead the
traditional crypto API is now just implemented on top of lib/crypto/,
which uses the "best" implementation automatically and by default.

This is the first issue report since that started.  So clearly this
simplified approach has generally been working fine, as expected.

In this particular case, the user is just a test script.  Also, it seems
it doesn't actually care that it gets the generic code specifically, but
rather it just uses a "driver name" rather than a "name" to verify that
dm-crypt's "capi:" syntax accepts "driver names" and not just "names".

So while we could introduce an "aes-generic" alias if absolutely needed,
I don't think this test script is enough to motivate that.  For now the
test script should just be updated to use the new driver name, or fall
back to the old driver name if the new one isn't supported.  And yes, I
recommend updating the cryptsetup documentation to clarify that
specifying crypto "driver names" isn't really supported.  Actually, if
that is done, maybe the test case isn't even needed at all anymore.

As for disabling AES-NI, no one actually wants to do that in practice.
But even if they did, it can still be easily done using the kernel
command-line option "clearcpuid=aes".  That's a more comprehensive
solution to disable the use of a particular CPU feature in the kernel.

- Eric
