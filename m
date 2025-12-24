Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41D772F12C6
	for <linux-crypto@vger.kernel.org>; Wed, 24 Dec 2025 10:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766572229; cv=none; b=OWG7ICsZ70oO/+1RNxlKwVEd4XVQETfaGWQRoiFBQTcQKv4iDOIEn03lorgf22XEsAF3/gzbvO8ja3zOczDVCAb+G2vR8VMDK8tuf3A4UxTTg4JP17mJSL+VG+zdWnfpwnjFKjoHVqQv3Lk0dsf9ZpVsuRwHYsYAD3GQGHn8RyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766572229; c=relaxed/simple;
	bh=KNz2TcJzJmqF7rsKjUpwytr/M43/Sc2TIAVK6pF3yUw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LiNe+0sj+wagXpIromUCfahf04EST4bnMi8bFku7PAXgcbQwnIN5YdJjrO6tKhWM8JxcMRaQrQZG1qelC0XQ/E6u8w8aL7oNfNNxrVAVF/99LDH1IIBC8LfVa1n2IkBvZjDw9D8cCx849w1WfjY9mWFwCgMwG1KY18HXbgmm+3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=QkflirsL; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="QkflirsL"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b7ffa421f1bso1172198166b.0
        for <linux-crypto@vger.kernel.org>; Wed, 24 Dec 2025 02:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1766572226; x=1767177026; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KNz2TcJzJmqF7rsKjUpwytr/M43/Sc2TIAVK6pF3yUw=;
        b=QkflirsLWgw6/rIVLUiHc+xA6dek2yABjKGT4i+A+L5IppltKVDlUGSuOMevhCMgcK
         ckCLksZyu0cznkJw9n+xpMrIVsyQ3Vziem1/pZP0tLUIfK9BDzN3rwJgG/wSnpHiLBmn
         TbECIwlIAMkmtsBG4zMVFVhSwlOxuJaxJtFPNAujXepGgZdMwiScXo/ikP27cH5mMmK5
         QdxyunnKgaVS/qXTP0+3piJErhrQ7gDnG6FI1Dwa1lihHSqS/wyP5Uwz562Viur8V2EB
         fBVLF6esy6inerOy3NioZOYB5LpnIbIj1uwUN/K3fkNamRPUqXKSwot/bT8w1TYli6/g
         f0Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766572226; x=1767177026;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KNz2TcJzJmqF7rsKjUpwytr/M43/Sc2TIAVK6pF3yUw=;
        b=P9uyNTs82xV20l+sOjjSXSIffJIoS6jlp1ZjVrxNIWJHhu8Q8Bpb/CQU8lX9DG3BcI
         qOygY5uPRdbItOHSvPD653IahY+LjVghKD9ySnTKGYQ3/LwPsXG9RUN26+X1NVJQ529Q
         92bCAK62ai+0d3YD6Ry52G/eJbPq/xLdtgMg6GGFfd8s55dBlJWFW7Ps/B1wfzrnbFks
         OLmURbsemcU0adw3AOfltN/7Cu6WyZ454RRDoJ7WNG4xafwDgsGNQJYi+T+lbmkrLsSP
         5tavYRNGOC4219F9r3mj/RmQVA7q9TePnu/CBnTp/v+dRYnwVzmmv/hB0ib0bvu4A1hm
         JExg==
X-Forwarded-Encrypted: i=1; AJvYcCW/Fb8W06sldXcTDugTGq4qfiy86y/Ah9kKHEdMQOYwQNM5AOJcUtJzpvK6TbDLqW4u7QydYfwb/ddYxp4=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOPqOWozJfSPG6iJc72A4Btihyc5lnS6ARwD2X6mWd6r6w3HN+
	AIFfgBRLEfaULUUr4rMUQz13qD8ngB4P6zQKU4VystVkOLHlh7EYqBOahs1hLymPGboEOBG3RJ0
	8uH3LQowKd8YXRaaC/akT6e9i6zGZh8hxC+KlfE+lAQ==
X-Gm-Gg: AY/fxX4xHdgTlqV5PnU35EWKnQhX8mgfmBtXGBlTHliZCKToM6dlvmGVqZSfCfa6byx
	cb4Vz/4LBcwRe2w80gcRgOhXrq5dLHLDPpDU5qfr/M5PsOr5z8Q2V1xxxCM0wiNQ3vtDGMyoxoT
	4GrbmkRY2lIMaJkGoJaI8i0C1nbWHKsSOxN1wuT1iiHBG2tr4iWXQKOE+NfTLb69VnUXuDUicZH
	0zqjyQqjSaUpPnYE/eFJlocdPGleFxfVWuA+H5mWGpIJKqD3Xur/jIID+QSfB0E3T0hV/dqurK6
	Vhz0J/pcKJqk8RQlU8mEWJ2pzZmesLpgxXR8Ry3Fb+GIbA0Em/M8uu09b2T6
X-Google-Smtp-Source: AGHT+IFeflXA2mce6O+1rdmvPjP/12/Umt2Y99WbRQ8cM3OEzOcKAWgIne20UzsSB0V8xKjPoflCDtb5j1Pn52N5SuA=
X-Received: by 2002:a17:907:7f01:b0:b71:ea7c:e501 with SMTP id
 a640c23a62f3a-b80355b2523mr2261188266b.4.1766572225170; Wed, 24 Dec 2025
 02:30:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251223201921.1332786-1-robert.marko@sartura.hr>
 <20251223201921.1332786-2-robert.marko@sartura.hr> <20251224-berserk-mackerel-of-snow-4cae54@quoll>
In-Reply-To: <20251224-berserk-mackerel-of-snow-4cae54@quoll>
From: Robert Marko <robert.marko@sartura.hr>
Date: Wed, 24 Dec 2025 11:30:14 +0100
X-Gm-Features: AQt7F2rVNXRXeSbgmjkb2SKB7p5AiaNihNvuJMBrgMZ7XIKTnJcRJJO5brWpKNE
Message-ID: <CA+HBbNGym6Q9b166n-P=h_JssOHm0yfyL73JZ+G9P81muK=g4A@mail.gmail.com>
Subject: Re: [PATCH v3 01/15] include: dt-bindings: add LAN969x clock bindings
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, 
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com, 
	claudiu.beznea@tuxon.dev, herbert@gondor.apana.org.au, davem@davemloft.net, 
	vkoul@kernel.org, andi.shyti@kernel.org, lee@kernel.org, 
	andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, linusw@kernel.org, Steen.Hegelund@microchip.com, 
	daniel.machon@microchip.com, UNGLinuxDriver@microchip.com, olivia@selenic.com, 
	radu_nicolae.pirea@upb.ro, richard.genoud@bootlin.com, 
	gregkh@linuxfoundation.org, jirislaby@kernel.org, broonie@kernel.org, 
	mturquette@baylibre.com, sboyd@kernel.org, lars.povlsen@microchip.com, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	dmaengine@vger.kernel.org, linux-i2c@vger.kernel.org, netdev@vger.kernel.org, 
	linux-gpio@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-clk@vger.kernel.org, luka.perkov@sartura.hr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 24, 2025 at 11:21=E2=80=AFAM Krzysztof Kozlowski <krzk@kernel.o=
rg> wrote:
>
> On Tue, Dec 23, 2025 at 09:16:12PM +0100, Robert Marko wrote:
> > Add the required LAN969x clock bindings.
>
> I do not see clock bindings actually here. Where is the actual binding?
> Commit msg does not help me at all to understand why you are doing this
> without actual required bindings.

I guess it is a bit confusing, there is no schema here, these are the
clock indexes that
reside in dt-bindings and are used by the SoC DTSI.

I guess I should have titled this something like:
dt-bindings: clock: lan969x: add binding includes for LAN969x clock IDs

Regards,
Robert

>
> Please use subject prefixes matching the subsystem. You can get them for
> example with 'git log --oneline -- DIRECTORY_OR_FILE' on the directory
> your patch is touching. For bindings, the preferred subjects are
> explained here:
> https://www.kernel.org/doc/html/latest/devicetree/bindings/submitting-pat=
ches.html#i-for-patch-submitters
> Bindings never have a "include" prefix.
>
> A nit, subject: drop second/last, redundant "bindings". The
> "dt-bindings" prefix is already stating that these are bindings.
> See also:
> https://elixir.bootlin.com/linux/v6.17-rc3/source/Documentation/devicetre=
e/bindings/submitting-patches.rst#L18
>
> Best regards,
> Krzysztof
>


--=20
Robert Marko
Staff Embedded Linux Engineer
Sartura d.d.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr
