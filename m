Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0C1440A2A;
	Fri,  2 Oct 2026 07:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790927256; cv=none; b=Q8CWpD+DQrGld2XsmQvpxXJYrO/Ys+YzWKU4wQT1gPXXeP4fPPY9vVbjSfnzGXcYlV3/z+l9TZ2veV9/flfh5EsHrxbXyhXW8fWv40ChYjMVn0fid6NP+CClNcO+yyyAsTMLm70/J8+7WXKbHbvEY/IbU5qMuAgA10AWq3/NfZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790927256; c=relaxed/simple;
	bh=UEveuqkyf57uqMI2yRjkjj8hyMx+lBTqzR4/Tf/cYsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XNOynpC/44nXgjHcOCUqNFjmVAD72ntmH3uZgVKZ+CG1gQEC/w+7siItyMAVClQXfnucxriq7Da2Qd50+m24QIbXv9XbVc3urnB3NMABRxCOMTtW3kuM3owCJs9B4kLlKv2KJgCkJB++sf28TKmjo+buTY/M84LZwlSPhCl/qo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=GyPpWFx1; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="GyPpWFx1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=BKcdcBZHxpoUZtJeR7l2uPE+/VMDpXJrv22RJmCmI1o=; 
	b=GyPpWFx10hh5rikilhgeb1FUEWz5r36Oy1Y1Lk+APXvQVMa+HYJ+si2huENLpmBeriM7jAFJsmp
	nfF2CISEO/EC1ljP3D9Tqq8zN97RF4WUelCBNM8aoOLMH4J2d24MBgrU+xqSuUCqsrKF4m4eC44Ob
	/uHq8UawVG3tqj8zZ2JsjWRUq+JhEeoBO0XCdRDMhwScavGgiwy8vfLjvD+HK9Rl+2kTxXRWRtQNF
	9+9DGSOGktyJqBjXLwTjMQALJPZaiDeVSAMoMzTyL/Mx2g9U0U2AEQEmkvLa9H4YEaQXTiMeIMCnn
	No6GZ6722T7qitbk2ffuzqVL9Z3E9dbxkdQw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xCXzK-00000002ltQ-3yIe;
	Fri, 02 Oct 2026 15:47:28 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 02 Oct 2026 17:47:26 +1000
Date: Fri, 2 Oct 2026 17:47:26 +1000
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Leonid Ravich <lravich@amazon.com>
Cc: linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev,
	davem@davemloft.net, ebiggers@kernel.org, agk@redhat.com,
	snitzer@kernel.org, mpatocka@redhat.com, bmarzins@redhat.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/6] crypto: skcipher - multi-data-unit request
 splitting
Message-ID: <ar9hjvFGLUKv3lEM@gondor.apana.org.au>
References: <20260924075846.28203-1-lravich@amazon.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924075846.28203-1-lravich@amazon.com>

On Thu, Sep 24, 2026 at 07:58:40AM +0000, Leonid Ravich wrote:
>
> 1. "Could you send me the patch so I can take a look?" (per-unit cost)
> ---------------------------------------------------------------------
> 
> Patch 4 is that patch -- the API-layer split, self-contained in
> crypto/skcipher.c.  The cost I measured, and where I believe it goes:
> 
> An in-kernel microbench of skcipher_crypt_unit() against the legacy
> per-unit loop (identical inner AES, VAES-AVX512, r7i.metal) shows a
> fixed ~48-52 ns per data unit, CV <1%, and it is the *same* ~50 ns
> for a 512 B unit and a 4096 B unit -- so it is per-call setup, not a
> crypto effect.  Against ~70 ns of VAES work for a 512 B sector that
> is ~+70% on the crypto call itself; end-to-end in dm-crypt it is
> ~2% of an ~18 us I/O and does not show up in fio at all (see the
> Performance section below).

I think the issue is that we're generating the IV twice.  Once
in the Crypto API and once again in the DM layer.  Not only is
this slow, but it is actually wrong for decryption.  You're ignoring
the IVs on the disk.

We really should only do it once, either in the DM layer or in
the Crypto API.  It should be transmitted via memory to the other
side.

My suggestion is to allocate memory for the IVs.  Of course
memory allocation can fail, but we have an easy fallback, which
is to use the existing single-unit path.

IOW if you succeed in allocating memory for storing the IVs,
then invoke the multi-unit code path, otherwise fall back to
the single-unit code path which iterates over the sectors one-
by-one.

To pass the IVs to the Crypto API (or back), just use the existing
IV pointer and extend it by the number of units.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
