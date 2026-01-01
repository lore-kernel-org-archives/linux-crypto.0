Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9801AE573
	for <linux-crypto@vger.kernel.org>; Thu,  1 Jan 2026 21:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767303969; cv=none; b=KYUpeGxfPKf41rAflUmjrFnYsjrjgbhuHaDRrQH9uBCvh1/Zar5MKrw6CqL+h+mrr3MZQ5tnXn2JGjfXxe02uVmk0nWQGvv0TpKdRZbtefEcLjR2WuWuUzFH8ZW3ilbiAv3YhCcC6PUNS7FON7HW5lelicRV1jTiKVMaFNzVwWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767303969; c=relaxed/simple;
	bh=OLy6N738FY0bYNvkj+ec/gJdT2s9N3ef1h20yJTb8Mo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=piPfLy1uNSSpIRNJQnYNt5DdyXy183l0OAeW/ATUW8e/Q2+O7KssRqEqBYyjdAY6ttlRfXABOvDmsVMaHhYvgFAHQEyhzYKrn0sLboyFmbkRdk5AABB4jgEqjr8AoqjhgPn0+bIUs6ZNrccNl1QzsQCOCx94kPaGzvPHF8bokr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dMkF2jd9; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dMkF2jd9"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso121046445ad.1
        for <linux-crypto@vger.kernel.org>; Thu, 01 Jan 2026 13:46:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767303967; x=1767908767; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/qGeOIEXCnLq99CGQeQ1eWuZeDA3OumK0NUXsyjIwoc=;
        b=dMkF2jd9VlWi9dpq4qU4dvTClKDooOO0hcGZpHiG99bS9KeFE+oWmmz/4QqgK39DeU
         67q/1/enNoBhSCb9zxFyPZSq3vAl6mGP1ZLNa5LYoG1PpS9hkPk61UMtcR9gW5eCb2zJ
         GQguF99XdgqgpN3cyi1W1k9FSzL+WIY/c8z5V9sz0zTMQk8Yv9DgpYX92ie0nfAyc42N
         1HuqDtrT9757S11aZ4VPsgOGpcC55CaCqzBeU04d6TZXPkiH/JVlchvFdNgQ4n0OdFgR
         mvej+o+E+3B/phzpPamL4zu3Ss9Mo4yUJ9XqkHjIja5GPpDownTnAJ64B6VSXp+2lQEp
         PvTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767303967; x=1767908767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/qGeOIEXCnLq99CGQeQ1eWuZeDA3OumK0NUXsyjIwoc=;
        b=V7uD7YY77cjkrvPrzNrvmfSjuRNnRFJtM04s63lQL3Jh5pLfy4ChRZSniDJRVe58az
         0xgEjqj4PzK/L31Vd0oHRwhg9GtUPkqQ1UZExMHXYKpB8u3FlBGgmd4vh0OCXpM/4RSD
         ijSFXMHDc4Zzo1OJD6qZsxLSfD9JrufrqqFeT5PjJaxMYSFDJ9BB8PmBTourOis2FrdY
         kly0AgHkjCEsjEkQe3H4vHOGJ4z6s4GTNuImseutpg/XCoLC2JeLZvSe75D/gjMg0w6f
         hptaAZx5T6X5FEsur3vSrv3FaPRXlj31VLNLgxrWHm8PLeJ1Ewi9sYGB5okry03lWObg
         nyww==
X-Forwarded-Encrypted: i=1; AJvYcCWso54xNvFF0kzctwS4elOdPWb/g2k2x/LGBebOy2JCN8mfWRH3wmLxbfD07n8jHj9rW1EMaMIWTwhMEhQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YzUsNhFWg+YZcW8NVTMcWggg3QneSZacCl6k/tTuXipaJEpirkh
	QWNYL6Yyly9QE4C+dXwlqQXniacek/puHpe7FS43j3cZDqZlrBLCnQzDBzc1Fa2H3Ntekd4eTaC
	mMfijvwfStvCxjXy5MmtPm14kTm3VPVM=
X-Gm-Gg: AY/fxX51Q/vkMw40SKIuNeEbkmKerXBL+LGDiszsDuTZFdR/T98UmcIlTp3updkp/F8
	paNvm5k48jRxxf962S7O7lHoX6xjZVnXowcXZVjuCV4F7z+BdKHxlkAXeyv0wHR6JrpIXJKvzK/
	ZvgecvsLyyD7HV3gf2lXiqiNJmTi6LHhn7MJwYnS752shVjKSfmgBCdIU2IQIYcZgJArE6oa5Qg
	YSGPLYmpoAWMXsHEKAZPWsyIQ4TGWwB8xRRhttHP/hOT/OFvEaTugwdUk0yTiNKGnY6Zs7TPmuL
	/NJU
X-Google-Smtp-Source: AGHT+IHSUyciBMOilIcbt7HWqVU9MizsV+4Y+vMa4rwxqp1kK6Xy4T8CKC8ooJ7UwHC5GL0rYFqcLpHFUdgExBBrRuo=
X-Received: by 2002:a05:7022:e11:b0:11b:7dcd:ca9a with SMTP id
 a92af1059eb24-12172302438mr46279194c88.34.1767303966643; Thu, 01 Jan 2026
 13:46:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260101172052.1862252-1-olek2@wp.pl> <20260101172052.1862252-2-olek2@wp.pl>
In-Reply-To: <20260101172052.1862252-2-olek2@wp.pl>
From: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Date: Thu, 1 Jan 2026 22:46:19 +0100
X-Gm-Features: AQt7F2oqocFNQmJB-3KQEF2TnEZfZsw4aObS_R4iYm5tqbcpTsbrKBpnm8uH8pk
Message-ID: <CAMhs-H_iN7pWsis2HbeJ-xr+9JoMa+EF-+7z9e21DJ1dyNNtuw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mips: dts: ralink: mt7621: add crypto offload support
To: Aleksander Jan Bajkowski <olek2@wp.pl>
Cc: ansuelsmth@gmail.com, herbert@gondor.apana.org.au, davem@davemloft.net, 
	chester.a.unal@arinc9.com, robh@kernel.org, krzk+dt@kernel.org, 
	conor+dt@kernel.org, matthias.bgg@gmail.com, tsbogend@alpha.franken.de, 
	angelogioacchino.delregno@collabora.com, linux-crypto@vger.kernel.org, 
	linux-mips@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-mediatek@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Aleksander,

On Thu, Jan 1, 2026 at 6:21=E2=80=AFPM Aleksander Jan Bajkowski <olek2@wp.p=
l> wrote:
>
> Add support for the built-in cryptographic accelerator. This accelerator
> supports 3DES, AES (128/192/256 bit), ARC4, MD5, SHA1, SHA224, and SHA256=
.
> It also supports full IPSEC and TLS offload, but this feature isn't
> implemented in the driver.
>
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  arch/mips/boot/dts/ralink/mt7621.dtsi | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/arch/mips/boot/dts/ralink/mt7621.dtsi b/arch/mips/boot/dts/r=
alink/mt7621.dtsi
> index 0704eab4a80b..9ba28fa016fb 100644
> --- a/arch/mips/boot/dts/ralink/mt7621.dtsi
> +++ b/arch/mips/boot/dts/ralink/mt7621.dtsi
> @@ -361,6 +361,14 @@ cdmm: cdmm@1fbf8000 {
>                 reg =3D <0x1fbf8000 0x8000>;
>         };
>
> +       crypto@1e004000 {
> +               compatible =3D "mediatek,mt7621-eip93", "inside-secure,sa=
fexcel-eip93ies";
> +               reg =3D <0x1e004000 0x1000>;
> +
> +               interrupt-parent =3D <&gic>;
> +               interrupts =3D <GIC_SHARED 19 IRQ_TYPE_LEVEL_HIGH>;
> +       };
> +

AFAICS, the crypto engine for mt7621 has also a clock gate[0] and a
reset line[1]. These two are not present in this binding.

[0]: https://elixir.bootlin.com/linux/v6.18.2/source/include/dt-bindings/cl=
ock/mt7621-clk.h#L36
[1]: https://elixir.bootlin.com/linux/v6.18.2/source/include/dt-bindings/re=
set/mt7621-reset.h#L33

Best regards,
    Sergio Paracuellos

>         ethernet: ethernet@1e100000 {
>                 compatible =3D "mediatek,mt7621-eth";
>                 reg =3D <0x1e100000 0x10000>;
> --
> 2.47.3
>
