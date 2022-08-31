Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F788ECAAD8
	for <linux-crypto@archiver.kernel.org>; Wed, 31 Aug 2022 05:39:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbiHaFjS (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Aug 2022 01:39:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiHaFjR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Aug 2022 01:39:17 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DA16B99D8
        for <linux-crypto@vger.kernel.org>; Tue, 30 Aug 2022 22:39:15 -0700 (PDT)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 8F1523F466
        for <linux-crypto@vger.kernel.org>; Wed, 31 Aug 2022 05:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1661924352;
        bh=txCx48RIfKM16nx+L1M9PxgQMz3XT3zQYEbu5lORqqY=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=nAqLsgXinTH6xqTjEOIroH7utDKMGoezu6r94GtLLN4T3yngkYqMwicogVccbhfNd
         qkQTm9H72W1rPr1tTdbkHdXuVW0/4BKXzFiX6lvAjA2RaqT8oUgMiSHchhhtoai19e
         GDkKepm2OgiJu6HGJ451NPLpFQ1wLMy8eK41QZBVgYzda/rqrWg62WqoTYIiUcJh3G
         HEP08CaNAxU0B5S5dNav7aOgQlnvY2ZOx6R78AYXL2KQB8+j9+ESExldPCJu7tT93c
         kCx8wuv+kBukjd14tCuiYD2dto5VBqwJ2aqFGjkctqPojg1ikMT3vGQqScyM2Gy19f
         tjCeCwSIHCWgg==
Received: by mail-ej1-f70.google.com with SMTP id hp14-20020a1709073e0e00b00741a2093c4aso3105331ejc.20
        for <linux-crypto@vger.kernel.org>; Tue, 30 Aug 2022 22:39:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=txCx48RIfKM16nx+L1M9PxgQMz3XT3zQYEbu5lORqqY=;
        b=x4/FiQU8g/CQqFm9zfzGLBoXpvugUVa/OEsoZqcEiKH03F6dDUqVPVRkisrsGNz8UU
         SuC9Cf3KF4HtzSZys/9EmuJ8zECm0LzTo6injXoTJd/M8djmrYnAPWlAicu7pnt1QtOL
         7TpB1fMyp0h+z/xhb5V/90BQGRVNGb+M0xFPOdf4bzKJcXFijwV1xTJdQw/fl9SNvR32
         Oeoov6RevW+XXWRdr46dHSV65M630o3m8WsjclJh8bPez3XqGk/xtZ/7cyXyE0LzFdFi
         TsgCvXVHjrr/WcuqJclY/ED3b1E4FYTvHdioQ4+a3tfayaJTI1xgd5NspgTmAsmzGuB4
         rqug==
X-Gm-Message-State: ACgBeo05JBRyy/KFAKb4dE9rvmAwrCygEJZJNv9TEmGJq2SgN1nWctvq
        H5XpBrNdz2ZTciErxPnoL1Fx1Jwcl+XueJYEsanJNXWq+anLnhveLjMygUzPDaoUp3KoLrfKDWX
        WovB8oI2K48V2naD3do7TPPqZjG4AuU4XV6XIivWSDFojDQUquRk3jWnzpg==
X-Received: by 2002:a17:906:ef90:b0:730:9af7:5702 with SMTP id ze16-20020a170906ef9000b007309af75702mr19803512ejb.107.1661924351828;
        Tue, 30 Aug 2022 22:39:11 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7uOUte+ry1NAh94ZJbMnMVIwONJd4fEz1OzKR5q1Z1GvXFokc8l3qvii94v5yHIpkFy/9UW34eW/Ubnl6lW54=
X-Received: by 2002:a17:906:ef90:b0:730:9af7:5702 with SMTP id
 ze16-20020a170906ef9000b007309af75702mr19803502ejb.107.1661924351595; Tue, 30
 Aug 2022 22:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220830093439.951960-1-koba.ko@canonical.com> <c3ea3992-df42-3a26-6d30-834368faf91c@amd.com>
In-Reply-To: <c3ea3992-df42-3a26-6d30-834368faf91c@amd.com>
From:   Koba Ko <koba.ko@canonical.com>
Date:   Wed, 31 Aug 2022 13:39:00 +0800
Message-ID: <CAJB-X+XMHYyQJLLuC24rAvQwNOOZUdMBhh12RC9UTOSCrCa=HA@mail.gmail.com>
Subject: Re: crypto: ccp - Release dma channels before dmaengine unrgister
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 30, 2022 at 11:32 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 8/30/22 04:34, Koba Ko wrote:
> > A warning is shown during shutdown,
> >
> > __dma_async_device_channel_unregister called while 2 clients hold a reference
> > WARNING: CPU: 15 PID: 1 at drivers/dma/dmaengine.c:1110
> > __dma_async_device_channel_unregister
> >
> > Call dma_release_channel for occupied channles
> > before dma_async_device_unregister.
> >
> > Fixes: 4cbe9bc34ed0 ("crypto: ccp - ccp_dmaengine_unregister release dma channels")
> > Signed-off-by: Koba Ko <koba.ko@canonical.com>
> > ---
> >   drivers/crypto/ccp/ccp-dmaengine.c | 8 +++++++-
> >   1 file changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
> > index 7d4b4ad1db1f3..ba3eb1ac3b55d 100644
> > --- a/drivers/crypto/ccp/ccp-dmaengine.c
> > +++ b/drivers/crypto/ccp/ccp-dmaengine.c
> > @@ -641,6 +641,10 @@ static void ccp_dma_release(struct ccp_device *ccp)
> >       for (i = 0; i < ccp->cmd_q_count; i++) {
> >               chan = ccp->ccp_dma_chan + i;
> >               dma_chan = &chan->dma_chan;
> > +
> > +             if (dma_chan->client_count)
> > +                     dma_release_channel(dma_chan);
> > +
> >               tasklet_kill(&chan->cleanup_tasklet);
> >               list_del_rcu(&dma_chan->device_node);
> >       }
> > @@ -762,12 +766,14 @@ int ccp_dmaengine_register(struct ccp_device *ccp)
> >   void ccp_dmaengine_unregister(struct ccp_device *ccp)
> >   {
> >       struct dma_device *dma_dev = &ccp->dma_dev;
> > +     struct dma_chan *dma_chan;
> > +     unsigned int i;
> >
> >       if (!dmaengine)
> >               return;
> >
> > -     dma_async_device_unregister(dma_dev);
> >       ccp_dma_release(ccp);
> > +     dma_async_device_unregister(dma_dev);
>
> Seems the right way to get rid of the warn, but can there still be a race
> where the channel is grabbed again after ccp_dma_release() and before
> dma_async_device_unregister() is called?

After tracing the ccp driver,
dma_device is held by the ccp device.
the only function called ccp_dmaengine_register is ccp5_init/ccp_init,
ccp_dma_release is called in ccp_dmaengine_unregister/ccp_dmaengine_register,
so there's no race condition in current codes.


>
> Thanks,
> Tom
>
> >
> >       kmem_cache_destroy(ccp->dma_desc_cache);
> >       kmem_cache_destroy(ccp->dma_cmd_cache);
