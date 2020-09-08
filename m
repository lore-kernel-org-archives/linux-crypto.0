Return-Path: <SRS0=6HzI=CR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AF6DC433E2
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 22:45:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DA6920936
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Sep 2020 22:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599605116;
	bh=cMnnOr763yvjfYwvjCco7OsSO5StUldVw62YA9uW+30=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=wElYW5pQdRqiktm5wRFJJ4nH39KKwkJYPxPtlx40ldeQNvygvvSSwxzqsBUV2JsKk
	 +YSVWpuyeMOERJ4QlVdYtmP0g7XPo8c027gnaWESuimGun+KzDLlCsRRW8UjXR7sL/
	 UFQKrCeXM57/6C4iT+/40oapD6An33d1AghRazGQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729397AbgIHWpN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Sep 2020 18:45:13 -0400
Received: from mail-il1-f193.google.com ([209.85.166.193]:39005 "EHLO
        mail-il1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730189AbgIHWpE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Sep 2020 18:45:04 -0400
Received: by mail-il1-f193.google.com with SMTP id u20so502694ilk.6;
        Tue, 08 Sep 2020 15:45:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=07txvhH2BG9OTM26xqF10Jb9n/MVeadsHz8mMrk5RNc=;
        b=r9tq+4p3DLlC0mYlgaB1FjO1Jf9kEbgEFkx0gmEboGi6WkQo3LjCWggH4IXeitB/O2
         pvnFkUC/iGvp9wTJTspFFDMKXqeA7QuWCKMZCdt1XrbU+Z2Ag0jcMRs4BT7/jOsSZ4yf
         T39gozMLLU31ftVkefZW783S8TRdR0szWr0AdIONlcA3az1EQZ+q2M86LhqREIN4etq0
         tozsipJwMXJlkMZgxsWy8Kaf40y9pFv+9Hm1UMcJxk7k3ZCxHyjWpBF5MUoFNBy9+3Ek
         hXAZ4+D0bWVQmMGgB4VFZvfh9CuoaRcJOe+nQt38qCz73zg/SXpO/XQnzyEmcJ6MztkJ
         FcOw==
X-Gm-Message-State: AOAM530egC6LtnTXCtGS1Gm7wOHRYr6KaHZjbiNJctOQJdOlCN8PeiLk
        5MvZ01mtH4vsPGUSP0NGPHCMm2Nrvs+s
X-Google-Smtp-Source: ABdhPJywKD+k64PZOFj9EqQgqrVi1nzsMnRUoIkBGOyK4D6OaCQbC4cTtJT4MD3CuAA4Rlxl+UQZVw==
X-Received: by 2002:a05:6e02:1086:: with SMTP id r6mr921919ilj.159.1599605103511;
        Tue, 08 Sep 2020 15:45:03 -0700 (PDT)
Received: from xps15 ([64.188.179.251])
        by smtp.gmail.com with ESMTPSA id e14sm298350ilr.42.2020.09.08.15.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Sep 2020 15:45:02 -0700 (PDT)
Received: (nullmailer pid 1075979 invoked by uid 1000);
        Tue, 08 Sep 2020 22:45:01 -0000
Date:   Tue, 8 Sep 2020 16:45:01 -0600
From:   Rob Herring <robh@kernel.org>
To:     Tero Kristo <t-kristo@ti.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        davem@davemloft.net, devicetree@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: crypto: sa2ul: fix a DT binding check
 warning
Message-ID: <20200908224501.GA1075868@bogus>
References: <20200825133106.21542-1-t-kristo@ti.com>
 <20200825133106.21542-2-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200825133106.21542-2-t-kristo@ti.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, 25 Aug 2020 16:31:05 +0300, Tero Kristo wrote:
> DT binding check produces a warning about bad cell size:
> 
> Documentation/devicetree/bindings/crypto/ti,sa2ul.example.dt.yaml: example-0: crypto@4e00000:reg:0: [0, 81788928, 0, 4608] is too long
> 	From schema: python3.6/site-packages/dtschema/schemas/reg.yaml
> 
> Fix this by reducing the address sizes for the example to 1 cell from
> current 2.
> 
> Fixes: 2ce9a7299bf6 ("dt-bindings: crypto: Add TI SA2UL crypto accelerator documentation")
> Reported-by: Rob Herring <robh@kernel.org>
> Cc: Rob Herring <robh@kernel.org>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Tero Kristo <t-kristo@ti.com>
> ---
>  Documentation/devicetree/bindings/crypto/ti,sa2ul.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Applied, thanks!
