Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA674343E7
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 13:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786455791; cv=none; b=PE51Qigl51enaqRsoHywXYqtpyEtd3b70BaZJPSferBAJmWp9ussgR4x7iBUo3x4dAF51JCxJ7KPuFsIYf1TKsQRgTLjLekrBMnZa1/6lC2j1HjZvLsu2uQCF2ET77tu1YLtP8N8/97N8icThRdpk/jEXyJlAOoG8CQ0g13vlo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786455791; c=relaxed/simple;
	bh=sqHqnQEgb2eopnRchvARr5TfEBtuEQo7ezPtINDXkqg=;
	h=From:In-Reply-To:MIME-Version:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m19gYxkIkYzi/I07Vd9dj1n29RzQ/rBrL5PooA3KUAxctwV1r5h5ec3EnZ1USm+06TypflFUVRM8rH8v6UNecH+q0lPCTj1zXlmoW556lxfERpfGtmvJRIKIfsIoRB+5NcChLt2SjL6ktn7JlHWcsbPdUZ7glheAo2OgcRRtAi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BpB9+IN2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BpB9+IN2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D4AA1F00A3D
	for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 13:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786455779;
	bh=oGL2ON+fY7rc/DLjrgmdVLzgpG4X0fa0OqzQfBqPl78=;
	h=From:In-Reply-To:References:Date:Subject:To:Cc;
	b=BpB9+IN2EktpZlwbaW/abyZTkq3FyAM1VgonyxsDOF6/vWRs3SHfwfjNAt8bK2Ta/
	 IMqyeeJkKJw79rmkLM24A6nq+dpmQVF6hBzb9uqB3sXItxVseBCc7syz6av+nlFi+y
	 +RNQnHhjD9yPsFEFMaJtwDCqS3uJ24sBLX+u8oX70nZ16PuWElWsqnqZj1nuXqL/tT
	 fLIrV0nivVzPGe1affq32ALi59n4ep3U5sNuhd2vdFQCALX0yWMCfB9n17/eOWNCRV
	 6xt8AT41D1+LZ86/COb6h/Ou9kn7E36EscZdprREsX9YQSEJ0uTjAG1B5+QVA3wExf
	 vf6cXn4X7iq6g==
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-39c86945164so24612041fa.1
        for <linux-crypto@vger.kernel.org>; Tue, 11 Aug 2026 06:42:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rpah6fXL8spK2UrcySlhQxS2B50giDzTo/5AxiBFfypo8iYplalrgSJikD2wptukfXrl9AXSPZawAlfPNA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwCHUHUdEOn221QekAXbZXFxYZOawlsOucLb6S0DLFPPeTHauJU
	pg7WuwxSXZhT6mteIvTwALhjwUen2iD634j6s1BZujo4Y0VQdH3ub4AJcG4OKibkc81poY2EZxv
	D6y4QV/iBkkzOZdLHVFwUkkQAVCdslcpumu9yAeNhoA==
X-Received: by 2002:ac2:4c4a:0:b0:5b2:b004:ab9d with SMTP id
 2adb3069b0e04-5b448633cccmr554909e87.34.1786455777968; Tue, 11 Aug 2026
 06:42:57 -0700 (PDT)
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 11 Aug 2026 08:42:55 -0500
Received: from 969154062570 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 11 Aug 2026 08:42:55 -0500
From: Bartosz Golaszewski <brgl@kernel.org>
In-Reply-To: <20260801171242.GA3567@quark>
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260731050838.158825-1-ebiggers@kernel.org> <a28c2903-0976-4559-b870-4de5553ba9ab@kernel.org>
 <3ba57269-3305-4d80-b3f2-aa82fa59b59d@gmail.com> <b9b655a9-c683-4c4e-ba0d-f98577dd2912@kernel.org>
 <20260801162900.GA2021@quark> <e7aeec9b-11aa-4635-bde9-fb8c7ca38260@kernel.org>
 <20260801171242.GA3567@quark>
Date: Tue, 11 Aug 2026 08:42:55 -0500
X-Gmail-Original-Message-ID: <CAMRc=McL5QQRk8C8zzkHm+FUj-SAVi5PLJr2pXo8eNpaxXuALg@mail.gmail.com>
X-Gm-Features: AUfX_mxPZ9dCN1jSvjbQwqq_cAREJeltmA9cJmtfDea-v8VxD3gCP4H0x5h0r80
Message-ID: <CAMRc=McL5QQRk8C8zzkHm+FUj-SAVi5PLJr2pXo8eNpaxXuALg@mail.gmail.com>
Subject: Re: [PATCH] crypto: qce - Replace with stub driver
To: Eric Biggers <ebiggers@kernel.org>
Cc: Demi Marie Obenour <demiobenour@gmail.com>, linux-crypto@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, linux-arm-msm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Bartosz Golaszewski <brgl@kernel.org>, Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>, 
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>, 
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Krzysztof Kozlowski <krzk@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sat, 1 Aug 2026 19:12:42 +0200, Eric Biggers <ebiggers@kernel.org> said:

> Well, that again brings us back to the core issue which is the actual
> current functionality of the driver, which is to register crypto_ahash,
> crypto_skcipher, and crypto_aead algorithms with the crypto API.
>
> It isn't useful functionality, but rather just a footgun that allows
> users to misconfigure their systems, an issue I've seen happen multiple
> times.  CPU-based implementations of *every one* of those algorithms
> already exist.  On a typical SoC that has this hardware, the CPU-based
> implementations are ~50x faster as shown in tests.  Pending patches make
> the difference even greater at ~100x.  And the CPU-based implementations
> actually use significantly less CPU time, as well.  There seems to be no
> path forward for significantly fixing this issue, either.
>

You've repeated your point about performance several times. Nobody ever said
you're wrong. Performance is not the only reason for choosing one provider over
another.

> An alternative we could consider is dropping the cra_priority further,
> to further decrease the chance that these algorithms are used.  But I
> feel it's hard to justify why they're there at all, if the rationale for
> keeping them is "we made sure that no one can actually use them, so they
> can't be causing problems anymore"...
>

No, the rationale has never been this. FWIW it can be that it's used for
testing of the crypto module on a supported platform and that is already
enough of a reason to keep it upstream.

As I've said before: we don't just drop maintained drivers from linux.

Herbert: it's been a while, would you mind chiming in and deciding one way
or the other, as Greg seems to have deferred to your judgement?

Thanks,
Bartosz
