Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3B61A6824
	for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 07:50:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777017035; cv=none; b=gNrJzmc3haAEXONfa8yg6eGqY3fQmGT12vAmy1/xHDh7OMX91V0ngBpN89DGpdpkJc73eRCikdPazEKoW2bnzPMoWPdxE1PAmL3GhGiAKIA0P77yvDVUJVNKabIg0Na8m/QSfTAUA4IdIE8D9oUJRzz0nWSGlIefq6URQq2Wv9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777017035; c=relaxed/simple;
	bh=CNoygD0dv5JfT0nfE4Tj5Dbc6egyC7TCUBRqF/t8Ilk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t+0K2lutP2Os8trHrkxDm6+YgZlntefZ52nEMy5ni4x5uI8+9peiw722iz2FYwemStsbjPa+TwCYFXWRlTq2rX8UrX33n1zpZY/nXDX7JMjfr3US/3FHrm7ho3dt8UgOXPSODpAMzE86Hp46pH7MlDel+AvGDMzgCTeYtZWDYN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TuldJeKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TuldJeKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06457C2BCB5
	for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 07:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777017035;
	bh=CNoygD0dv5JfT0nfE4Tj5Dbc6egyC7TCUBRqF/t8Ilk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TuldJeKdeaItWj2xl8/CEwnIwukeELht3ZfAHclYx6lOlwUx/g519CGLzHHItpNGl
	 ullVSRtf9+R7zUV1Np7bDCTtHodQhkQvy9Kv3h2dC5omUD2sAASbxwdPzrVfiqjjmd
	 lAktCR4k60i39gmih/EjCWXaIud3f9NcQTVCXzPplfRoROl0um2iYuZV4KHoO9HRlc
	 KFfgy1nMP5hKlpNh7gH4rTlLJoMOthQPc7cpfNWmtBc8Va6017z1ZV5iVSulj9vZ/9
	 Mqj3iqGi1aTPFMXRWs9WSwjtirGtS61azOfyjLub8J8X98BKLqpbhVBWud0dD8M6MP
	 rt+pf8jRd1GUQ==
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-5a3cee3a271so7643147e87.3
        for <linux-crypto@vger.kernel.org>; Fri, 24 Apr 2026 00:50:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ86BrDBBFqgdwrz++t2roD5N5Dcvwx5YYqiohwu6ZyPP8cCzxsVKrBIA2So1P+rDR+DRTuYZ2fy8C4XBE4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUJ8Odf7GNoVclcZoC1K93v7K9LJBfIJ7BMcs/IJG8B/q4QYki
	SGw2wAP3tXCnKYWtRyMxfqrtyhH+NmfLI0teuEuKX9JyvNQPCDdpjra03gGHnR3UUSkDN52Smk0
	B8lPixbr+YSKJbmdW25vhY9uMO4ZXvIg=
X-Received: by 2002:a05:6512:3d27:b0:5a2:b3dd:7a74 with SMTP id
 2adb3069b0e04-5a4172e7af6mr11159656e87.33.1777017033724; Fri, 24 Apr 2026
 00:50:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260423111956.185761-1-ruoyuw560@gmail.com>
In-Reply-To: <20260423111956.185761-1-ruoyuw560@gmail.com>
From: Linus Walleij <linusw@kernel.org>
Date: Fri, 24 Apr 2026 09:50:21 +0200
X-Gmail-Original-Message-ID: <CAD++jLkg3L=QJpiBzRR57yohb3LSBXgz1wXXCPcdwdNb=rg_xg@mail.gmail.com>
X-Gm-Features: AQROBzDoZz6qn_4vxmisrCCvKwCV3z7zWOcAxXt_ce1FEO95eQ_iWMXrWqnkSa8
Message-ID: <CAD++jLkg3L=QJpiBzRR57yohb3LSBXgz1wXXCPcdwdNb=rg_xg@mail.gmail.com>
Subject: Re: [PATCH v2] crypto: ixp4xx - fix buffer chain unwind on allocation failure
To: Ruoyu Wang <ruoyuw560@gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Corentin Labbe <clabbe@baylibre.com>, 
	linux-crypto@vger.kernel.org, Imre Kaloz <kaloz@openwrt.org>, 
	"David S . Miller" <davem@davemloft.net>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 23, 2026 at 1:20=E2=80=AFPM Ruoyu Wang <ruoyuw560@gmail.com> wr=
ote:

> chainup_buffers() builds a linked list of buffer descriptors for a
> scatterlist. If dma_pool_alloc() fails while constructing the list, the
> current code sets buf to NULL and later dereferences it unconditionally
> at the end of the function:
>
>   buf->next =3D NULL;
>   buf->phys_next =3D 0;
>
> This can lead to a null-pointer dereference on allocation failure.
>
> If the failure happens after part of the descriptor chain has already
> been allocated and DMA-mapped, the partially constructed chain also
> needs to be released.
>
> Fix this by terminating the partially constructed chain on allocation
> failure and letting the callers unwind it via their existing cleanup
> paths. Also fix ablk_perform() to preserve the hook pointers before
> checking for failure, so partially built chains can be freed correctly.
>
> Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>

Essentially I think Corentin & Herbert are better at reviewing this code
but it sure looks good to me!
Acked-by: Linus Walleij <linusw@kernel.org>

Yours,
Linus Walleij
