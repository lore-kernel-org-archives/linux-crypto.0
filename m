Return-Path: <SRS0=x16Q=X5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 672C8C47404
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 17:53:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F8A92084D
	for <linux-crypto@archiver.kernel.org>; Fri,  4 Oct 2019 17:53:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rqFfmPBj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388648AbfJDRxM (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 4 Oct 2019 13:53:12 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37192 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388880AbfJDRxM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 4 Oct 2019 13:53:12 -0400
Received: by mail-wm1-f66.google.com with SMTP id f22so6734395wmc.2;
        Fri, 04 Oct 2019 10:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SiYnbzF7WkjqWKJjUmGyqc1k8qogotE1jvdb1MCejmk=;
        b=rqFfmPBjt5rNehUrfCoog3sBIjQKw8DOTHfqANDdbh6jLSdp3Jt4BHH2BqNPxDJkPf
         X9GmB0XLf5OILRwmuglpo4UHl9sJPPoTlrXu6ADQEiAZEetGw2XgIlzniuQdX8DCAHje
         4USGkdxGIrdT0zkJ87uc27k538trG28T3Jo3c7cZE6FYXI40/vp3QY58vrjZGd7tCFBJ
         16gdzjIHv+UtYdOz1n2+9TbrnQfQYNT/a8cPNeyboqCehSOnkRQGg67jSRVJ3pIhxflF
         IY8/P91g35XLJfSnbnjHsfQW0c/ML1NcmgXpv6KFcWdfqjbcKsZ5yTQioEB+YWCTH+gM
         oWUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=SiYnbzF7WkjqWKJjUmGyqc1k8qogotE1jvdb1MCejmk=;
        b=LVnDQ04qMrZ5znamXsk/HkfKI5M5yN5FmBQ2m+fsvArUTyxCt5OQnnaHZzf9Y4DRpm
         CNui/c6GqE6JaKuxHY46KK03Cfl4EYcPjfkXgnYEv0+cmTBw7bWxyeIwoIQRz4CwB3lZ
         CVYc1TBA8DqOTqN+QajuRPH7ZZGQJaqXLhWfJILt04snSCEej4OthidIOihD10SZMI0J
         VbGEmxcJawtsOBZLnQ+N1HYbYdZkSj95MQyDDpcS29rHjQYiLv0X77SuMyuzYkj0ZsNU
         vcfBUxmVOmSPf1nxDo8Voz+5R3H/iERvRfJxtF2nJuzMeT3/dkKiX4lg+0nm/rXoruY/
         SK5A==
X-Gm-Message-State: APjAAAUZzjhueG2+H7/E3OYxfwKGPx+al/uAhDLGXTGt5FZ08w2sjQK8
        hHdX/wmTGdLq7EtZJ0Kb2do=
X-Google-Smtp-Source: APXvYqyyUV/AKwxAyN9TZuMCT9wd+X8T76PBdPNUsiucJS6dHYCgcxvSYkeRlQ7nwRaHVXmuaanUnw==
X-Received: by 2002:a05:600c:2252:: with SMTP id a18mr5967972wmm.141.1570211590660;
        Fri, 04 Oct 2019 10:53:10 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id e9sm17598865wme.3.2019.10.04.10.53.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 04 Oct 2019 10:53:09 -0700 (PDT)
Date:   Fri, 4 Oct 2019 19:53:07 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     catalin.marinas@arm.com, davem@davemloft.net,
        herbert@gondor.apana.org.au, linux@armlinux.org.uk,
        mark.rutland@arm.com, robh+dt@kernel.org, wens@csie.org,
        will@kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 03/11] dt-bindings: crypto: Add DT bindings
 documentation for sun8i-ce Crypto Engine
Message-ID: <20191004175307.GB11208@Red>
References: <20191001184141.27956-1-clabbe.montjoie@gmail.com>
 <20191001184141.27956-4-clabbe.montjoie@gmail.com>
 <20191002055458.zo2vdbxodj3ch53g@gilmour>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191002055458.zo2vdbxodj3ch53g@gilmour>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 02, 2019 at 07:54:58AM +0200, Maxime Ripard wrote:
> On Tue, Oct 01, 2019 at 08:41:33PM +0200, Corentin Labbe wrote:
> > This patch adds documentation for Device-Tree bindings for the
> > Crypto Engine cryptographic accelerator driver.
> >
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >  .../bindings/crypto/allwinner,sun8i-ce.yaml   | 92 +++++++++++++++++++
> >  1 file changed, 92 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
> > new file mode 100644
> > index 000000000000..9bd26a2eff33
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
> > @@ -0,0 +1,92 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/crypto/allwinner,sun8i-ce.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Allwinner Crypto Engine driver
> > +
> > +maintainers:
> > +  - Corentin Labbe <clabbe.montjoie@gmail.com>
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - allwinner,sun8i-h3-crypto
> > +      - allwinner,sun8i-r40-crypto
> > +      - allwinner,sun50i-a64-crypto
> > +      - allwinner,sun50i-h5-crypto
> > +      - allwinner,sun50i-h6-crypto
> > +
> > +  reg:
> > +    maxItems: 1
> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
> > +  clocks:
> > +    items:
> > +      - description: Bus clock
> > +      - description: Module clock
> > +      - description: MBus clock
> > +    minItems: 2
> > +    maxItems: 3
> > +
> > +  clock-names:
> > +    items:
> > +      - const: bus
> > +      - const: mod
> > +      - const: ram
> > +    minItems: 2
> > +    maxItems: 3
> > +
> > +  resets:
> > +    maxItems: 1
> > +
> > +  reset-names:
> > +    const: bus
> > +
> > +if:
> > +  properties:
> > +    compatible:
> > +      items:
> > +        const: allwinner,sun50i-h6-crypto
> > +then:
> > +  properties:
> > +      clocks:
> > +        minItems: 3
> > +      clock-names:
> > +        minItems: 3
> > +else:
> > +  properties:
> > +      clocks:
> > +        maxItems: 2
> > +      clock-names:
> > +        maxItems: 2
> > +
> > +required:
> > +  - compatible
> > +  - reg
> > +  - interrupts
> > +  - clocks
> > +  - clock-names
> > +  - resets
> > +
> > +additionalProperties: true
> 
> I guess you meant false here?
> 

Yes. i wil fix that.

Regards
