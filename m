Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F345A101DE;
	Fri, 29 Aug 2025 15:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756481421; cv=none; b=Xlps3bFHWubwWyebdwaNJr20OdiY1w/T0yiKxnTEXjO/un3SRxP1ebxAEivca0EczvuBi5ADCME2sg1ts4M8OsIvM/oCPgbozbPlkLAMpEu5mkG6YRjN/0/4UgKYfZUD3gqS1/QlHtmBLHmOvHshxXyZW3wHpVJjeZioGq59Kd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756481421; c=relaxed/simple;
	bh=6nx14GaRznFcg4Y5SDC94Wpm0J9fdI27wEAhF+wvXJU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dcclj6BdhbHqAoXH5Sv8194FCTDIGIJdkUv4t7sEHiHKU2LJWSq6ZzmIoRliHWbt1QtU4W1bgeb2I0QrLD5TsA7NzYBVwv4BDOQLd16MFNsRvs2BL9+Hu62+5nWqlNOinNQLP0T3GA8EvGmCn0hAMayedMXjNnWbKEBk2BOHlrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a0T2DGR2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a0T2DGR2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41363C4CEF0;
	Fri, 29 Aug 2025 15:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756481417;
	bh=6nx14GaRznFcg4Y5SDC94Wpm0J9fdI27wEAhF+wvXJU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a0T2DGR2IVEMAKqGqQ5VCA1B4/cfeH+LX5Bv/iLLqRqpa5oz0O69d6Dcq3UkH2Sc0
	 tfh+Wcc6iyOJZe+nlU7bnYzT0OltR08atmAWd1OPxrJQeYw8Dc4LQ3nh+FU6bivD7s
	 jkYf/wERtmiE7E5wbYeJySB9Y4dQS58KIDgIjKiwxkQhkYRQm8yF9ZBD/zixxnjeXT
	 Hf/IcqbCi9zlfv5gbbhW5vcz/+IA8PbncxJnr2h7Qgu9zYuQsWo0ODgNoSyd1q/IMa
	 7qWnO2EyTRx1Qukps/BchlFCGLc+r2enm7LAdfvJvzneS0eDeUd5ZChPqdX97pKnPU
	 vtPnyoL+Dyo5g==
Date: Fri, 29 Aug 2025 08:29:12 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Honza Fikar <j.fikar@gmail.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 09/12] lib/crypto: blake2s: Always enable arch-optimized
 BLAKE2s code
Message-ID: <20250829152912.GA91803@sol>
References: <20250827151131.27733-1-ebiggers@kernel.org>
 <20250827151131.27733-10-ebiggers@kernel.org>
 <CAEH5pPY98CaSm+EXiuOzo6EuWzGu7rEQjGa3eojk18HP29Rs7w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEH5pPY98CaSm+EXiuOzo6EuWzGu7rEQjGa3eojk18HP29Rs7w@mail.gmail.com>

On Fri, Aug 29, 2025 at 03:08:56PM +0200, Honza Fikar wrote:
> On Fri, Aug 29, 2025 at 2:54 PM Eric Biggers <ebiggers@kernel.org> wrote:
> 
> > Currently, BLAKE2s support is always enabled ('obj-y'), since random.c
> > uses it.  Therefore, the arch-optimized BLAKE2s code, which exists for
> > ARM and x86_64, should be always enabled too.
> 
> Maybe a stupid question: what about ARM64? The current NEON
> implementation in kernel arch/arm/crypto/blake2s-core.S seems to be just
> for ARM.
> 
> While the upstream BLAKE2s with NEON is both for ARM and Aarch64 (ARM64):
> 
> https://github.com/BLAKE2/BLAKE2/blob/master/neon

There's no ARM64 optimized BLAKE2s code in the Linux kernel yet.  If
it's useful, someone would need to contribute it.

- Eric
