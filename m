Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793315247;
	b=dzE4uxoRq1wa1nfKhlS82rPiV9bcex1p72970FAawPTEjuixC6vQpC7mv9APKi1eirur
	 fqcY+O01Fmp5Mxhm8Y0zq+Qoy3+SDBWLuMGEUsULJH0i+5UxhydZe/09W8m6Xl4Ds79RO
	 LcaRJATZiZh6Z+0lCUThg32lM5Jy52kw6N8oy4eGlyr5M5c4Z35chFfFoKNoxp/bNemt4
	 6s6lIKWDW6BwoOdeB9Ttsf8sGpvbAA7IFRuHRp2+A6U+Zq90L4xORWDjsuN8g8hnkPpa/
	 Z/vYObjbxQcec64QJDNYjsMLE2XPfDX1vyysG2UuWrdIRPD5wVRvf45rmJG6dA+dSSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793315247;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 MIME-Version:Content-Type:Content-Disposition;
	bh=6+C+naqW0TPxuq8vtcEr/45/NSckPKx0FfCdd/TyUF0=;
	b=DaZ9+i5zAKyE/1Q9u0S+73nFy/6LLyb+15LGZ1D30/qIJcip/R3mkMXLqKaD7/k/8RKK
	 BTuwibS0xNSR1M2epzEQTgZNxt1jgmhXwqar/y/tY9u3Q8FQe6XDYOFDXoFLJwvarcux0
	 E3xRwepWVftmMzddIS7YVQBHeO2eL+pZlWsBFAw4fwCjRvAc1mSnACCJ/0S7ER2tmfZYy
	 TnOnGSHotpOQv9rB63SAJXlEB0NMTr0gFvO3MZIKrKEbq6eqOl41qndCHZPqc0XEHVq9+
	 k+Zndr8NJNUF7LSTmhHWRpFI/Ke31V2ge5FAxsCP1fOkFcU+cRHe3BSSi81M6wmY0Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A7sBqUiP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C59C606A31A;
	Thu, 29 Oct 2026 23:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A7sBqUiP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08DD21F01816;
	Thu, 29 Oct 2026 23:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793315246;
	bh=6+C+naqW0TPxuq8vtcEr/45/NSckPKx0FfCdd/TyUF0=;
	h=Date:From:To:Cc:Subject;
	b=A7sBqUiPge6AZY2LXjN+E7lAZgGIM5ZrtJq91H5BMjx+PLyoR5M++2CiWOdg0PGSN
	 dx37eEiZx5R/e9aebYTQSUaFsBlh/9gF5mB4DAYAS87kAE0BAvucrPEUdBFCD3P/W8
	 GH/9of2BbYj5Fv0eqWzFJis0wnZGoEEv260BYyffcT72460VGeG4FosgOcPPeVrUrk
	 y2DgBctDFJh++DKnGmUa4ebYrmeYVRooCTULufeE2oFrpPC24RwKXaaRNWBf92jkpA
	 O3MggrA4pOx2R0Pd6toiIzXBhPxUGUdp1g/0CBrhJC3cgCU14kmltCUZzhpqsBj5kJ
	 2VSU9k8wIbAhw==
Date: Thu, 29 Oct 2026 23:07:24 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Subject: Apply "crypto: algif_hash - Allow hmac(sha512) for unpriviledged
 users" to 7.3
Message-ID: <20261029230724.GB1254086@google.com>
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

Please apply commit 80fb9a85807177d3ca64746d59a68b1c6e8f20a6 to
stable/linux-7.3.y, as it fixes a regression in being able to build the
Fedora kernel RPM.

- Eric
