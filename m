Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABF717E575
	for <linux-crypto@vger.kernel.org>; Mon, 13 May 2024 20:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715632173; cv=none; b=nSP6Bdz/7yL9ttvQgCMYimAqID3k3jL3PjYGck5Q9BAIMSH+YDl4gyTyUIREvDcTUFh1+95vdJCkhr317/R54YLts0ZMr3VttkFt3Gj4mC7vhUuw0nePixyWjIkvwTnLUqajg0ZlBrUZWSTKw/pkbHzybTyooMFuCqG7kee9qOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715632173; c=relaxed/simple;
	bh=tJr1x3drsvVI/amU0d8Vg7GM70Kp7rHygXZ6vBa3uzE=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=b5MGJK2hiziBqHMEmhxmunuvJPrV/gMpkS6ma4jpdLuakS06VsN2Hemcqp79FuvA4LEZtasex6+84/CY9adCvZv/HwB864raKiqJ+RKoXW08oiUHfCdcDsK39zxyUXUiunciQwbZ9pdrvC9pkDvcdHkua/nKBSOb3DiK4NSYsGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jXNWKoCk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jXNWKoCk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F20C113CC;
	Mon, 13 May 2024 20:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715632173;
	bh=tJr1x3drsvVI/amU0d8Vg7GM70Kp7rHygXZ6vBa3uzE=;
	h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
	b=jXNWKoCkXvj1RoTsMllyB1/R5Gs0eR/JAgI1/GKEWrnXGUH4ohzXE45/gx8juGlZa
	 59EG5KHL7k/vL8FSiEOc8eShQ4G2yjT7GOBP5atQNGrgLaP+BKAVVygMtp45SLwvv5
	 b9PW8j72Ij8GhiCDXHYp/x3HDbzi36vm+LDVWIb9b9DdJTRRPnrGaYMJhLAGg2kN9E
	 v19cAVVL4y3c5rEvo1FHXfngVS/PlrIDnhweEsvIpCmjAX2vtRVuK70HgojrsYcotD
	 LLyucxWGU5zVRb2pmJrf7/1pO1g6gLRHB/X/nORU9Pt1zSUGbQ/TeQ3Xaac15S+N5K
	 oIgmbwWUsy+LQ==
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 13 May 2024 23:29:30 +0300
Message-Id: <D18SUIGMWEXS.1Z998TAJKVNZA@kernel.org>
Cc: "David Howells" <dhowells@redhat.com>, "Simo Sorce" <simo@redhat.com>,
 "Stephan Mueller" <smueller@chronox.de>
Subject: Re: [PATCH v5 2/2] certs: Add ECDSA signature verification
 self-test
From: "Jarkko Sakkinen" <jarkko@kernel.org>
To: "Joachim Vandersmissen" <git@jvdsn.com>, <linux-crypto@vger.kernel.org>,
 "Herbert Xu" <herbert@gondor.apana.org.au>
X-Mailer: aerc 0.17.0
References: <20240513045507.25615-1-git@jvdsn.com>
 <20240513045507.25615-2-git@jvdsn.com>
In-Reply-To: <20240513045507.25615-2-git@jvdsn.com>

On Mon May 13, 2024 at 7:55 AM EEST, Joachim Vandersmissen wrote:
> Commit c27b2d2012e1 ("crypto: testmgr - allow ecdsa-nist-p256 and -p384
> in FIPS mode") enabled support for ECDSA in crypto/testmgr.c. The
> PKCS#7 signature verification API builds upon the KCAPI primitives to
> perform its high-level operations. Therefore, this change in testmgr.c
> also allows ECDSA to be used by the PKCS#7 signature verification API
> (in FIPS mode).
>
> However, from a FIPS perspective, the PKCS#7 signature verification API
> is a distinct "service" from the KCAPI primitives. This is because the
> PKCS#7 API performs a "full" signature verification, which consists of
> both hashing the data to be verified, and the public key operation.
> On the other hand, the KCAPI primitive does not perform this hashing
> step - it accepts pre-hashed data from the caller and only performs the
> public key operation.
>
> For this reason, the ECDSA self-tests in crypto/testmgr.c are not
> sufficient to cover ECDSA signature verification offered by the PKCS#7
> API. This is reflected by the self-test already present in this file
> for RSA PKCS#1 v1.5 signature verification.
>
> The solution is simply to add a second self-test here for ECDSA. P-256
> with SHA-256 hashing was chosen as those parameters should remain
> FIPS-approved for the foreseeable future, while keeping the performance
> impact to a minimum. The ECDSA certificate and PKCS#7 signed data was
> generated using OpenSSL. The input data is identical to the input data
> for the existing RSA self-test.
>
> Signed-off-by: Joachim Vandersmissen <git@jvdsn.com>

Unfortunately I don't have anything to complain about so:

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

Linus pulled 3/4 of my previous pull requests (TPM, trusted keys and
keyring) so the road is clear for asymmetric keys pull request.

BR, Jarkko
