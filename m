Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4A83A3830;
	Wed,  1 Jul 2026 07:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782890460; cv=none; b=nJ3h6nusAt/DIZTCMYhydxLEBM2lxkU4MvPUWyzBuMTs7PdHwKVLEcbRuzrFzg8f/93SgIPBtJk+zJeQmpw+QFfMFwLlTUxACyBxLpqXgqMA+SRtwMIsCkcOHzLCv4LU84T/q6xMGAg3fzHxQU/Iys90GvTB84Q0viHKBvEa9gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782890460; c=relaxed/simple;
	bh=9hpAc1+MXlpU115bkiS7aY+dhuRScu+PhmKpwwjIRsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZuCH3gX1ZEFlL3GfAxnWyQC4ohA0Np5GZBn1BqYagrKHjhRDD4YKXagVmLSxQ3x1PON/FvIYXzrUWIfvPNHCYnx7cctutSAkeWEXtxzfv0ea66miUT5SEDoMpXazQGb237mYDMshPuhb6Z+sDBID80UNfq0MbHGl+E6TN2wuCDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k3XOdT1j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k3XOdT1j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D6A1F000E9;
	Wed,  1 Jul 2026 07:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782890459;
	bh=iZ/3Tm7ZRm3ifBbKZc7mGH8pURO/2EJBjkwryWHH6ck=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k3XOdT1jZpwM3GYI89WMduQIiAqLdyKwbU+y82VmubNe3ZjWwhW1ZLq8xloaPIz6G
	 Zp9s7f4DSDsSaU06Iwx5xzhA5nPemONb4X+DUyjgGMHZrQwUz3QWsL4L6peiqINT7p
	 QesnK5Ni6xkroBuwO2Rbsgs+/IsSpkt9//tqFccN7LSihN1J7E8JLhyU302BM1sNzn
	 Pbmf3/z7okSoHSU/21SZW2/OrE7KfJT0XQ/44cQ6vGFKP5WRTtWda4izAmUAks1F5m
	 DlDRQspNT3yq+yzeK1YAH4sCyDnlZGidKexnIWH8yEb0or/byFvYd8khSJ6GlRsiqs
	 SgTT573+E/Rcg==
Date: Wed, 1 Jul 2026 00:19:19 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Leonid Ravich <lravich@amazon.com>
Cc: linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au, davem@davemloft.net,
	snitzer@kernel.org, mpatocka@redhat.com, axboe@kernel.dk
Subject: Re: [PATCH v5 0/5] crypto: skcipher - multi-data-unit dispatch as a
 template
Message-ID: <20260701071919.GA111652@sol>
References: <20260630083431.2772-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260630083431.2772-1-lravich@amazon.com>

On Tue, Jun 30, 2026 at 08:34:26AM +0000, Leonid Ravich wrote:
> This is v5. It reworks the multi-data-unit support from the in-core
> auto-splitter of v4 into a crypto template, dun(...), addressing the v4
> review: there is now no added cost on the core skcipher path, no
> per-algorithm capability flag, and the per-data-unit split lives in an
> algorithm rather than in crypto_skcipher_encrypt/decrypt the shape
> Herbert suggested, which removes the "overhead for everyone" Eric
> objected to.

No, this didn't address my feedback.  It moved things around but still
adds additional overhead for everyone to support an out-of-tree driver,
which also hasn't been shown to be any better than just using the CPU.

- Eric
