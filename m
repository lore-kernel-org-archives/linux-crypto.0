Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C8832B9B6
	for <linux-crypto@vger.kernel.org>; Tue, 16 Jun 2026 07:49:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781596158; cv=none; b=fYQBi7q4WNSNX2Qbuf3Qx5qWZyQ1L4Kg0LqMTqbJqCcgO8bXD10ysfx//WCTkTp2oOQ97DNfiroFZCDP6BVpbWeKDI070LrFuH4BaHdaNNGPzfJdsaiSdv0bo2Z0SZfMW6CK/QKkdouXduNrCEdZ/+IEdEFXp8QXY1L/YQXyQKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781596158; c=relaxed/simple;
	bh=rMzvxrAFf7w9v162EK2aq1CNbTyCn8hNCo1RDuT55PI=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IjdukI8eUCU8kYRXm8e0R8pY0SGCGtHTI0Na0bZK0uK/DWLrqLaLMoZ9Ankb1g+jnKBL0RVFAEyn1dlBTnoogHU849Z2vZryDY0Ie3VUEn6TWGCRzudXiKtkEFPR7urpFU+x0Sd9gQOpsvd5YhKh6Y6nnVv0mV6yUzFEExvhgDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZlCFqkSq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZlCFqkSq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED881F000E9
	for <linux-crypto@vger.kernel.org>; Tue, 16 Jun 2026 07:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781596157;
	bh=rMzvxrAFf7w9v162EK2aq1CNbTyCn8hNCo1RDuT55PI=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=ZlCFqkSq7TfuPcLBSyPVNk8s9rIgjt3q9hhSvpn+68PAVBc1Xw1R+rVKYWTIXNUVk
	 vRm2gqC5L8GGZM81b6LVw2jwsBwAqwhDR+6vrtXpKUYDxV0BZLpRdLl/HIDy8GQ0Er
	 gVKYHPNvLZ7/ytw7QF77Vx47h4ea6KpwEvNBX3/qysY0MlIU1XYceSKhhXO8BsIcci
	 q0u5SoQadRu2o7h4YNU/JNqM35AhbGTdIipSyBYuQqMkVcluqiym/gyUrpdOyI4a67
	 KUCb9W6g4E+1RejGCEUVSuyk+urpeXEGm4VrRd4WWFEXswK/4jZwWt4n0YgEa1WShs
	 8K00p9T8IuSZw==
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-39664fe2dd8so33533041fa.3
        for <linux-crypto@vger.kernel.org>; Tue, 16 Jun 2026 00:49:17 -0700 (PDT)
X-Gm-Message-State: AOJu0YxFyFGxVW/87+f/gVCpmigiV9NimNPmsVgcnGZ68L7fhi7YkkIC
	7OItwGGwrKwu89RPJE0MYBf/qXqRNEDoyV5o7B7NT+k7+BZ7LT9VQq9I1dCOv8mLBa5Df1Br1cn
	OnN4p+eTw93nndeMNtbqFDfk2qbRD0XolOUulSG68LQ==
X-Received: by 2002:a05:651c:98d:b0:396:6a01:a781 with SMTP id
 38308e7fff4ca-3995c86286fmr8713461fa.26.1781596156054; Tue, 16 Jun 2026
 00:49:16 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 16 Jun 2026 00:49:14 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 16 Jun 2026 00:49:14 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260614152605.701754-3-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260614152605.701754-3-thorsten.blum@linux.dev>
Date: Tue, 16 Jun 2026 00:49:14 -0700
X-Gmail-Original-Message-ID: <CAMRc=McqG4oRyB7bc59Qz_i1d9-zXmC4EF+McRCrpR9ivL1hPA@mail.gmail.com>
X-Gm-Features: AVVi8CfGD7DcvTT2XOaw0oxzt3n2WfhHJZDdsXF8EBjBeO6QxY9RX6ENZakEeHY
Message-ID: <CAMRc=McqG4oRyB7bc59Qz_i1d9-zXmC4EF+McRCrpR9ivL1hPA@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce - drop unused scatterlist traversal in qce_ahash_update
To: Thorsten Blum <thorsten.blum@linux.dev>
Cc: linux-crypto@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Bartosz Golaszewski <brgl@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"

On Sun, 14 Jun 2026 17:26:07 +0200, Thorsten Blum
<thorsten.blum@linux.dev> said:
> Commit df12ef60c87b ("crypto: qce/sha - Do not modify scatterlist passed
> along with request") removed the only use of sg_last, rendering the
> scatterlist traversal useless. Remove it and its local variables.
>
> Also remove the redundant hash_later check, inline the source offset,
> and assign the number of complete blocks directly to req->nbytes.
>
> Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
> ---

Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
