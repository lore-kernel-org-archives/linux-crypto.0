Return-Path: <SRS0=pw/0=7L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701B3C433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 17:13:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42A292075A
	for <linux-crypto@archiver.kernel.org>; Fri, 29 May 2020 17:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1590772421;
	bh=JxDE/n0MpMfNbPEDKKXh+fAgJ5uh9CIJ/cNjMHBkatI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=fO+IjteH9kKvI581VvxHn0EGdQyXmTTStG+vQ8kX+qG+j2y2CO3w99lD+JGzbQ8TU
	 SGZxjks940lpotqCCtGTEw2MwE+BgUVk8MKQ7t+KajXWlZcdcrKuE/MFDB26tMG2tT
	 3FlyE1Pv7O4DzEbjdmtB2mIMdaS/ELlLV9QF/MFo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726954AbgE2RNk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 29 May 2020 13:13:40 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41298 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725601AbgE2RNk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 29 May 2020 13:13:40 -0400
Received: by mail-io1-f68.google.com with SMTP id o5so106848iow.8;
        Fri, 29 May 2020 10:13:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D1ZNjA/SwN8xaDiWG0YzoBxwmlWEy7BSXbZQ7tmqCJU=;
        b=j6ewV/uUSg43lgpo/GiYOJ1HGvNZPVo2yS9Ywu1zQMWwf+n1xW2NkCucGrOE/YBh5F
         fP1xETEAZ7gUuz4v+hwG7AYYXov/Q34Fsmnbi0xUIunVPl6zX/clZsFV1xHLoKQS3cPx
         ab0oHxS7zyQab3YeHcU/dzwYuLelJQmloZE8BZHC5apZrd1G3P7CSDiroixpBskq3wvg
         aefAxBDApP/P9RtTsSBrZdaYwpzao11a3JQEUaSg4bQc48JFfsP/M54xs8mIxVs2tF/m
         I6cNpydCLkSKIuqdfRPQXlL2HQBNvSb3Oq0SlIhUljh7sJFbzohwbgxq8xqLaWQ/O5KI
         wfKw==
X-Gm-Message-State: AOAM531ZTsbA9Nn7qH7u/1VQxJLNYCFRCHQbP7zKWZk6dhfweMyPX2wN
        XPMHV3Lxn5Ui4wmc7aA4oA==
X-Google-Smtp-Source: ABdhPJyjgELpUt1OGTBbdTi0c6PoBYEykHW19ny3K+tzC0jA583t16P71pw6bLlLAAUhxwkI6sup7A==
X-Received: by 2002:a05:6638:dd3:: with SMTP id m19mr8383035jaj.106.1590772417929;
        Fri, 29 May 2020 10:13:37 -0700 (PDT)
Received: from xps15 ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id d66sm4062915iof.27.2020.05.29.10.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 10:13:36 -0700 (PDT)
Received: (nullmailer pid 2588701 invoked by uid 1000);
        Fri, 29 May 2020 17:13:34 -0000
Date:   Fri, 29 May 2020 11:13:34 -0600
From:   Rob Herring <robh@kernel.org>
To:     Olivier Sobrie <olivier.sobrie@silexinsight.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        sebastien.rabou@silexinsight.com,
        Herbert Xu <herbert@gondor.apana.org.au>,
        devicetree@vger.kernel.org, Waleed Ziad <waleed94ziad@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/3] dt-bindings: rng: document Silex Insight BA431 hwrng
Message-ID: <20200529171334.GA2588610@bogus>
References: <20200525195606.2941649-1-olivier.sobrie@silexinsight.com>
 <20200525195606.2941649-3-olivier.sobrie@silexinsight.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200525195606.2941649-3-olivier.sobrie@silexinsight.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 25 May 2020 21:56:05 +0200, Olivier Sobrie wrote:
> This patch documents the device tree bindings of the BA431 hardware
> random number generator.
> 
> This IP is for instance present in the Viper OEM boards sold by Silex
> Insight.
> 
> Signed-off-by: Olivier Sobrie <olivier.sobrie@silexinsight.com>
> ---
>  .../bindings/rng/silex-insight,ba431-rng.yaml | 36 +++++++++++++++++++
>  1 file changed, 36 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/rng/silex-insight,ba431-rng.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
