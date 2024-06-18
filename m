Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88A9E13A895;
	Tue, 18 Jun 2024 13:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718717260; cv=none; b=T8KuuGDrt5A3U8zk3rjwQzhR6ej0mwOOtSn+6o25PyWLGBhtz+z6zsLHJnmK6IKE1rAOJvfYcjaVwMJQJK8kfVsAAwnLq+I/7YmkSDqFoeVE5UhfahWV/jJPoa3Do6BBWYB3kSGxXhBJw1Nxm7iNx6oFywF2ISbAbJfBbpdmygQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718717260; c=relaxed/simple;
	bh=P8C3kZNC9TFvn43XN5wi5WNHC+Y2XUWCEIMIFb8aiTg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bkYncDkU1+QUTAPz1ya9zbkwxWGEhGzbDeLMViAwttYi0qgkxpPZYi/ureuKXo9Qu+xMEKAUH/AkyvLEuK2fMbUa4els35qdvmJvP9GxZD2RPaulgsmLWYEuSmC+yxgehZ0DiVOa+vtaa9DL7Y3KOx1pr3WMBRmn6hBkxk3h5yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l6W2YwvB; arc=none smtp.client-ip=209.85.161.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l6W2YwvB"
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-5b9a35a0901so1800902eaf.0;
        Tue, 18 Jun 2024 06:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1718717257; x=1719322057; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CdNdOEwtXS2JQSR1qzVkD9A7XBal8hZRGM6LmJ/+p9Y=;
        b=l6W2YwvBkoLr8tQZq0rCVwtx/jSimHjpNEGu27akNzU+ZsAc/tzTCarRyscE5ekeQA
         52JR/6G3SQ5x0Qmyc4TjvdNny6pixF3kCfNT9LwSvRCHxBih0fL3fXuZkdAro4/neIr4
         9BJGADqJSUi8+jLtGhBfeHbyLC8ePLPfeDj7n5dpeKSWRxWwgQgDFBYmjluaxOIru7d2
         +pLtJrHYftzVtsa2BnRP+Sw876D/XqnOtCUVQ++HebADVLP4EEQ4R7AkLMHeuqCx3sI/
         mMN4tOK+RRE9arX08WXNHZDmIrbspZqvnNO8JvFsJfJi2RVyxcqwNOj+ifNjYsXmc7dI
         Tr9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718717257; x=1719322057;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CdNdOEwtXS2JQSR1qzVkD9A7XBal8hZRGM6LmJ/+p9Y=;
        b=vMEWKQKrHLd0Zs+fBMHJQhXK8SGOcA24xmIjQF2p/qeZl/8xH5GFA+3w2eWxpVE+B7
         +8PdW9kM2MFSUrdEcxaJrsU/WDVns2Pw4r4asUY3Xq3BdPz0sQf9kBH5LbzQXZwAopYK
         zlz1VRhWMU102bjo9bDscO5+n5kEGCAlpwl62aZLc4ffJ6c1UT7cJjxwhOq7KWgugrXS
         6ptjRIAZuaaC9LxTFcLgC2402lIX6avCCPkahss9WVRy4UPYwm2ut67gn77cybzD/V2Y
         R/edkKtVh7B4x18/xfSkf//OHnKF9GU9VIi1iFKPH+Y3aZ+zCiFoheEmqtscAadFfCY9
         9A6g==
X-Forwarded-Encrypted: i=1; AJvYcCUa15yeitvNdQ7DtglNTc7QQD09MqL+pqXItqig2/n3AVdSxsy81I7u/VQCOpOLkknf6PaxjQKZk6meUgbD4uw8DFA+sq3xHhH4hSVxP5DwBAKewnbvbYgoyK4Lhs5GxGf8x2g4MU+9TFe1
X-Gm-Message-State: AOJu0YxfuIeCLg+pNPexwyufOZSlk+nE8V5l2JP2z74CTTmarC1KsbAl
	un0cO8L59Q4nanEoMF1xRyGU34W2Tzjk7Ltb0M8jhbQ4tJrLHstenNtLPMpHAo5/BtK289yZe6m
	IPDGtAvX2a6L1b+R3+9JWW3Pawms=
X-Google-Smtp-Source: AGHT+IHxlwSqQtRjMjtn/Lc54p7Vzqf7fp+SfJ6DO+Ng4Vn2vJjW4WCtOPDDggwmIApml74xjVqttMcF/cYgNat9V3k=
X-Received: by 2002:a05:6820:554:b0:5ba:ea6f:acb8 with SMTP id
 006d021491bc7-5bdadbdecefmr12975302eaf.3.1718717257431; Tue, 18 Jun 2024
 06:27:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20220919210025.2376254-1-Jason@zx2c4.com> <32f8797a-4b65-69df-ee8e-7891a6b4f1af@arm.com>
 <Y9juvficPxFUfgHD@Red>
In-Reply-To: <Y9juvficPxFUfgHD@Red>
From: Anand Moon <linux.amoon@gmail.com>
Date: Tue, 18 Jun 2024 18:57:21 +0530
Message-ID: <CANAwSgTTzZOwBaR9zjJ5VMpxm5BydtW6rB2S7jg+dnoX8hAoWg@mail.gmail.com>
Subject: Re: [PATCH] hw_random: rockchip: import driver from vendor tree
To: Corentin LABBE <clabbe@baylibre.com>
Cc: troy.lin@rock-chips.com, shawn.lin@rock-chips.com, hl@rock-chips.com, 
	ty@wevs.org, mike.rudenko@gmail.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Herbert Xu <herbert@gondor.apana.org.au>, Heiko Stuebner <heiko@sntech.de>, 
	linux-rockchip@lists.infradead.org, robin.murphy@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Corentin / Jason,

On Tue, 31 Jan 2023 at 16:10, Corentin LABBE <clabbe@baylibre.com> wrote:
>
> Le Tue, Sep 20, 2022 at 10:35:44AM +0100, Robin Murphy a =C3=A9crit :
> > On 2022-09-19 22:00, Jason A. Donenfeld wrote:
> > > The Rockchip driver has long existed out of tree, but not upstream.
> > > There is support for it upstream in u-boot, but not in Linux proper.
> > > This commit imports the GPLv2 driver written by Lin Jinhan, together
> > > with the DTS and config blobs from Wevsty.
> >
> > Note that Corentin has a series enabling the full crypto driver for
> > RK3328 and RK3399[1], so it would seem more sensible to add TRNG suppor=
t
> > to that. Having confliciting compatibles for the same hardware that
> > force the user to change their DT to choose one functionality or the
> > other isn't good (plus there's also no binding for this one).
> >
> > Robin.
> >
>
> Hello
>
> I am very interested on how this serie was tested and which tools was use=
d to ensure output was random.
> And how did you get that CRYPTO_V1_TRNG_SAMPLE_PERIOD(100); was the best =
choice.
>
Is there any update on this driver

I just tested this patch on my RK3399 board.

 8<-------------------------------------------------------------->8
# dd if=3D/dev/hwrng bs=3D100000 count=3D1 > /dev/null
1+0 records in
1+0 records out
100000 bytes (100 kB, 98 KiB) copied, 0.829212 s, 121 kB/s

#  cat /dev/hwrng | rngtest -c 1000
...
rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 0
rngtest: FIPS 140-2 failures: 1000      <--  failures
rngtest: FIPS 140-2(2001-10-10) Monobit: 21
rngtest: FIPS 140-2(2001-10-10) Poker: 1000
rngtest: FIPS 140-2(2001-10-10) Runs: 1000
rngtest: FIPS 140-2(2001-10-10) Long run: 0
rngtest: FIPS 140-2(2001-10-10) Continuous run: 4
rngtest: input channel speed: (min=3D18.079; avg=3D955.991; max=3D9765625.0=
00)Kibits/s
rngtest: FIPS tests speed: (min=3D18.062; avg=3D31.619; max=3D50.459)Mibits=
/s
rngtest: Program run time: 22125055 microseconds

Whereas for /dev/random

# cat /dev/random | rngtest -c 1000
...
rngtest: starting FIPS tests...
rngtest: bits received from input: 20000032
rngtest: FIPS 140-2 successes: 998
rngtest: FIPS 140-2 failures: 2
rngtest: FIPS 140-2(2001-10-10) Monobit: 0
rngtest: FIPS 140-2(2001-10-10) Poker: 1
rngtest: FIPS 140-2(2001-10-10) Runs: 0
rngtest: FIPS 140-2(2001-10-10) Long run: 1
rngtest: FIPS 140-2(2001-10-10) Continuous run: 0
rngtest: input channel speed: (min=3D381.470; avg=3D5551.073; max=3D19073.4=
86)Mibits/s
rngtest: FIPS tests speed: (min=3D24.933; avg=3D70.400; max=3D79.805)Mibits=
/s
rngtest: Program run time: 276870 microseconds

Thanks

-Anand




> Thanks
> Regards
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
