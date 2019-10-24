Return-Path: <SRS0=tzqc=YR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35AA4CA9EBC
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 09:31:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0ACBB20684
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Oct 2019 09:31:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XMP5pmUH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391353AbfJXJb0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Oct 2019 05:31:26 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37384 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732686AbfJXJb0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Oct 2019 05:31:26 -0400
Received: by mail-wr1-f66.google.com with SMTP id e11so16542774wrv.4;
        Thu, 24 Oct 2019 02:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6XIbW73y9ctw9e/3P96K5zJqGLVfoAK/VYWpXjJw2cg=;
        b=XMP5pmUHvn9M98uKH+J5MZT8v5M4PCWkjafEhZUbn3F2eeF1DOLIflDiDHyJWqq+/i
         F/KS6/w6gkyxjYy4l1Dv7ZDbB/wOtgXlNitmSlg6K4TDT4loDeB9xqdD1ZQJKyukOv8T
         bgaMQT0ZFy2X2EZl6fsDIhAbKc09Du3rC8ATq7cJQGkgC77uh+FmMiK50UuF9KBx/uBy
         LriRMp2Bdw7ekGE8Iccm2v1B4fthtqUgf9euw+nS9CmK5p0qQSDfD6EiLr1Mu3QJ5gw4
         V7G+qw9j6JUCU/RvlKTO6UPQezqdO8LRbeZ5ZMvG4w7bJ/iWsuczWeBRSd8k0DIh5XTo
         vrmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6XIbW73y9ctw9e/3P96K5zJqGLVfoAK/VYWpXjJw2cg=;
        b=CiwP7y7k14VuxCJ5lTL9GreR8eEtQkjC5REXUjvSwpOjzhKgsDcOo+yIC4SJO3z0as
         NRE/Kgj3XoK78Ad9CysCgQbj7S9jZ+R4xN7ekLBphMtUJjEbFz7ISqqE6AJZrYzY36/J
         /pQEJHu8Mqx7Ms7akg7hDgKWx98SBcthsdKMTYwAzi/WQbAu81DNdG6CnmdTlXOVEJ/e
         Oj7FyW6oR+w4u0zKjd7vY3QLoh6UxdpvRgfDVxcbidYJsDB4LHIwrayrjZNPM3LPo+M0
         Se/p7eap68tPrPw5gyX32gYqAEjGUbM3oaz2s2WnXs86UXGg60TJeX6YxUffd6GhaDjX
         K2vg==
X-Gm-Message-State: APjAAAW6X9Ohh+lZJAkQEZK0jkhgcp5Bsx7iR2T4KDnhMzsLcjrSJMzh
        p/bdfbOPMHjMTSZlBWxi7U8=
X-Google-Smtp-Source: APXvYqwZ8rjiLOJ/UB5QcbVNrlN7zQLDzi8Rcsr89hkCErMnGSUnJEExfdTvM7cc4w4Yj9zFIeYJLQ==
X-Received: by 2002:a5d:404d:: with SMTP id w13mr3037712wrp.185.1571909482912;
        Thu, 24 Oct 2019 02:31:22 -0700 (PDT)
Received: from Red (lfbn-1-7036-79.w90-116.abo.wanadoo.fr. [90.116.209.79])
        by smtp.googlemail.com with ESMTPSA id o6sm14733871wrx.89.2019.10.24.02.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2019 02:31:22 -0700 (PDT)
Date:   Thu, 24 Oct 2019 11:31:18 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, robh+dt@kernel.org, wens@csie.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH v2 2/4] dt-bindings: crypto: Add DT bindings
 documentation for sun8i-ss Security System
Message-ID: <20191024093118.GA15113@Red>
References: <20191023201016.26195-1-clabbe.montjoie@gmail.com>
 <20191023201016.26195-3-clabbe.montjoie@gmail.com>
 <20191024065005.hdypdl2dgqsrry5i@gilmour>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024065005.hdypdl2dgqsrry5i@gilmour>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 24, 2019 at 08:50:05AM +0200, Maxime Ripard wrote:
> Hi,
> 
> On Wed, Oct 23, 2019 at 10:10:14PM +0200, Corentin Labbe wrote:
> > This patch adds documentation for Device-Tree bindings of the
> > Security System cryptographic offloader driver.
> >
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >  .../bindings/crypto/allwinner,sun8i-ss.yaml   | 64 +++++++++++++++++++
> >  1 file changed, 64 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
> >
> > diff --git a/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
> > new file mode 100644
> > index 000000000000..99b7736975bc
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/crypto/allwinner,sun8i-ss.yaml
> > @@ -0,0 +1,64 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +%YAML 1.2
> > +---
> > +$id: http://devicetree.org/schemas/crypto/allwinner,sun8i-ss.yaml#
> > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > +
> > +title: Allwinner Security System v2 driver
> > +
> > +maintainers:
> > +  - Corentin Labbe <corentin.labbe@gmail.com>
> > +
> > +properties:
> > +  compatible:
> > +    enum:
> > +      - allwinner,sun8i-a83t-crypto
> > +      - allwinner,sun9i-a80-crypto
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
> > +
> > +  clock-names:
> > +    items:
> > +      - const: bus
> > +      - const: mod
> > +
> > +  resets:
> > +    maxItems: 1
> 
> The A83t at least has a reset line, so please make a condition to have
> it required.
> 

Hello

The A80 have one also, so I need to set minItems: 1
But setting both minItems: 1 and maxItems:1 lead to a check failure:
properties:resets: {'minItems': 1, 'maxItems': 1} is not valid under any of the given schemas

How to do that ?

Furthermore, I try to do that for interrupts and reg, since they are also mandatory and same failure.

> > +  reset-names:
> > +    const: bus
> 
> You don't need reset-names at all in that binding.

Fixed

Thanks
