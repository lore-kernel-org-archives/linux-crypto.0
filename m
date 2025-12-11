Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4C927280C
	for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 11:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765452745; cv=none; b=Og8tgS1NWPJbHtZUlREWd6fHkGfU0zI+6JBJU/gSSpMrIsBVyQLCR7ZOarIS7C7uyvtQ/1/U2tX2OOBGDTa5VOn9qBbZNXAGTMznkcKeFHzELfndbTCIUAxaahiCy29XnsnQNP0AZJDqB1TCR343OcFOTLJhx9YdzbfLzUH/9sA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765452745; c=relaxed/simple;
	bh=fTSH993Mk+TXcNH7gBcDzv8X8Zy3Ya7TfMmE6MvGpFc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MB4z1pF1mcvT93FEcx8ouR23cZ4Wbl0YoRp4JGuUoUi6i+zjoJhqdJ4LRmuxsYaEXKQ4gKApznw36ddRrg/LFc05b6kvgFqPp+VF8qTCSWcRhCWQQupaXcz//exoUxv0SOxoWQgTXpNEKOSv3XAiLHGBQxQf4hb6pAAzhRqNKZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=JqjYI0+Q; arc=none smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="JqjYI0+Q"
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6420c0cf4abso817921d50.1
        for <linux-crypto@vger.kernel.org>; Thu, 11 Dec 2025 03:32:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765452742; x=1766057542; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=phiy9ied8gdfxveKkebHqanag2hE7Otb50tt4bxl1+s=;
        b=JqjYI0+QfCo2XJtf6glhKa4oS63fM3EiwnAyqO6fTI6BPzirD8QQyM48d/AjqlE5ni
         olrWKVMLmfSuw93+pIqY5JAs7SerzbNm2dv6TfsSzoUjHr7PQURGgJ+nDJiVPl3xx+Ht
         RyKElP1puHDfVaeIp94/WkUNFhMX2hG2Ffl68cgargk44w5ddzae5456iRqF8yaeS5wk
         1S+F/0+PhyVM4URNyoPHK1fCsp66FOQI0z8deC6xLLqYD60Z+F9TRohmLaufyDOlOxfH
         8YF980pLwUbReSRDgr3F7kC9SdQMEtWwVKlsPlFElx2xxfTWbXw5GXr0Q90dgOrqZuis
         1y6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765452742; x=1766057542;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=phiy9ied8gdfxveKkebHqanag2hE7Otb50tt4bxl1+s=;
        b=UitmSgng8mKMSS7ytERPDhrmW96UmLhVEP8F1f9M3xy8PEP91RCK7yesGxPjRWLJVl
         1/H7h7YOPmW8Nzzeb77QxDTsuZL/x84AkFYhuno2ipb0RzOJIJosO/Wk21fah8S6fpbP
         shR7+B6xre55ioUPRqEGDFld67oTKezpJof2KbDywGO4SXoPJV4IIKzW/PEqiMyhq+oz
         3rX/57uYWYAJuLvFom5uE3jIRshOMFti0YL0ZvkzmsLbzHox6JDQdtSklzBCwhpmba8k
         L9QdZnDtHIvDafXpVAmCWCuIYEDG4AxQzkcLDnzg1hGZTDraAfhGCsuLLrjR4oBEUunk
         +dxg==
X-Forwarded-Encrypted: i=1; AJvYcCV9xNU/LOFfcpraEzbdmrelG5N+GnfirFBKjqkeTN/YcAFt0V6/uTOCyjxuj/+xl8/vb/nulbcMNYkXeYU=@vger.kernel.org
X-Gm-Message-State: AOJu0YydSHEiMwYI0Ck5CzyukK+6vmVWfJ4SvdQMeQ9vhOKZf28+j9Aj
	lgvW6/YU6rCpkPdSWzLVIFByK7mlSaZA69720bRZ/PKVHhFkLCuRoUw5ja7gRsNfZGJxSCdiNyI
	4ss/2Z9+mi/c2+netJ9O/iQe2G486/0vsR4UkgD2u+Q==
X-Gm-Gg: AY/fxX4bS0EmZ0PgyhkOr0jp+XvqJSWRSjSIsA4Oe+LeCNh9Nkdj5W0Z8f+qoqsQDx/
	hPx1QUvL2GfMSrr6JtdnKAKopN4VkazAX7pSSwoEa9l6b2xWJfQf5NGNt3p9WCbXD3MRN/gXgDg
	PxwPKxlWUEm/lPzA6l6QyYk1TPxV9KE01c5w5+CM2V4M1Kt+m4Z/pFTJy9TbKjT5zDEgPo1RV6s
	an4oaKnDq7M4FJK1H2FVquyUMKVeOHcoOWoTTJVStRPU20dtJFRevnh1uxGKjmfsLixeObY
X-Google-Smtp-Source: AGHT+IGcqwaxtfJMJnD56RcASi/uVKO/lK/0JnQ8qMBQTGtHR3OnnoyAdnC7R6PIycF4XsJLibnnvktvbwIlYjUAVZY=
X-Received: by 2002:a05:690e:120e:b0:63f:96d7:a350 with SMTP id
 956f58d0204a3-6446eb4a92cmr4347837d50.66.1765452742333; Thu, 11 Dec 2025
 03:32:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251211-dev-dt-warnings-all-v1-0-21b18b9ada77@codeconstruct.com.au>
 <20251211-dev-dt-warnings-all-v1-7-21b18b9ada77@codeconstruct.com.au>
In-Reply-To: <20251211-dev-dt-warnings-all-v1-7-21b18b9ada77@codeconstruct.com.au>
From: Ulf Hansson <ulf.hansson@linaro.org>
Date: Thu, 11 Dec 2025 12:31:45 +0100
X-Gm-Features: AQt7F2oiHWORIK5IUrdndTpX-opjO6A0dESgetC9ddqm2QKKAaLxTanuvA5lEio
Message-ID: <CAPDyKFqZQUurBNSNUBKE7rgBf+UHxKiYBWt+xxSY+dh7PgdPPQ@mail.gmail.com>
Subject: Re: [PATCH RFC 07/16] ARM: dts: aspeed: Remove sdhci-drive-type
 property from AST2600 EVB
To: Andrew Jeffery <andrew@codeconstruct.com.au>
Cc: Rob Herring <robh@kernel.org>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Conor Dooley <conor+dt@kernel.org>, Linus Walleij <linusw@kernel.org>, Joel Stanley <joel@jms.id.au>, 
	linux-hwmon@vger.kernel.org, devicetree@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-aspeed@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org, 
	linux-gpio@vger.kernel.org, linux-mmc@vger.kernel.org, 
	linux-crypto@vger.kernel.org, linux-iio@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 11 Dec 2025 at 09:47, Andrew Jeffery
<andrew@codeconstruct.com.au> wrote:
>
> The property isn't specified in the bindings and is not used by the
> corresponding driver, so drop it.
>
> Signed-off-by: Andrew Jeffery <andrew@codeconstruct.com.au>

FWIW:

Reviewed-by: Ulf Hansson <ulf.hansson@linaro.org>


> ---
>  arch/arm/boot/dts/aspeed/aspeed-ast2600-evb.dts | 2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/arch/arm/boot/dts/aspeed/aspeed-ast2600-evb.dts b/arch/arm/boot/dts/aspeed/aspeed-ast2600-evb.dts
> index de83c0eb1d6e..3eba676e57f1 100644
> --- a/arch/arm/boot/dts/aspeed/aspeed-ast2600-evb.dts
> +++ b/arch/arm/boot/dts/aspeed/aspeed-ast2600-evb.dts
> @@ -314,7 +314,6 @@ &sdhci0 {
>         status = "okay";
>         bus-width = <4>;
>         max-frequency = <100000000>;
> -       sdhci-drive-type = /bits/ 8 <3>;
>         sdhci-caps-mask = <0x7 0x0>;
>         sdhci,wp-inverted;
>         vmmc-supply = <&vcc_sdhci0>;
> @@ -326,7 +325,6 @@ &sdhci1 {
>         status = "okay";
>         bus-width = <4>;
>         max-frequency = <100000000>;
> -       sdhci-drive-type = /bits/ 8 <3>;
>         sdhci-caps-mask = <0x7 0x0>;
>         sdhci,wp-inverted;
>         vmmc-supply = <&vcc_sdhci1>;
>
> --
> 2.47.3
>
>
