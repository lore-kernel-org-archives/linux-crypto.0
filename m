Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11846338F38
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 15:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765985862; cv=none; b=MhaR0d5G6I8uzW6zwlNwXfHB3MRNKWM/J2aS7rczvV0+rzER5P2Jk8jjIPpAHbTi7AvywbqO1aT/1gwj1flHbHAv4sLxmKFMy48aShL9estHO8O+atBLmwBx7g1f7HkfKocm3Je8rmu5/knDnOnTl22xRS9WShte6vzNTW64yIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765985862; c=relaxed/simple;
	bh=3zWGgAak/FBm7Vkk94ZrLytELeHbedaeePRas4C5o5A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ATUwgId1BZmtG3uAIjtwkijS/45DrljwzfBPHbskp9WHy4kszOyexDZdrHtAm8h/37psUFj3uboi60g2/lzUI+ubETlsVN720wI+zhfwl1/Gd/YZvkx6miRtiJOLra3RF3EH12m3DFwmvO75PuIDkDqwmBvpRBfuwoTMuP5AU2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hMNPbQfH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMNPbQfH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FC9C19425
	for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 15:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765985861;
	bh=3zWGgAak/FBm7Vkk94ZrLytELeHbedaeePRas4C5o5A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hMNPbQfHkiOGVqJHw5AtuOCvRV0FWKVO23ESw20F2cpxcqWTBIOhlBqGNkwequi0i
	 3oeUmzcEgHgSCtPoeLi5W9KvVXmE1VGX7UUnHrN1mtR68GvWl08uXF7HTsH54i7ZE9
	 KfYRP9/8MnbbeqwSYkqRzywXs1Oee8xupqaf+a3s5LDAgTLnveEoDXptQ80gqAbzq5
	 bjMNZezJ7p4GnTY2AwYJ0eq5AHSinGdYScOtbFN/Adxv8qepgBFrnvzwv9d+LJGjra
	 iG70B1IeKSjTYdQQgNkT1NrvCLmUQmuqa9VxS8bv5ivZq+pOTD21TTRtZYR98YCKkC
	 GNKlOB4AN3+tA==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b8010b8f078so103139866b.0
        for <linux-crypto@vger.kernel.org>; Wed, 17 Dec 2025 07:37:41 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWHaAlKJogDe/1pclzwfO9hSziX/RlSW88aOxEntB1AXUt76lcS7Jr4SW0Nldd+CqKkWJ8Njm3hw48Bb4U=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx9YjvMWlRT8C926eVEXHf639aOpKEbWZp5Ay2Cg2K0Suj8XQt1
	0Wohpkjl9zNpNuJW+SEX3WPAU1n2O/+XfK6r3Hf4h8aq5w2UcMUyQJfOUCnKlyv/tLp3F88JnAC
	lPJ1Ubs6eWbjf2zG51VAKUzNwsFl3qg==
X-Google-Smtp-Source: AGHT+IE+MbpVy0D9cI7vtayEcuAQ5BpKDVDav3dQlj552I/4svzEpwf9VDtWU/NeRoVokGuFNkCPT8ATPD0NU91eNy8=
X-Received: by 2002:a17:907:3cca:b0:b72:c261:3ad2 with SMTP id
 a640c23a62f3a-b7d23af00e6mr1859042566b.50.1765985860268; Wed, 17 Dec 2025
 07:37:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251211-dev-dt-warnings-all-v1-0-21b18b9ada77@codeconstruct.com.au>
 <20251211-dev-dt-warnings-all-v1-1-21b18b9ada77@codeconstruct.com.au>
In-Reply-To: <20251211-dev-dt-warnings-all-v1-1-21b18b9ada77@codeconstruct.com.au>
From: Rob Herring <robh@kernel.org>
Date: Wed, 17 Dec 2025 09:37:28 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJUaKKsJ8BCNbVXe4vLVsQ2Av7VuWqf9DnUKHeLzLb8NQ@mail.gmail.com>
X-Gm-Features: AQt7F2q-nb9Xy6ZmXCdkQqrO-_0mpnqJ_RWJ9ZzKv3sOBl98lQ-TH7L8rvtaBLo
Message-ID: <CAL_JsqJUaKKsJ8BCNbVXe4vLVsQ2Av7VuWqf9DnUKHeLzLb8NQ@mail.gmail.com>
Subject: Re: [PATCH RFC 01/16] dt-bindings: hwmon: Convert aspeed,ast2400-pwm-tacho
 to DT schema
To: Andrew Jeffery <andrew@codeconstruct.com.au>
Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Linus Walleij <linusw@kernel.org>, Joel Stanley <joel@jms.id.au>, linux-hwmon@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	openbmc@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-iio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2025 at 2:46=E2=80=AFAM Andrew Jeffery
<andrew@codeconstruct.com.au> wrote:
>
> From: "Rob Herring (Arm)" <robh@kernel.org>
>
> Convert the ASpeed fan controller binding to DT schema format.
>
> The '#cooling-cells' value used is 1 rather than 2. '#size-cells' is 0
> rather 1.

Okay, I can't figure out why I thought '#cooling-cells' needed to be 1
here. I don't see that anywhere in the tree. The driver for sure only
supports 2, so anything that's not is an error in any case.

> Some users define more that 8 fan nodes where 2 fans share a PWM. The
> driver seems to let the 2nd fan just overwrite the 1st one. That also
> creates some addressing errors in the DT (duplicate addresses and wrong
> unit-addresses).
>
> Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
> Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>
> ---
>  .../bindings/hwmon/aspeed,ast2400-pwm-tacho.yaml   | 106 +++++++++++++++=
++++++
>  .../devicetree/bindings/hwmon/aspeed-pwm-tacho.txt |  73 --------------
>  2 files changed, 106 insertions(+), 73 deletions(-)
