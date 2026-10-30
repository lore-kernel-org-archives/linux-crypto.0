Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793384249;
	b=nBx94du3AOGLsjk8MeJO0Xy0hP39jqqJ/gvx2jM6Ds43UDR1qQKYvAoXOmX/YeVJKyAf
	 OBNau/DfVD1wkqXX9Po0X/35IroyKi403UolKf5q28FUtAIAh4x8D7zSQpqz9Xwqv0TKb
	 Tgul5FXD3x/xdCu0GPTa8yBqndCwXAlnq3+COWuL8IMoS3m19EfkUB5uukBTpfMnb5wyl
	 CtGY8naZUtvlcxjP2Rd2KiFfCJBHr7kT8upn9fjtoqtl4HsVdnlcEWeaYaKQZiRIqyPqq
	 8qPsO5iCPur/g7oCdUB6O8yk+dCS1hoW7j65ATikwLkwQL2/eHxty9DVQr/ZpW2VhlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793384249;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=ZmdNEdsBW8LoeBKSrvd1d6xYZhom/SPrpvUEQiOqYTc=;
	b=4GLQED6oO5+VbROW7HuNfFHu0+RL8IkdLGTMgqUdCXr+BH8ddHVy4B/9knGNm5FJNJMa
	 ZxlJal985pY34vS6bCan0P7fa7VLvYx5eXuhzU1Yzke5isGDYLpnfjSi9K6jbyWQLWItf
	 9f83RcNrNb21qfhJVmJgfQ+zHNpv11c9cPPvcHK2QimBF9G4bAIaoFFyxN6UpUjcuIUT4
	 0X8EpkyETyX+KjSTLKNDW/YJsqMNVch8i+7dxZfHqEs5usIpezSB/l8uIctYWec/b1haM
	 blipS5awpLcPRdsplXOyBmqyjaOPipYpgZ/tknmNLNXd18BS/9rw3Xo0oHJfHbEdibg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="lXSjWP/9";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9EB606A31E;
	Fri, 30 Oct 2026 18:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lXSjWP/9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB69A1F0093A;
	Fri, 30 Oct 2026 18:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793384248;
	bh=ZmdNEdsBW8LoeBKSrvd1d6xYZhom/SPrpvUEQiOqYTc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lXSjWP/9QgGrOPDBzWHc9g9WpE+BKPllQSOsjDUG3M2eRvE1RY7LpYi/J1smH9Mia
	 WkWQ0RBj0ZSJD7buSSTPNi5kWS0CngwS83hlmklzgr/PZM5sBwyG+QWxFB2QvklU6z
	 CzxnrD2H2j6DP12nZG27g+mR/NCSk8wl1+cHpDHDg9KVBrzx3c1qzd1fnEmptrp7cT
	 BkvvM0pwB7rpcOCHfRVBTgXse6lVYZ1digD6G8gHIsaCang0IZMOXp4kEKrBD5wdx7
	 mDclEL0CfTsBAoCFrMNjiggSw+G1CxdtLKNXB5na4aRhTZag8WsXMZ8Y3/D/8pazf3
	 5zLjYQKcLTrFg==
Date: Fri, 30 Oct 2026 18:17:26 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-crypto@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>
Subject: Re: [PATCH net-next 2/5] net/rxrpc: Use local FCrypt-PCBC
 implementation
Message-ID: <20261030181726.GB2500145@google.com>
References: <20260428024400.123337-3-ebiggers@kernel.org>
 <sashiko-outbox-190324@kernel.org>
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
In-Reply-To: <sashiko-outbox-190324@kernel.org>

On Fri, Oct 30, 2026 at 04:53:35AM +0000, sashiko-bot@kernel.org wrote:
> Does this code leave the cryptographic key material on the stack?
> 
> The local struct fcrypt_key cipher is allocated on the stack and initialized
> with the session key schedule via fcrypt_preparekey(). After the decryption is
> complete, the function returns without securely erasing this key schedule from
> the stack.
> 
> Could we call memzero_explicit(&cipher, sizeof(cipher)) before returning to
> ensure the key material is cleared?

The old code left the key on the stack as well (in 'iv', since the key
is reused as the IV here...), and I didn't aim to change that in this
patch.  And FCrypt is not secure anyway.  Only real reason to add this
would be so that LLMs don't complain.

- Eric
