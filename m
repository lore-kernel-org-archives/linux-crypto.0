Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB59635AC11;
	Wed,  2 Sep 2026 20:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788380241; cv=none; b=c01uejS+6ZRlehA1TcBWIbSotU+nDMnssyloeec2Z7kPbDK/5fTJlZLYHWjv2gaqgAjdokiervS2fsEtW4YNGdTN0QSZr9ZYTvjYHeJ2JhlKIrWnckkDQcoEQ/mlFvN9pj0fIE2rP2CMMmvfsY+QeFIDq1PVJj34csus/V6F9BM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788380241; c=relaxed/simple;
	bh=r4mpgfPTqS62PXOHjuWEIEUz1wuNWv9KodkrVLlwnXE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C6AcPREOa6DHN7CRBCk3f7c2Nwr+HND7TD1X0OkJOcIeS3jX6lAx2tuy+udGRX5myZXC1R1YzKLqbyB+SVygRBFw0HmWrzwn49is5QVNNLcuWsO5cU2FSmamjPchd/FklND13SEkyYQx4K4CB/mnW9L/ckiirHYRP1Izn2/HmlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZUkZjW9c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZUkZjW9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD261F00ACA;
	Wed,  2 Sep 2026 20:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788380240;
	bh=4UbAnf1a6CiK69QYEYFjB2Egx33UW0sHKquJ0GMWF0Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZUkZjW9c+WE7uqat1HYdkJcO1QPmQ14H/iGgqBcrnsD+mUDkQdA4gxNyvRN+uYYns
	 YbkoPXsCShJLpFBfHmV2EAGdJqJTFij+LjfuZAi2Jd9g0tYUNk4dX8dDLRjEqJJuWK
	 ehFONmWe6Plr/fZZoaLII3X+pWLTsLEOr5lDj3shL5aBZd6o7t2TWmzBjx2FvO3WA6
	 eiKa+RmycBsi0vmmNcdmM+FUHMpLahFvpYzE3MjB7z+DQFh/5TB0I7IRwqLaW6aBPc
	 mPejXrmhLQZ3Tv7UjpnAxWILIxKzXlpms5uyMOV6laIRBjJfmBcYo0J+UsDGrsUk5O
	 s7PuIV8srTXaA==
Date: Wed, 2 Sep 2026 13:17:20 -0700
From: Kees Cook <kees@kernel.org>
To: Manuel Ebner <manuelebnerli@mailbox.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Cheng-Yang Chou <yphbchou0911@gmail.com>,
	Eric Biggers <ebiggers@kernel.org>, linux-crypto@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: arm64/aes-neonbs: transition to kmalloc_obj()
Message-ID: <202609021314.8A9C0B8@keescook>
References: <20260830101714.625728-3-manuelebnerli@mailbox.org>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260830101714.625728-3-manuelebnerli@mailbox.org>

On Sun, Aug 30, 2026 at 12:17:14PM +0200, Manuel Ebner wrote:
> I have a couple similar patches lined up but they could be automated or maybe
> the script is already made by Kees.
> Kees can you make a script assisted commit (again)?

This lead me down quite a long path to try to figure out why the existing
Coccinelle script (scripts/coccinelle/api/kmalloc_objs.cocci) didn't
catch these. The answer is the cleanup.h macros and poor interaction
with Coccinelle. I think I've got a work-around built now, and I'll send
a new tree-wide change to Linus before -rc2 gets cut.

Thanks for noticing these got missed!

-Kees

-- 
Kees Cook
