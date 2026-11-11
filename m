Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794438082;
	b=umq7naFnMoy8Tzxl9PXWs/DM1wGP/2G4RHrYyqUABeZZ3rqqByTFQh56fL7eE9Z1SfB5
	 26IpH1eu26pA5miTNmNQR8T87TlgGb5z8DVrj5U2iEW898RNjjaz7xG5g6N9vuG30oLCx
	 nblui2HzznPQ4qQczUB1tmU1Ej41QOewoT8a0wEKLOmksVWWMXasdd6As/JlqqPUXAgTs
	 DEIwT2kyvLIVG+/eaY/3xDiZKZCceSaeggAl+g6g1CheWT6K/iXCH+YIQWhJQnB+cuhwq
	 9wrmpE8CO4ZulQPMs6fcpHs6RqoLbsJbgES8YYfOjADx31lYRX4+OuA0/j8lPjmrLPw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794438082;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=es2W//wdjmPVYd4m7qpzscuMfFc0jaKJ7FDPSuWbxV4=;
	b=uwNZwTPBZFiN4kFQj1b1DbJwtNyWiWUjrIhO+2eDCGk1FZj+qyjn9o5JET0GF5GBCWLP
	 FDxoqJ5Q/dom9bkTOHyH3AVW4ymJoYrZWIq4P6Z96R0VYq/WZkAWdVRipmPYNIUJiU9LT
	 /Gk7/Ov+k57elvPMGdGAPuRjI3ZtJoNuUA4HBSe1nDD8As0ISpX0WNFRUjL+rlebgD4A9
	 hEI1xd2iUbWXinACVLCQaS1M6r7rAZ1kN02VfYPQKQhOhQ5sFz+f/Q+ZyaanZYfTZhaf8
	 Z9hhR8sX7sH7hSjtYHv+sZvIJL2Ep5s92Q3o4IVfVjr9svgyzlbFtZ3LOuSZfmkMlCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NOXMy5DW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 043EC606A32A;
	Wed, 11 Nov 2026 23:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NOXMy5DW
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0334E1F00A05;
	Wed, 11 Nov 2026 23:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794438081;
	bh=es2W//wdjmPVYd4m7qpzscuMfFc0jaKJ7FDPSuWbxV4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NOXMy5DWybbYd7K3He+h+oTeCws9eV61iNHecz83rKnt9KToNrjjjFbLPZ9DZ44KQ
	 p1ubAP3PSClYqlnyOsMB4YvkcIzv7dl9dYAEWlVdfDHs9TK/b0DKyu6YCWsj44ZVNW
	 zk42KWJHCjoTn3G/5sox0aDzbb/ta+ryPeoC1ieUYUtlAe99lzguR0FVLxFBSbhP0n
	 x4yndzlP650V2LctloZhZ0vOM0skZckhtz8h8j4Ydf46OIlAyVBVKwB2/32yMxINKa
	 PkOpjZAqKEh81KKcVelwaGsMzBcm/cHpVs416JWbtbsZDve495sKipC3npy16+H3u1
	 2DRo9xQKe+BbQ==
Date: Thu, 12 Nov 2026 01:01:17 +0200
From: Jarkko Sakkinen <jarkko@kernel.org>
To: florian.bauckholt@cispa.de
Cc: David Howells <dhowells@redhat.com>, Lukas Wunner <lukas@wunner.de>,
	Ignat Korchagin <ignat@linux.win>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>, Hui Peng <benquike@gmail.com>,
	keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH 2/2] KEYS: asymmetric: Fix PKCS#1 decryption of an empty
 message
Message-ID: <avTzvV6hI3HsgiF3@kernel.org>
References: <20261111-keyctl-pkey-fixes-v1-0-934ebaa267a7@cispa.de>
 <20261111-keyctl-pkey-fixes-v1-2-934ebaa267a7@cispa.de>
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
In-Reply-To: <20261111-keyctl-pkey-fixes-v1-2-934ebaa267a7@cispa.de>

On Wed, Nov 11, 2026 at 04:56:08PM +0100, Florian Bauckholt via B4 Relay wrote:
> <SNIP>
 
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

That said, I'd by default pick only 1/2 to my tree.

Br, Jarkko
