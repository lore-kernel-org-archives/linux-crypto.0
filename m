Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DA4215480
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 07:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="i2m+v7vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9F78C433C8
	for <linux-crypto@vger.kernel.org>; Fri,  1 Dec 2023 07:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701416454;
	bh=Rw7nFfQiCBEtnhl7FPkpleDWigkG1bpMwSrllfJU6gI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=i2m+v7vuR7DizMvJjcZXAFWV9Lq15vAw1y85oYSrhpD1csDSfCHoW5PqyJKbES0QZ
	 A+cZsj1sjrPm53EfZzQtei0IleenOCZ1XkC30j9lMA/R8ibpYPeWFpvbpB0NKs3g7f
	 R07CcyJzq2GzdOmYg9QqutaNqYwfsBnsQnHTFsF3vpp61sYGa01woF7juUFPpS7OsO
	 6Q+RC/M223/Pud7mRfF23VTSupb/B+z62XFc2DPwHoLpLrHwluGMfM1a83vpJluEsy
	 E3wGGTRN7K3ZdDXEpXNdgSzWTGiXSjRgO004WkwKef2a1VFzdRDBAavRo4nlbffvYE
	 HBWXTIQ1hpZFw==
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2c9c1e39defso22637621fa.1
        for <linux-crypto@vger.kernel.org>; Thu, 30 Nov 2023 23:40:54 -0800 (PST)
X-Gm-Message-State: AOJu0YzIk1T6sDYES9f4cQZ5dpMg77o94NJDUvdERSSpOQ5BPVVeX4Qz
	62LXoHY/V4C+l/2qDH93j58hvFMzntl52bBa7Uc=
X-Google-Smtp-Source: AGHT+IHDxy1EGUcBJ132ZTeYHPkmF2qTJxhnlGuXXjVRhysn27acAGZ44fA20XZi1zuYSfRar6xI+FECtXf0OB9stc8=
X-Received: by 2002:a2e:9b8d:0:b0:2c9:cc3b:b1fb with SMTP id
 z13-20020a2e9b8d000000b002c9cc3bb1fbmr528331lji.26.1701416452987; Thu, 30 Nov
 2023 23:40:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
In-Reply-To: <ZWh/nV+g46zhURa9@gondor.apana.org.au>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 1 Dec 2023 08:40:41 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHMSgBtcmYJ-z8uhttJd6v4ZrZd=W30zUdY2OWk-NvcLQ@mail.gmail.com>
Message-ID: <CAMj1kXHMSgBtcmYJ-z8uhttJd6v4ZrZd=W30zUdY2OWk-NvcLQ@mail.gmail.com>
Subject: Re: [PATCH 0/19] crypto: Remove cfb and ofb
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 30 Nov 2023 at 13:27, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This patch series removes the unused algorithms cfb and ofb.  The
> rule for kernel crypto algorithms is that there must be at least
> one in-kernel user.  CFB used to have a user but it has now gone
> away.  OFB never had any user.
>
> Herbert Xu (19):
>   crypto: arm64/sm4 - Remove cfb(sm4)
>   crypto: x86/sm4 - Remove cfb(sm4)
>   crypto: crypto4xx - Remove cfb and ofb
>   crypto: aspeed - Remove cfb and ofb
>   crypto: atmel - Remove cfb and ofb
>   crypto: cpt - Remove cfb
>   crypto: nitrox - Remove cfb
>   crypto: ccp - Remove cfb and ofb
>   crypto: hifn_795x - Remove cfb and ofb
>   crypto: hisilicon/sec2 - Remove cfb and ofb
>   crypto: safexcel - Remove cfb and ofb
>   crypto: octeontx - Remove cfb
>   crypto: n2 - Remove cfb
>   crypto: starfive - Remove cfb and ofb
>   crypto: bcm - Remove ofb
>   crypto: ccree - Remove ofb
>   crypto: tcrypt - Remove cfb and ofb
>   crypto: testmgr - Remove cfb and ofb
>   crypto: cfb,ofb - Remove cfb and ofb
>

Good riddance.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
