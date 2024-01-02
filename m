Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7CE1156F0;
	Tue,  2 Jan 2024 18:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eEv45m5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 573D2C433C8;
	Tue,  2 Jan 2024 18:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704220282;
	bh=a2nksk6kIBPxDGBv3UGxAQM7iBjL7hf0hbNNRAGystg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=eEv45m5kFoRQ/7gQWJ1sqsuCI3uLdd4x6RajWHJLuydDWfnRJkRgWeHZoX2tnol1f
	 CeCsC4jfMxqtijOSfUAzCJiUcp0CJ5SIDfI/Cf80JujlnUhVJkhMZbkeU/xIP3VJBs
	 sX82tksg08IZOae+c4ufqN1Ll0Ju+haJb6dT5bh6417y1qI24e77k8jrh0yzTDV6C3
	 XVG/h2M3ZBwuKFmhdiu633fMR08EFaOh0axrjnBoz+1JXic4iN0rwPbF7Ou8u4zH/B
	 n96uFjwY6kZrqkqz+E1gyk6k2Ba2IgiOBEWeVeRc41AteZ8IcM9QTwqoh6+GXDuqZb
	 FHSOKBaX8WTWg==
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2cd1232a2c7so6979261fa.0;
        Tue, 02 Jan 2024 10:31:22 -0800 (PST)
X-Gm-Message-State: AOJu0Yz9JJJQOFTLZvLc2viHHfnpPXJMI6Tw2FPyjKVqvjv1wQQoQ6am
	VswwcSsvzdKwMjDel0LxplpqZNrDICoprXC6FA==
X-Google-Smtp-Source: AGHT+IHcaSoyRt5IyzuibmWh/dkkmcEzUUJ2eE6UdEpzS4Cis2MFZeEfvXQ3c/lHwNcUCtoAWOKO6fNIjTfdWYhMEJk=
X-Received: by 2002:a2e:7816:0:b0:2cc:f1aa:8a3f with SMTP id
 t22-20020a2e7816000000b002ccf1aa8a3fmr2707582ljc.88.1704220280569; Tue, 02
 Jan 2024 10:31:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240101114432.28139-1-zajec5@gmail.com>
In-Reply-To: <20240101114432.28139-1-zajec5@gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Tue, 2 Jan 2024 11:31:08 -0700
X-Gmail-Original-Message-ID: <CAL_Jsq+hpOS-rdOYasJ1dzU6d_vVDWv2CseRhYmNHA2H_p=_pw@mail.gmail.com>
Message-ID: <CAL_Jsq+hpOS-rdOYasJ1dzU6d_vVDWv2CseRhYmNHA2H_p=_pw@mail.gmail.com>
Subject: Re: [PATCH RFC] dt-bindings: crypto: inside-secure,safexcel: make
 eip/mem IRQs optional
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: Antoine Tenart <atenart@kernel.org>, Sam Shih <sam.shih@mediatek.com>, 
	Matthias Brugger <matthias.bgg@gmail.com>, 
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, linux-crypto@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 1, 2024 at 4:45=E2=80=AFAM Rafa=C5=82 Mi=C5=82ecki <zajec5@gmai=
l.com> wrote:
>
> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>
> Binding for this cryptographic engine defined 6 interrupts since its
> beginning. It seems however only 4 rings IRQs are really required for
> operating this hardware. Linux driver doesn't use "eip" or "mem" IRQs
> and it isn't clear if they are always available (MT7986 SoC binding
> doesn't specify them).
>
> This deals with:
> arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: crypto@10320000=
: interrupts: [[0, 116, 4], [0, 117, 4], [0, 118, 4], [0, 119, 4]] is too s=
hort
>         from schema $id: http://devicetree.org/schemas/crypto/inside-secu=
re,safexcel.yaml#
> arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: crypto@10320000=
: interrupt-names: ['ring0', 'ring1', 'ring2', 'ring3'] is too short
>         from schema $id: http://devicetree.org/schemas/crypto/inside-secu=
re,safexcel.yaml#

Which platform does the schema currently match? None, because the
Marvell ones get these:

     28  crypto@800000: interrupt-names:5: 'mem' was expected
     28  crypto@800000: interrupt-names:4: 'eip' was expected
     28  crypto@800000: interrupt-names:3: 'ring3' was expected
     28  crypto@800000: interrupt-names:2: 'ring2' was expected
     28  crypto@800000: interrupt-names:1: 'ring1' was expected
     28  crypto@800000: interrupt-names:0: 'ring0' was expected
     28  crypto@800000: 'dma-coherent' does not match any of the
regexes: 'pinctrl-[0-9]+'

(28 is the number of occurrences)

The existing list of names defines the order AND index. Since there
are 2 versions already in use, you have to define 2 lists.

>
> Cc: Antoine Tenart <atenart@kernel.org>
> Ref: ecc5287cfe53 ("arm64: dts: mt7986: add crypto related device nodes")

Not a documented tag. Don't make-up your own ones.

> Cc: Sam Shih <sam.shih@mediatek.com>
> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
> ---
>  .../devicetree/bindings/crypto/inside-secure,safexcel.yaml      | 2 ++
>  1 file changed, 2 insertions(+)
