Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938672E0923
	for <linux-crypto@vger.kernel.org>; Tue, 27 Jan 2026 09:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769506377; cv=none; b=tJT1NsrcZfoiZS2B1sB7iYRhxCQaRmhZv/oSaKrdaIDL0nkoE17bLxypIIZXdcKkx7hl//+3RMwZgp6k/ovBv8Doa3L5EfFXDfC8fySzoxsOrFTwxvmbTQ9md9gACrzwSaRbkK2QxSTaojIBXJACjiKVRAI0pfOUHbbyZpXDSrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769506377; c=relaxed/simple;
	bh=nd4756Hy+92ohyhREHEr2ehaES7a+HF9kecPSnYoKRI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i6kWIG3Hau8uZvp+yQLqWA5EANVX9Uv6f1EMzawq8jRzbz7Yub7KLzXFFvL5bIHidOqUcqC7uLGF0OMX+dYb+nftt1BR4gXv7kZoFLIEDpihCJ4vO65s3Lh8qmJ4A5hgAM0Nh5k++EeMh/KkX21wXijXGnRhAzhdMCyX8D7Ccts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hqg/p5fw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hqg/p5fw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D92C4AF0B
	for <linux-crypto@vger.kernel.org>; Tue, 27 Jan 2026 09:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769506377;
	bh=nd4756Hy+92ohyhREHEr2ehaES7a+HF9kecPSnYoKRI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hqg/p5fwd0Wtm1K4HPBR20a0ZALUIPwJbR+HTRa2SE9d84XqA97XGZ0n5H7mZ/pdY
	 LrjP7i6moJ/1DKMh3Ytl3YLATfXpP09QgOljgvsJQY/IYIEHYWaCJWONYB5b1bsQdM
	 JVDDcg/mmFlM3swvNUuEodb70UKzeHAXzR3f3GWxzLI+QLDjCYFcH0etlakY+OErJj
	 UtNpdTSkGiffuXXOp+rivvZLqk7ewNp1ny7Vd5fcL9tYwhlehqrW4wLewQ5h4JslZ7
	 P2hD4a0YTZxIISfyde3jLLAOXwD7M0PnMd/pnnluIIr1/1vvlxzzehe1wM3o8X4nrE
	 rDvlKs0ndj1Zg==
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-79456d5dda4so22739337b3.2
        for <linux-crypto@vger.kernel.org>; Tue, 27 Jan 2026 01:32:57 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUUzoUPzaBonB8Wkv3h7EsXpdGTL7ceCmtnW3uYZAl3HjKa8gUnhnkCSbJVNJLndOC3Am6ChoMVow5BkNY=@vger.kernel.org
X-Gm-Message-State: AOJu0YyeKpphent6lk4fmwCv9cUZkqkUQPjpVjMatDQOz7aiIrBmDUZ0
	E+oa3+Q57NO81xLwffBzuWkp96tZViGClrXaco9+Db2u4WUdI1oaCJXHhOsWPOB0HUyu0CESKxS
	q9B1mlcvrjLH2up53wp+xdag11MvQl9Q=
X-Received: by 2002:a05:690c:fd1:b0:794:78ad:470d with SMTP id
 00721157ae682-7947ab40c1fmr16169877b3.27.1769506376440; Tue, 27 Jan 2026
 01:32:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260115114021.111324-1-robert.marko@sartura.hr> <20260115114021.111324-7-robert.marko@sartura.hr>
In-Reply-To: <20260115114021.111324-7-robert.marko@sartura.hr>
From: Linus Walleij <linusw@kernel.org>
Date: Tue, 27 Jan 2026 10:32:45 +0100
X-Gmail-Original-Message-ID: <CAD++jLn3pP4cdB3h5KN04Pn_v+XuvK6ROuxpNfJVhSRJpo2FUQ@mail.gmail.com>
X-Gm-Features: AZwV_QjPaAf4YpNWpzKIxLTu_1dAPvSU-dSWNUWnEkSR0mawzeMGDcKYjAjufcE
Message-ID: <CAD++jLn3pP4cdB3h5KN04Pn_v+XuvK6ROuxpNfJVhSRJpo2FUQ@mail.gmail.com>
Subject: Re: [PATCH v5 06/11] dt-bindings: pinctrl: pinctrl-microchip-sgpio:
 add LAN969x
To: Robert Marko <robert.marko@sartura.hr>
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

On Thu, Jan 15, 2026 at 12:41=E2=80=AFPM Robert Marko <robert.marko@sartura=
.hr> wrote:

> Document LAN969x compatibles for SGPIO.
>
> Signed-off-by: Robert Marko <robert.marko@sartura.hr>
> Acked-by: Conor Dooley <conor.dooley@microchip.com>
> Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>

This patch 6/11 applied to the pinctrl tree!

Yours,
Linus Walleij
