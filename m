Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E012F5B;
	Sun, 10 Nov 2024 03:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731210411; cv=none; b=WXIZo/WFQ7UGIA5ON4PNUy2Y/nCcSE0JHTvIUyQ/xC9ZbQ6VJ5xRR8RQqfNrPd9owBA6Tot5cYrw9Kc76sJUsu6ECRUE7lRTTg6QFg5XwUwlH4tcphkZz7eeSFYrkvXRToSNK14M9bgSNb6TaBzTm/JpAO66tfRt92cyrZcSMnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731210411; c=relaxed/simple;
	bh=sMRRCoaMB6/1PH+eUc/5raCFtksZ8r1HEB2amBDW3Cg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hvdKX2gOfz7EidF5QLO2MH6xrhDROr2p7XkrAbXm+H3+Vq1R+zM7/LPbF365QvlhONoSdQdzvR3m90nHNXOp1jnauiWhdZcLwufNAJrwP5J0O4/zfH/j/E9e16xIyEzhlbnGtLfnw5DC+cjtb3Hyx4fWqV40L1WF9SDzHkyilUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=cFf0H9jY; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="cFf0H9jY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=7Uo7+x1Rgz3g7xlkvmY5PW7juASM51XmbFf1untbUJc=; b=cFf0H9jYksU6URcXqv8pX0wSAK
	7egOrXD7GraWk4BBtwP+tq0VEjF6AU1HyMFYugLGg8ikiRfqJvjlzxi2tDqGk6bdlH7dxtDrDFd4D
	C+Pq86SS6fYMJ5W1S/ecO4VSdhJmtiFzRDhpY+iqqkW8i96GGnctHJQwitJ4HxU1XEglVUzxYNd5e
	orIVf2mVV1KWp7cftovxJGPVsH4lR+Gb3vAsxgnlBN58H5RySh+O2iD+ssQh+Rrlr/pd2LjwqH2JR
	DSwZqm5f4JXoTiODemOYPV2jo8rU18BqBdISNufNzWFXE2XXFkR2KXoOswg5AMzJO8orcF5Yp7G2w
	rWbr9gzA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1t9yu8-00FkA7-32;
	Sun, 10 Nov 2024 11:46:26 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 10 Nov 2024 11:46:24 +0800
Date: Sun, 10 Nov 2024 11:46:24 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Christian Marangi <ansuelsmth@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>, Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Antoine Tenart <atenart@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>, Will Deacon <will@kernel.org>,
	Waiman Long <longman@redhat.com>, Boqun Feng <boqun.feng@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, linux-crypto@vger.kernel.org,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev, upstream@airoha.com,
	Richard van Schagen <vschagen@icloud.com>
Subject: Re: [PATCH v6 3/3] crypto: Add Mediatek EIP-93 crypto engine support
Message-ID: <ZzAskOZyclM9dWsg@gondor.apana.org.au>
References: <20241102175045.10408-1-ansuelsmth@gmail.com>
 <20241102175045.10408-3-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241102175045.10408-3-ansuelsmth@gmail.com>

On Sat, Nov 02, 2024 at 06:50:35PM +0100, Christian Marangi wrote:
>
> +static int eip93_hash_import(struct ahash_request *req, const void *in)
> +{
> +	struct eip93_hash_reqctx *rctx = ahash_request_ctx(req);
> +	const struct eip93_hash_export_state *state = in;
> +	int ret;
> +
> +	ret = _eip93_hash_init(req, state->sa_state, state->sa_state_base);

You cannot export/import any kernel pointers.  The state is meant
to be a serialised version of the hash state.

So state->sa_state_base has got to go.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
