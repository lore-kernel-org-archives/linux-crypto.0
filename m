Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E40AB4EA396
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 13:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788788644; cv=none; b=oxqAEx3MuGruLxxKKdhIuUcO9yDmzmCHlpt/0XdPBzKPBLeKy/7SuwMvJoCde6zCEKywDTU94z/o6M6M/iQXSu6Zg0geylIuQrRrcPV0ClHG7FisLcI0ZDjvYouc98pHuTkwqAgcfLygWwYMY8AxMIBd4HAfTndi3doi4ao13wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788788644; c=relaxed/simple;
	bh=ql744/WYUtoTkdt+sI2NI1Ib8lTKbZVorqwmJnFkaxk=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bX+VSobIbE2HZH31jI/ZPYVi5iH9iWo43fpiEL+DP6SPgkx8UyANY8eakQ22zCh6HP7mryDHc1iscb1JzkpAUgTqYngRUArOVh94r/F9G9zp765dS7jhm4VLHaf5sSbDJ5BXU/hI69H80Sk36SNQ+EgxEhy5smtA2IsqWYbehXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LIdB0hPr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LIdB0hPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE0781F00A3A
	for <linux-crypto@vger.kernel.org>; Mon,  7 Sep 2026 13:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788788636;
	bh=gS5KVI+4yQZf58FrqRaCjURnmXDn+UkPbYquQY74jXw=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=LIdB0hPr/C2wJVMOt5nJQYb9K60zCLRIDqqYKVE+No36zAB/v9XrWuRwWGHvj9KoG
	 Qmi+GA7d7b+c6nSxD7xdfc3BVs9f/ktXO6w/dH5tNCARrP6z6kLyZ1R8kTgS1ldJob
	 u7nBMgtUiRrP9SvnbI83Ugt+KrCZ3Z98LV0pb9/7x1O5D351Dj/rsekNRbYL9JAqSj
	 tDZ2c/Q+xmnlRrPxm57qWdqNoYWebuWtuDds1cpyb2t0UvEJuUnWObxrgJ/jXNgcxF
	 7iTLaXmiP9p1xD1OU75wU7Vh4BEN54MLWGVMvOuSe+HpHnzinhWsuJbyVzigw93s2h
	 8/EaP+21XjR4A==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-5b5f21afe8cso5548186e87.1
        for <linux-crypto@vger.kernel.org>; Mon, 07 Sep 2026 06:43:56 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByq6H0RgKtqPEc1UiQ4auuPenl0SUhsPPRubfwFaUer+G0H+JKf7lTpKLM/H/FtVpUk4EBgPUZYmdjTJzg=@vger.kernel.org
X-Gm-Message-State: AFuF++mcIB9A1eEO0ZF2HVWKzQ1H0KsIjxU05sUgwinf4tXeS7um0sSz
	qFv4NL0vpkG7CFac6NTr5nTgjF55kDNDH9TbHqb5Bz22b0VAELD90STvyiq5rhzX7fvTcQZ79Wt
	kFJVZPSFRNd1c75Bue0jDhyCAvQCi7Ec5e0Ni2fl6qQ==
X-Received: by 2002:a05:6512:3f20:b0:5b6:10bc:dc4a with SMTP id
 2adb3069b0e04-5b610bcdda5mr4154057e87.33.1788788635406; Mon, 07 Sep 2026
 06:43:55 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 7 Sep 2026 06:43:53 -0700
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 7 Sep 2026 06:43:53 -0700
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260904114345.27509-1-hemanth.selam@gmail.com>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260904114345.27509-1-hemanth.selam@gmail.com>
Date: Mon, 7 Sep 2026 06:43:53 -0700
X-Gmail-Original-Message-ID: <CAMRc=McXzTWFc2KCoKoiXrjfJJC3e6ZRD67cRpBM1xR-GbzxOw@mail.gmail.com>
X-Gm-Features: AcwNN1WNfEGXDsyeIgZ-XbB4z1C5oh_dNjOjXAIjSW9W2zVJYyiLOhmf6dkuuZs
Message-ID: <CAMRc=McXzTWFc2KCoKoiXrjfJJC3e6ZRD67cRpBM1xR-GbzxOw@mail.gmail.com>
Subject: Re: [PATCH] crypto: fix typos in comments
To: Hemanth Selam <hemanth.selam@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org, 
	linux-samsung-soc@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Nicolas Ferre <nicolas.ferre@microchip.com>, 
	Alexandre Belloni <alexandre.belloni@bootlin.com>, Claudiu Beznea <claudiu.beznea@tuxon.dev>, 
	George Cherian <gcherian@marvell.com>, Tom Lendacky <thomas.lendacky@amd.com>, 
	John Allen <john.allen@amd.com>, Gilad Ben-Yossef <gilad@benyossef.com>, 
	Ayush Sawal <ayush.sawal@chelsio.com>, Srujana Challa <schalla@marvell.com>, 
	Bharat Bhushan <bbhushan2@marvell.com>, Bartosz Golaszewski <brgl@kernel.org>, 
	Krzysztof Kozlowski <krzk@kernel.org>, Vladimir Zapolskiy <vz@mleia.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 4 Sep 2026 13:43:39 +0200, Hemanth Selam <hemanth.selam@gmail.com> said:
> Fix typos in comments, reported by scripts/checkpatch.pl using the
> misspelling list in scripts/spelling.txt.  Only touches comments, no code
> changes.
>
> Assisted-by: Cursor:claude-opus-5
> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> ---
>  drivers/crypto/atmel-sha.c                       |  4 ++--
>  drivers/crypto/cavium/cpt/cptpf_main.c           | 12 ++++++------
>  drivers/crypto/cavium/cpt/cptvf_main.c           |  4 ++--
>  drivers/crypto/cavium/cpt/cptvf_mbox.c           |  4 ++--
>  drivers/crypto/cavium/nitrox/nitrox_main.c       |  2 +-
>  drivers/crypto/ccp/ccp-dev.c                     |  2 +-
>  drivers/crypto/ccree/cc_buffer_mgr.c             |  4 ++--
>  drivers/crypto/chelsio/chcr_algo.c               |  2 +-
>  drivers/crypto/hisilicon/sec/sec_algs.c          |  2 +-
>  drivers/crypto/marvell/octeontx/otx_cptvf_mbox.c |  4 ++--
>  drivers/crypto/omap-sham.c                       |  4 ++--
>  drivers/crypto/qce/aead.c                        |  2 +-

For QCE:

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
