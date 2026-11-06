Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793939949;
	b=sDSrsFpGLnY5mxionXdh3eqljAp/mJCgWDfaaAU+qUVWziHv2ZfIf29rDSyfk8fVIf/3
	 KXz1w3iW9ar8bc4DjE8cWt/WKAIe0/jLq3fxpJTeSLlhwGuttyCiYA2HFLtR/RuwWQiTf
	 iC0WJAdxdz1H49CWBTbjm6DQVjiPgUndNq1crR2NAl9twNa1ZA9GLWPH/ALZvQr0LvB3J
	 LiDAyeHansT/As/MQhXvQxcZ3dCFv+4v3a/r3VoX4hymh7ISKTpJoWL2p/F2B3fZkDrXP
	 x2/DFBwxBwVgLjfV7DxEvYYpA32z0APso+nEcjZ4VnGHkYHjaszZzd3O5Dg2YIixWdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793939949;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=WJYakVHTUhSimLuhetEiFN6YjNSgw5A9ogbMFTPYB+M=;
	b=uZXCJdkZeNHCkt/aLAlYiJg2qhVTrCUsUbnXcXjknG7hUnHPJL5bm8879XlmQgGOourv
	 loZSJ+aQw23IvVK9VPDHWYqDzF+8Ovx8IGUcgu7GiUtOG20+BiXgmGIdZML9Hwe7tTF1s
	 jUrGtmUvNLWco1IDXx0gIp98f1RN+2ha7YPRBlhouz7CTMzMn2TjYGMWnxbZN+H3V5eIe
	 L03RoVsVtqaARQAVyNBi3VGZ3fSNjquj/jL+J8YU/IJkeGqlFjQb3F1oTl0V/Cx5u5gTU
	 m3aBv0Spzh8mSPGP8SpSTXmtk48TXs9sB9jEoiS/tN4v0ADMs6UxmzmOYr2iNt2mDZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DcbK63p+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13582606A31B;
	Fri,  6 Nov 2026 04:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DcbK63p+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71B881F0089F;
	Fri,  6 Nov 2026 04:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793939948;
	bh=WJYakVHTUhSimLuhetEiFN6YjNSgw5A9ogbMFTPYB+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DcbK63p+2ga0ES8PIR7j9TglbcWVb6xd6xGaohOG85yUqo/tsyI2RWIgmhv6Mku/w
	 7JoXLz29DqtfFoeD/Ze0b7TX3WZGBq5MG/J9Tx6UOztWcHTtjICk5tbwshrKwYQlY3
	 8Pm2MK7kSo2SM5/srTaWbM6S23GEpUlC2MjNKvYDyqJW6TkqOX2z/GKlbLOci3pEbS
	 OY7fmXoSHBswPUrBSY3kCCQwMz5DHzp6RVdKuza+h5O4rKnbMGDkyDBXYJoM36m/pu
	 S63JhCr+349Q6ZByR+sVTEoV52uDhLEM43DAvonQdd92Q5O3YqQDEydXwE3qfMZ2iK
	 L6qqDxqxxYp+A==
Date: Thu, 5 Nov 2026 20:39:07 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Walter McKelvie <walt@mckelvie.org>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] crypto: algif_aead - Allow gcm(aes) for privileged
 users
Message-ID: <20261106043907.GC3877@sol>
References: <2e4c2648-72b2-4249-89d3-8dd111b84395@app.fastmail.com>
 <20261106043459.1169202-1-walt@mckelvie.org>
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
In-Reply-To: <20261106043459.1169202-1-walt@mckelvie.org>

On Thu, Nov 05, 2026 at 11:34:59PM -0500, Walter McKelvie wrote:
> iwd depends on the AF_ALG algorithm "gcm(aes)", although iwd's own
> source never mentions "gcm(aes)" or L_AEAD_CIPHER_AES_GCM.  The
> dependency is indirect, through the TLS implementation in libell (ell)
> that iwd uses for EAP-TLS, EAP-TTLS and EAP-PEAP: iwd's
> src/eap-tls-common.c hands the EAP tunnel to l_tls_new().  In ell, the
> TLS 1.2 cipher suite table in ell/tls-suites.c uses
> L_AEAD_CIPHER_AES_GCM for the eight *_WITH_AES_{128,256}_GCM_* suites,
> ell/cipher.c maps that to the AF_ALG name "gcm(aes)", and
> tls_change_cipher_spec() in ell/tls.c instantiates it with
> l_aead_cipher_new().  Before offering a suite, ell checks that its AEAD
> could be bound on an AF_ALG socket (l_aead_cipher_is_supported()) and
> drops the suites whose bind() failed.
> 
> With af_alg_restrict=1 the bind of "gcm(aes)" fails even for iwd, which
> holds CAP_NET_ADMIN, so the AES-GCM suites silently disappear from
> iwd's ClientHello and EAP authentication fails against RADIUS servers
> that only accept GCM suites (common for eduroam deployments).  This
> contradicts the intent of commit 2f204fe718f5 ("crypto: af_alg - Add
> af_alg_restrict sysctl, defaulting to 1"), which was to keep iwd
> working under the default restriction level; the iwd algorithm list it
> was based on evidently did not account for the algorithms used by
> ell's TLS code.
> 
> Add "gcm(aes)" to the privileged part of the AEAD allowlist.  It is
> the only AEAD that iwd actually uses: ell's TLS code has no CCM or
> ChaCha20-Poly1305 suites, and no other ell or iwd code creates an AEAD
> cipher.  (ell does bind "ccm(aes)" once at startup, in
> init_supported() in ell/cipher.c, to probe which AEADs are available,
> but nothing uses it, so its allowlist comment is left as is.)
> 
> Fixes: 2f204fe718f5 ("crypto: af_alg - Add af_alg_restrict sysctl, defaulting to 1")
> Link: https://github.com/NixOS/nixpkgs/issues/583203
> Cc: stable@vger.kernel.org
> Signed-off-by: Walter McKelvie <walt@mckelvie.org>

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
