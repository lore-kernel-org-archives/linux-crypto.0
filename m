Return-Path: <SRS0=AsAY=B5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11798C433DF
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Aug 2020 22:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1A89207FF
	for <linux-crypto@archiver.kernel.org>; Wed, 19 Aug 2020 22:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597876660;
	bh=9CurXhWaSWGEy9gnoNnrjYaGBIZfnjd7kw1+vLuNXuA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=TifEJNvVIgzNzozk0QV8XDPiZIa/Z1LtV/sQSXLgA6zR1K6V2o8rV/dUZoqetorth
	 3ZFGray2KtJl2GIRSLsHtzlTQitWTf0kCM9G7XFhH+E8PE1xwoOB5lt+hdMFe59nUc
	 qCKB79FbKOt8Nh0Eux7jK/e5JAxtiwDjI/Lwz8Xg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbgHSWhg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 19 Aug 2020 18:37:36 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:33052 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726209AbgHSWhg (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 19 Aug 2020 18:37:36 -0400
Received: by mail-il1-f195.google.com with SMTP id r13so172230iln.0;
        Wed, 19 Aug 2020 15:37:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o5qA84rWrAEOCaZMFgVyYmX8nHeEhZoBGHX1NffFCVA=;
        b=Nc5A33IxqNjTzRl8/GxAyD/yhuouPmLLdWAxE71BKQ4+BtpAIY6MgX7cEr6sVDBgpT
         9B7JHq/bLE6IZGrdi61vt0q4s6bZ61EMxNb35UR3smR/GFXgrMMrpmOWM40kZi6vvydA
         CYOHnsiWAR8LPw20/WzK4ebfUa2xsr7SeY5v6F6FACYsDb3rE9CbXc0EK7Fj/HflqPzt
         DBxamwVmTFmYNnI1tHgQ5MG5hXUdY8fFlxsyHyi6AEcEuNZbJHhZpUot967I7TJ1rEUm
         1g2uLabSAdQN8j5pevaKSxwAEOYcAtwIhKDq9SIZY5TtsdRe3CwzauMkpK+RvO7sOpue
         mDtA==
X-Gm-Message-State: AOAM531W/4X0b0I6RZqTJ7DXVXhiJvtiZsYL6AVD7m22cbDJS17uKX48
        OBSn4FZ8aDtegZ18h91RcQ==
X-Google-Smtp-Source: ABdhPJxo7gtlvJgP9oAns2kIAfcL9UyMaa16qwyRQgiOPARY1thTlnNOXv83xs0qDABXRT29WgM76w==
X-Received: by 2002:a92:dd8c:: with SMTP id g12mr209066iln.184.1597876655178;
        Wed, 19 Aug 2020 15:37:35 -0700 (PDT)
Received: from xps15 ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id p77sm253335ill.39.2020.08.19.15.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 15:37:34 -0700 (PDT)
Received: (nullmailer pid 2089228 invoked by uid 1000);
        Wed, 19 Aug 2020 22:37:33 -0000
Date:   Wed, 19 Aug 2020 16:37:33 -0600
From:   Rob Herring <robh@kernel.org>
To:     Atte Tommiska <atte.tommiska@xiphera.com>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Mackall <mpm@selenic.com>, devicetree@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 2/3] dt-bindings: rng: add bindings for Xiphera XIP8001B
 hwnrg
Message-ID: <20200819223733.GA2088539@bogus>
References: <20200819122135.25316-1-atte.tommiska@xiphera.com>
 <20200819122135.25316-3-atte.tommiska@xiphera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200819122135.25316-3-atte.tommiska@xiphera.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 19 Aug 2020 15:21:34 +0300, Atte Tommiska wrote:
> Document the device tree bindings of Xiphera's XIP8001B-trng IP.
> 
> Signed-off-by: Atte Tommiska <atte.tommiska@xiphera.com>
> ---
>  .../bindings/rng/xiphera,xip8001b-trng.yaml   | 30 +++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/xiphera,xip8001b-trng.yaml
> 


My bot found errors running 'make dt_binding_check' on your patch:

/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/rng/xiphera,xip8001b-trng.yaml: 'maintainers' is a required property
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/rng/xiphera,xip8001b-trng.yaml: ignoring, error in schema: 
warning: no schema found in file: ./Documentation/devicetree/bindings/rng/xiphera,xip8001b-trng.yaml


See https://patchwork.ozlabs.org/patch/1347768

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure dt-schema is up to date:

pip3 install git+https://github.com/devicetree-org/dt-schema.git@master --upgrade

Please check and re-submit.

