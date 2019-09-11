Return-Path: <SRS0=VsuX=XG=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECD5BECDE20
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 18:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C5011222BE
	for <linux-crypto@archiver.kernel.org>; Wed, 11 Sep 2019 18:32:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jmgDd6/9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729859AbfIKScD (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 11 Sep 2019 14:32:03 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:54628 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729867AbfIKScD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Sep 2019 14:32:03 -0400
Received: by mail-wm1-f67.google.com with SMTP id p7so4647875wmp.4;
        Wed, 11 Sep 2019 11:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6Te7QE2Q2g9STJbNhhZtv5SiHSyMZyM+FEre3Dz6O8Y=;
        b=jmgDd6/90ZK/KSjOdrNqJAxGaDbwNjQJv5BWKzzKlM6LwUpEtBrZ4S/M6pY1Y2zwVV
         SYnUdgL2vXoRYvJP69g7kRU8ygDsin0HwQX37zUefUMQVvvH3BAdctndGQ6ajD6V9/p7
         B1LcD9Q7jXCDeUw1PxdEbcIiApu7ZJyDqkv7hu7B4b4A8tl+7W7n43Ja8y2XVNmsXXPi
         2JPPtO9FTxf2qhFuv126oXjMVF1OO2LnELKexrwxJc+me24+3CWUCeR0oF52zerphQst
         zBF8s+lLPpx4Eftb2S04xTlTUUEcd1SSmuWlDD040Yc/OoyaxfqGL0I2+/RiA08WTukU
         7idQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6Te7QE2Q2g9STJbNhhZtv5SiHSyMZyM+FEre3Dz6O8Y=;
        b=AvqMrVhdS+y4k2C+F5j8z4JWxoLuQ63V3BSHwamMbVV7UasN7S4lm5KuwJZ5+NEGDW
         4jeTheYzQGcQXWOKsuc0Km+2I5hwTU8Qg+gkCpLC0uJ8NUmujgWs3E5ErSslV0jLAT67
         sec5ORsNSD0vOMPDkSmhqizV6yP492n3zhXErfanD94eENa/tj4LLdqRGSzS7vdymQKE
         GXFh7JGCmdaRjyoxmyDXccC7l5iHa+UTgqdtNHaaqt9DyjujOU6KkudIMUQJ1OWb7Hn5
         JxF4a24WXo3wOCoFc0jYIddhZDcu4C5AOSrhn1Pc9rYRdFLzJ/+Lbug7710/xZjWgF02
         Ri4w==
X-Gm-Message-State: APjAAAX1U2UPwYUFt3Gyx0A8KRZVZtkDqNouNaLI/VJs2nwBXlpSEQPi
        zz7IU+ylV2yYPQybjEDJKiI=
X-Google-Smtp-Source: APXvYqxLgk2nQMwVb7p2dfq9uG3VnutIy2nbjXTYamMxfezNSLjPILVR6BBa3EVv43hysi/02tOp5Q==
X-Received: by 2002:a1c:5451:: with SMTP id p17mr5092099wmi.103.1568226721265;
        Wed, 11 Sep 2019 11:32:01 -0700 (PDT)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id i9sm5162622wmf.14.2019.09.11.11.31.59
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 11:32:00 -0700 (PDT)
Date:   Wed, 11 Sep 2019 20:31:58 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        linux@armlinux.org.uk, mark.rutland@arm.com, robh+dt@kernel.org,
        wens@csie.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com
Subject: Re: [PATCH 3/9] dt-bindings: crypto: Add DT bindings documentation
 for sun8i-ce Crypto Engine
Message-ID: <20190911183158.GA8264@Red>
References: <20190906184551.17858-1-clabbe.montjoie@gmail.com>
 <20190906184551.17858-4-clabbe.montjoie@gmail.com>
 <20190907040116.lib532o2eqt4qnvv@flea>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190907040116.lib532o2eqt4qnvv@flea>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Sep 07, 2019 at 07:01:16AM +0300, Maxime Ripard wrote:
> On Fri, Sep 06, 2019 at 08:45:45PM +0200, Corentin Labbe wrote:
> > This patch adds documentation for Device-Tree bindings for the
> > Crypto Engine cryptographic accelerator driver.
> >
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >  .../bindings/crypto/allwinner,sun8i-ce.yaml   | 84 +++++++++++++++++++
> >  1 file changed, 84 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ce.yaml
[...]
> > +else:
> > +  clocks:
> > +    items:
> > +      - description: Bus clock
> > +      - description: Module clock
> > +
> > +  clock-names:
> > +    items:
> > +      - const: ahb
> > +      - const: mod
> > +
> > +  resets:
> > +    maxItems: 1
> > +
> > +  reset-names:
> > +    const: ahb
> 
> This prevents the usage of the additionalProperties property, which
> you should really use.
> 
> What you can do instead is moving the clocks and clock-names
> description under properties, with a minItems of 2 and a maxItems of
> 3. Then you can restrict the length of that property to either 2 or 3
> depending on the case here.
> 

Hello

I fail to do this.
I do the following (keeped only clock stuff)
properties:

  clocks:
    items:
      - description: Bus clock
      - description: Module clock
      - description: MBus clock

  clock-names:
    items:
      - const: ahb
      - const: mod
      - const: mbus

if:
  properties:
    compatible:
      items:
        const: allwinner,sun50i-h6-crypto
then:
  properties:
      clocks:
        minItems: 3
        maxItems: 3
      clock-names:
        minItems: 3
        maxItems: 3
else:
  properties:
      clocks:
        minItems: 2
        maxItems: 2
      clock-names:
        minItems: 2
        maxItems: 2

With this, the dtb_check keep complain that a64 have two short clocks.

Regards
