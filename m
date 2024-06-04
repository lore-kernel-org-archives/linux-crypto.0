Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7433613B5A0;
	Tue,  4 Jun 2024 18:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717526542; cv=none; b=NMvx3VN5JVPAcb3uo2iFNk0yo1iI58QaerDB54ZwCnaKcr0VrXgKW39vxsA54S8i5hYh5IaYJ89HHFJ0PDsoFzIv6PhGvKoo84PbrDZE6Nu9Cwp+sIkYvtEx9xunFwXVa7CVYvKB38s2n+fGW8y68WnyaCFHf9sa0nPk8L3L+z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717526542; c=relaxed/simple;
	bh=TAmCuYHgvksi5yyEVMkM6NTME/kcFTf5GBRttrygVtI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6Yf6/bh1zAEe6fZqGGNJ6xXic9b0rYFCsnZo2bjUeuvEW+w4cWaSmLTB/IxFB7rUXsFhDMpWRqCUD7v1rWjfj9Mii/a8z35cssQeDfCkKOBbS3zDBdk1FiPO+UGaU8h6+HPIF4v+KoKktjTNkunZeCq+uqKbO/LpMpX0EWn0NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bfdxaZrU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bfdxaZrU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7205C2BBFC;
	Tue,  4 Jun 2024 18:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717526542;
	bh=TAmCuYHgvksi5yyEVMkM6NTME/kcFTf5GBRttrygVtI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bfdxaZrUUfeWaewS3+OMZfVZyZ/6y0h0RkZ6D9paQP7HPumPolPQQskFYL6esLdNW
	 UQM3oxuC10eW1VW0GtWsISafG3E+Ng9lq6mc5h7qF2JfGH0E5XSwQWx/oXmBZ5exke
	 4J12DaZoG4OsnvptXz3U8KjpFgdwJi8hOEElfEam0iOXOI6LSBQICVcSu2gY40vOe2
	 +6efNfsIHtta3Hi/Er2JkRjiseTsidl6N8ft1Qof67aZbnzknNddD5pK/vsZIxBShe
	 zxXHHdMmluqGD/KEFay+/DxZXT83prvA6O2n78rU2zcsRfVlem8iDQ5+UyII9cckOB
	 8IkTKkQVdiFwA==
Date: Tue, 4 Jun 2024 11:42:20 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org, fsverity@lists.linux.dev,
	dm-devel@lists.linux.dev, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Ard Biesheuvel <ardb@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v4 6/8] fsverity: improve performance by using
 multibuffer hashing
Message-ID: <20240604184220.GC1566@sol.localdomain>
References: <20240603183731.108986-1-ebiggers@kernel.org>
 <20240603183731.108986-7-ebiggers@kernel.org>
 <Zl7gYOMyscYDKZ8_@gondor.apana.org.au>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zl7gYOMyscYDKZ8_@gondor.apana.org.au>

On Tue, Jun 04, 2024 at 05:37:36PM +0800, Herbert Xu wrote:
> On Mon, Jun 03, 2024 at 11:37:29AM -0700, Eric Biggers wrote:
> >
> > +	for (i = 0; i < ctx->num_pending; i++) {
> > +		data[i] = ctx->pending_blocks[i].data;
> > +		outs[i] = ctx->pending_blocks[i].hash;
> > +	}
> > +
> > +	desc->tfm = params->hash_alg->tfm;
> > +	if (params->hashstate)
> > +		err = crypto_shash_import(desc, params->hashstate);
> > +	else
> > +		err = crypto_shash_init(desc);
> > +	if (err) {
> > +		fsverity_err(inode, "Error %d importing hash state", err);
> > +		return false;
> > +	}
> > +	err = crypto_shash_finup_mb(desc, data, params->block_size, outs,
> > +				    ctx->num_pending);
> > +	if (err) {
> > +		fsverity_err(inode, "Error %d computing block hashes", err);
> > +		return false;
> > +	}
> 
> So with ahash operating in synchronous mode (callback == NULL), this
> would look like:
> 
> 	struct ahash_request *reqs[FS_VERITY_MAX_PENDING_DATA_BLOCKS];
> 
> 	for (i = 0; i < ctx->num_pending; i++) {
> 		reqs[i] = fsverity_alloc_hash_request();
> 		if (!req) {
> 			free all reqs;
> 			return false;
> 		}
> 
> 		if (params->hashstate)
> 			err = crypto_ahash_import(&reqs[i], params->hashstate);
> 		else
> 			err = crypto_ahash_init(&reqs[i]);
> 
> 		if (err) {
> 			fsverity_err(inode, "Error %d importing hash state", err);
> 			free all reqs;
> 			return false;
> 		}
> 	}
> 
> 	for (i = 0; i < ctx->num_pending; i++) {
> 		unsigned more;
> 
> 		if (params->hashstate)
> 			err = crypto_ahash_import(req, params->hashstate);
> 		else
> 			err = crypto_ahash_init(req);
> 
> 		if (err) {
> 			fsverity_err(inode, "Error %d importing hash state", err);
> 			free all requests;
> 			return false;
> 		}
> 
> 		more = 0;
> 		if (i + 1 < ctx->num_pending)
> 			more = CRYPTO_TFM_REQ_MORE;
> 		ahash_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP | more,
> 					   NULL, NULL);
> 		ahash_request_set_crypt(req, ctx->pending_blocks[i].sg,
> 					ctx->pending_blocks[i].hash,
> 					params->block_size);
> 
> 		err = crypto_ahash_finup(req);
> 		if (err) {
> 			fsverity_err(inode, "Error %d computing block hashes", err);
> 			free all requests;
> 			return false;
> 		}
> 	}
> 
> You're hiding some of the complexity by not allocating memory
> explicitly for each hash state.  This might fit on the stack
> for two requests, but eventually you will have to allocate memory.
> 
> With the ahash API, the allocation is explicit.
> 

This doesn't make any sense, though.  First, the requests need to be enqueued
for the task, but crypto_ahash_finup() would only have the ability to enqueue it
in a queue associated with the tfm, which is shared by many tasks.  So it can't
actually work unless the tfm maintained a separate queue for each task, which
would be really complex.  Second, it adds a memory allocation per block which is
very undesirable.  You claim that it's needed anyway, but actually it's not;
with my API there is only one initial hash state regardless of how high the
interleaving factor is.  In fact, if multiple initial states were allowed,
multibuffer hashing would become much more complex because the underlying
algorithm would need to validate that these different states are synced up.  My
proposal is much simpler and avoids all this unnecessary overhead.

Really the only reason to even consider ahash at all would be try to support
software hashing and off-CPU hardware accelerators using the "same" code.
However, your proposal would not achieve that either, as it would not use the
async callback.  Note, as far as I know no one actually cares about off-CPU
hardware accelerator support in fsverity anyway...

- Eric
