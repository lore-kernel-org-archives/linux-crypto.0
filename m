Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72879EBE;
	Sat, 14 Dec 2024 04:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734151074; cv=none; b=J6y+ExWn6bqYFHcgIgqgboUF/QiEyZ79hSZt6nJy3HR8OCjb/mUyWPJkWXY0NMUy0AEvPwLpocYBlomKB+tH21+jI+AhmB6BfEt+B5PbUYHB0nbz4viXTEA/fpHCdJrMjTuGLvqyk780jFyoNbhTcQmbI7qzi+OOxB9dQFjef2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734151074; c=relaxed/simple;
	bh=0+CszUVADNAsoOvEKPdSsfEkhgw1MIeDvHs1+CbUzd0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mkedKtoxgE5W+O1rU+r+3hb9VkO/VGGNEdoJeHZtgiJRw4hh2FMwjmuwUZ6qquak7GKAEBSLaT+4wweh29OhbHpd7KazaEklHTNb+cQhVVZIt6Uk4xV1jedm7cyyBr6scKkPsfx94nACUJJsr9CbcT6VChi32SsJ3O0a2WAqRB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=rt1x09z8; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="rt1x09z8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6m5em2Z9V8ppDHMu5bgEkM80Ya1xpLt2NaP6Fd/8cn0=; b=rt1x09z8MKXqBmEEb07A/tn2we
	pCn7KOkUHUaNrI3L8bn0QuS/ksCWMDqtnUJWSFTNpDP8S78EL9WtDoQtwbUiFlO2/cAQdnicW2BMu
	pPwQOLqmMUe6kGPNyYcGTfGVXBtftA7sejIMO9gOslwZ8lk0YY9DA7Jx1e47fe/PHCcQA/90TDbDc
	zXIj/DGFER8fPXl+g1N7o9bMZLz+/LTlTYrVYo2g33/DyOG6vXVxYLlsYuZ1SVWYA58vSBE7JUfh7
	y3LaB3yk0fPfcGXBptwf9gLwbVHKLaArhV0EhG0s7tEQj6ksh41aGS5ZcIOlfZdsRGtl2gvG1mhdg
	X3I8iRcA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tMJhB-001RQ6-1k;
	Sat, 14 Dec 2024 12:37:23 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 14 Dec 2024 12:37:22 +0800
Date: Sat, 14 Dec 2024 12:37:22 +0800
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
Message-ID: <Z10LgtZm4-qCB2aL@gondor.apana.org.au>
References: <20241210204853.18765-1-ansuelsmth@gmail.com>
 <20241210204853.18765-4-ansuelsmth@gmail.com>
 <Z1lb0ImxhhFs4Kuz@gondor.apana.org.au>
 <675979e5.5d0a0220.207826.2bf1@mx.google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <675979e5.5d0a0220.207826.2bf1@mx.google.com>

On Wed, Dec 11, 2024 at 12:39:13PM +0100, Christian Marangi wrote:
>
> Do you have quick example for this?

Just search for crypto_ahash_set_reqsize in drivers/crypto and see
how they use the reqctx to store temporary data.  For each request,
you're guaranteed to have exclusive ownership of the reqctx.

If you wish to DMA into the reqctx, search for ahash_request_ctx_dma
to see how you should set it up.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
