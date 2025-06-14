Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77D4418BC0C;
	Sat, 14 Jun 2025 04:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749876831; cv=none; b=FYmkJ+LtJ3KklYGHRXeR0lz2Pa6Ys4GYnMAAIUCjvfoZXmv7IwBAQ7TOsZ+pRp0eF0PBajDdd/G36XWSCJBgcftWdwS+UXdgECs6SxJbTbrAZnpyasyrrHXT3SlNaEQDu/Dd6Hh8ZkGm6tDYproZ1Ltxfv1KWO87JMfNN0Hrz78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749876831; c=relaxed/simple;
	bh=LidFlTi/IsbSYffEMZSY1sUJMyaqh8baxe0hyVagAyM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SqcaoJy3LSCHqzfD2p1Ov2TDvas0Bg/ytjEHjh/19K7Pg4rIE7FVgRa9/Vk4rSgPNrs9potQlyd6iDlWQ6FYSPBA45yJC9q7Imvf2iGoZ5TPQqXeI2nInBoG6pq6/cpajXGgu/v+r3iLCMwTJ7bUoB6YL9+ZnxBwQ33nHhjuSRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R7ws5yFE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R7ws5yFE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FDCC4CEEB;
	Sat, 14 Jun 2025 04:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1749876830;
	bh=LidFlTi/IsbSYffEMZSY1sUJMyaqh8baxe0hyVagAyM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=R7ws5yFEPJMU+E644zMbOuX8Vk8LmQzOcu4+pA08MDoDwMYG3KAbq0T25fMobWSsE
	 inEv+u9fAiBqzlejlPTq068xQi+/dzfwPuwxK043BY8akotvIRHOe0LrMSnZjuAxy1
	 6TlHIkV39Pe51mHkZhLMPx9kEG5nVSmyfHmLw16m2YqwW2k3c14sL5UeP6irjhvjDJ
	 ErEzYhKlLhcuQ1NDJ5WvcQHquoeGjDl1M/8hRSMAHMFDMQVCCgubJj6wfMhzv8uKXk
	 LDBCIYeuG2bjuerrxuYHlEC0sMZWZXfDnBeQA886sTfFvrUs4ZoJq7QJ2yoNREu8LA
	 EkrVOPYzZ3SlA==
Date: Fri, 13 Jun 2025 21:53:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Yuzhuo Jing <yuzhuo@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	Ian Rogers <irogers@google.com>, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] crypto: Fix sha1 compile error
Message-ID: <20250614045323.GF1284@sol>
References: <20250614000828.311722-1-yuzhuo@google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250614000828.311722-1-yuzhuo@google.com>

On Fri, Jun 13, 2025 at 05:08:26PM -0700, Yuzhuo Jing wrote:
> This is a followup patch series for an ongoing patch series to reuse
> kernel tree sha1 utils in perf tools and remove libcrypto dependency.
> This mirrors the fixes made in perf back to the kernel tree so we can
> use tools/perf/check-headers.sh to monitor future changes.
> Link: https://lore.kernel.org/lkml/aC9lXhPFcs5fkHWH@x1/t/#u
> 
> This series contains two patches: one fixing signed and unsigned integer
> comparisons and another fixing function type mismatches.
> 
> Yuzhuo Jing (2):
>   crypto: Fix sha1 signed integer comparison compile error
>   crypto: Fix sha1 signed pointer comparison compile error
> 
>  crypto/sha1_generic.c      | 2 +-
>  include/crypto/sha1_base.h | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

I don't like these signedness inconsistencies in the code either, and I'll be
fixing these (among many other issues) when I refactor SHA-1 to have a proper
lib/crypto/ API similar to what I'm currently doing with SHA-2.  That being
said, the kernel doesn't have these warnings enabled, and especially in its
current state this code isn't really designed to be copied into a userspace
program.

So I feel that the premise of this patchset, and more importantly also the one
you linked to above for tools/perf/, is a bit misguided.

I've sent an alternative patchset for you to consider:
https://lore.kernel.org/all/20250614044133.660848-1-ebiggers@kernel.org/.  It
adds a minimal SHA-1 implementation, including a test, to tools/perf/util/.  The
SHA-1 implementation is less than 100 lines anyway.

The effort it would take to "share" the kernel's code here is just not worth it,
IMO.  Especially when I have some significant refactoring planned on the kernel
side which would make the tools/perf copy diverge anyway.

- Eric
