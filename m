Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5FC2D9796
	for <linux-crypto@vger.kernel.org>; Mon,  3 Nov 2025 08:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762157786; cv=none; b=KDXreognQ0xMQT+k/0wA6lt3UbUqXJZKm7m5f8KDXl7Bm8P7kRRDPPo6etm9t/xuuz3cxxj84CspP/Q5LWHB5Gd9JvjreOjrs3cxetglwo1I6DbN8koxmKuR7MTu1WWj83fj1Povsswaljku65HusgdTgMxdp5FrMjXxWcSqMZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762157786; c=relaxed/simple;
	bh=c154LS7C223aeWXiB3Ll1avPbtgcFEIhPTiTybi8syM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eKnVKr4u4C6TtiHXKxlxztSm1LQPjHBgzKvIaR4STTdWEeEtFsGRMbgRmJNnUNMnITq1KR/lkf327Hd8xDECmhXmFHiVCibyGe046TBX4Sw29amUQdgJ69V+bcEPdFLz9HddBIFMiFPg4dbDpm9GaZVBVqVp3Zswav6nVyfdX7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sN9y6uap; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sN9y6uap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A0BC4AF09
	for <linux-crypto@vger.kernel.org>; Mon,  3 Nov 2025 08:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762157785;
	bh=c154LS7C223aeWXiB3Ll1avPbtgcFEIhPTiTybi8syM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=sN9y6uapHy4tzZAHcHYrItEVUdGQ6UFg90NAfNAODAM1Fq3MJjJUXDBJmrgpPzEMf
	 pqCnoxaZ60frcHquvMK6C5ppdFQlnjtS/0cDW7Ze8Zxt3CIIZwYcGBvynxqzFmyO1f
	 EghcwtqUHs9vHxtA9iKyxFoZDYrCFmtJjJ2ds4Nx0vqZC+gut3yNQcSdpVp7Q3yJen
	 O3jbysdGWVrWs3xujcQQxzdFRVvEQHhtcU1YAarRcD2wtDfUMXN8DBE6syQF/dz+ho
	 EhMgTpj7cwy0CuAhOwiIwsiHXRUoG0Om7QuXg0qcJDf/VTTjsjExqUrmvvcSKH9k9I
	 iPRq6hqHoAEcw==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-37a38e56dd5so3687991fa.0
        for <linux-crypto@vger.kernel.org>; Mon, 03 Nov 2025 00:16:25 -0800 (PST)
X-Gm-Message-State: AOJu0Yw7zfTsBMKJ+bAL7B9En7fKKY4+01F9iSP4YZhfYjcz71P1ldu7
	tC1XKGAcNLLSFJyUrecZ2uWVpFGHfVrpytYAWeB9rpj72B9iDtpz9GYOewSs64LHgw44jTK5Cq/
	pcs5/WoUYhJfJ4qCvZ8XZG5ozQc8LElU=
X-Google-Smtp-Source: AGHT+IF4ACwkJR8bwJb7M6QwxTxIEvoPGvLDZOprvgt3QSaFTHynE+1LONAwGjdGlx58bOvJItp+XwzJ/15PYothuaQ=
X-Received: by 2002:a2e:be1a:0:b0:37a:3615:89f2 with SMTP id
 38308e7fff4ca-37a36159157mr8317061fa.9.1762157784129; Mon, 03 Nov 2025
 00:16:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251102014541.170188-1-ebiggers@kernel.org> <20251102021553.176587-1-ebiggers@kernel.org>
In-Reply-To: <20251102021553.176587-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 3 Nov 2025 09:16:12 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEGLTgM2njWdNTuGtYE3jETgVwBFYdHk52V-N1oYC6=pQ@mail.gmail.com>
X-Gm-Features: AWmQ_bnEQ-UJpVxlFN-w4khvNkXXvYEeaSS0zddlmSeN1qlxIDjfciglxjhkk_g
Message-ID: <CAMj1kXEGLTgM2njWdNTuGtYE3jETgVwBFYdHk52V-N1oYC6=pQ@mail.gmail.com>
Subject: Re: [PATCH v2] lib/crypto: arm/blake2s: Fix some comments
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"

On Sun, 2 Nov 2025 at 03:16, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Fix the indices in some comments in blake2s-core.S.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> v2: Fixed the same mistake in another place.
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
