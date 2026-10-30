Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793384446;
	b=E/fszZjJsOAmRpElo8w2E4jrB9ciwQQceMJyfryAK89DRERKVhEDOsSK2WK01fC6SKUB
	 a3vUp3MWhBcGxKqMg2RYvV7ZDoSkn+M9L2JSXfWxZWQP4htGtvfm/lRMSMNkrAqu6rB4N
	 nXoQ4nedcr94e5HJ7kOENxkG8hVG+LHJeOCpddAC6uR2fqZ4Afgem14sivN1gtSEQY0U+
	 q0C0IsOvvKifPnvUvdoUxi46vTMqqjmD9Ttl/cx2U9JKGesFYgUUIb4OuLTwAK5nDAqYw
	 ZiS3OQC5gb3f3DqUEyQyrzgqMqy9WV3ZoUZE04ioI9wTd913u1J6h3E57D/Bvj8mx2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793384446;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=XrTk6H1ozhsKKIUAfLaewns0CWVKrB7d+ne/BcvUjg8=;
	b=b8eLmnioc0GoE0Jwz6Ehi8nrku56Ca14Bqof2VohK1UNk8E61y8aGczNKIb9VN0u/pob
	 4TZU2gcnLuDyI0BAXxB/2eu4N8i10Rd7EvUP6f3ZP30CapDadO+zQHndECdZhw6zY8eUj
	 X4n+mXW3FfQ1M75KqnjJqnc+b4iMINFj2yAhsrjA/3XmpXAXvU/7tHSu1triHTSDXacCB
	 S/t27N4boYaFFWyvngx7IaeAdWegnCjl/MnhAZSscIVcxVY5762OKxIFckZu1dqqOsjpj
	 ePNeod77HXdVje/FTyQpukxXy/GZMfUDk/Bw1//Xj3Cq+Hl8mpBrMHQiHfMiM3SzyKQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CPp1ppHk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2938606A31A;
	Fri, 30 Oct 2026 18:20:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CPp1ppHk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B2B1F000C1;
	Fri, 30 Oct 2026 18:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793384445;
	bh=XrTk6H1ozhsKKIUAfLaewns0CWVKrB7d+ne/BcvUjg8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CPp1ppHk7V7dU1ClceDi2B67LzVqheHtyagKOQlr772Rqpl/jozYq3+FJcoKppHq/
	 54hddIPl/t8ndRlzL0L0I1DGAs7Mn+qmytKzWCceMWu5qvGufLfU++RLMPjk6e3Ci/
	 zdrg0uP0R5spUsdCpYDw45Irad/E1McqD6oyGQXWfLVt0Ehy4zEeEPF3CRlzwGysro
	 6wqJoAPU/oppvX3ur4Ddet7TDaleVt6f7xHKcjkaOFXx8h9NNYpmeRO1DhppjR9JTU
	 xVT6SsuvcFKvOvtN15AY7XBkTJvgNVzLt1XcaFTA831kNdgDRZIrCfjp6yQaoUhjo4
	 wZ4lbccN4iiQg==
Date: Fri, 30 Oct 2026 18:20:43 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-crypto@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net-next 3/5] net/rxrpc: Reimplement DES-PCBC using DES
 library
Message-ID: <20261030182043.GC2500145@google.com>
References: <20260428024400.123337-4-ebiggers@kernel.org>
 <sashiko-outbox-190325@kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-190325@kernel.org>

On Fri, Oct 30, 2026 at 04:53:36AM +0000, sashiko-bot@kernel.org wrote:
> Does this introduce an unintended behavior change regarding weak DES keys?
> 
> The old code used crypto_skcipher_setkey(), which in the generic DES
> implementation suppresses the -ENOKEY error and returns 0 (success) unless
> CRYPTO_TFM_REQ_FORBID_WEAK_KEYS is explicitly set. The RxRPC code did not
> set this flag, meaning weak DES keys were silently accepted.
> 
> By calling des_expand_key() directly, which unconditionally returns -ENOKEY
> for weak keys, rxkad_preparse_server_key() will now fail and reject these
> keys instead of succeeding. 
> 
> While weak keys shouldn't be used, could this undocumented change break
> backward compatibility for existing userspace configurations or test
> environments relying on fixed weak keys?

Could be either a bug or a feature.  If someone wants to make
net/rxrpc/rxkad.c start allowing weak DES keys again (by ignoring
-ENOKEY from des_expand_key()), it could be done.  I doubt anyone cares.

- Eric
