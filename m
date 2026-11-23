Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795445659;
	b=RRtXXxGdzRJmwwhJB+W36jFzWygurTbnjYoqc+AULcwDDR1SIGhzTCcZc5rvNffYl7Ge
	 o01AdXNGcXyTWaP2rd83aAyTXCzJ9m2DGOcDl1FGiXtnizjxLE8XBr6Bu38fGIAAzI3e7
	 GwUCEnw/HK1Z4JvIhRW7yyW8D8ZR1rGvFjPoJ7sVgus12cc83Oa6PtAbUubCLRNIGYy3g
	 21WkCxW1g58S9JchEHC2l9Tku5T6ituWpju8F0LqQe9ml2x1oRk6aUqVpKDOEbVjcjIIh
	 G0S7rnqUl7EYLoI0A2K0sNWl+VVAbou6RUhLZncx5/BT1zVGgdSLqvjy+KU00vUlZSA==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795445659;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=ufGJoKCcAS+FG1R9253xSs80GkWpyQjdUam5hUgGAsg=;
	b=Ub9Q+UlSUIuKRWoIB5p5jUxHU3ABtzNhztEZN7ZY0JTJgxKTAB0aiqsWBY1psRqki/YB
	 LQ0eEH67ksEYacbhffpKOfuBtgrYxFvdwCPS6PbE+d1U8zKmOXt2UvlhSXwWzFsqUeOmF
	 +hy/U37NYCcMacuMqsXyBf/8pwDuGyoQGQnn89H2jqhfz/NfoV2n4xJl4D5y32K4BJmWf
	 Ez4c+hyuLV9uWy4h12yvCJNg/KiLGJwXuN0Hk5SV/anvmsLwpuyR2TcF8RR4gOVRsd5ze
	 07TPFjUIEoMjYZWj39oaPgAF3DTsx8QA+SW8P0LxbKnaRPeTODQwyFKS/GxboKC0mPg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="vO/o+WDN";
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8458D60A3808
	for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 14:54:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8458D60A3808
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vO/o+WDN
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c5127c7abd5so540019266b.3
        for <linux-crypto@vger.kernel.org>; Mon, 23 Nov 2026 06:54:18 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795445657; cv=none;
        d=google.com; s=arc-20260327;
        b=h0+Tv+foU8CYxPn58Ske7McEis3vz0Tf92/593dNhb0xJJupH2q2qao7yJcVo6/wIB
         TJgJmXQF6dHoLkRgwLyAkDi4d0HUZPV3irv4j4+WTXasUyk5HXjxtJ3A0qYTDu0QsTFJ
         vdOoisRhgH9WqbfqqfyCJftQSaPzjSBzZE62EFjYQ75oM1Ikha77ZDF9NVdnWZNeaGNk
         Sg85QZSu75ADt2gTcvyme1baXVo9WgLi09r8FksiPjGxk2XuX+NT1rPmEDDJmmcHnZYk
         crTD8+QT07EDhx5HaqSkyHrSQGSIp3CrUDJlXdUoC4lnrmJ93nShMSIWD83kyd6roGQ1
         bnnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ufGJoKCcAS+FG1R9253xSs80GkWpyQjdUam5hUgGAsg=;
        fh=JsI2QH03j2dEY2ID+TF0g30zMtFaf4o0cq2Rg3t5fEg=;
        b=lp5CsOGMpzHp2MrT4uG569WGAmJrvCyWnKykqyHy3GiqsrGfDS889dEcPz5vSS51xi
         DdmcGeDVWUibmC+n5SgRiVoo+JixOx0U5A08fI2BhftID90UxLgWx3WPIBNuzo9BW1kX
         W5fY9mxLvJRqIAS7c8f7Y78SS6kzPPv+FFY3L1Zh9/xB68bNAHQoIxBZsxqzsnm7sdP2
         8VMnJH7/j3UlMkuPr1zWkfcfZhh9au/ZedJjQfE08VQkqSjE8vyr7nERE3Atd4zxjJJ4
         PQNWOpnYDZavum7sxC7AMWJ5gZQFE5aWDe1VxCXm6uBBAAQ8m3vo+Z/ZWsjrGOJ9svaI
         Iz5g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795445657; x=1796050457; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ufGJoKCcAS+FG1R9253xSs80GkWpyQjdUam5hUgGAsg=;
        b=vO/o+WDNz7WgFm7HLgz1Lpw2NYWv+PRCf92k1YVhzyyopl83+yS8ITDt1vLQj4ekk8
         eOOdp9IQKpQw6bhBD9g35dO890qr958mYcIiSEh96QpczeVPAo0IAwu21MQzZz9WVB9I
         3n7usFcUAKdKUW/NVtyrYfNwD3Hf8OrH48N1KT6UIppbEkpuMjq8bmrg0MOrJMqibclJ
         UUE07sXjAbJWm2BnCaBcNhGXFOKmauFWWzqgOUO3m7vX1sreCFHcUxF80PPbtmfbYZIf
         YpzK8Hn8i+h7XyPdUseVYsmEgtJWHGtqMpOjFCXm8GqSpknsek6ZvCSrc3BbNM0IwccV
         FEoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795445657; x=1796050457;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ufGJoKCcAS+FG1R9253xSs80GkWpyQjdUam5hUgGAsg=;
        b=tLNtIgwSjl/aYEyng1nYHIfAL7h0JcQxUElrJp+fxv73jnidJycVurUKnrwQKEXl9L
         M+XV9chKQsJ+tfkl9U6kSWqiuseOdXkykUI0pxOrHn70KFqma4uMwJtrSsu73iqg7X/0
         uSXxBdVTUBxtu4Q4JanRRwkJ9cT4ifGWV0ZsmdpaPJ0DHNlsoex80BxRHD4T1NH+SPph
         dd3z2HwLu3difNav/aM5G6tkx6EYqlo96L6N4ZDwnYG0+VFl3Krat5QWVoqBxNffKPXo
         0MSq93UE36+2R2bG9m2yY/0qAkW713xjUC9RFLInlq9/pawVBYs88quBIdmMAEiJyAZ2
         LvgQ==
X-Forwarded-Encrypted: i=1; AL+hErFeBfffG+uQFmw4FisI4udOzWVm0r1/oXyjuZKu6UYFEHmld8Aubys7FQNYwlJ9bcEibaXvp89hi8Bfq8s=@vger.kernel.org
X-Gm-Message-State: APuU4Z+CPP+rkVKZK6mdIsQNwqy/C8tE6UsnTQrp7SRqCkvIGV4onRYa
	OxvvM5PdLjuW0ukybgsxGSTEc1feweFz3nI7BowdmVJDFz4b0MAy4B2g07cFMsPLpWVA53u7sXW
	FhVjhqotS7aNiAHA1/EheySBUkbMZx+c=
X-Gm-Gg: AZFdTZfMB/d+g7RHhlNloQAPALbxFf1onE7sMI1i3TYh/QYM8za11kK9NAhfAXqHAd9
	7kZ4w9zBOm5MWO6GwmSvBCiFe63w/L4ftSsg6tiSe8qbMa7I5YeBGN3HC18c7CJyHWolmQ2l4jJ
	HvvyXTrQLNA/RGytpL6rzw5r2tKqj3NYbXUFOBkEFwvNDhvrudHFIubbgh70v34FctW1DUBoDSq
	MOJuBZgWxVt8MKCIYLTrl/UiWutETmU2zuxLjCvF907qp/MGn0TySP73k+0hvWB/O3ZQDS1tKzN
	kQfoHbPDFGNndVTJw2J02reSh7kFbjD/nIk6ZVINzHYqCGYcHHnh+E72lHun3kzmfTfJTAU/Nl2
	GSUdydZaZPHYqicQMTAuXm48/9mRpg5fBeuCFMD4wKBJ6OaQkDHnlj95O
X-Received: by 2002:a17:906:fa82:b0:c50:4b6e:329 with SMTP id
 a640c23a62f3a-c513a5eaea2mr740199066b.15.1795445656730; Mon, 23 Nov 2026
 06:54:16 -0800 (PST)
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Post: <mailto:linux-crypto@vger.kernel.org>
List-Help: <mailto:linux-crypto+help@vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-crypto+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261122152900.1113961-1-sashal@kernel.org> <20261122194200.GA2122@sol>
In-Reply-To: <20261122194200.GA2122@sol>
From: Shreesh Adiga <16567adigashreesh@gmail.com>
Date: Mon, 23 Nov 2026 20:24:05 +0530
X-Gm-Features: Aa3M54oFCYgRDogfTqeuThv0nhidW6LYPLzRsNkekwYNrTVHMWAhXuqfICGEcXo
Message-ID: <CA+-x59aKkxNODACP=HcG8g=Z2i_=pGyVOJve=r45Gm2N8Ks+Gg@mail.gmail.com>
Subject: Re: [PATCH] lib/crc: Use uint64_t for the new NEON crc64 fold constants
To: Eric Biggers <ebiggers@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>, Sasha Levin <sashal@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, linux-crypto@vger.kernel.org, llvm@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Mon, Nov 23, 2026 at 1:12=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Sun, Nov 22, 2026 at 10:29:00AM -0500, Sasha Levin wrote:
> > Commit ff049836f05f ("lib/crc: Don't include <linux/types.h> in NEON in=
trinsics
> > code") in mainline switched the arrays passed to vld1q_u64() to uint64_=
t, since
> > u64 and the uint64_t that vld1q_u64() takes are different types on arm6=
4 once
> > <linux/types.h> is gone. The two arrays added by commit ef4102757fdd ("=
lib/crc:
> > Add 4-way folding in NEON crc64_nvme implementation") still use u64, so=
 the
> > combination fails to build with clang:
> >
> >   lib/crc/crc64-neon.c:66:40: error: incompatible pointer types assigni=
ng
> >   to 'const unsigned long *' from 'const u64 *' (aka 'const unsigned lo=
ng
> >   long *') [-Werror,-Wincompatible-pointer-types]
> >
> > Use uint64_t for them too. This builds with and without ff049836f05f.
> >
> > Fixes: ef4102757fdd ("lib/crc: Add 4-way folding in NEON crc64_nvme imp=
lementation")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >
> > crc-next is based on v7.4-rc2 and ff049836f05f went into mainline after
> > rc3, so linux-next will hit this once it merges the two. all-next hit
> > it already.
> >
> > Tested on arm64: lib/crc/crc64-neon.o builds with clang and gcc on
> > crc-next, and with clang on crc-next merged with mainline 4843f6873f7c.
> > Without this patch the merged tree fails as above.
> >
> >  lib/crc/crc64-neon.c | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> >
> > diff --git a/lib/crc/crc64-neon.c b/lib/crc/crc64-neon.c
> > index 03b46d0abcc41..f36389789fe65 100644
> > --- a/lib/crc/crc64-neon.c
> > +++ b/lib/crc/crc64-neon.c
> > @@ -11,11 +11,11 @@
> >  u64 crc64_nvme_neon(u64 crc, const u8 *p, size_t len);
> >
> >  /* x^575 mod G, x^511 mod G */
> > -static const u64 fold_consts_4x_val[2] =3D { 0x0c32cdb31e18a84aULL,
> > -                                        0x62242240ace5045aULL };
> > +static const uint64_t fold_consts_4x_val[2] =3D { 0x0c32cdb31e18a84aUL=
L,
> > +                                             0x62242240ace5045aULL };
> >  /* x^319 mod G, x^255 mod G */
> > -static const u64 fold_consts_2x_val[2] =3D { 0xb0bc2e589204f500ULL,
> > -                                        0xe1e0bb9d45d7a44cULL };
> > +static const uint64_t fold_consts_2x_val[2] =3D { 0xb0bc2e589204f500UL=
L,
> > +                                             0xe1e0bb9d45d7a44cULL };
> >  /* x^191 mod G, x^127 mod G */
> >  static const u64 fold_consts_val[2] =3D { 0xeadc41fd2ba3d420ULL,
> >                                       0x21e9761e252621acULL };
>
> Thanks Sasha.
>
> I've dropped "lib/crc: Add 4-way folding in NEON crc64_nvme
> implementation" from crc-next temporarily.
>
> Shreesh, could you send a new patch that folds together that patch with
> the two fixups for it?  Then we'd get one clean patch.
>
>     lib/crc: Add 4-way folding in NEON crc64_nvme implementation
>     lib/crc: arm: Support partial blocks in NEON crc64_nvme
>     lib/crc: Use uint64_t for the new NEON crc64 fold constants
I've submitted v2 for "lib/crc: Add 4-way folding in NEON crc64_nvme
implementation" which essentially contains those three listed commits
(I also changed u8 to uint8_t used by vld1q_u8() in fold_partial_block
for consistency).
There are some checkpatch CHECK printed about usage of uint64_t and
uint8_t and to prefer the u64/u8 though, hopefully that can be tweaked
to allow for neon code?
I've rebased the patch on top of 7.4-rc4 latest master so hopefully it
should be sufficient here. Kindly review the v2 recently submitted and
let me know if any additional changes are necessary.

Thanks,
Shreesh
