Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C1F5208BD
	for <linux-crypto@vger.kernel.org>; Wed, 30 Sep 2026 21:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790804680; cv=none; b=QYeBBGf2jDlhetpDupFZQxHj0lQF/oCxyKIBg2hwF09Pl5zrfq8hPx69wFuiCEdOROU2L2K2kTFP9/0ybMlBCLSzN1iFgplgKBK6MJEp3GtsEal5DQJEh8LLQW1TgifNeBcS7SFW85YWuY6rSEyFpttviZ6wBEB71HRNkz4xrKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790804680; c=relaxed/simple;
	bh=x75/A4gCqzcZrGvIrjJ+sqJbv94Ey0wVQQ18KutMg1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LcwtDobVnw0NvBEguq+LJ+FBpyKmBHzwryvjRPQebAiAmjt3F2fj6ZIYHkyWn9eiDsiHzxfOA/VgY7SPsLQi7Ha7TZ+RtsOa5JRGYMw8dH1RXKl8ltYmQMFviaV7rxkJMEPX0cpKfLS5I+KLW1b6Rgx99BdYq2Ud5G95T6qlCek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MABWld2w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MABWld2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4BE1F008A0
	for <linux-crypto@vger.kernel.org>; Wed, 30 Sep 2026 21:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790804679;
	bh=x75/A4gCqzcZrGvIrjJ+sqJbv94Ey0wVQQ18KutMg1I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MABWld2wIzPLvtaI5dmjY6APKTlFRidOZdEFdKyrd8ZtXE5pUM46eY9a8s0c4yDOr
	 ov6KOwIYvxpwGb2i5+DN3bV5vXfuugYtilfrc79ZZG5DoWo0ji7nCaVoHayGlaOukM
	 i55YgFzDi3G4eDaoCxpxoKU5FjuGpmRyr8oyOeErck0yM7+gmUjypzWnPqor9BagWN
	 16QTnwYcI0px3ytzs67ROrJvjVSwWaF3dt7x+XPWQUsZxYIn+h84FDcOb3djn+vZBg
	 0c2QPNHkcY+jvQVVGeasvlXib/pibESD/Q3Ikr2CLTcQPiSCVzVTjjE9sKklCKwSFi
	 v+KjKMnKaZf6A==
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5ba379d8804so1890917e87.3
        for <linux-crypto@vger.kernel.org>; Wed, 30 Sep 2026 14:44:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBz3YJfbxXt7ZVoGZ90VBrbdYwZRYuWdik2LJF2BPRmJfW8IvGdzSFg2GDfNdcuwIK9ayiNuTt2Rhg2gdv0=@vger.kernel.org
X-Gm-Message-State: AFq9FYIABqX4B7nnF6AsHFTqt/23dQV2Bkr89xkihgdY8S3YtHoQumWp
	y4yQQQvWu4YaFNGXU3QzhCm9tiEEn/5rY7UxcCUnP7D2JA7qHqWIxnhFLIxtkbgaexO7SB5t6S5
	AihIQuIRLrevqk5eDgjriaGhfpMM8pfE=
X-Received: by 2002:a05:6512:3e0d:b0:5ad:5c4a:8221 with SMTP id
 2adb3069b0e04-5ba4026960amr1187056e87.0.1790804678165; Wed, 30 Sep 2026
 14:44:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260922031954.320895-1-phucduc.bui@gmail.com> <20260922031954.320895-4-phucduc.bui@gmail.com>
In-Reply-To: <20260922031954.320895-4-phucduc.bui@gmail.com>
From: Linus Walleij <linusw@kernel.org>
Date: Wed, 30 Sep 2026 23:44:25 +0200
X-Gmail-Original-Message-ID: <CAD++jLmE+Hjiv7UahoPXTXHD1KdYmeHLMhSybTt=3rHxSjC2LA@mail.gmail.com>
X-Gm-Features: AclHuK_ndMT7hGc647CUvfJALH_COJ36nJJO_gqn7uNKeHTlIiNYpO8FKvA5GLg
Message-ID: <CAD++jLmE+Hjiv7UahoPXTXHD1KdYmeHLMhSybTt=3rHxSjC2LA@mail.gmail.com>
Subject: Re: [PATCH 3/3] crypto: sl3516 - Use pm_runtime_resume_and_get()
To: phucduc.bui@gmail.com
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	davem@davemloft.net, Chen-Yu Tsai <wens@kernel.org>, 
	Jernej Skrabec <jernej.skrabec@gmail.com>, Samuel Holland <samuel@sholland.org>, 
	Gilad Ben-Yossef <gilad@benyossef.com>, Hans Ulli Kroll <ulli.kroll@googlemail.com>, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-sunxi@lists.linux.dev, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 22, 2026 at 5:20=E2=80=AFAM <phucduc.bui@gmail.com> wrote:

> From: bui duc phuc <phucduc.bui@gmail.com>
>
> Replace the open-coded pm_runtime_get_sync() + pm_runtime_put_noidle()
> error handling pattern with pm_runtime_resume_and_get(), which already
> does this internally.
>
> No functional change.
>
> Found by manual code inspection.
>
> Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>

Reviewed-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij
