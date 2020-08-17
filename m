Return-Path: <SRS0=OEQH=B3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1256EC433E1
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Aug 2020 21:33:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D58632065D
	for <linux-crypto@archiver.kernel.org>; Mon, 17 Aug 2020 21:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597699990;
	bh=tvv3kaFlJ93NK3UtxjKDoSmhBbddX/0xNgSMiGn06V8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=YZUyOBid/WWX1IaCvDrkGkaw+LijiJJr4OI4rb/nY2fPtM8CWVXHOEP+em907zIcs
	 6pFHSRl/VdIYCjesDeKI7o392nb/v11PT/QX0fyGVUr/mLKbRvM507KMM5Zb9WpYdl
	 7Q/Ign2+/VU5CjAZdKans2eT4hDNiz6HJSmodYoE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgHQVdE (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 17 Aug 2020 17:33:04 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38467 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgHQVdD (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 17 Aug 2020 17:33:03 -0400
Received: by mail-io1-f65.google.com with SMTP id h4so19142698ioe.5;
        Mon, 17 Aug 2020 14:33:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LAtTEbaWNRnYp1UJl/edA6Ydg1sX3/eo18oG8QKPaWc=;
        b=dEkgGtOqXun88BYFpCAjO69N0Tw+/UBpzkdkwJmuaBTq1Rka/Ym2VeFBTG/XD/G5k8
         cjNgDRc7pECLHLxaSaqPxVn5fn6b/sTl0OBssaT46plEtnQ3ROxKplKVUhyUszAEQwH7
         MAiFTPVRhjpgpLdEEeiVqDmRZjOfZvjxLhtcFLiAZfsueCvyUqIns4sCN+ixdZJ2GDI/
         l2EaIn5/6do0pacm89nz1//kofyv0cG3rcYnFVLsCYfy9AaH419xCyvoyo5xy5tY4dbj
         jQ1azDgLNpjr1ZhcQ4d6mUPULfqGY/Q9la4ULnk6ZqD9Ux1wWXhisN9nhvtkuYO6AO5/
         cqGw==
X-Gm-Message-State: AOAM532g09ofhRC5qnN1Djm0FhkHSdu+Ubd7osA9B3ZJzIRIFFFnLxcC
        oibA0OkQgzRvy0nBD+5h9sDHAQ0flw==
X-Google-Smtp-Source: ABdhPJzrl+0ThCRPJ+9n/OwQEnkYXK+38CFOUdv8hQyI9cW1uvcBAbrkvuKEt3H7yHqe5dXwI9x8yw==
X-Received: by 2002:a6b:f719:: with SMTP id k25mr13744698iog.22.1597699982210;
        Mon, 17 Aug 2020 14:33:02 -0700 (PDT)
Received: from xps15 ([64.188.179.249])
        by smtp.gmail.com with ESMTPSA id t26sm10529749ilb.80.2020.08.17.14.33.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 14:33:01 -0700 (PDT)
Received: (nullmailer pid 1603662 invoked by uid 1000);
        Mon, 17 Aug 2020 21:33:00 -0000
Date:   Mon, 17 Aug 2020 15:33:00 -0600
From:   Rob Herring <robh@kernel.org>
To:     Anson Huang <Anson.Huang@nxp.com>
Cc:     kernel@pengutronix.de, shawnguo@kernel.org,
        s.trumtrar@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        Linux-imx@nxp.com, linux-kernel@vger.kernel.org,
        s.hauer@pengutronix.de, linux-crypto@vger.kernel.org,
        robh+dt@kernel.org, davem@davemloft.net,
        devicetree@vger.kernel.org, marex@denx.de,
        herbert@gondor.apana.org.au, festevam@gmail.com
Subject: Re: [PATCH 1/3] dt-bindings: crypto: Convert MXS DCP to json-schema
Message-ID: <20200817213300.GA1603573@bogus>
References: <1596595410-26921-1-git-send-email-Anson.Huang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1596595410-26921-1-git-send-email-Anson.Huang@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 05 Aug 2020 10:43:28 +0800, Anson Huang wrote:
> Convert the MXS DCP binding to DT schema format using json-schema.
> 
> Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
> ---
>  .../devicetree/bindings/crypto/fsl-dcp.txt         | 18 --------
>  .../devicetree/bindings/crypto/fsl-dcp.yaml        | 49 ++++++++++++++++++++++
>  2 files changed, 49 insertions(+), 18 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/crypto/fsl-dcp.txt
>  create mode 100644 Documentation/devicetree/bindings/crypto/fsl-dcp.yaml
> 

Applied, thanks!
