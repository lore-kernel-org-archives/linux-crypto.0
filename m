Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955B630B508
	for <linux-crypto@vger.kernel.org>; Wed, 31 Dec 2025 21:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767217104; cv=none; b=BN+wf6QP7ixYruA5SIS5MjKhjXQESLDe1rnfkK2Hd35Q5MoOaSmrFZcaEEybLVDRwT3IgyAOY2R3SfLycInqGYMgm+C8ixud4m64IdT35ZXQSXwEUp6AWlw7IhUPfHYkAE6DJ5K9aAsXOuzlqxbiTYvGpmV9BYaLYwV2AFSVhGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767217104; c=relaxed/simple;
	bh=bNI4moxHzlL6mKNWIZsVYWKbjwRce0cuGLHEF0rQIaQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hKSK9R3p4iovxrasra8xVM45fRknDTybaSkhbAbbQ8TWNKXXtpoK7eDSY5bQMCowy+1L9rSTEIsgtARUIJjtzqzLCHVd/5d5GgrgVW5JGVmqf1AdRicJJRTRLlqqtd64TDfstX2ewcw4Mjff113mCCBrFrbjIDOfXqvRh3+9LDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ud1JCDQ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ud1JCDQ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319E7C4AF0D
	for <linux-crypto@vger.kernel.org>; Wed, 31 Dec 2025 21:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767217104;
	bh=bNI4moxHzlL6mKNWIZsVYWKbjwRce0cuGLHEF0rQIaQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Ud1JCDQ6O191m3kYD44vkt1ShFs9vgo4JobjnhWd+evWDfkmkNYuJI5wcSNL4tWrL
	 0Z7WpJ+bn7kwco/mfx1YQUb+Cf2JEoE/aLmZRvF04wFMC+yaiiiu1Wrne8U3CLXW7m
	 rlf4vA2wklUadaJzq65C3YgpX5x29MdV+ltwo/Vd2zN8HofhUcqV8WbtJ0uksC688J
	 ++6tS4KWFBNxOPHIOXyel+T5t0WvUdmHTbHNbqpkG920NCyjtE7n4FDHgl2Y4TBj64
	 W6M7ykqRfovFexXy0AhEWH8mXR/2CkOb0cvGL234hY0g3gpG0VTXQnHhEZE4eY7Nqc
	 84vzL6TQKrNEA==
Received: by mail-yw1-f181.google.com with SMTP id 00721157ae682-7904a401d5cso16652497b3.3
        for <linux-crypto@vger.kernel.org>; Wed, 31 Dec 2025 13:38:24 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXGOYdxNQNOzeOUJTE9cxjuyLfY8qnAVB7jtFkvkD8NbfLqZVZYmkiaWFFnuq+aVl/dRolzD10stAU5A6k=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxz2/fJcBmeK27Kvugxq9rhj/p2HrQRBSZtQnRif3tdl4LgIxaL
	XIArE+Da1DfPtYLbxXoH2FGTePU9RFpQaE+936RuOtkMslGVysUMLjrVS4BSxPb9FFffLNHUOGR
	u+3g2qHl83M7n9Rl+gdW1Ag1Fjy4ZM0s=
X-Google-Smtp-Source: AGHT+IHGZ+h0d0MHZDCxvMCHygNM5e2LD8BSbr6KIbsOXsE3Z3p+Mpa0Okg+bD8neauLjOFoWJ8WBhGUbfiIcHde2OA=
X-Received: by 2002:a05:690c:90:b0:78f:a9e9:f784 with SMTP id
 00721157ae682-78fb3f5d4f4mr320728627b3.31.1767217103495; Wed, 31 Dec 2025
 13:38:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251211-dev-dt-warnings-all-v1-0-21b18b9ada77@codeconstruct.com.au>
 <20251211-dev-dt-warnings-all-v1-3-21b18b9ada77@codeconstruct.com.au>
In-Reply-To: <20251211-dev-dt-warnings-all-v1-3-21b18b9ada77@codeconstruct.com.au>
From: Linus Walleij <linusw@kernel.org>
Date: Wed, 31 Dec 2025 22:38:12 +0100
X-Gmail-Original-Message-ID: <CAD++jL=TXQyGD5nSdg37KK=OrUJDwi=2pXQciLr+udC9hjCVkw@mail.gmail.com>
X-Gm-Features: AQt7F2oBzR1qfgGQMAe5k9Xw2nDJvErMxOKzOVsHNn8uiB-Wg9Ho6D3OL063WYs
Message-ID: <CAD++jL=TXQyGD5nSdg37KK=OrUJDwi=2pXQciLr+udC9hjCVkw@mail.gmail.com>
Subject: Re: [PATCH RFC 03/16] pinctrl: aspeed: g5: Allow use of LPC node
 instead of LPC host controller
To: Andrew Jeffery <andrew@codeconstruct.com.au>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Joel Stanley <joel@jms.id.au>, linux-hwmon@vger.kernel.org, 
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	openbmc@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
	linux-mmc@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-iio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 11, 2025 at 9:46=E2=80=AFAM Andrew Jeffery
<andrew@codeconstruct.com.au> wrote:

> There's currently a wart where the Aspeed LPC host controller has no
> binding specified, but the pinctrl binding depends on referencing its
> node.
>
> Allow specification of a phandle to the parent LPC controller instead.
> Fall back to testing for a compatible parent node if the provided
> phandle doesn't directly resolve to the LPC controller node.
>
> Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>

Reviewed-by: Linus Walleij <linusw@kernel.org>

I guess when this is non-RFC I will just apply these two patches.

Yours,
Linus Walleij
