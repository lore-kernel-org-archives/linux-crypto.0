Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF661A83E9;
	Wed, 11 Dec 2024 09:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733909493; cv=none; b=DzrSZqhe+UKeSeEcIr0GqIP5244E9miHimEBos0o0ej6eMQtrcyQKDH8wg/jV8Ne5n2pRm/AX5ZmBzZd9AoRJfxQh921gIjLoD2fJjRMfbESJ3b+Rd1Zog8t8QYQ9Kk8SBFlVvsDXINfIHRacIAhUCEAB7jWieGh/pphvnASWJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733909493; c=relaxed/simple;
	bh=n5YgshR1sFfXUiS//KEredRhU0DpugW9DrAjNrcfVvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VnlE9XRywsBmyfvb0Quh6p4GverWV73+oAsSTzFEzKJTWhQAcXkxiHTQQ+kMRIz6Jyf3+nyOwHrwjd2ugTXhAtA8M1Np0SbGQSKSwFEcgE/E2XG9kYSxn/rwBBcPNTLGFbxmBL2zb8DlCUraG77HfkXuTE7+lCFcPe41sPXItIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=ih91x07p; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="ih91x07p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=fEl58DL4MAFxwTJpgb3U+ILMMojCdQUomfAFX9LGcFA=; b=ih91x07ptKzgvYvaZFqB8HkGp0
	S3jxXecIsMf8iPyMFc1jli0GDmZBr3S8IDuY3/RrzuhQzzE0vuFQXnBm9ptKMVD6RbIfXDjr04OHW
	+sGtLQudD91dYkQ5MCBnIemPulnRszwNSGQnSMSapehxH7rubyqEfSJ//Eq7pAQFltq4qIXESOlFe
	Qp2GhLRc6LwKkk9NVVVmTZhRqWw8qm+jCN4BMuBI/Krq8+HkadFPGWVGSHi5xbAPVxmweeSU2+3ns
	WnraUcKtzmmK1P6GTLHRIfKVgHju4tyY9OC0bOWnEM9Fo28w00N7FZm/TMCDQkiT2wZ2c0dtajH2M
	JLOkT+3g==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tLIqe-000iLO-0Q;
	Wed, 11 Dec 2024 17:30:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 11 Dec 2024 17:30:56 +0800
Date: Wed, 11 Dec 2024 17:30:56 +0800
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
Subject: Re: [PATCH v8 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
Message-ID: <Z1lb0ImxhhFs4Kuz@gondor.apana.org.au>
References: <20241210204853.18765-1-ansuelsmth@gmail.com>
 <20241210204853.18765-4-ansuelsmth@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241210204853.18765-4-ansuelsmth@gmail.com>

On Tue, Dec 10, 2024 at 09:48:33PM +0100, Christian Marangi wrote:
>
> +	/*
> +	 * Consume remaining data.
> +	 * 1. Loop until we consume all the data in block of 64bytes
> +	 * 2. Send full block of 64bytes
> +	 * 3. Skip sending last block for future update() or for final() to
> +	 *    enable HASH_FINALIZE bit.
> +	 */
> +	while (to_consume > 0) {
> +		int to_read = min(to_consume, SHA256_BLOCK_SIZE);
> +
> +		block = kzalloc(sizeof(*block), GFP_KERNEL);

You should avoid allocating memory.  If you really must do it,
then it needs to be GFP_ATOMIC, and your algorithm needs to set
CRYPTO_ALG_ALLOCATES_MEMORY which means that it won't be used
by the storage layer as memory allocations may lead to dead-lock.

The preferred way to access extra memory is through the request
context structure.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
