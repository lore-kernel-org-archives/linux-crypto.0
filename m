Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD7A2D0267;
	Mon, 23 Jun 2025 18:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750702961; cv=none; b=liE8oaBCK89uUACqRN+5N55cw9LPfqgVHD6fEhKnBdbNt+0yN+SsH9kzN4CIU3f5KnLg5401tIIz6STop3WvzYgzyKpZjjojHspdNfVvgiD72QPZVZ77Ol4dLaTDY0s4pQCrK9QZieYMA0PE+5A97zxtmwuWMTajQR6S80X2/w0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750702961; c=relaxed/simple;
	bh=uwhWwxqjKMdAavHDWS2p2j9VXDBcTPp01nkrjGdrCn8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ci48xSE5j2aNs+eZGDEFQ9Z2DahbJBtJIbrAGsxoZDQA9kQc1ua759OhifARTEe55C9QjhpVkMm4Kk9kyFqc272fuqLOmCEAG2DgBQ9LpqAiJe66/Ipx1AzkeTnplRcjNpoEiZJy3Wdo0uP1+4Q5RnmXqb2A9BsJR3Pd/RBT2c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ss5S/CcK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ss5S/CcK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A3A9C4CEEA;
	Mon, 23 Jun 2025 18:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750702960;
	bh=uwhWwxqjKMdAavHDWS2p2j9VXDBcTPp01nkrjGdrCn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ss5S/CcKmJLMcNiVI8pZjN7nTUA5f2l0QTO3TnIxMfUCYmDw8VdMden2LJsWe7UZm
	 z0y/KC4Z2H6kSLdvOd9KgtbcszWXokj2Z353zO4ui8yAsG71q/UfFRsgFfJJb7/jwz
	 Oz5hc42XgRUelnBWuUzW7zQMkgMHk/TkOTxv89OfWIiSrwgirqIuj3O3gOUFER0RwQ
	 OXhiKFjsc9OtWzrmcWXdFwJvzNc3y+3NIV0J5n0eoy48t3awiturhqGbTtTpHK9ocl
	 P1u0Qz8k4f1ShoexfvD3T27foeOB5bNoTqVtIyg//JrdaAmG5fKqOL/1N7aNeR5OYw
	 Ile5+RGQrNIew==
Date: Mon, 23 Jun 2025 18:22:38 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Milan Broz <gmazyland@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
	dm-devel@lists.linux.dev
Subject: Re: dm-crypt: Extend state buffer size in crypt_iv_lmk_one
Message-ID: <20250623182238.GA1261119@google.com>
References: <f1625ddc-e82e-4b77-80c2-dc8e45b54848@gmail.com>
 <aFTe3kDZXCAzcwNq@gondor.apana.org.au>
 <afeb759d-0f6d-4868-8242-01157f144662@gmail.com>
 <cc21e81d-e03c-a8c8-e32c-f4e52ce18891@redhat.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cc21e81d-e03c-a8c8-e32c-f4e52ce18891@redhat.com>

On Mon, Jun 23, 2025 at 11:40:39AM +0200, Mikulas Patocka wrote:
> 
> 
> On Fri, 20 Jun 2025, Milan Broz wrote:
> 
> > Hi,
> > 
> > On 6/20/25 6:09 AM, Herbert Xu wrote:
> > > The output buffer size of of crypto_shash_export is returned by
> > > crypto_shash_statesize.  Alternatively HASH_MAX_STATESIZE may be
> > > used for stack buffers.
> > > 
> > > Fixes: 8cf4c341f193 ("crypto: md5-generic - Use API partial block handling")
> > > Reported-by: Milan Broz <gmazyland@gmail.com>
> > > Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> > 
> > Yes, that fixes the issue, thanks!
> > 
> > Tested-by: Milan Broz <gmazyland@gmail.com>
> > 
> > Mikulas, I think this should go through DM tree, could you send it for 6.16?
> > The full patch is here
> > https://lore.kernel.org/linux-crypto/aFTe3kDZXCAzcwNq@gondor.apana.org.au/T/#u
> > 
> > > diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
> > > index 9dfdb63220d7..cb4617df7356 100644
> > > --- a/drivers/md/dm-crypt.c
> > > +++ b/drivers/md/dm-crypt.c
> > > @@ -517,7 +517,10 @@ static int crypt_iv_lmk_one(struct crypt_config *cc, u8
> > > *iv,
> > >   {
> > >   	struct iv_lmk_private *lmk = &cc->iv_gen_private.lmk;
> > >   	SHASH_DESC_ON_STACK(desc, lmk->hash_tfm);
> > > -	struct md5_state md5state;
> > > +	union {
> > > +		struct md5_state md5state;
> > > +		u8 state[HASH_MAX_STATESIZE];
> > > +	} u;
> 
> Hi
> 
> 345 bytes on the stack - I think it's too much, given the fact that it 
> already uses 345 bytes (from SHASH_DESC_ON_STACK) and it may be called in 
> a tasklet context. I'd prefer a solution that allocates less bytes.

Of course, the correct solution is to just add MD5 support to lib/crypto/ and
use that here.  All that's needed is a single MD5 context (88 bytes), and direct
calls to the MD5 code...

- Eric
