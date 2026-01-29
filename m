Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDA31A76DE
	for <linux-crypto@vger.kernel.org>; Thu, 29 Jan 2026 15:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769699809; cv=none; b=TdSaciw84UlhksA5A+cnBibmRw/hy8Sh+dBDA8Ri8k91RHHrSALzCyuO2jWy8ybqHuOuD0DpGB7rRFF2m48h6SH8PEvCcYAZiZbXhU5cV8TajSGf4AY0LT66oadCPzD8qZ5VX2qWxcniC1WCR6CA/iQEF042dolH30Bi8xxIsgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769699809; c=relaxed/simple;
	bh=O1tloW8gfVEMEcBPVggd9EMmWqLpPlFRfEzQCkil1HA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C5qRJuuzMSOnSw1sWcJgSciRkFCX1GcLUl1dIO0xouAvrnqei2jvtqc5scCM0mA1B7orLNFVT9GzC6RvDb/FJVLKhJahkBsvSxpigvN67g2jVi0vmA64nDgpWVsQKsOd2S2sz7rU5h5CI6FbEyMyFWS3A1dzbTRb5Jf/DevY+OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kiS3Pm5I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kiS3Pm5I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D823C19422
	for <linux-crypto@vger.kernel.org>; Thu, 29 Jan 2026 15:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769699809;
	bh=O1tloW8gfVEMEcBPVggd9EMmWqLpPlFRfEzQCkil1HA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=kiS3Pm5IueYJq5TmZqGrS7X7C+cWyG1KdjBU9oiug7eGGcyzr2O934EguWjN3FDjz
	 gat2aSyrK4fKp5K+S6alGJQvo4aL5TDXGkyr1lEbH+drcNwr3BcQLLDTaNNvLcf0Xi
	 Xww/zptlAVq99/UpW7eL3bzwdZjWV+ansPM7JM9JvgnyVm3cmmydMgusNtXysqT+t5
	 i6bfvNdLW5qgYE0+CTzveGSBq6R2JV+1s8L8e1CvVBVR6xtcoFOP/+ee1u8/s4xTaU
	 DCPzLxwKeW7M0TJja1ZFpyoUC/GEnxOwm9VoOjHuipk19xaZAmreQTZDvMVfbO7DbG
	 FOXOUIoDAUB9w==
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b8871718b05so189400066b.2
        for <linux-crypto@vger.kernel.org>; Thu, 29 Jan 2026 07:16:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWRUyi+LRFE24CRrfvuvaNIMIALi+IW+WRBvE24Mp6paOpFZHcw/KmlSbkIKR2LVsm9Gj2byRs/9n4E6X4=@vger.kernel.org
X-Gm-Message-State: AOJu0YzjcspvsSDBQ9Gr9gcoi0NDeR/Zh7Yyu8xbnoqNw6FWct97GEyA
	ADYNoDJdzezEukE+Jm7mU22OIlIqSSTnKG4K5jjd8fpznb0jW9TVnPHt9z9GgG4fPiuHedqceC7
	O+LmDsdF2t9q2kAuc5fnwS8VPVeeZUQ==
X-Received: by 2002:a17:907:940a:b0:b87:65c5:603a with SMTP id
 a640c23a62f3a-b8dab423ef5mr644045466b.39.1769699807795; Thu, 29 Jan 2026
 07:16:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251211-dev-dt-warnings-all-v1-0-21b18b9ada77@codeconstruct.com.au>
 <20251211-dev-dt-warnings-all-v1-5-21b18b9ada77@codeconstruct.com.au>
In-Reply-To: <20251211-dev-dt-warnings-all-v1-5-21b18b9ada77@codeconstruct.com.au>
From: Rob Herring <robh@kernel.org>
Date: Thu, 29 Jan 2026 09:16:35 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJxfVaLqzTwm7iEvc4maBzVvpc-i5uD6CZRtiv+V+7+1Q@mail.gmail.com>
X-Gm-Features: AZwV_QgoP-01T8gPVg_GjRssieKZeDUA4_1M3p-JswAzI-a2M9jAVmrm9uPisdk
Message-ID: <CAL_JsqJxfVaLqzTwm7iEvc4maBzVvpc-i5uD6CZRtiv+V+7+1Q@mail.gmail.com>
Subject: Re: [PATCH RFC 05/16] ARM: dts: aspeed: Remove unspecified LPC host
 controller node
To: Andrew Jeffery <andrew@codeconstruct.com.au>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Linus Walleij <linusw@kernel.org>, Joel Stanley <joel@jms.id.au>, linux-hwmon@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	openbmc@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-iio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2025 at 2:46=E2=80=AFAM Andrew Jeffery
<andrew@codeconstruct.com.au> wrote:
>
> For the AST2500 the node was used for pinctrl purposes, and while the
> hardware capability is also present in the AST2400 and AST2600, the
> their pinctrl no relationship to it. Further, there's no corresponding
> binding, remove the node for now to
> eliminate the warnings.

Odd line break.

>
> Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
> ---
>  arch/arm/boot/dts/aspeed/aspeed-g4.dtsi | 5 -----
>  arch/arm/boot/dts/aspeed/aspeed-g5.dtsi | 6 ------
>  arch/arm/boot/dts/aspeed/aspeed-g6.dtsi | 5 -----
>  3 files changed, 16 deletions(-)

Acked-by: Rob Herring (Arm) <robh@kernel.org>
