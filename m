Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793936967;
	b=AL0ta0WamRylZMK7f1tzpqYMMuWZWKbifmiWRTC42Yj3z7SZdGqPTcvX53Uq5IGEZiLH
	 czR5fRbz6ZTKbV8AjOOF7PWeCHeOh5+kfWSr89nAV2HfdLkaCKeMDyvIBu3jbJB+DKaZ0
	 Y/1XIWolz+9i3mwe3d9HwDsDXJtusPLuKP97lcCMP+YOXu36GY6egjwMrJqbNa4lXnuNJ
	 dn2Hoz79TWSeibL73frvyqVS7dUqenvi1Kt9jZ1ZdAwHOjp7isEGRAGYvRnnVMU4uZKf8
	 /8TaBg+TWYcDJtajgEE9KxXbmj4M+8ahIIf9bWKPsFHdgbtE4FXSaYityNdgsmFLMWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793936967;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=bR6/RyzKOdjpGGJRJNVfShP1T5DrkTgxl/K0lqGB0w8=;
	b=AaX4xCJJGZTpecxsWtfhE5lPJNGXi7/bZQbZwr1fVGc/t6xgrhOId0PBaSJk/OQvcOYo
	 DTPQW6S5+A+VrdB5lfMFxdI9DPa6zNemQfw0rEU6HfstjxBIykeEFdGbbkhphUrDA/kn3
	 XeFLR0RemAdmMsi/NIxgy6/MBe6WMGaOdf3qHrxreICp3tFbwTkqPMdMV8CunFLdMnPYR
	 PkWPxKKMDaUW8VLCTbIh2X9dbWyefneYNireo3x63tXvOUuMhEE4Tq2CrKHNuAgoO1NMc
	 NOsVYnoZtpudZ/bBRLVYNDBjcDRzP1UHGhX1AeuH3Mni9CLXX4B5phBBnRYnlPLrNyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DBXLa1GR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71CEF606A31B;
	Fri,  6 Nov 2026 03:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DBXLa1GR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297C81F0089F;
	Fri,  6 Nov 2026 03:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793936967;
	bh=bR6/RyzKOdjpGGJRJNVfShP1T5DrkTgxl/K0lqGB0w8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DBXLa1GR6y3NbdRJY+QMmx7gNQCu1YDGZ1tdDdYd2N7coc1sO/SVQQgl68pVnjc8z
	 8Rg+d+mxzghll7ZdM9KS5/9EWVqR0WZIVzgWKSXSCHMSkvwS2nlLaT9De6WKR/SHoj
	 bQ+yZlfsyv/0bDTqLAFXstxFC3p4dU7Sj174b7K9HT5sFjLEX6Dtr+CWRpJlVK6EhA
	 VE0Au+OaPS8fkKERAOkD61x3hbvV1KR/vFOpIElDrEhGM4AC/JwTtOaK2gJ27+4MsJ
	 CWm5//y0lnhZWIIE0Z7fGgNpS6rIqMLkWeQEKzLwI+bKYFI+8Rxj0yww8KVz9UVAPb
	 O1zkAIOeq+Liw==
Date: Thu, 5 Nov 2026 19:49:25 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Walter McKelvie <walt@mckelvie.org>
Cc: herbert@gondor.apana.org.au, davem@davemloft.net,
	linux-crypto@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: algif_aead - Allow gcm(aes) for privileged users
Message-ID: <20261106034925.GA3877@sol>
References: <20261106034150.1159818-1-walt@mckelvie.org>
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
In-Reply-To: <20261106034150.1159818-1-walt@mckelvie.org>

On Thu, Nov 05, 2026 at 10:41:50PM -0500, Walter McKelvie wrote:
> iwd (via ell) implements TLS for the EAP-TLS/TTLS/PEAP authentication
> methods and uses AF_ALG for the AES-GCM AEAD of the
> TLS_*_WITH_AES_{128,256}_GCM_SHA{256,384} cipher suites.  With
> af_alg_restrict=1 these suites are silently dropped from the
> ClientHello, and authentication fails against RADIUS servers that only
> accept GCM suites (common for eduroam deployments).  This contradicts
> the stated intent of commit 2f204fe718f5 ("crypto: af_alg - Add
> af_alg_restrict sysctl, defaulting to 1"), which was to keep iwd
> working under the default restriction level.
> 
> iwd runs with CAP_NET_ADMIN, so add gcm(aes) to the privileged part of
> the AEAD allowlist, next to ccm(aes) which iwd also uses.
> 
> Fixes: 2f204fe718f5 ("crypto: af_alg - Add af_alg_restrict sysctl, defaulting to 1")
> Link: https://github.com/NixOS/nixpkgs/issues/583203
> Cc: stable@vger.kernel.org
> Signed-off-by: Walter McKelvie <walt@mckelvie.org>

Is this with upstream iwd, and do you have a source code reference?
"gcm(aes)" is L_AEAD_CIPHER_AES_GCM in libell, but iwd has no references
to L_AEAD_CIPHER_AES_GCM.  It didn't show up in the search before either
(https://lore.kernel.org/iwd/bcbbef00-5881-421b-8892-7be6c04b832d@gmail.com/),
and the iwd maintainer confirmed the full list without "gcm(aes)" on it.

- Eric
