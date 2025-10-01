Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2211E28C2D2;
	Wed,  1 Oct 2025 16:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759337778; cv=none; b=hurL9hF2evD8dTVSOEvhWySIXsp0zkVxIvlmZz/UV1e01adA3VI1kOozow16FdZ1wrW8Vp5w1msUS2LW+9duI20RSB3KCMvTdN0Cpzvl26dvxdX85n32yNaMa9Z8XVqcN40B5IMtDIxv2/dAMiZSwrV0+2sHOOjSGSXlqIAO1hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759337778; c=relaxed/simple;
	bh=rpAjRFYNrwr9P/dKBIUH+iBTuw2t7D7elVjJUZZ01v8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ap+XAwrDOe4xnA4JvclmUf6SkqLv6At5uyTzGDdCh/m/hVkeMzW1siUJwqziQ0kdRulmjQzwrnI9F71Fq1UFdwJO4OXMjZmR0G29t7JmUEIiw2MEjJoANZPn9CO/VgqcNaBjagLrhfi0yaUq+SHSamambAGFMEdRH/4yzvUbWRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=duBNrr3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="duBNrr3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2B7C4CEF1;
	Wed,  1 Oct 2025 16:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759337777;
	bh=rpAjRFYNrwr9P/dKBIUH+iBTuw2t7D7elVjJUZZ01v8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=duBNrr3XK8WrXfwmvxSXZ0ToUjddax8jwkZwV0dgy6wn5pepDK4VMbIxGXUO8n1GJ
	 GhcibkDUtSS7tx1S9lSSswSUS+nJ0vnNPn9kV6kyROkhzmLVOlpZcWaJILkCk1HAPU
	 TRvFS5MumXBQ4CT8VTM5UmGyThr86gevB65Cb0+F0fTenbOFDItaGIyjuDGL45eLhY
	 zqz1AnJXMzmjR7gy39lRUK+h7tgU3z7o9FF0f6mf/t+YycM75lvfP1Dr70/mLt82sF
	 zmYvfVPB0HTNj3bfG/gG3fAzqlN54UHvGT91Jfk43ckvH7v1h3fm1qKcn1035l+Fly
	 l2CX2mRMcjG4g==
Date: Wed, 1 Oct 2025 09:54:55 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: gregkh@linuxfoundation.org, sashal@kernel.org, stable@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ardb@kernel.org>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Michael van der Westhuizen <rmikey@meta.com>,
	Tobias Fleig <tfleig@meta.com>
Subject: Re: [PATCH] stable: crypto: sha256 - fix crash at kexec
Message-ID: <20251001165455.GF1592@sol>
References: <20251001-stable_crash-v1-1-3071c0bd795e@debian.org>
 <20251001162305.GE1592@sol>
 <jm3bk53sqkqv6eg7rekzhn6bgld5byhkmksdjyxmrkifku2dmc@w7xnklqsrpee>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jm3bk53sqkqv6eg7rekzhn6bgld5byhkmksdjyxmrkifku2dmc@w7xnklqsrpee>

On Wed, Oct 01, 2025 at 09:45:07AM -0700, Breno Leitao wrote:
> Hello Eric,
> 
> On Wed, Oct 01, 2025 at 09:23:05AM -0700, Eric Biggers wrote:
> 
> > This looks fine, but technically 'unsigned int' would be more
> > appropriate here, given the context.  If we look at the whole function
> > in 6.12, we can see that it took an 'unsigned int' length:
> 
> Ack. Do you want me to send a v2 with `unsigned int` instead?
> 

Sure.  Could you also make it clear which kernel version(s) you are
expecting the patch to be applied to?  Is it everything 5.4 through
6.15?  It looks like this bug actually got exposed by f4da7afe07523f
("kexec_file: increase maximum file size to 4G") in 6.0.  But
backporting to older versions should be fine too, if it applies to them.

- Eric
