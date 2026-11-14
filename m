Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794630301;
	b=rZGTIGjhupoZb4xIe0hFsVWOzja//cf8NWJ/EcaHS8+HPdh71ANwiLy3vhuC85K8i8Z+
	 70jSbZ4X5hSJ71zsXvtksMvfLOOR9ex9+XVtRAf2PuB4rPDExb5IxSOrOnAYGWoKgAok8
	 QItQb+qeubZpWpI75/ZL+0/6UEDnGKTrux07Xrqcg2fxKaxs3PwnNLJ9SzX/BeQl1SoTf
	 kOfKwYBtlb9iy6UUK+KNCgYBeMHbEAJKV4Sbp+p+DPpCEXwKZFH9w+i5U9+PePJCBaJUC
	 ucOsj4Qp0ctO4GVBaGUrQBxHxY3rt6sx73OJnYEniay0nIJkVs42n7gAKewMzMukaMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794630301;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=qjZsEaWUyewgfl3HD4bludnmfVeUhTu32MbYGqOSuQI=;
	b=aiX3aFurZRaDhIIeynh4lnH8k4kWrZuySIIgAMkPRBZfm+4etKOihts5bR/oPXLIWC6F
	 whnFLPmkhEGKL6zLV1m5ExlcOm+sbUqNZPhZug97Ex69H0WacHH8rS0dN3DyuF2d20XEH
	 quROX2qZGv4uIkS0QOlvqbZtDwVtxpMzBRUEh2z91kFJdkRR7NzMm742/xMPuhktdXBrn
	 LIQVuJOMVGM/NNBI48SAuX71X3AvBp6LgzjreNQiVZCnNJP1jzouilX2kWFJe8wgGegWY
	 RtEnBQvz05F9Fu58r4pPA8ISDtvOkbCJ5ONqtDbymYZoV8JXJf9rdWui5sdRutqmEJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nhcnke35;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8C6606A323
	for <linux-crypto@vger.kernel.org>; Sat, 14 Nov 2026 04:25:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nhcnke35
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D68BB1F000C4;
	Sat, 14 Nov 2026 04:25:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794630301;
	bh=qjZsEaWUyewgfl3HD4bludnmfVeUhTu32MbYGqOSuQI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nhcnke35jzDrmi9jXgY5X/cTPKmqTkxAzrxUhg4P4Km8iGIyGHJt4LM6MgmFO4EhG
	 xT8nM34zXWbUCIFGBJy+UMto9w31GVLtKktyrJQ2vGcaKj9psUuOTiWYC6OYmtilrR
	 3/pp/7MlcdjfmGlSxsf7hwLln2OKtDDFAaRjCq6X7yNmcOftJj95NxUV7pROxZKsNE
	 TnaR1Lu2l4DNPEj6j6agf2nFy3zoA4C7skQLNq9jq+oRZIlzZnMvveflLTEp26Eqhl
	 i/+dDboWJelEHzZ3gdAqLuHxELDsEqExBEN9Rf6Q/IO5UfCF07lKyHvG4KRqtyur3K
	 divm3KOKb+Zng==
Date: Fri, 13 Nov 2026 20:24:59 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: linux-crypto@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Antonio Quartulli <antonio@mandelbit.com>,
	Martin Willi <martin@strongswan.org>
Subject: Re: [PATCH v2] lib/crypto: x86/chacha: Fix mistakes and
 inconsistencies in comments
Message-ID: <20261114042459.GE2025@sol>
References: <20261113031340.63688-1-ebiggers@kernel.org>
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
In-Reply-To: <20261113031340.63688-1-ebiggers@kernel.org>

On Thu, Nov 12, 2026 at 07:13:40PM -0800, Eric Biggers wrote:
> Fix various mistakes in comments, many probably originating from
> copy+pasting: incorrect block ranges, duplicate words, and stray text.
> 
> Also make chacha_1to4blocks_ssse3() refer to the state matrix using flat
> indexing, like the equivalent AVX2 and AVX512 functions.  It was the
> only place using 2D row-column indexing of the state matrix.
> 
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> v2: Fixed another inconsistency pointed out by Antonio
> 
>  lib/crypto/x86/chacha-avx2-x86_64.S   | 12 ++++-----
>  lib/crypto/x86/chacha-avx512-x86_64.S | 10 ++++----
>  lib/crypto/x86/chacha-ssse3-x86_64.S  | 36 +++++++++++++--------------
>  3 files changed, 29 insertions(+), 29 deletions(-)

Applied to https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git/log/?h=libcrypto-next

- Eric
