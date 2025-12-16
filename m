Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FD023BF9B
	for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 16:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765904109; cv=none; b=eXug604sjePdMVilQ3US3PQCsyt+/RzoXV4PCXpg/6b71Uv0RON72484nAelrOBadED+brINSFozzzJ+P60ulDiuQu21NNGeFjF8x7UFvnNY+vnjXNIwWc+8Muo1R/r7HUkX4YZKDHX5HCNwHyKnmY/X2Jsw6MKg2gBT8I6xPqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765904109; c=relaxed/simple;
	bh=UN+I8vzJ8cwqizu/csjxQGAMQDSJQX7rflsi34zqodk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Rr13xKt2VBZ2uPclj7Wops51LLKU2Kl0lxrbCaO5OLQe5Sv7/OVbfiHHEv86XE5izL17tYIbiONXcrQsrNMnVlhY6b+kzbEYwPMv/W1MIbOyDOmZaGA23MRmT/L68RK94ng4b4n9z3IxNNiVBxmgOXBSPcZM7NztmXAb5iMCYmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr; spf=pass smtp.mailfrom=sartura.hr; dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b=p2nctEGS; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=sartura.hr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sartura.hr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sartura.hr header.i=@sartura.hr header.b="p2nctEGS"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-64175dfc338so6864283a12.0
        for <linux-crypto@vger.kernel.org>; Tue, 16 Dec 2025 08:55:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura; t=1765904106; x=1766508906; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UN+I8vzJ8cwqizu/csjxQGAMQDSJQX7rflsi34zqodk=;
        b=p2nctEGSNrBNH4w0gv/yBfai7zSBJT37Uc/6sCOChec1JnUq/nw1WTcH4vymi0Gysn
         AroI/pZ8T3uPg5QkGXajLuB2WTjrAnztoLvBwRjqyRxmsBdcDCAW7YCLK+qAy3YVpRm5
         0jIkBfTX0ws4dfu2mNth8gjTjWhMx2EZQOKy6QhhKNirbkDGS7qdWp8SyOJJBY5ST3/z
         gC/oZXzU3ZyGWPCk/JG9jpo9Vkqgmrtj44yEOluChgE7zG0ptlixUvmEO84b9YPhYhTg
         blywLMj7i/cbZeihiF4uHL5VtC3JYGC1MiBUPlqXRuBI1Jo8lJ3VlO+hLQD3TfNz6+g/
         TiLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765904106; x=1766508906;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UN+I8vzJ8cwqizu/csjxQGAMQDSJQX7rflsi34zqodk=;
        b=lWoTI55YHwQI422H9DpN0dUFuCjJmUkC7zYKWz1BsPmkfYOzdOJVl00Jm3Ikrt4Zr/
         K57y0Pa/y8Ac0+Msu/xg8YRKPx6SawsiEdy/UmkFAuUSI5/3UqmquBiJrz1bqBaA5AXP
         u+9IM51ZmPWjQjseSVK4Eh+7ku3RhZlmzXSMcMWqKfMAgSzSX1MNae+wdscguPkBIuCH
         wMTdwpGnJw3bYJ+z1xzqRCgpb6Wb5dRW5pVnzGmKDN2kdL790TReIEEm0YJYEV/aEbzH
         TD9b1MxcPSmYqDT6oFpC7gzSRSeZ9DlWEcDzB1lt8POMIo5swyYKfgQkaOcdZsoVylVG
         UhBg==
X-Forwarded-Encrypted: i=1; AJvYcCUM7q2Au+QpVPE1jKBQQwy4MTfOs920W3V6C0wyJ01QrQ0Y7Km819pU7myPvn0kvn5aQ86sWGAhI0dj8lE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxOkndWlJfaM+AMO/JRssq/O0sIlmLMHV3UgVoAS4ftXT9LlpQq
	KKfED8uvqZDiVG0gkpxYxoBKHn+VxORCtFFHn4OFGXRFLpwgJZB/GBMLDk8r0wCw8DUlUfaLeqW
	A3gOJLc93C2neBLQfmh27h/d/3BhPEAWptTT3CsbSRA==
X-Gm-Gg: AY/fxX4t6W7gWqqYizMS1xfaYrD4mKq/RasBXG4rFhhBQNT2lv1huggMTvuLVmFJdFT
	nEiXfYmyHaVSDOTZBRQFRdjtr1j2kWkllyvOwwI7h7Q5rSeU+pBgclZzSa84vYhjkae0YRG8juk
	zUVs5WCLv2RzJwa2cL0DLuCUMQJuVYtmullQhMIcBtZAqB9zp9+51LPr6D6DNZ0w3KP/eFxwZJw
	8z6KYsbyrfIaXFDPsHpoEOITMKJnz1j4bQUp1gwBxlz0VNS7Rnic9rkJr6uo2yWPPwUbPyB
X-Google-Smtp-Source: AGHT+IHss9Bd1xLNKBKVvo2auf8JouoGjNJ+pij6L9GBIFkYaw2yQJkBsu5mTJ8ApxjlWW3ipaEa8krFjlxvR+te8cI=
X-Received: by 2002:a05:6402:430c:b0:64b:3a8d:8f2f with SMTP id
 4fb4d7f45d1cf-64b3a8d8f4amr1282460a12.8.1765904105940; Tue, 16 Dec 2025
 08:55:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215163820.1584926-1-robert.marko@sartura.hr>
 <20251215163820.1584926-4-robert.marko@sartura.hr> <39d5371a-ed3e-4262-9cc9-e76c039f352c@kernel.org>
In-Reply-To: <39d5371a-ed3e-4262-9cc9-e76c039f352c@kernel.org>
From: Robert Marko <robert.marko@sartura.hr>
Date: Tue, 16 Dec 2025 17:54:55 +0100
X-Gm-Features: AQt7F2pB7VocjSO0euYm2JMWHk2AXNZHaLhwttYBwdz_DAq0CW2nlyHeH65guEQ
Message-ID: <CA+HBbNEsXG64L26S-78A4E9dUOnfdtTEQoifiv5Y16_oQeiiHw@mail.gmail.com>
Subject: Re: [PATCH v2 04/19] dt-bindings: arm: move AT91 to generic Microchip binding
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
	charan.pedumuru@microchip.com, kavyasree.kotagiri@microchip.com, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org, 
	dmaengine@vger.kernel.org, linux-hwmon@vger.kernel.org, 
	linux-i2c@vger.kernel.org, netdev@vger.kernel.org, linux-gpio@vger.kernel.org, 
	linux-spi@vger.kernel.org, linux-serial@vger.kernel.org, 
	linux-usb@vger.kernel.org, linux-clk@vger.kernel.org, mwalle@kernel.org, 
	luka.perkov@sartura.hr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 4:56=E2=80=AFPM Krzysztof Kozlowski <krzk@kernel.or=
g> wrote:
>
> On 15/12/2025 17:35, Robert Marko wrote:
> > Create a new binding file named microchip.yaml, to which all Microchip
> > based devices will be moved to.
> >
> > Start by moving AT91, next will be SparX-5.
>
>
> I don't understand why. Previous layout was correct.

Hi Krzysztof,

In v1, I sent the LAN969x series as a separate binding, but Conor then
requested that
they should be merged into a generic binding, and LAN969x added to the
generic binding [1].

[1] https://patchwork.kernel.org/project/linux-arm-kernel/patch/20251203122=
313.1287950-2-robert.marko@sartura.hr/

Regards,
Robert

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
