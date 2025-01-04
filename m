Received: from abb.hmeau.com (abb.hmeau.com [144.6.53.87])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1041DDEA;
	Sat,  4 Jan 2025 23:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=144.6.53.87
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736033301; cv=none; b=o9QCW8UkoaVYf7Fl5qnWrXpa513i0EwdhkGoUUhLO/dQ5jG09yv6H0Nfc7xH+EPDXRBlnuFvvhFFCekrfFECZvXiO77fskDCBjdUcH2zBsUGgxmH4/G087SjIkP06KfpKdpK94HGaJV3ZBiO1bBEk9l3+JvaReNofIvaSheQWLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736033301; c=relaxed/simple;
	bh=xPMA15QZ1lOH/51vQOnBECvvvsg0NQdxiRmTGrVuzZE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tQO0TavGPtB4/Ze4vTUwbrydMycl6F2q9wdi/r6+CixQKIl34IC/05cBB5gxd1/kQTyqiIzpgCbIp/toAM+GlYhuOyxnWUPz3T3Qc1gWtaSjiHCs4f7EdWh9AV3ZlfmiaSf0vG2zHZ4zI5pHJdYtWHwN2fRNDuJdubLBbovTqtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b=g5/VJD4S; arc=none smtp.client-ip=144.6.53.87
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hmeau.com header.i=@hmeau.com header.b="g5/VJD4S"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ekZ3/Itr3LZ8Laj6t1UFlViaAjAsbeIKV+suPWU48/I=; b=g5/VJD4SK7i9yoQoxuYh3c7zD3
	hIodUD/stl59xteDjzJJOT5x9yQVxwrN8Yf0en9D6WwFOmreQbp1F5E8INF7DgPKe0lsVt4zK9ygR
	4TKOlaUJnX6L/5ZEho5fATJmR2XXFwltWHlRV5t158Lw/IfKU28XMsm2DMaOrws23cNm6RmkkZ7h0
	ZXY6HRyH4unINGoLhaqs2CLnh4ktlOCSmal+5pso5bNsRU6/0fL0QG74OXUwITZwgYGbAy0lAXnQ5
	q2bcxlC/EuCYx2NcAoUN58Zf9YF6I6zJEAr5KfJRHGSZs2ALJcs7dBQSPa8sU5Xevodn/lu7q9Ej8
	UuxgtVuQ==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1tUDLn-005poV-30;
	Sun, 05 Jan 2025 07:27:57 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sun, 05 Jan 2025 07:27:56 +0800
Date: Sun, 5 Jan 2025 07:27:56 +0800
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
Subject: Re: [PATCH v9 3/3] crypto: Add Inside Secure SafeXcel EIP-93 crypto
 engine support
Message-ID: <Z3nD_EQf1CyNmOtV@gondor.apana.org.au>
References: <20241214132808.19449-1-ansuelsmth@gmail.com>
 <20241214132808.19449-4-ansuelsmth@gmail.com>
 <Z2aqHmrVAm3adVG6@gondor.apana.org.au>
 <6779613a.050a0220.184c1c.c90e@mx.google.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6779613a.050a0220.184c1c.c90e@mx.google.com>

On Sat, Jan 04, 2025 at 05:26:28PM +0100, Christian Marangi wrote:
>
> I'm a bit confused by this... I can't find any reference of
> CRYPTO_ALG_SYNC, is this something new? Any hint on where to look for
> it? Can't find it in include/linux/crypto.h
> 
> Following the codeflow of crypto_alloc_ahash is a bit problematic.

Sorry, I meant CRYPTO_ALG_ASYNC:

	ahash_tfm = crypto_alloc_ahash(alg_name, 0, CRYPTO_ALG_ASYNC);

This should give you a synchronous tfm.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
