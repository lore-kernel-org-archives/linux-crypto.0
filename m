Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A91B1C9EA3
	for <linux-crypto@vger.kernel.org>; Thu, 31 Oct 2024 18:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730400964; cv=none; b=D7SifBkPMTOQN6x7ECLfq8ZjlN8jCpD3ly/cI2TMP3t3Vy9fDJ8HFgi2TrXpU5jf9mqOQsx75nnUGQBxsoLh9Sw/17rBybZ380erXQiPEB3f/e1jAi/e/RNr9hT0IkvD6ZUR7YYHSdzoLUnrMy2aBm2Nzx9CMUljuayodBcV6HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730400964; c=relaxed/simple;
	bh=B4oTAhRHxTZv6woXYBjT10l0sPULFpxloGX1fSZnhFI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QSPpyYNjZUe/lSuS2mZ/FB/YWd9h80iSyE6fr5QkFx54gPCYL05QVJUDU44SvKcO6o6he4ohGhwhK+Rch8qEMWurkO8z96RZnlZoI+h1CXCUCtol7DkDxpaAGb7VI9/ltUFeX3bqzHYGCVkovuPf2SbLKNZh6gnKW3pYRT1T1Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=dB41oaQ+; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dB41oaQ+"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2e2bb1efe78so927603a91.1
        for <linux-crypto@vger.kernel.org>; Thu, 31 Oct 2024 11:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1730400962; x=1731005762; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=n9x1m1RYOM7X235H8PXZkpmXCy7V1cpMxA3l6ZbKlLA=;
        b=dB41oaQ+F4hOH5iV62YOarY2em20muXAUpP+rNjx/qnok74eVh9BTQAINHjVus1EG4
         6LxZqXP0aevOdGY9AgsiYmxf+qre6vk1jLu3kpotKu+nQNUr1nuaV6vKJSEFqnjRgJZY
         DilzQlL+vkRXrWmwDfTdYPNha8xbO3q1O6oqw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730400962; x=1731005762;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=n9x1m1RYOM7X235H8PXZkpmXCy7V1cpMxA3l6ZbKlLA=;
        b=OIE6iuK+S0N4UrFOpcWUpr51BGAGsNkQByFWLWPvhhgakS4Y+yjieSlC5cdY9zm2h3
         VjrXkMm9xM1SxXjZSck9rvZzZFe98a0CLh+KE/7UWT00nOi2X47bxVlfcaWUEzYoLYYN
         uPKB5u0keytCaUuZZIsPM7LsbZmIyGUjxbAikDiBpt15fznfPPii2HS7F0dRbwbBEQBz
         gDb70+Zje+ikNcMJVA+I6zEq9B84l1weyXJRi5iC2E8Nkpk0ZRsD3awRMKWTmhjotHs1
         vo0/FXfjKf+2RTDFD/KKP5sD+kGHE1mTJZZBR70fjFy++0O1Q0mO0XHkolZepjYVPCAL
         v1pg==
X-Forwarded-Encrypted: i=1; AJvYcCUbXMoKBUXIBL2RtnkI2EODiHyZHXI/c7BxnolF9rSHzIv/gGfWEnH9Uae38eOiptU2CfLH1n0ROkuG9gc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyIO3wzcUe0s6smqR4TE9poKqwzSbEtbGrCEBBV7T1EXDHZvfUR
	/dq/UR6GhnY4Lg9Tvg2Yg9/mr5dWZIksoOO0Tdr9FGPZvO93kMcu4GiMyBVD2GBsh8xX7mKZENb
	dDnA9e3nglqm/L3hmnRj3p/30UvqNl35ZlwzS
X-Google-Smtp-Source: AGHT+IGJpxj9d+x9ha4I4b3L3gglHusIK56TMkuuORxNw6XyB05oJPNEE+9L1slSzK08FESBEhhNbGUFCE1cpFuwIAc=
X-Received: by 2002:a17:90b:3a8d:b0:2e2:c1d0:68dc with SMTP id
 98e67ed59e1d1-2e94bdfa857mr1551852a91.9.1730400960308; Thu, 31 Oct 2024
 11:56:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-crypto@vger.kernel.org
List-Id: <linux-crypto.vger.kernel.org>
List-Subscribe: <mailto:linux-crypto+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-crypto+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241030213400.802264-1-mmayer@broadcom.com> <20241030213400.802264-2-mmayer@broadcom.com>
 <db7b7745-404d-45f7-a429-c1c747de8e6b@linaro.org>
In-Reply-To: <db7b7745-404d-45f7-a429-c1c747de8e6b@linaro.org>
From: Markus Mayer <mmayer@broadcom.com>
Date: Thu, 31 Oct 2024 11:55:48 -0700
Message-ID: <CAGt4E5ud=0rwSKBTOAsx0RMB3Pkjo+HHxZ_JLPBFbOSZUTCRVg@mail.gmail.com>
Subject: Re: [PATCH 1/2] dt-bindings: rng: add binding for BCM74110 RNG
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Aurelien Jarno <aurelien@aurel32.net>, Conor Dooley <conor+dt@kernel.org>, 
	Daniel Golle <daniel@makrotopia.org>, Florian Fainelli <florian.fainelli@broadcom.com>, 
	Francesco Dolcini <francesco.dolcini@toradex.com>, Krzysztof Kozlowski <krzk+dt@kernel.org>, 
	Rob Herring <robh@kernel.org>, Device Tree Mailing List <devicetree@vger.kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 31 Oct 2024 at 00:29, Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:
>
> On 30/10/2024 22:33, Markus Mayer wrote:
> > Add a binding for the random number generator used on the BCM74110.
> >
> > Signed-off-by: Markus Mayer <mmayer@broadcom.com>
> > ---
> >  .../bindings/rng/brcm,bcm74110.yaml           | 35 +++++++++++++++++++
> >  1 file changed, 35 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/rng/brcm,bcm74110.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/rng/brcm,bcm74110.yaml b/Documentation/devicetree/bindings/rng/brcm,bcm74110.yaml
> > new file mode 100644
> > index 000000000000..acd0856cee72
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/rng/brcm,bcm74110.yaml
>
> Filename as compatible.

I am not sure what you mean by this. That the filename should match
the compatible string? I did change the filename to
brcm,bcm74110-rng.yaml the ID to
http://devicetree.org/schemas/rng/brcm,bcm74110-rng.yaml# in response
to Florian's comment from yesterday.

> > @@ -0,0 +1,35 @@
> > +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/rng/brcm,bcm74110.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: BCM74110 Random number generator
> > +
> > +description: |
>
> Do not need '|' unless you need to preserve formatting.

Removed.

> > +  Random number generator used on the BCM74110.
> > +
> > +maintainers:
> > +  - Markus Mayer <mmayer@broadcom.com>
> > +  - Florian Fainelli <florian.fainelli@broadcom.com>
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - brcm,bcm74110-rng
>
> That's not what you have in DTS.

Fixed in the DTS to be "brcm,bcm74110-rng" everywhere.

> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +
> > +additionalProperties: false
> > +
> > +examples:
> > +  - |
> > +    rng: rng@83ba000 {
>
> Drop unused label.

Done.

I am giving it a bit more time for additional feedback (on the driver
and the binding) and will send v2 in a few days. Meanwhile, the
generated DTS (with the changes incorporated) is now looking like
this:

$ cat ./Documentation/devicetree/bindings/rng/brcm,bcm74110-rng.example.dts
/dts-v1/;
/plugin/; // silence any missing phandle references

/{
    compatible = "foo";
    model = "foo";
    #address-cells = <1>;
    #size-cells = <1>;

    example-0 {
        #address-cells = <1>;
        #size-cells = <1>;

        rng@83ba000 {
            compatible = "brcm,bcm74110-rng";
            reg = <0x83ba000 0x14>;
        };
    };
};

Thanks,
-Markus
