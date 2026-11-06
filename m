Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793938481;
	b=dtj0sHAWAOe6ro37IW/IM39cwLYYpF3TONgdZwibYdDYYmvFnDMg7R05BC4cAxCtw+LA
	 KyG9n4PhLpomqqJjkRDgewjC9L1U60VKplTAe1VeOqQyLKbZLEfecRR0+HeyJUKCz3UP/
	 E33qN4uc2oI1Gl66t92aR4vxTUrmmmcX4MEQVMbE7tupi09Q93lEZacgSyVkTIwIIBVmM
	 MUPjpk55uT4Pt6nqRYZC57qsDvhT1l5PvbxcDLd5SD1Yq6tG0LIgRdcir/v0exLfaMPRi
	 m+1TdJyvTXQ8UbpmBQNpsKe3m9fMxBdcdycBaC7GYuxxLfIKivxIeqsKJiPLUMT6Qgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793938481;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=4iTH9f0OGjuepkIDDRmld8vcQdsQ2gH6OvHWl1xN5rY=;
	b=W286KZJDSoBoJeUh1Ur6xemyzmRnMdfpV4ZTtc2StsHQHJa+/29dz4/VYffsnfaOA4Q3
	 06ihAN43KChzQHeczI7R1g4ITvo294o2jypOtKZTwiuTlMu7L2ii8vZE3Lexpo4LImVYi
	 HVG8asbeMp/VQVgJJtZWFMtMOieOOxRa8lk8kfp/B8fLIXWVPIuSOeFZSFSS8QPgXalkp
	 0bTtuW/sRGdRN7TgG2D9Nmit+epWC4d4szpah6qhhDzCK+UnfzTcd2idfadPXwC3v8npV
	 CfKPeMU/37eVXP6QVGQJqFnkUlq21og5JFFpsfOfxu32n6Q/O6n5+zQZ9KtHKm3GrEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RTQiGQef;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057BB606A31B;
	Fri,  6 Nov 2026 04:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RTQiGQef
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689931F0089F;
	Fri,  6 Nov 2026 04:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793938480;
	bh=4iTH9f0OGjuepkIDDRmld8vcQdsQ2gH6OvHWl1xN5rY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RTQiGQef685VHKBpZwxgPg0CTHNbn+OwPiCDmS7NjfK4zakOtlU1m8zZPMJZu1ZhY
	 GMm3h+t/GQJbbvfSGDAu5qp3FlwpCs9Y2KC5Y9scVhVtjPwQpZzzEjSsUr1YP2lWWY
	 nDeSqZs7JpPUOGq6jhDw5voEF0iZumLfryW9wVlOQ8E2AYGPIQ5P33Cg9ijUN1IKIg
	 MAng/uO+BtH+3OTJK+s7e+YwnzDYGyakW28IGhSpvZcBuJPdvpLFy4i2xBCpkgC1vy
	 PPWXd/FCA9yAHlRGOGhLhWkJ9s6QvvaLs8SUsF0KIkKPEqF1O4CKCxgA0AHhFdiLyn
	 cqlSgFQz7BxxA==
Date: Thu, 5 Nov 2026 20:14:39 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Walter McKelvie <walt@mckelvie.org>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: algif_aead - Allow gcm(aes) for privileged users
Message-ID: <20261106041439.GB3877@sol>
References: <20261106034150.1159818-1-walt@mckelvie.org>
 <20261106034925.GA3877@sol>
 <47a49300-5b78-4723-b67c-4320aadfaf43@app.fastmail.com>
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
In-Reply-To: <47a49300-5b78-4723-b67c-4320aadfaf43@app.fastmail.com>

On Thu, Nov 05, 2026 at 11:07:15PM -0500, Walter McKelvie wrote:
> > Is this with upstream iwd, and do you have a source code reference?
> 
> Yes. I'm using upstream iwd 3.12 with upstream ell 0.83.
> 
> The reference is in ell rather than in iwd, which is probably why your
> grep missed it.
> 
> iwd's EAP-TLS, EAP-TTLS and EAP-PEAP implementations hand the TLS
> tunnel to ell (src/eap-tls-common.c:641, l_tls_new()).  ell's TLS 1.2
> cipher suite table uses L_AEAD_CIPHER_AES_GCM for the eight
> *_WITH_AES_{128,256}_GCM_* suites:
> 
>   https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ell/tls-suites.c?h=0.83#n1220
>   (tls_aes128_gcm / tls_aes256_gcm, used by the suites at lines
>   1322-1425, e.g. TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)
> 
> That maps to the AF_ALG name "gcm(aes)" and is bound through AF_ALG:
> 
>   https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ell/cipher.c?h=0.83#n224
>   (aead_cipher_type_to_name(), then create_alg("aead", ...) in
>   l_aead_cipher_new(), and the bind() probe in
>   l_aead_cipher_is_supported())
> 
> When the probe fails, ell drops those suites from the ClientHello:
> 
>   https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ell/tls.c?h=0.83#n413
>   ("Cipher suite %s's AEAD cipher algorithm not supported by the
>   kernel")
> 
> With af_alg_restrict=1 that is what happens, and EAP authentication
> then fails against RADIUS servers that only accept GCM suites. This
> is the failure in the linked report. An affected user confirmed that
> setting af_alg_restrict=0 fixed the connection.
> 
> Everything else iwd uses through ell is already on the privileged
> allowlist, and ell has no ChaCha20-Poly1305 AEAD, so gcm(aes)
> is the only missing algorithm.

Okay, thanks.  Can you document explicitly in your commit message that
iwd can use "gcm(aes)" indirectly via libell's TLS support, despite iwd
itself never mentioning either "gcm(aes)" or L_AEAD_CIPHER_AES_GCM?
Even the iwd folks themselves apparently don't know they are depending
on AF_ALG support for this algorithm :(

You also mentioned that iwd uses "ccm(aes)".  If that's true, the
comment next to "ccm(aes)" should also be updated to say 
/* iwd, bluez */ instead of just /* bluez */.  However, libell doesn't
actually have L_AEAD_CIPHER_AES_CCM in its TLS cipher list, so I still
don't see that one.  Do you have evidence that AES-CCM is used as well,
or did you just assume that one would be the same?

- Eric
