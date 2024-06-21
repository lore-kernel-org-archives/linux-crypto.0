Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66452232B;
	Fri, 21 Jun 2024 14:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718980660; cv=none; b=DSTlVvp/rm5YY0SwP/QYl8jNORq0zpEsfEWXSHowqr+4nshjuRFbdeaUwfzzh3l1RaQHfzVkKhDsLmU8jT/dFljI8x9l+AWALUokCnrs8y7o8EcmOngsWv68kFP6LviGq3zjd6Jq5SQocQgn5h336+6tx9RB8Ij9MiwUwqC9WCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718980660; c=relaxed/simple;
	bh=ejMsu1bb2eGEnL9goJV3n78NDDkQX2G7CVwsyRVBo4k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S/1ZWw34ikFPVWcOn622OP0GlDYkBPTwWqGZ4WPxua5TL1vipzKigdmiywH1lhlfn3ft58uMvH/jiTru5Rws87JOhPlJ5VL2fElyUp4bQAe2Cw9fyoS7enD+uSv8lPD4fNTy00jJJ0YuaWqoFxYSXSfrpQzVa3LPvuYM/aJDjIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.208.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-2eaae2a6dc1so39147531fa.0;
        Fri, 21 Jun 2024 07:37:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718980655; x=1719585455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ejMsu1bb2eGEnL9goJV3n78NDDkQX2G7CVwsyRVBo4k=;
        b=YcP5bI3JIUFvs1uMsm2OeIPbe5v58sE89KIVThALwsg406yybosC7XV8FnZ2ehpjj6
         SSmG5lc8nVtGEkSRrrVS8MUxoAcyvcxqFMwoIBBbhasPs0p7rwouqNcZhgY1ooTQyWPw
         +D/FwDm+tQ+Ok+uyxRSG5kfRzyeMViWZfMyWD5Hsxp2UoFae56FLMdj5MxCbkbPaSyGu
         WHSjrB8nB6B4SlvyZXU8f2FHeuFkaq1Ie1jVi/bLmwwahSOnzA0cdtrhhEzPlVOEPBuG
         sUc4paDvU+CzksGF+sDmkkCk6MOKEi6LZ34jTplUEZ9vlh9CG/58/SmRgrOQkS3qJr9S
         AI7w==
X-Forwarded-Encrypted: i=1; AJvYcCUYK4Wal5D8afxYXIgtUz4RowyKHordBM4OmX8dViIDuuIa0vTGtcze1RKl7Lng79pgtJ/6nch5UWTmNJIV4wECuOZ7mTTdxtM1P6gLK8HB02M4AuNsYDRiH1ZN5GE4/deE7dhlqxb4tA==
X-Gm-Message-State: AOJu0Yw9z+rOkArq2ds0iMRrGbn7htWco0Mp+3YSRL8NykvqXDhpwwTI
	Vc7Z4ajSZT6tF/bkUHEKbcclok3WBRR0BRI/P7JjQMx88bBwKx3kauh+UP4V
X-Google-Smtp-Source: AGHT+IF1rX81EhoxmN2x+YZygjI6p408k58V0LS3KQFvZd7c9Vkoaz3dyBbzx5pjq7pQklTHNKlujg==
X-Received: by 2002:a2e:8955:0:b0:2ec:5200:a93d with SMTP id 38308e7fff4ca-2ec5200aa16mr7547091fa.23.1718980654620;
        Fri, 21 Jun 2024 07:37:34 -0700 (PDT)
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com. [209.85.208.169])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-2ec511dac51sm912611fa.74.2024.06.21.07.37.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jun 2024 07:37:34 -0700 (PDT)
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2eaea28868dso27763031fa.3;
        Fri, 21 Jun 2024 07:37:34 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXbg7MSeLwQwC0u4kfF9m/OlzhNXhvnR3GTFwxo8TeF6WtRwZ1dV0o0FyXYei3KO//7XGh7HFG0c+AkVe7XaSDU9S5oQGjGLVItinW12/YOHpdzeadqP/w0mb/x/YoziX0RjzJ9Ia/sYA==
X-Received: by 2002:a05:651c:1a0b:b0:2ec:4093:ec7 with SMTP id
 38308e7fff4ca-2ec40931047mr73651401fa.30.1718980654160; Fri, 21 Jun 2024
 07:37:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240616220719.26641-1-andre.przywara@arm.com> <20240616220719.26641-2-andre.przywara@arm.com>
In-Reply-To: <20240616220719.26641-2-andre.przywara@arm.com>
Reply-To: wens@csie.org
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 21 Jun 2024 22:37:21 +0800
X-Gmail-Original-Message-ID: <CAGb2v66t88ER-D71hrJ6pqybjHiYrHE8gnHHxpX11sa5H_F7bA@mail.gmail.com>
Message-ID: <CAGb2v66t88ER-D71hrJ6pqybjHiYrHE8gnHHxpX11sa5H_F7bA@mail.gmail.com>
Subject: Re: [PATCH 1/4] dt-bindings: crypto: sun8i-ce: Add compatible for H616
To: Andre Przywara <andre.przywara@arm.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Jernej Skrabec <jernej.skrabec@gmail.com>, 
	Samuel Holland <samuel@sholland.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev, 
	devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2024 at 6:08=E2=80=AFAM Andre Przywara <andre.przywara@arm.=
com> wrote:
>
> The Allwinner H616 has a crypto engine very similar to the one in the
> H6, although all addresses in the DMA descriptors are shifted by 2 bits,
> to accommodate for the larger physical address space. That makes it
> incompatible to the H6 variant, and thus requires a new compatible
> string. Clock wise it relies on the internal oscillator for the TRNG,
> so needs all four possible clocks specified.
>
> Add the compatible string to the list of recognised names, and add the
> H616 to list of devices requiring all four clocks.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>

Acked-by: Chen-Yu Tsai <wens@csie.org>
