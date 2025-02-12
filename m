Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D193921018A;
	Wed, 12 Feb 2025 15:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739373659; cv=none; b=ElzX+ppErpb8lmkeWjBFn0YRCNPRzGQwQdv+HsqlsMu5VHbhrr2oiePXT9bekv+uEPsPweR4GhEb5GWv5ZUMk8ctjcUaYF5X8g1VuELlDlzacLVdpC/Ww2kaFPT280f0wgb5JjlQut2jfFH7j5LKz/PEjOjP6ww/5GlFMbZI9N4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739373659; c=relaxed/simple;
	bh=l70dMKRZZuIcTN7P7KYGeI54CkmfOAguGwGNr3boZ6o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JIge2/Ul0m0/eLMQzoR4051SS8+oTiCg1BX0Az4RBPyKxn9InRp+1dH9fb2MsYSADCS3YeDoyvKYP6oShBu+jd+VoX7mjMdR91lejhPUNeGQew0TQl7+APngark+z6uMZ0k2pDWMC7tiXE4L0EFTdT3hRN31gwK+X4xlqhX5+fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQw1dYcA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQw1dYcA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75818C4CEDF;
	Wed, 12 Feb 2025 15:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739373658;
	bh=l70dMKRZZuIcTN7P7KYGeI54CkmfOAguGwGNr3boZ6o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gQw1dYcANs1L+I6pI6LMs0z3EhXQQ20a41aWQcrsTE6vEtMYSnoC0vvf4psAphxBF
	 dHGaKMpWKlyVGMr10FKYAnwcN5NcHxYzIW+vWZwWvKTokAfaBslGTqbYyOFC5p3FAv
	 afijLUbuFPg609q6nBnUIMc7CFIOyfB4qBVEBxLwYD1uclpKrDWBUg5YCiz/R2yr8N
	 nJCzfv1LLpYeQxUhRWxHEQAsfGahfRGqM45tb+q3ay3QYhyzwvLrZgK028CusANr6L
	 kupL48i8z3ujPqJivFu3FKEv7heU2XaEoG9LVtqSBG/JAYYVjscaWKolfoD3qtMDYf
	 3yrr66V8+TdTw==
Date: Wed, 12 Feb 2025 07:20:56 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Harald Freudenberger <freude@linux.ibm.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
	dengler@linux.ibm.com, linux-s390@vger.kernel.org,
	linux-crypto@vger.kernel.org, dm-devel@lists.linux.dev
Subject: Re: [PATCH v10 2/5] s390/crypto: New s390 specific protected key
 hash phmac
Message-ID: <20250212152056.GA1256@sol.localdomain>
References: <20250115162231.83516-1-freude@linux.ibm.com>
 <20250115162231.83516-3-freude@linux.ibm.com>
 <Z6hrvQzb5G_wqlni@gondor.apana.org.au>
 <20250209163430.GB1230@sol.localdomain>
 <9971160da17b1d18d4bdc87fc1297fda@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9971160da17b1d18d4bdc87fc1297fda@linux.ibm.com>

On Wed, Feb 12, 2025 at 12:17:46PM +0100, Harald Freudenberger wrote:
> On 2025-02-09 17:34, Eric Biggers wrote:
> > On Sun, Feb 09, 2025 at 04:47:57PM +0800, Herbert Xu wrote:
> > > On Wed, Jan 15, 2025 at 05:22:28PM +0100, Harald Freudenberger wrote:
> > > >
> > > > +static int s390_phmac_init(struct ahash_request *req)
> > > > +{
> > > > +	struct s390_phmac_req_ctx *req_ctx = ahash_request_ctx(req);
> > > > +	struct crypto_ahash *tfm = crypto_ahash_reqtfm(req);
> > > > +	struct s390_kmac_sha2_ctx *ctx = &req_ctx->sha2_ctx;
> > > > +	int rc;
> > > > +
> > > > +	/*
> > > > +	 * First try synchronous. If this fails for any reason
> > > > +	 * schedule this request asynchronous via workqueue.
> > > > +	 */
> > > > +
> > > > +	rc = phmac_init(tfm, ctx, false);
> > > > +	if (!rc)
> > > > +		goto out;
> > > > +
> > > > +	req_ctx->req = req;
> > > > +	INIT_DELAYED_WORK(&req_ctx->work, phmac_wq_init_fn);
> > > > +	schedule_delayed_work(&req_ctx->work, 0);
> > > > +	rc = -EINPROGRESS;
> > > 
> > > This creates a resource problem because there is no limit on how
> > > many requests that can be delayed in this manner for a given tfm.
> > > 
> > > When we hit this case, I presume this is a system-wide issue and
> > > all requests would go pending? If that is the case, I suggest
> > > allocating a system-wide queue through crypto_engine and using
> > > that to limit how many requests that can become EINPROGRESS.
> > 
> > Or just make it synchronous which would be way easier, and the calling
> > code uses
> > it synchronously anyway.
> > 
> > - Eric
> 
> A word about synchronous vs asynchronous...
> 
> As a synchronous hash (or chipher or whatever) MUST NOT sleep I can't
> really implement the pkey stuff in a synchronous way:

As I said at
https://lore.kernel.org/dm-devel/20250116080324.GA3910@sol.localdomain/, shash
could fairly easily be fixed to support sleepable algorithms (e.g.
CRYPTO_ALG_SLEEPABLE).

This would be *much* simpler than doing it with ahash.

You even had it as a shash already in the first version of your patchset, just
missing the bits that add the support for sleepable algorithms.

I am trying to help you by suggesting an approach that would be much easier.
There is no need to shoehorn CPU-based crypto into ahash, which is designed for
off-CPU offload.

> The issue with pkey (We call it "protected key") is that it is some kind
> of hardware based key. As such it needs some special preparation action
> to be done upfront in the hardware/firmware to use such a pkey.
> Now think about KVM live guest migration where a guest suddenly awakes
> (Well the guest is not even aware of this) on a new machine with another
> hardware. So out of the sudden a hardware based crypto operation fails
> with an indication that the hardware/firmware can't deal with this
> key object and needs re-preparation. Usually this preparation step is
> some kind of asynchronous operation (write some pci registers or run
> some DMA sequences or refresh the working key material via an HSM
> communication...) and as such may take some time and involve even
> sleeping on a mutex or completion until another kernel thread is done.
> Please note this is not unique to pkey on system z but may apply
> to all kinds of hardware/firmware based keys in situations like
> KVM live guest migration or suspend/resume.

I.e. it already uses a kernel thread that does the operation synchronously (as
opposed to being actual hardware offload that does not consume a thread and
signals completion to the CPU via an interrupt), in addition to the caller's
thread which also waits synchronously via crypto_wait_req().  There is really no
need to make it async, nor to use scatterlists.

- Eric
