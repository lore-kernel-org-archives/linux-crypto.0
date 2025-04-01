Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3CE1F0E25;
	Tue,  1 Apr 2025 10:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743504806; cv=none; b=Fc5i1XPWByQimGmOlfnXuceqPGJRhiKBg+4W0na0SWSw2Vt7FkhAjJAk02PU5lbbQu6jUYyz4It62H7lPFgFtLeXMWnuvvymPCqRf8CL+EH/eoBSOxRJN0bfcfUE1MK8gvEi2NsoDG/RxvJtUUPLWBGqXhjuAjbj7fxWMg2Ywoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743504806; c=relaxed/simple;
	bh=HdTgkz2qKeSPHguJUOKjN1z7xAhj6zw9hjYP+nHhEvM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QuvYROuJsqbd3njmrM9jH3iKHrBgzJHdjksXWxZJlgnsvPtvyO9BHGm6FYg5X1V2T38EfqqJs11xVgVsi10YvwaXmYLJh6jDreI/nD6LF6cUo9bx1UHyVnQLKPMZ8x5ydwlL3LaU5LX1OJ+TY77C+xS9ZnfXRhtBtjMdaQFiCHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=c1cFC/Kn; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="c1cFC/Kn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fkeBrjJdGHBg0K6rKMRdv9J8Bb9dqInOgDKuuQTww8Y=; b=c1cFC/KnEfozmWHJWYvVhgO/Qx
	WMgtdtKm+kY5BSbNgEcaDkEeuLsUIGMhipt8ExYy/++EcC1Pl2ZmIXgK3gG+9pQ9NaTTdVst4AqlQ
	3lxlC/BORtY5rH4QRV2STsmihD5JGrk87GPgIqubgFGv321wZiPXAv4yENeo2aJlR0yvZ+5q0w+DZ
	ti9PthJq2Z/PhpLnMZqFEkfoIq6GMHxCxzmrk/XPGsGQAL6tmrA/nSCYRNEKX3/nY5ntZX7asiRRc
	Yqyvz8wRPHWx8H5cqUH0dTeKlL1sl90xmAi/FXGnwhlX37xSyj4rF+i85rzXYaeEpsvLGCL6SW9X2
	Hx/HGBIA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tzZEv-00BoMD-2J;
	Tue, 01 Apr 2025 18:53:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 01 Apr 2025 18:53:05 +0800
Date: Tue, 1 Apr 2025 18:53:05 +0800
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
Subject: Re: [PATCH v11 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
Message-ID: <Z-vFkUmd6vgciU6V@gondor.apana.org.au>
References: <20250114123935.18346-1-ansuelsmth@gmail.com>
 <20250114123935.18346-4-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250114123935.18346-4-ansuelsmth@gmail.com>

On Tue, Jan 14, 2025 at 01:36:36PM +0100, Christian Marangi wrote:
>
> +static void eip93_hash_export_sa_state(struct ahash_request *req,
> +				       struct eip93_hash_export_state *state)
> +{
> +	struct eip93_hash_reqctx *rctx = ahash_request_ctx_dma(req);
> +	struct sa_state *sa_state = &rctx->sa_state;
> +
> +	/*
> +	 * EIP93 have special handling for state_byte_cnt in sa_state.
> +	 * Even if a zero packet is passed (and a BADMSG is returned),
> +	 * state_byte_cnt is incremented to the digest handled (with the hash
> +	 * primitive). This is problematic with export/import as EIP93
> +	 * expect 0 state_byte_cnt for the very first iteration.
> +	 */
> +	if (!rctx->len)
> +		memset(state->state_len, 0, sizeof(u32) * 2);

I don't understand when this can occur.  As far as I can see,
zero-length packets are never passed to the hardware for hashing.

> +	else
> +		memcpy(state->state_len, sa_state->state_byte_cnt,
> +		       sizeof(u32) * 2);

I need to know the endianness of state_byte_cnt, which I presume
is the number of bytes that have been hashed into the partial
hash state.

I need this because I'm changing the export format of all ahash
algorithms to match that of the generic implementation.  This is
so that you can seamlessly switch between an async ahash and its
sync fallback.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
