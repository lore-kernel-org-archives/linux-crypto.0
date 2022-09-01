Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB3C8ECAAD3
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Sep 2022 13:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233505AbiIAN5V (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Sep 2022 09:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbiIAN5U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Sep 2022 09:57:20 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9F413F92
        for <linux-crypto@vger.kernel.org>; Thu,  1 Sep 2022 06:57:18 -0700 (PDT)
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com [209.85.208.69])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 6CFC83F0ED
        for <linux-crypto@vger.kernel.org>; Thu,  1 Sep 2022 13:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1662040637;
        bh=eatamg8KEOTO7jgHDtGKXWunmQpTPYEKBxdi9CxrfRQ=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=uN/aYLBr7VkWCtJ8z5Q91PoOTLm/Lb82jnyTrPkD+sAQEEzWeXoWXJOw4dabWAHm8
         OJnrH8QWEItxh6EMwlR4ODPaDWmc7GNwGbUCfprU7Pd7GpNOUBtiW9OgQttIPkQOpO
         pbiqihGOYksGKUvQC1e3k3jOiyMAtLPwSyJaFAQl+dHYa4GUcIraDh62EAWEHh33sj
         oxlwgeZapFHmZI8h0WR1CfQL4le8CogiW8zhLHbUvvixSiSwsH194XKVqaCbxOvDUj
         hAry3bQU7HTF7FCRsi/EBSqcn1bPFs9v2TIwtrfG6vpYtdBoiUW4/lU6edmIkql303
         NPGCF8/G+yVMQ==
Received: by mail-ed1-f69.google.com with SMTP id r11-20020a05640251cb00b004484ec7e3a4so8933737edd.8
        for <linux-crypto@vger.kernel.org>; Thu, 01 Sep 2022 06:57:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=eatamg8KEOTO7jgHDtGKXWunmQpTPYEKBxdi9CxrfRQ=;
        b=aiQ9eLSPlJs2mPDjLyWZ/DnUss6Wn6FZKwDl1sodiCdjATCcHcnzm5EVxTB3FMNP2Z
         gqyQtot89F+iSNuGkQmSZuecDFHqfDKrOcblZPbxA7x15K16Phsuan0OSAKRdkGnHLHF
         HMlZkZytMka4S81KUDmtKnK8Ng4GOGRwc6tz35hzJQq2cefCCm/opuXm9m1T/fzwEOBl
         BBfVko/Hs4cXcAhDvILbryCgtsnLgcCp84e0pc3c8+C2mTJGOiiniAkEINfLIhyIw4CO
         +ekztit/l/s5ptwQLJ95iY2PqbM5c0R8wfIYq6vgA9T/y6cUmyKoDLNv5kRTG+qbys90
         NybQ==
X-Gm-Message-State: ACgBeo2YlWYXF6J4V669sV9j30JoutaLgm7rZD+4X2rNUtMJ7Dbg8Jp2
        9j4VDciMnAG2ioZEhPhFfmKcEzbm53MA6IRxT1MWf1i6pVc5F4OTdMlFVrOPhwI/LmCwlPivkK+
        ua5o2Gz7Mhibs0cREMfO6fTLvMHxbbNxthrAglfOXbCFsBL4af/YuvZKD+g==
X-Received: by 2002:a50:fe91:0:b0:43d:c97d:1b93 with SMTP id d17-20020a50fe91000000b0043dc97d1b93mr29907569edt.67.1662040633957;
        Thu, 01 Sep 2022 06:57:13 -0700 (PDT)
X-Google-Smtp-Source: AA6agR4pjZ4PvM9dADBtZDfV/dC1vl9LAgpRNbNaP8opEFR0qd/BGnVwJ1XzicJH6Wlr5JB2yCtqu7vb3pn5KKjrzVI=
X-Received: by 2002:a50:fe91:0:b0:43d:c97d:1b93 with SMTP id
 d17-20020a50fe91000000b0043dc97d1b93mr29907548edt.67.1662040633618; Thu, 01
 Sep 2022 06:57:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220901021628.1130985-1-koba.ko@canonical.com> <a15ab3e6-249d-af48-b4d5-25840b72a933@amd.com>
In-Reply-To: <a15ab3e6-249d-af48-b4d5-25840b72a933@amd.com>
From:   Koba Ko <koba.ko@canonical.com>
Date:   Thu, 1 Sep 2022 21:57:02 +0800
Message-ID: <CAJB-X+V-D0Es+5=KJQYdv6DKVK48jYzyU_4y6qvfY=H55y6oHQ@mail.gmail.com>
Subject: Re: [PATCH V2] crypto: ccp - Release dma channels before dmaengine unrgister
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 1, 2022 at 9:42 PM Tom Lendacky <thomas.lendacky@amd.com> wrote:
>
> On 8/31/22 21:16, Koba Ko wrote:
> > A warning is shown during shutdown,
> >
> > __dma_async_device_channel_unregister called while 2 clients hold a reference
> > WARNING: CPU: 15 PID: 1 at drivers/dma/dmaengine.c:1110 __dma_async_device_channel_unregister+0xb7/0xc0
> >
> > Call dma_release_channel for occupied channles before dma_async_device_unregister.
> >
> > Fixes: 4cbe9bc34ed0 ("crypto: ccp - ccp_dmaengine_unregister release dma channels")
>
> I can't find this Fixes: tag. I did find:
>
> 54cce8ecb925 ("crypto: ccp - ccp_dmaengine_unregister release dma channels")
>
> Not sure if Herbert can take care of that or if you'll need a v3.

Sorry, it should be 54cce8ecb925("crypto: ccp -
ccp_dmaengine_unregister release dma channels")

>
> With the change to the Fixes: tag
>
> Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
>
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Koba Ko <koba.ko@canonical.com>
> > ---
> > V2: Fix the unused warning
> > ---
> >   drivers/crypto/ccp/ccp-dmaengine.c | 6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/crypto/ccp/ccp-dmaengine.c b/drivers/crypto/ccp/ccp-dmaengine.c
> > index 7d4b4ad1db1f3..9f753cb4f5f18 100644
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
> > @@ -766,8 +770,8 @@ void ccp_dmaengine_unregister(struct ccp_device *ccp)
> >       if (!dmaengine)
> >               return;
> >
> > -     dma_async_device_unregister(dma_dev);
> >       ccp_dma_release(ccp);
> > +     dma_async_device_unregister(dma_dev);
> >
> >       kmem_cache_destroy(ccp->dma_desc_cache);
> >       kmem_cache_destroy(ccp->dma_cmd_cache);
