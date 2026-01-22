Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC682DC76A
	for <linux-crypto@vger.kernel.org>; Thu, 22 Jan 2026 09:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769074548; cv=pass; b=lw1SlMa5MbWsuxAz1e3a0+GlPJ5iqVA+4maLhas62xPDfT8Fo5hiDjdQhqfNDvsBUYn9GGY90fl8QJDJjp7hVFekquoMxJNpRg7/a5VWyMrb4c6+D4BWHGXreyAG4sIeV4gHVxW1KX4s6h+KAtm08hhkcA1HC8LBIQzF/OLD7Ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769074548; c=relaxed/simple;
	bh=CpowxPIs9WsIvTj4/MuMW1Y5/GmzHzBIUQWzh9qqtsQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mt0dPe118CMePcrFe5IitdVxRQAoDRXTHgqwJVS+G4d/nls2G+M9cBQ5h1IB6bY9kZGz8IjVpyJ9w6ytEI4ecXbsPF9EDB10ICEiLU2FAIddAw41qxhtUIj5QB3rLi2jSiLXFNuAewNk6vE/6DHTixfTcFbzm/ZJBCyyvNXoyBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=WMmVf+cD; arc=pass smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="WMmVf+cD"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6505d141d02so1061614a12.3
        for <linux-crypto@vger.kernel.org>; Thu, 22 Jan 2026 01:35:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769074545; cv=none;
        d=google.com; s=arc-20240605;
        b=fdOkMCmq0k3aveWNVlx5hYA8GGKSUHDr0aq7IQ+BERFjscvpkfXJmcaz4t53NxyO8u
         NgUztCq+xzcp/wcIfLX6CBLKgUJAtIrFYeoxw2Um42aE2mKgciDccMSZPth5Yyo4OSlh
         PAdNMid0WMNrvEGwZdeA4hvcb/vW2F/yczZ0w8susjRPWivb+K56P/yhQyWc2u4ZAVTc
         V+gRx/9Q+CFtSfF/ThB6k0OJerziikCZ3YGIZYfTqai63CBUGTibmYO1tyM7QfXjEIeT
         uVT6WwBHXJz4Xob/IvuE/GRQT3F4dIW4GOUHulisn/4x/kTBI3OAFE8ZAsEiwnV0L5Fh
         pbUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=CpowxPIs9WsIvTj4/MuMW1Y5/GmzHzBIUQWzh9qqtsQ=;
        fh=UQsDb1zcsZNg+AVFEIOQe2Qs/aqai2btYfo62PdRgk4=;
        b=Vqx46kyAc8/CmNxT0jj1lSI1fBWPUqE5IWqJrmlxO7P4jGPXyfDC1i5JTXocvr2n3F
         J7kBzyp5HMdMSTs6kc/PCJiSKkp+sHzBpdQ0ZuBNsUAgG2X6GR7DffmpMuT22exXnURI
         VlpR+UNMa8kx2zQnt3VomCPZ+nepv5cmYY6pzhmGxf5sD8oYwVfV8Kg34WzO3g4sWDp8
         3mceq63kRpBh6A3J7NV2skd/SMKaViBrO9IlG8feGdkvwE7yJwa9N1fWCRhP9kxBicF5
         fD9wtJYdfxYJ8FYir/gmB/ef1wmt3wTprAwo0MAD+8wCy9qpDp44Piqjz7cNLnu1g6Tq
         QJ0Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1769074545; x=1769679345; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CpowxPIs9WsIvTj4/MuMW1Y5/GmzHzBIUQWzh9qqtsQ=;
        b=WMmVf+cDPVXyzKm73nlXhVqX/GgwBPysyw+V8fdoMVElEaKbT5iIB+JX6bg1SMgNHp
         BZ/xpZLXmDtL49wkbLH6Qe5t/c1FlVbMBwB35Yj2bfbomiTfVmmlbRHxUoEZR/oQWck+
         Be74nd4grwTHoU8lZrxh7rK5Z11b36UuyBJ2+hjYl8aOJ18c08LpQdSkzjpNZL7dXtFS
         T9v9pdYZUJX2F6R2ZKeQUFJ7x2iA+DdPl0QupDzrrWAwUT1dVBgpkasAEVxZ/M05ccks
         CyBCrEYEw1asEPFNKbUBuBO1ZPFruijEtPlo7DqxHXrUhxmMxMlp5rmrVyWYwRFOfOVs
         sNLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769074545; x=1769679345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CpowxPIs9WsIvTj4/MuMW1Y5/GmzHzBIUQWzh9qqtsQ=;
        b=GhAxUn3dc2tniM/wRANjPF0uvCColB90OQj36mp//gpBBYP0wIQivvo6DjCh+Y/AKL
         dDTiTTdIv8ecRp8PK7bHpxo0hlsTidgSWsRwE2Io6et7q4WChcFKqHRcusX1S0xVqz5M
         9dNmLdeXzirBb5pI5qJJWrzOZSPOpP6rh+QA9xkn/8yXQqfhysKmkRVFyaIecgNItYf2
         au+Wdq3lpZIDVMwXOONt0NLAU3E3dolHXH7aOxX7ooC0gu7vwZeeE9OAxvv/X4EZKgTt
         y1OW8T9m2QUZJrH+j5c0SqUrH6OsJ+Vi8oN/NVBspOFsskZgVEWpoz3N0Bn2Jlh/VtwX
         ZhjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcy0MvLKr46UnBG3uLKwWKEYqBZSVVC+JAKZfoH/ic4ZMPGpCz4V6+aE0uijXBcMQWdXxqrWk8RPmEZZw=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx2SCjCcvQq0+sQDBups3JUZ5am1CBYKVR5QF9Xf7pxAXBejFL3
	A7cgvfSWr7lKVHAGaeSpt1PoqYEumFLCLPFErH+VwMBz5lOqlTk+mRhtUoK7GwmTGlMnrBZC0gy
	rs1l0m6hivgytLtmoXNcvSoofRuxaLiZlbZcquQWAtg==
X-Gm-Gg: AZuq6aK45lFnQ+yzZLQJLmkNqMrwL2rN0TBNqZGylIuqZIcgm5AmXdyFaGWCIkoYxju
	dcuAeUxaYF57b8EGpsL502xBr5es//uFArMkg9b8Fbg358W1E1RqLQUIMAmR0GoovRghdhXZINM
	RtEghjUqwsEY2wHaQ/YEpFgX5lta7drkC5g5+PQeYG6xIhZII0FPELLN1yh8i4Aq8Xfy8dGjKrl
	1fAU1aYk7ms6SjznnMpiTAc0/oGgXqELrNejv4b1ApZdEjr69HDZd+G2K6VR1486upF5wcO+3Tf
	lo/m3fXp3a5uV4CYdPYssDVj8vdJ0ajG3lvDEVznJRWqc0hR2K/NBGyQZ2UUMw==
X-Received: by 2002:a05:6402:f02:b0:658:1304:b68b with SMTP id
 4fb4d7f45d1cf-6581304b771mr3388171a12.15.1769074544348; Thu, 22 Jan 2026
 01:35:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115114021.111324-1-robert.marko@sartura.hr>
 <20260115114021.111324-7-robert.marko@sartura.hr> <CAD++jLmitNVhWmUf9BBqLR2_WsAR7V-+ykVJsLK3MuOSUKQF0A@mail.gmail.com>
In-Reply-To: <CAD++jLmitNVhWmUf9BBqLR2_WsAR7V-+ykVJsLK3MuOSUKQF0A@mail.gmail.com>
From: Robert Marko <robert.marko@sartura.hr>
Date: Thu, 22 Jan 2026 10:35:33 +0100
X-Gm-Features: AZwV_QgGcZewelkI3QjoxNf_Rdp39oV_bH_54mEjrqvn-sBMKJLuqze3gq5di5o
Message-ID: <CA+HBbNEw_9FNOFxx8Mo63Aq49MxWvvuQ4Sc75mXFYpwtMmETiw@mail.gmail.com>
Subject: Re: [PATCH v5 06/11] dt-bindings: pinctrl: pinctrl-microchip-sgpio:
 add LAN969x
To: Linus Walleij <linusw@kernel.org>
Cc: robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, 
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com, 
	claudiu.beznea@tuxon.dev, herbert@gondor.apana.org.au, davem@davemloft.net, 
	lee@kernel.org, andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, Steen.Hegelund@microchip.com, daniel.machon@microchip.com, 
	UNGLinuxDriver@microchip.com, olivia@selenic.com, richard.genoud@bootlin.com, 
	radu_nicolae.pirea@upb.ro, gregkh@linuxfoundation.org, 
	richardcochran@gmail.com, horatiu.vultur@microchip.com, 
	Ryan.Wanner@microchip.com, tudor.ambarus@linaro.org, 
	kavyasree.kotagiri@microchip.com, lars.povlsen@microchip.com, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	netdev@vger.kernel.org, linux-gpio@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-serial@vger.kernel.org, luka.perkov@sartura.hr, 
	Conor Dooley <conor.dooley@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 21, 2026 at 1:44=E2=80=AFPM Linus Walleij <linusw@kernel.org> w=
rote:
>
> Hi Robert,
>
> On Thu, Jan 15, 2026 at 12:41=E2=80=AFPM Robert Marko <robert.marko@sartu=
ra.hr> wrote:
>
> > Document LAN969x compatibles for SGPIO.
> >
> > Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> > Acked-by: Conor Dooley <conor.dooley@microchip.com>
> > Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
>
> Should I just merge this one patch to the pinctrl tree?

That would be great as other bindings are slowly being picked into
their respective trees.

Regards,
Robert
> Looks good to me.
>
> Yours,
> Linus Walleij



--=20
Robert Marko
Staff Embedded Linux Engineer
Sartura d.d.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr
