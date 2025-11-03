Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 023FE42AA6
	for <linux-crypto@vger.kernel.org>; Mon,  3 Nov 2025 08:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762157736; cv=none; b=f47ZqBt69x2xEjQGNGKv8Kvs88F1yVArXeZ3C/jPCL7+yCuvCavIX2um6oTX5C6AxU00kSMz0FEqkvxaMhOTEwEsv1E71cu2BBO5c+yhO/Gv4a16IU2xvfImAVFaAa46lnbtq8ru5SsZNgTjlcNM10adv9FTvXzI3cGvfJiHDzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762157736; c=relaxed/simple;
	bh=Mla/J/chdCgtqBXoWskoS0eR4Lu3pJ8L8PpXPuXKUAo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LoDscnyoqlMV0lLU7khKUWlN7xv8y25MyUt1Uw1s3bRNv+9QwLdCRBS8JPiLu3dB4JY+2mDWdyPtsYII3BoBt7I1KlnFabsXws5hyCyM0gnIMEWw7JGiTOsWiddbJDH8H9+tuf9JXTYB7cxW5kT2/X2AX4JCK9OM6rrWCeun+pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hyq/FHbD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hyq/FHbD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E67C4CEE7
	for <linux-crypto@vger.kernel.org>; Mon,  3 Nov 2025 08:15:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762157735;
	bh=Mla/J/chdCgtqBXoWskoS0eR4Lu3pJ8L8PpXPuXKUAo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hyq/FHbDadgatX/J38DIQARmzbpA9qAjfQ4aklW/kO2ELiv3Pm6OmhXnYN0LgPBpI
	 urkzxfKCcvBSIOHptbOsnGk3qok0eMCSKP2UqydFs6scpTv7sqAcbNPs30w8i/b1S4
	 qQMRH7kfaYi52uNOauOkp6gRGZZ9GAsNYlHtSqTD3GBcFG8tbRPAQAxi/yuyIIXA7p
	 ABQcAuo+/Hih1FtSCtp/egXsHsmDfIASkcVt1Waa9tt3hXhu+zlcj+lmolPz3pwpQJ
	 nAiNUS5noiM7YJU7FmQ8JMeokqD9WD/yMxNHCxFfwYa5WjRIuK10IWxeP2qETp/FG/
	 kmBIBNChml37A==
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-362acd22c78so36355031fa.2
        for <linux-crypto@vger.kernel.org>; Mon, 03 Nov 2025 00:15:35 -0800 (PST)
X-Gm-Message-State: AOJu0YzaPT5xnKsdYhItxzBsAj+Df4xB5kBPtMo1kHO+b/wqMVl8LiwC
	aeKVAGRbPmbMVWNfycCweKy5R5il1lH/bg1LdYJ7C/GUoamk6+77wh+R98DMgHRt5d/mNLo9sDS
	1Jy9CRwF4y56WdYo0aQvSpQTEWr2KP24=
X-Google-Smtp-Source: AGHT+IEfO3ylN4Kk4vUWfU8FjXxoj0c8y4TB6yHta1iNXxJc7ljw4i/a4pKQ6cvFFBu9mfYuu/+SG/UIv+zmq2O0Rz0=
X-Received: by 2002:a2e:be27:0:b0:37a:2b3d:12cc with SMTP id
 38308e7fff4ca-37a2b3d178fmr21158401fa.44.1762157734001; Mon, 03 Nov 2025
 00:15:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251102014809.170713-1-ebiggers@kernel.org>
In-Reply-To: <20251102014809.170713-1-ebiggers@kernel.org>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Mon, 3 Nov 2025 09:15:22 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHj9mcJsQHNUgJtn_X6iZsTRz11fBupjOzxBR-E2k_4WQ@mail.gmail.com>
X-Gm-Features: AWmQ_bnrKErTARYe3t3bURcaDZIHGYVBV7t9uRNS0-kf9krlgf-_r1StGaNUIvQ
Message-ID: <CAMj1kXHj9mcJsQHNUgJtn_X6iZsTRz11fBupjOzxBR-E2k_4WQ@mail.gmail.com>
Subject: Re: [PATCH] lib/crypto: arm, arm64: Drop filenames from file comments
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2 Nov 2025 at 02:48, Eric Biggers <ebiggers@kernel.org> wrote:
>
> Remove self-references to filenames from assembly files in
> lib/crypto/arm/ and lib/crypto/arm64/.  This follows the recommended
> practice and eliminates an outdated reference to sha2-ce-core.S.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>
> This patch is targeting libcrypto-next
>
>  lib/crypto/arm/sha1-armv7-neon.S  | 2 +-
>  lib/crypto/arm/sha1-ce-core.S     | 2 +-
>  lib/crypto/arm/sha256-ce.S        | 2 +-
>  lib/crypto/arm64/sha1-ce-core.S   | 2 +-
>  lib/crypto/arm64/sha256-ce.S      | 2 +-
>  lib/crypto/arm64/sha512-ce-core.S | 2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>

> diff --git a/lib/crypto/arm/sha1-armv7-neon.S b/lib/crypto/arm/sha1-armv7=
-neon.S
> index 6edba3ab62e8..a0323fa5c58a 100644
> --- a/lib/crypto/arm/sha1-armv7-neon.S
> +++ b/lib/crypto/arm/sha1-armv7-neon.S
> @@ -1,7 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0-or-later */
> -/* sha1-armv7-neon.S - ARM/NEON accelerated SHA-1 transform function
> +/* ARM/NEON accelerated SHA-1 transform function
>   *
>   * Copyright =C2=A9 2013-2014 Jussi Kivilinna <jussi.kivilinna@iki.fi>
>   */
>
>  #include <linux/linkage.h>
> diff --git a/lib/crypto/arm/sha1-ce-core.S b/lib/crypto/arm/sha1-ce-core.=
S
> index 2de40dd25e47..7d6b2631ca8d 100644
> --- a/lib/crypto/arm/sha1-ce-core.S
> +++ b/lib/crypto/arm/sha1-ce-core.S
> @@ -1,8 +1,8 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
>  /*
> - * sha1-ce-core.S - SHA-1 secure hash using ARMv8 Crypto Extensions
> + * SHA-1 secure hash using ARMv8 Crypto Extensions
>   *
>   * Copyright (C) 2015 Linaro Ltd.
>   * Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>   */
>
> diff --git a/lib/crypto/arm/sha256-ce.S b/lib/crypto/arm/sha256-ce.S
> index 7481ac8e6c0d..144ee805f64a 100644
> --- a/lib/crypto/arm/sha256-ce.S
> +++ b/lib/crypto/arm/sha256-ce.S
> @@ -1,8 +1,8 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
>  /*
> - * sha256-ce.S - SHA-224/256 secure hash using ARMv8 Crypto Extensions
> + * SHA-224/256 secure hash using ARMv8 Crypto Extensions
>   *
>   * Copyright (C) 2015 Linaro Ltd.
>   * Author: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>   */
>
> diff --git a/lib/crypto/arm64/sha1-ce-core.S b/lib/crypto/arm64/sha1-ce-c=
ore.S
> index 21efbbafd7d6..8fbd4767f0f0 100644
> --- a/lib/crypto/arm64/sha1-ce-core.S
> +++ b/lib/crypto/arm64/sha1-ce-core.S
> @@ -1,8 +1,8 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
>  /*
> - * sha1-ce-core.S - SHA-1 secure hash using ARMv8 Crypto Extensions
> + * SHA-1 secure hash using ARMv8 Crypto Extensions
>   *
>   * Copyright (C) 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
>   */
>
>  #include <linux/linkage.h>
> diff --git a/lib/crypto/arm64/sha256-ce.S b/lib/crypto/arm64/sha256-ce.S
> index 410174ba5237..e4bfe42a61a9 100644
> --- a/lib/crypto/arm64/sha256-ce.S
> +++ b/lib/crypto/arm64/sha256-ce.S
> @@ -1,8 +1,8 @@
>  /* SPDX-License-Identifier: GPL-2.0-only */
>  /*
> - * sha2-ce-core.S - core SHA-224/SHA-256 transform using v8 Crypto Exten=
sions
> + * Core SHA-224/SHA-256 transform using v8 Crypto Extensions
>   *
>   * Copyright (C) 2014 Linaro Ltd <ard.biesheuvel@linaro.org>
>   */
>
>  #include <linux/linkage.h>
> diff --git a/lib/crypto/arm64/sha512-ce-core.S b/lib/crypto/arm64/sha512-=
ce-core.S
> index 22f1ded89bc8..ffd51acfd1ee 100644
> --- a/lib/crypto/arm64/sha512-ce-core.S
> +++ b/lib/crypto/arm64/sha512-ce-core.S
> @@ -1,8 +1,8 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  /*
> - * sha512-ce-core.S - core SHA-384/SHA-512 transform using v8 Crypto Ext=
ensions
> + * Core SHA-384/SHA-512 transform using v8 Crypto Extensions
>   *
>   * Copyright (C) 2018 Linaro Ltd <ard.biesheuvel@linaro.org>
>   *
>   * This program is free software; you can redistribute it and/or modify
>   * it under the terms of the GNU General Public License version 2 as
>
> base-commit: 5a2a5e62a5216ba05d4481cf90d915f4de0bfde9
> --
> 2.51.2
>
