Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E6D17838C;
	Wed, 11 Dec 2024 23:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733959158; cv=none; b=efxrWlOVk1e/1qyoDEFj2APHKqGNB9h6S9QV2zb1u3+OE76i+jU+c18F3n3WhlXNfPYGnYGGqb8aB/i5Pn8qGNOM9RgSYM6BbkrStCkmnbAnCDZ5J7AK60d1Yxv789HOuPG3+sVdHbbw8SBFveMudiN+Nx/R6V/dvVj54Sg3ffs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733959158; c=relaxed/simple;
	bh=3mQol+kxBBEzejx272hcO9JZECRCz4n4isvDE0UXZKc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tepODfE9kwlMAdGOY8eF6q57IO44eJKTL7/khJVIzT9wqcUrTgvwYDb3esdGa+0YnmxsnTBUyyxjboLj4U+1BWBf5GeAzBLQFTJIHe9A5pFjvEtUOUWia0opGHH41ZMa2PiJNaFMRx+tdG9UP289VGwunr595S4J1YGodMaeM/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=kDuSRDFj; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="kDuSRDFj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=qAOjMl/GqayOOrw6nEASh0nWNB4CfhlTcekM7AL4b1E=; b=kDuSRDFj2NoOaaycBqDWElWR9C
	SsLMhRE1ixtf6gYbtYBkCwNZN0I77Qes6BbIpolr7GGq2DbwMEj7huyimTxNVkkX65Rf7WS9iPMpa
	Mn7xahf9MF4j+DTKGGIHTfOC5cJz6CHM/tyfBNZvtMPtuIfon99F2XMoJ9L5E/pjOmaOp6X1A5BfU
	kE0m7kvkYiyvG8lf3qDw4DepkN3v+wJ+4EIa/FMU11C1eVJ6t4Qwv3fl2ae7a5OVfhxNZB99Ztbmt
	3zMSpshe/7S4yxW3wmD1MobqMkObMHWZd9ga3uApG1LmfcLtlP+ezmuAGg8pqE/CjarvWeEs10+gS
	1oHkhTlA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tLVls-000tOn-1I;
	Thu, 12 Dec 2024 07:18:54 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 12 Dec 2024 07:18:53 +0800
Date: Thu, 12 Dec 2024 07:18:53 +0800
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
Message-ID: <Z1od3fgP02ay88Wy@gondor.apana.org.au>
References: <20241210204853.18765-1-ansuelsmth@gmail.com>
 <20241210204853.18765-4-ansuelsmth@gmail.com>
 <Z1ldzyPKgoD8GZfx@gondor.apana.org.au>
 <67597a1e.5d0a0220.9b04.2bef@mx.google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <67597a1e.5d0a0220.9b04.2bef@mx.google.com>

On Wed, Dec 11, 2024 at 12:40:09PM +0100, Christian Marangi wrote:
>
> Just to make sure, this is only limited to DMA or it's also problematic
> to the block list? Aka NO FREE should be done in export or NO DMA FREE
> should be done in export?

It's all resources.

The user does not have to call export, final or finup.  The request
object can be freed directly at any time after a call.  So you can
never hold any resources in the request object between calls.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
