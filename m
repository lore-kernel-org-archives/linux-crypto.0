Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DF942701B8;
	Wed,  7 Jan 2026 03:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767757444; cv=none; b=R+peziFQUCIGLBVF06E7TCDNwVYqvW8DrRIYa4RG4oxVJy8c7+0YvfFqa0nJBx4t6/ZzZTvmbQydK+hZNM0I14XptEFBFDm9k57EuO55C2a51AOgKEiS32n/Sz8v6RLmGwctS13qYd5jeSx81nbvMX1FAoorQtRBKTW6/L2MtZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767757444; c=relaxed/simple;
	bh=sBKLtZcr+zaiVvTAgHdnxk7H8Fjq981FTI154iwY78M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FQrb/b2HrhbNjWWaXHI3Lh7jv6o6i+feGFDHc3XLT8dkfm170jlmTTam+bTeix2AFJcZaBFLeMEhSfxyv2LB3Bx414Qdw5EyEqg8awvLS2m3d71vkZxglPuWv+lQRHPiN9WWkF9pInRzleSSEEdMaahPhGY+RKiXTgSU7w+GIHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pavmsgoj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pavmsgoj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4FEC4CEF7;
	Wed,  7 Jan 2026 03:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767757441;
	bh=sBKLtZcr+zaiVvTAgHdnxk7H8Fjq981FTI154iwY78M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pavmsgojqnpACVUZ1lCW6VcJTVI5dm6dJ2xOI8nOTeHaquVaZAGa+refu4OZB0RGk
	 wPb3ZwRFKqYkxPk2PuIjn0kruNDLebLgicfVdZ2XARYGzMZrR7y3/QtZQtjivu/n3a
	 PDedjJ/DHBeqA5iWt8PPpBaLwfaV90bcALPCxQZvSO3xnS7RsZ7UDbmOXjqLqknhto
	 w4KGECh2AkaFoVEYhXZ3SKhC0bYMWeJAfX7LxgPcl8qb1j1yle+1ESc+Zle6lrhi0R
	 Yqg3UzO4mn+3XfmqZ9s7sF/7hC3JSafvd1drMz4BBVZ0VGr2zHlXLKEgKgO9XmcXGa
	 lsVZXTRrYFQuA==
Date: Tue, 6 Jan 2026 19:43:41 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Jie Zhan <zhanjie9@hisilicon.com>
Cc: ardb@kernel.org, dhowells@redhat.com, linux-kernel@vger.kernel.org,
	linuxarm@huawei.com, jonathan.cameron@huawei.com,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH] lib/crypto: tests: Fix syntax error for old python
 versions
Message-ID: <20260107034341.GB2283@sol>
References: <20260107015829.2000699-1-zhanjie9@hisilicon.com>
 <20260107033018.GA2283@sol>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107033018.GA2283@sol>

On Tue, Jan 06, 2026 at 07:30:19PM -0800, Eric Biggers wrote:
> On Wed, Jan 07, 2026 at 09:58:29AM +0800, Jie Zhan wrote:
> > 'make binrpm-pkg' throws me this error, with Python 3.9:
> > 
> > *** Error compiling '.../gen-hash-testvecs.py'...
> >   File ".../scripts/crypto/gen-hash-testvecs.py", line 121
> >     return f'{alg.upper().replace('-', '_')}_DIGEST_SIZE'
> >                                    ^
> > SyntaxError: f-string: unmatched '('
> > 
> > Old python versions, presumably <= 3.11, can't resolve these quotes.
> > 
> > Fix it with double quotes for compatibility.
> > 
> > Fixes: 15c64c47e484 ("lib/crypto: tests: Add SHA3 kunit tests")
> > Signed-off-by: Jie Zhan <zhanjie9@hisilicon.com>
> > ---
> >  scripts/crypto/gen-hash-testvecs.py | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> I'll apply this, but it's weird that 'make binrpm-pkg' is doing anything
> with this script.  It's not executed during the kernel build process.
> It's only run manually to generate some files that are checked in
> elsewhere in the tree.
> 
> - Eric

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-fixes

- Eric
