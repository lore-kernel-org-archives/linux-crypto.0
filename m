Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25543659E9
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 13:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765978386; cv=none; b=MVwO12Z1DRDUi1TgyG1NK/8czegEaIhEXNcTZvqHhhlR5J8xTrFBf6r+oVvgMtYYfjUsKXwKWUCFnxbGSgcGbJbrph1vdevipM0yu+vI9wCSNMgzmXbJP69e4qtiJJwwY+/fKzl0rKmcLTMwrnxUEUr3j6wrsi7CkKlHbnEo3c8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765978386; c=relaxed/simple;
	bh=3NxV/sdr2BZyW6Fp6jeGvfWxTA5ctLtFaPPYKmOmWzs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CUB0bZ8j8An/lYOfMAJlupCvqbNf2Qax9b7QBG2ADpSDq1G33XFmb3JrM3RHOoLnbO20ijVbO6bYfH7zffqXFM9RyCmddOKKRh9RbezejqQS41N4C2LFTVWJZ7+q6/VTv/Qcm3d5JBNJZcsvP5r4c2/AnzzIgnBjuhMGRDXl5yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=G3TZwRs8; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="G3TZwRs8"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-644f90587e5so9814351a12.0
        for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 05:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1765978382; x=1766583182; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3NxV/sdr2BZyW6Fp6jeGvfWxTA5ctLtFaPPYKmOmWzs=;
        b=G3TZwRs8slika+uM8zA2b/tbxbmR9UD4zQjKjHTYFdQgFKQIvb5WcOE963ZZ02V0Mc
         qP0y3gHvcLeM0uzdbqcjgz/OUiak06hFqxxk2bqy9JyIuV+hWAOR+yfQT3/puygEdmcZ
         mSOwl2czqg7bWviUHQvoqfL2VNr6lSNSEKluYXqSdbSaAHT1yuKd6fpzL1rD93FYSdgq
         nGfR/UWTLwfs3EF6NQKalofoEucjD9bsNEEN4J8bADznJikY/0q8pziBBNcl66wb0YW6
         VefrjPLW58syX/GbFPK5ltyANGRw4PSWy3W4rvQNgVF5nVe6Cj7L6F0oCvRlAt9PVq8m
         SAHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765978382; x=1766583182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3NxV/sdr2BZyW6Fp6jeGvfWxTA5ctLtFaPPYKmOmWzs=;
        b=Gxr3irYFhgZvX7MeVy19tkA3zg6Bt3d1uS3BpqiHYp0sCGh7z+BQ8EYbsBgE8SImBb
         OK+fcMN29PlLOrJY9Wo+9rdDpffawxMiAi9KCKBxT79LsvII1uaJok2QI67bVrAbRBBh
         s5MOT+Ay4fwiK5Gs4U+ttvuIrVB+MhDeqAJYWDlIwMDtnew/YeWfl2WzLyPWpw8eqT/0
         IWeOnniUMZF8jkG5xiSS6+tY+8ORg5Ss/tcSu+LEztcfNIERd7JSTCaBWXaEACjrbbII
         I6DsoEux+kwlhJwpdC+5/oQDKyKdijdgpIhrMPygtPuloNc2lQhTbOG6TL7a6uAExebT
         vJdg==
X-Forwarded-Encrypted: i=1; AJvYcCWI/NXUD4+GJrawEPxCYSF72AOZ3RIyS0/fuSTlu5Uav/HJDs/M0rL+Rqf5ZFognYSJK6rS6cHnOcAouYQ=@vger.kernel.org
X-Gm-Message-State: AOJu0YwtuJj8+1ZmM0LoKRZ5odGP/Lj9zTmrS7rLh1sfPFGiE4mwXXnp
	YDe6sn6WHS2cCMHiJl/1rXxcqNc90M1Bc5cGDEGfUTo61n1IHzY/SLUo3P776lQ61Yyqe/Go05L
	wEPvK8hV8mSubrTW9TuXo2VBfzIz0tp2KpEhtzE//zQ==
X-Gm-Gg: AY/fxX4iW101kmoFUAFXAcC/rB8P3UbVjH5ZMPZFT1AJZVUqJIaPttcQ02Ii4MtWQS/
	VrAsUWz/XOB/x/gnu2xQw+m7Qu01Xw3aaGZvf1KzPJnxnsYAMkFts53NAHHhkEH3QRlYbMucMSn
	RydNHEWpaLPdpp/M1PprBJWxV1h+5/l4EoEbv3jhVP2o3eLFwvLZ5m7t6KAxIMzbLQIGvViIC6T
	eUSwQoYiWKuuS3oDFBbmeLcirwIb4yKeuAv3ahR45jUxebV5tSjF3yXDtQnnjE9UtSdXFtyKBb4
	//yBiH/Uc2YRTtNEg2aAqsePWV8XQEMG5YZ6IcT7CTMgX93Qn6qj
X-Google-Smtp-Source: AGHT+IHQBmS2mrQa3fgyiBBuz2kWHV24zlBwa/1NFFHKPKgWTqO46GlqIXXFCMupFuoXyMzVWH1kl/6iZAAmZg0kVsk=
X-Received: by 2002:a17:906:c39e:b0:b7f:e709:d447 with SMTP id
 a640c23a62f3a-b7fe709d458mr591500066b.33.1765978382116; Wed, 17 Dec 2025
 05:33:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215163820.1584926-1-robert.marko@sartura.hr>
 <20251215163820.1584926-5-robert.marko@sartura.hr> <fe15fcce-865a-4969-9b6f-95920fcaa5c7@kernel.org>
 <CA+HBbNGNMGRL11kdg14LwkiTazXJYXOZeVCKsmW6-XF6k5+sVA@mail.gmail.com> <3d6f254c-d53f-47d9-8081-8506d202bf9d@kernel.org>
In-Reply-To: <3d6f254c-d53f-47d9-8081-8506d202bf9d@kernel.org>
From: Robert Marko <robert.marko@sartura.hr>
Date: Wed, 17 Dec 2025 14:32:49 +0100
X-Gm-Features: AQt7F2p7AtghDvAyv4NK8Ascs8BHBx___HwB1JF-DX23awYiIEMyiUo7jk7sWyI
Message-ID: <CA+HBbNEKJ2qG4s51Gq9dh0uGuSwyPDfsq+mb5w6Kry6e9N0VSg@mail.gmail.com>
Subject: Re: [PATCH v2 05/19] dt-bindings: arm: microchip: move SparX-5 to
 generic Microchip binding
To: Krzysztof Kozlowski <krzk@kernel.org>
Cc: robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, 
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com, 
	claudiu.beznea@tuxon.dev, Steen.Hegelund@microchip.com, 
	daniel.machon@microchip.com, UNGLinuxDriver@microchip.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, vkoul@kernel.org, 
	linux@roeck-us.net, andi.shyti@kernel.org, lee@kernel.org, 
	andrew+netdev@lunn.ch, edumazet@google.com, kuba@kernel.org, 
	pabeni@redhat.com, linusw@kernel.org, olivia@selenic.com, 
	radu_nicolae.pirea@upb.ro, richard.genoud@bootlin.com, 
	gregkh@linuxfoundation.org, jirislaby@kernel.org, mturquette@baylibre.com, 
	sboyd@kernel.org, richardcochran@gmail.com, wsa+renesas@sang-engineering.com, 
	romain.sioen@microchip.com, Ryan.Wanner@microchip.com, 
	lars.povlsen@microchip.com, tudor.ambarus@linaro.org, 
	kavyasree.kotagiri@microchip.com, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-crypto@vger.kernel.org, dmaengine@vger.kernel.org, 
	linux-hwmon@vger.kernel.org, linux-i2c@vger.kernel.org, 
	netdev@vger.kernel.org, linux-gpio@vger.kernel.org, linux-spi@vger.kernel.org, 
	linux-serial@vger.kernel.org, linux-usb@vger.kernel.org, 
	linux-clk@vger.kernel.org, mwalle@kernel.org, luka.perkov@sartura.hr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 17, 2025 at 2:23=E2=80=AFPM Krzysztof Kozlowski <krzk@kernel.or=
g> wrote:
>
> On 16/12/2025 18:01, Robert Marko wrote:
> > On Tue, Dec 16, 2025 at 4:58=E2=80=AFPM Krzysztof Kozlowski <krzk@kerne=
l.org> wrote:
> >>
> >> On 15/12/2025 17:35, Robert Marko wrote:
> >>> Now that we have a generic Microchip binding, lets move SparX-5 as we=
ll as
> >>> there is no reason to have specific binding file for each SoC series.
> >>>
> >>> The check for AXI node was dropped.
> >>
> >> Why?
> >
> > According to Conor, it is pointless [1]
>
> You have entire commit msg to explain this. It's basically my third
> question where reasoning behind changes is not explained.
>
> When you send v3, you will get the same questions...

Hi Krzysztof,
Considering that instead of merging the bindings LAN969x will be added
to Atmel instead,
this will be dropped in v3.
Sorry for the inconvenience.

Regards,
Robert
>
>
> Best regards,
> Krzysztof



--=20
Robert Marko
Staff Embedded Linux Engineer
Sartura d.d.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr
