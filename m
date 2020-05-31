Return-Path: <SRS0=zu7D=7N=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4596BC433E1
	for <linux-crypto@archiver.kernel.org>; Sun, 31 May 2020 09:21:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2389B20707
	for <linux-crypto@archiver.kernel.org>; Sun, 31 May 2020 09:21:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PCwsA+xG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgEaJV5 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 31 May 2020 05:21:57 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:55456 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725860AbgEaJV5 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 31 May 2020 05:21:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590916915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ywTf4qZlZwxY3+4hdzNIdEQ5uHrIZLnoqwJn0ChNVtk=;
        b=PCwsA+xG8WKxm8E64o6JLhiCH5qqMmi4ft1HxNicoJI75RdxTZTpSBlv3LGdZLRSSPlw2d
        7yABzbDVZ6tku9AcHde7k1ffxekQ1pDb7BOVo3RQ2QnFoPbXUH/11DE+ClvU9ZNwz6IBz7
        jvLsE5ohO5sG3XNy+/4og8Av1f87Rxg=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-YPV8FgZiPr6MugiN7cI5kg-1; Sun, 31 May 2020 05:21:53 -0400
X-MC-Unique: YPV8FgZiPr6MugiN7cI5kg-1
Received: by mail-wm1-f71.google.com with SMTP id t145so1835818wmt.2
        for <linux-crypto@vger.kernel.org>; Sun, 31 May 2020 02:21:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ywTf4qZlZwxY3+4hdzNIdEQ5uHrIZLnoqwJn0ChNVtk=;
        b=bsyRYvCsyrJ8ecH2NVFfwGc0dMhMYMYFjU2PBOJQPhSYWJ+2tSOsPiLKaNtq9i4gH4
         jNACqTzhgYNoWl0AmrM/emtZGXCAAmvsVWCKZx7HUsAzi5FErKMzz7RSlTebrPu6EBKY
         NgiczrJcEH6pmgH4nmgpjHaxuDSCLgqU36IdVgvr7IuLw0HyA+X63Zn8Ahehoic4/Q6z
         CBkKZNqSUJa5VejLneaI4z5+Ww7b3zl9In1h+6zgRZd9DSQYADtEB8xI0ZHUntUTR4kK
         ZPKoqKOT+2gDcpUsKlKhsk6CyxpF0//Q/mwKpTMUydwY0hlWY+ZFCx4Dkqphsok2rMLo
         JKVA==
X-Gm-Message-State: AOAM533x+U7kqEGHs/nySTU9AyxsUiY/ak9BhzPgrrUgUCMBqB6O8x0S
        pR33thgMP87ogkPg61xQPG7uTnezGaIawTLzWPCnI4WN51WGIx4xNXVTAxa5yLaBvgxGuuEwnsz
        B8ET7uL94pEbDYP3hU1rtEV79
X-Received: by 2002:a1c:230a:: with SMTP id j10mr16369532wmj.124.1590916911666;
        Sun, 31 May 2020 02:21:51 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzzcgV6CUih1OZuVP6HyzHPhx3Qo76tys5xO9OetvdQfwhqn22ihHvFUhLx7Ow9OvlukxlV9g==
X-Received: by 2002:a1c:230a:: with SMTP id j10mr16369518wmj.124.1590916911412;
        Sun, 31 May 2020 02:21:51 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id 23sm7468291wmo.18.2020.05.31.02.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 02:21:50 -0700 (PDT)
Date:   Sun, 31 May 2020 05:21:48 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     "Longpeng(Mike)" <longpeng2@huawei.com>,
        linux-crypto@vger.kernel.org, Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Markus Elfring <Markus.Elfring@web.de>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] crypto: virtio: Fix use-after-free in
 virtio_crypto_skcipher_finalize_req()
Message-ID: <20200531052126-mutt-send-email-mst@kernel.org>
References: <20200526031956.1897-3-longpeng2@huawei.com>
 <20200526141138.8410D207FB@mail.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526141138.8410D207FB@mail.kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 26, 2020 at 02:11:37PM +0000, Sasha Levin wrote:
> <20200123101000.GB24255@Red>
> References: <20200526031956.1897-3-longpeng2@huawei.com>
> <20200123101000.GB24255@Red>
> 
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: dbaf0624ffa5 ("crypto: add virtio-crypto driver").
> 
> The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181.
> 
> v5.6.14: Build OK!
> v5.4.42: Failed to apply! Possible dependencies:
>     eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")
> 
> v4.19.124: Failed to apply! Possible dependencies:
>     eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")
> 
> v4.14.181: Failed to apply! Possible dependencies:
>     500e6807ce93 ("crypto: virtio - implement missing support for output IVs")
>     67189375bb3a ("crypto: virtio - convert to new crypto engine API")
>     d0d859bb87ac ("crypto: virtio - Register an algo only if it's supported")
>     e02b8b43f55a ("crypto: virtio - pr_err() strings should end with newlines")
>     eee1d6fca0a0 ("crypto: virtio - switch to skcipher API")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Mike could you comment on backporting?

> -- 
> Thanks
> Sasha

