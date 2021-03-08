Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F1EC433E0
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 21:53:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E72165253
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Mar 2021 21:53:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhCHVxF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Mar 2021 16:53:05 -0500
Received: from mail-io1-f54.google.com ([209.85.166.54]:39843 "EHLO
        mail-io1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231126AbhCHVwn (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Mar 2021 16:52:43 -0500
Received: by mail-io1-f54.google.com with SMTP id o9so11670279iow.6;
        Mon, 08 Mar 2021 13:52:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9kcVBHF9cG+tJeQFKjJmgmwtMVTvAiFINUmA15g/ad4=;
        b=n9zarCdoIEYQyzwTv6EvYbkVGGEpJjoEgfDvToHOuab7EhVKvnSgrIwSTkeKUkoykx
         sCeDtyGhhQWtE7XTU4/oJw3AyocwX3M/GevaLKifRqvVAG52VUUhHX5pPhuCY1z3Gt+K
         40ZLwpthSlfIAQusiarcO6G7Wz8RLUZ/fpe0zKcPyqc1lRwAdtwbXkAXnnWfn/35s5Na
         uifhWBH2VIO9I+VJmFOMCVqWPZWd2SGKcZgX5HKeAO179yvkygcQnm4dZO3lx5vU/pwD
         zvLswFXV5eVOPbDz2ukpj34qOtgdwwQnVTaVUgphLdDQHi8jErUcWjtNI+KNecA4fITo
         VNXQ==
X-Gm-Message-State: AOAM533mo1wrWYSlbzk7HMpU8eRSQU4+E7+JP8sWmsptgUV167yNVRqT
        MXj46HlIYk0sERQXPhjp5g==
X-Google-Smtp-Source: ABdhPJyedIMnANebfRsCpWxuPIn3WAySCJgBea8Yr3UdPlcu1P8XQ6uKRoQkShS2/dZTjyEi54o5xw==
X-Received: by 2002:a05:6602:26cc:: with SMTP id g12mr19262664ioo.169.1615240363270;
        Mon, 08 Mar 2021 13:52:43 -0800 (PST)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id k14sm6505568iob.34.2021.03.08.13.52.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Mar 2021 13:52:42 -0800 (PST)
Received: (nullmailer pid 3018316 invoked by uid 1000);
        Mon, 08 Mar 2021 21:52:38 -0000
Date:   Mon, 8 Mar 2021 14:52:38 -0700
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?=C1lvaro_Fern=E1ndez?= Rojas <noltari@gmail.com>
Cc:     linux-crypto@vger.kernel.org,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Matt Mackall <mpm@selenic.com>,
        linux-arm-kernel@lists.infradead.org,
        Alexandru Ardelean <alexandru.ardelean@analog.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-rpi-kernel@lists.infradead.org, Ray Jui <rjui@broadcom.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        devicetree@vger.kernel.org,
        Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
        Scott Branden <sbranden@broadcom.com>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH v6 1/3] dt-bindings: rng: bcm2835: add clock constraints
Message-ID: <20210308215238.GA3018261@robh.at.kernel.org>
References: <20210305070132.2986-1-noltari@gmail.com>
 <20210305070132.2986-2-noltari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210305070132.2986-2-noltari@gmail.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 05 Mar 2021 08:01:30 +0100, Álvaro Fernández Rojas wrote:
> brcm,bcm6368-rng controllers require enabling the IPSEC clock in order to get
> a functional RNG.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
> ---
>  v6: add new patch making clocks mandatory for BCM6368.
> 
>  .../devicetree/bindings/rng/brcm,bcm2835.yaml          | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
