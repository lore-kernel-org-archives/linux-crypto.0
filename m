Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E720918645;
	Thu, 27 Jun 2024 17:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719510861; cv=none; b=TJHfNBnjfrDwiO7o0D0QdqtxPxalYRTHCxbSBbtPSCRBFatriFAycSNPz7rjMycgTmJEB6RvSiSSTEqX677Ad0VfCtcG5SDIHsy/l9tjKO3fLNBh/h5OdulERja3RQCJb2EV/X+0xwV5e7xRS5TNR9pzzZU4kCNc7QpwN7Gyxts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719510861; c=relaxed/simple;
	bh=kWAsnel3A5mFApn7lpqazOCEOcFEQnU+u987bPBxcBs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OnlbQayknp5I0+C5emLdWeUdoKPG10IlQzmR8I0FFQXU68dOQ7Ixw4Y3P19ULwBhKNZKboBwMeerAObfhHtM3JxfSft7hwh5NTf6BqLuVwYnR/qEmrFzMHCyGkIlNBx2CXwB9YQTNaXcurS6Ia4jS6xUMa83Y4mspEB7bOCPFes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=csie.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7eee7728b00so301464639f.3;
        Thu, 27 Jun 2024 10:54:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719510855; x=1720115655;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tUDjh8HPRo//13YfMMh5tGFz16cFbmNK3MEKPkttN6E=;
        b=dta15JrwJWU6xxNVUoB9a1fLb3uxcN330HbaS/nR/mhBf4jyIwuFSkWLqdOFkHTJP6
         CniQNbxnRpViR60vwutKCpQKE00o1FQwF/H3H6IWyHbFn4opMD/n2/zNGOHh/SbyQK+9
         IvfEXnhzvcnBD2rGGhmRpvYCVjDo2lLGqSE7jF2VFdQfHc6Wjv1rgl4JmCBh4Xkg+O3k
         /Pk3PYBAwotdHVWTW1uLO+tiM6cSzO7QJNIBWTOzFcVLjPh3UQj4P4Pisn3YVXjW8pn2
         T/0ziJ+EwTi4lwXvkYH9wqAdMQShhFti1XMtcrRehSBIdrdCosrBVCu5SIV3mH3W0g4D
         tetg==
X-Forwarded-Encrypted: i=1; AJvYcCUrEyB6f9Mc5kl3APYC2szcMPhu9g+PmyfBwe3ewlHoTUh47/ARJuiWIEMl0OUW3kIfl+yibwAN1C5as1VRFT6PvboIw3X/hJS7wHlf0mEhF/KvI4iVM70+1GZt7rYyhrYFWtLQoekjpA==
X-Gm-Message-State: AOJu0YxfTuAWPo7okLZ3AKnUZ1j6Y5Pu22kwKXdeE5eKt9Y0lZEbmfqD
	To87kcj4VZyHczG1KpkO8ho2d9ouxkFLcJ6yN88ba8LC5Lz/++fcnb48NgCu6fM=
X-Google-Smtp-Source: AGHT+IHTh21GGYSW3yXrGcelvZqRDXGhtlfEt12UZciiuywurRFpUsLpmiE/krFMsAYME2N0cD8Blw==
X-Received: by 2002:a05:6602:13d4:b0:7eb:85fd:e29d with SMTP id ca18e2360f4ac-7f3a75b301cmr1829277239f.16.1719510855197;
        Thu, 27 Jun 2024 10:54:15 -0700 (PDT)
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com. [209.85.166.47])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4bb73dd7c44sm43760173.69.2024.06.27.10.54.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 27 Jun 2024 10:54:14 -0700 (PDT)
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7f3d3f1294dso77705839f.2;
        Thu, 27 Jun 2024 10:54:14 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVqLcIrkEpLqYktK366ELQT1dLJMEiYQt8nu1XP9yfRVRy0nVd0he/UoF8E994bqCKDgWxd3/XctRoaDdykhXr7N3R512kTRyZUV+txphm6xNFnZE4xc5GDB0076GKeBN/Tspp+BsJoBw==
X-Received: by 2002:a05:6602:6d8c:b0:7eb:c7ff:26e6 with SMTP id
 ca18e2360f4ac-7f3a75b3440mr1645762339f.15.1719510854318; Thu, 27 Jun 2024
 10:54:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240624232110.9817-1-andre.przywara@arm.com> <20240624232110.9817-5-andre.przywara@arm.com>
In-Reply-To: <20240624232110.9817-5-andre.przywara@arm.com>
Reply-To: wens@csie.org
From: Chen-Yu Tsai <wens@csie.org>
Date: Fri, 28 Jun 2024 01:54:00 +0800
X-Gmail-Original-Message-ID: <CAGb2v67qo7qgf2uzBAUf9-C9NHrHG47mLc579NRkTO7qLDtV7Q@mail.gmail.com>
Message-ID: <CAGb2v67qo7qgf2uzBAUf9-C9NHrHG47mLc579NRkTO7qLDtV7Q@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] arm64: dts: allwinner: h616: add crypto engine node
To: Andre Przywara <andre.przywara@arm.com>
Cc: Corentin Labbe <clabbe.montjoie@gmail.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S . Miller" <davem@davemloft.net>, Jernej Skrabec <jernej.skrabec@gmail.com>, 
	Samuel Holland <samuel@sholland.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Ryan Walklin <ryan@testtoast.com>, Philippe Simons <simons.philippe@gmail.com>, 
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-sunxi@lists.linux.dev, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2024 at 7:23=E2=80=AFAM Andre Przywara <andre.przywara@arm.=
com> wrote:
>
> The Allwinner H616 SoC contains a crypto engine very similar to the H6
> version, but with all base addresses in the DMA descriptors shifted by
> two bits. This requires a new compatible string.
> Also the H616 CE relies on the internal osciallator for the TRNG
> operation, so we need to reference this clock.
>
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arch/arm64/boot/dts/allwinner/sun50i-h616.dtsi | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/arch/arm64/boot/dts/allwinner/sun50i-h616.dtsi b/arch/arm64/=
boot/dts/allwinner/sun50i-h616.dtsi
> index 921d5f61d8d6a..187663d45ed72 100644
> --- a/arch/arm64/boot/dts/allwinner/sun50i-h616.dtsi
> +++ b/arch/arm64/boot/dts/allwinner/sun50i-h616.dtsi
> @@ -113,6 +113,16 @@ soc {
>                 #size-cells =3D <1>;
>                 ranges =3D <0x0 0x0 0x0 0x40000000>;
>
> +               crypto: crypto@1904000 {
> +                       compatible =3D "allwinner,sun50i-h616-crypto";
> +                       reg =3D <0x01904000 0x1000>;

The address range only goes up to 0x019047ff. The other half is the
secure crypto engine. The other bits look correct.

I can fix this up when applying, assuming the driver parts get merged
in the next few days.

Chenyu

> +                       interrupts =3D <GIC_SPI 91 IRQ_TYPE_LEVEL_HIGH>;
> +                       clocks =3D <&ccu CLK_BUS_CE>, <&ccu CLK_CE>,
> +                                <&ccu CLK_MBUS_CE>, <&rtc CLK_IOSC>;
> +                       clock-names =3D "bus", "mod", "ram", "trng";
> +                       resets =3D <&ccu RST_BUS_CE>;
> +               };
> +
>                 syscon: syscon@3000000 {
>                         compatible =3D "allwinner,sun50i-h616-system-cont=
rol";
>                         reg =3D <0x03000000 0x1000>;
> --
> 2.39.4
>
