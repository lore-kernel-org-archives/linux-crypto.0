Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 207B9CDB474
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Oct 2023 08:59:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376565AbjJTI74 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Oct 2023 04:59:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376569AbjJTI7z (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Oct 2023 04:59:55 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3BBAB
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 01:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1697792350;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uvz9/SuKlOMM8eAgBNPqNzyC4gsPxikcYikuf/XYhDE=;
        b=KHT5ffWJKGtP/FBORD4ADX+b/Tft8hp+nGncJsURAF3eN23njhfmhvRX0n3zFV9sUh2jur
        y2vBQRh9XnV4qXldmgvhEKMR9FO/q1m1bPo2clHme0503TIWF9No3qQxLwLBvDjjJTyG4v
        1bkfxM2LXjNwj3D+rj3Yolf/nKS2w+g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-137-_P7ZireMNpGPk2GVixne5g-1; Fri, 20 Oct 2023 04:59:08 -0400
X-MC-Unique: _P7ZireMNpGPk2GVixne5g-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-32db6a28e24so282092f8f.0
        for <linux-crypto@vger.kernel.org>; Fri, 20 Oct 2023 01:59:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697792347; x=1698397147;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uvz9/SuKlOMM8eAgBNPqNzyC4gsPxikcYikuf/XYhDE=;
        b=acfPdBKhq+ZEwSQ7KD3WrNkMo59RsKzz9PEnC62PWZRXQVZZgwoHPitKJghPK6WSd/
         GmH+rS7Uy/fs8F7L3C0fpdonyzKHoGUXMMZFCN1/QyvzilxFnqSMXr/gPSvggEN4gXri
         UIHkpSsqcYGZbrl5oJuTpz7XUzxMHGVgU89BqsPGrYuu7D9tVTRobxrF+EwefEHh4835
         l7d1HUWhzXaaqKMTE4tDc9NGN1nLqyVsSeDlWhVldRajysWpsdxbzEdOhhOiSvXXCBER
         TZmjVPOmwX88TZFXm1buDyHQ24u2pbITP4/nUlraPl5+/IBDNrycJm93AMskdrK+lqDw
         bmUg==
X-Gm-Message-State: AOJu0YxdNDH7PFOThaK1nuoT0ytBOoQuXuMdQdeCncmfex40zdkqyUuY
        OK1cMknvbyX6MQL8eREoAYHG9nYjFukcxM+jI93tA1DQLZ9d8F+W5+7BEpRFjRB88gNb+7q8PvA
        rwqjUCIpSLhkeeTvapHngoD6/
X-Received: by 2002:a5d:5709:0:b0:319:71be:9248 with SMTP id a9-20020a5d5709000000b0031971be9248mr874307wrv.19.1697792347516;
        Fri, 20 Oct 2023 01:59:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGwAlnz5LFaGpViOPQBVbbYYBiYpleDv/HpXbeUWdlmaJa7e7XRaJ3iQ9+0DjOBQ8udLXNkOQ==
X-Received: by 2002:a5d:5709:0:b0:319:71be:9248 with SMTP id a9-20020a5d5709000000b0031971be9248mr874294wrv.19.1697792347172;
        Fri, 20 Oct 2023 01:59:07 -0700 (PDT)
Received: from redhat.com ([2a06:c701:73d2:bf00:e379:826:5137:6b23])
        by smtp.gmail.com with ESMTPSA id a3-20020a5d4d43000000b003196b1bb528sm1226535wru.64.2023.10.20.01.59.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Oct 2023 01:59:06 -0700 (PDT)
Date:   Fri, 20 Oct 2023 04:59:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     zhenwei pi <pizhenwei@bytedance.com>, arei.gonglei@huawei.com,
        linux-crypto@vger.kernel.org, jasowang@redhat.com,
        linux-kernel@vger.kernel.org, Halil Pasic <pasic@linux.ibm.com>
Subject: Re: [PATCH] virtio-crypto: handle config changed by work queue
Message-ID: <20231020045844-mutt-send-email-mst@kernel.org>
References: <20231007064309.844889-1-pizhenwei@bytedance.com>
 <ZTIVDQZeHb2BlbH7@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZTIVDQZeHb2BlbH7@gondor.apana.org.au>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 20, 2023 at 01:50:05PM +0800, Herbert Xu wrote:
> On Sat, Oct 07, 2023 at 02:43:09PM +0800, zhenwei pi wrote:
> > MST pointed out: config change callback is also handled incorrectly
> > in this driver, it takes a mutex from interrupt context.
> > 
> > Handle config changed by work queue instead.
> > 
> > Cc: Gonglei (Arei) <arei.gonglei@huawei.com>
> > Cc: Halil Pasic <pasic@linux.ibm.com>
> > Cc: Michael S. Tsirkin <mst@redhat.com>
> > Signed-off-by: zhenwei pi <pizhenwei@bytedance.com>
> > ---
> >  drivers/crypto/virtio/virtio_crypto_common.h |  3 +++
> >  drivers/crypto/virtio/virtio_crypto_core.c   | 14 +++++++++++++-
> >  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> Patch applied.  Thanks.


It's in my tree too, but git should be able to figure it out.

> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

