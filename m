Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB4F14F70;
	Sun,  9 Feb 2025 16:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739118873; cv=none; b=j5NGDfaV1DrdgeexUrB6CLUAsDI0U8wnGvfmZ2wF97UO42dy4f0ebRQYfhJwO3rbaZ9hGQp5kqcbBMOLC0nqHTzd4TaId/PJQQ2YNCEQYPfVzP/dr0D5LgQin966ieMJfwrzxZjU5F/ujOANkiGXviGC2drozXoKN4digxS6o2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739118873; c=relaxed/simple;
	bh=m2p5tN8xBFikB7p9GuYbTf9YDLdou5SWbVeyIqJJ5vo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fbdnOvh6Mdj3upfMLHgYsDBCfP17kdQN+oQtb6ucgGcKj3wGMSw/mE8hjSvCXECwtSJGJauIpgklTfpRKvbITLGNlyHiaM7cb+G/mfB5VDiR/guckumyaxzs8MLhl7/dKTGIxhOWj3zWRqx+a0apR3uJ/y5wsig1Aw/IYlvnv3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S7cgtAUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S7cgtAUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F913C4CEE2;
	Sun,  9 Feb 2025 16:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739118872;
	bh=m2p5tN8xBFikB7p9GuYbTf9YDLdou5SWbVeyIqJJ5vo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S7cgtAUbyiNT7rhsLTSFiw++3hU6xKcppoyJGuXqlh2zYhK8L6M4g2q4/HC6/SDTy
	 7VOqBdCtJdlgbEqdcVw1edjOapkYquNjVHjcc7HNXmiXVOITIUbSDJSmh35TN/rmsm
	 vDHJVLRjQcaF+1lh+0nJwgV47biBiNAr33Wq2T3TAKaUtjFG6D1Em+xOq9C6M9HDxO
	 zATkrgMzNFdvL7RqtF9Aowp7LALS5XH+K15Pa1tNJe6djizdbQFtifLAvP0vMp5hoc
	 plNRiwE4Ekefmsop6zKNjowCn47uQqaLIPlv2TiH5ZJBlA7qaRvu9Rofpy5j8O7J35
	 kdwTQwmQcgCcg==
Date: Sun, 9 Feb 2025 08:34:30 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Harald Freudenberger <freude@linux.ibm.com>, davem@davemloft.net,
	dengler@linux.ibm.com, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org
Subject: Re: [PATCH v10 2/5] s390/crypto: New s390 specific protected key
 hash phmac
Message-ID: <20250209163430.GB1230@sol.localdomain>
References: <20250115162231.83516-1-freude@linux.ibm.com>
 <20250115162231.83516-3-freude@linux.ibm.com>
 <Z6hrvQzb5G_wqlni@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z6hrvQzb5G_wqlni@gondor.apana.org.au>

On Sun, Feb 09, 2025 at 04:47:57PM +0800, Herbert Xu wrote:
> On Wed, Jan 15, 2025 at 05:22:28PM +0100, Harald Freudenberger wrote:
> >
> > +static int s390_phmac_init(struct ahash_request *req)
> > +{
> > +	struct s390_phmac_req_ctx *req_ctx = ahash_request_ctx(req);
> > +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> > +	struct s390_kmac_sha2_ctx *ctx = &req_ctx->sha2_ctx;
> > +	int rc;
> > +
> > +	/*
> > +	 * First try synchronous. If this fails for any reason
> > +	 * schedule this request asynchronous via workqueue.
> > +	 */
> > +
> > +	rc = phmac_init(tfm, ctx, false);
> > +	if (!rc)
> > +		goto out;
> > +
> > +	req_ctx->req = req;
> > +	INIT_DELAYED_WORK(&req_ctx->work, phmac_wq_init_fn);
> > +	schedule_delayed_work(&req_ctx->work, 0);
> > +	rc = -EINPROGRESS;
> 
> This creates a resource problem because there is no limit on how
> many requests that can be delayed in this manner for a given tfm.
> 
> When we hit this case, I presume this is a system-wide issue and
> all requests would go pending? If that is the case, I suggest
> allocating a system-wide queue through crypto_engine and using
> that to limit how many requests that can become EINPROGRESS.

Or just make it synchronous which would be way easier, and the calling code uses
it synchronously anyway.

- Eric
