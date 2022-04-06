Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6771C433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  6 Apr 2022 12:05:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231368AbiDFMHB (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 6 Apr 2022 08:07:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiDFMGh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 6 Apr 2022 08:06:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1E18532389E
        for <linux-crypto@vger.kernel.org>; Wed,  6 Apr 2022 00:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649231280;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=tnMN3pUaj7lJGkHw7ZLvt0aTt3QjufyLZHnTLczmUJE=;
        b=ZHD3RBHYJUhUtxjgM2rMOgpE09EHsaF1eOMsiBtvDX/SSYJFGN22Fzm5NezPq3o+Punulu
        sotrBOKgiuyO8ZK4JxbHUAlHn+otnFWi/lu0DZg7IcusWLTgfcYjWD6QvAz5gkNYnXgT7x
        lg2Sx4nxTUHPIi3JHjNuwhe3H1namck=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-664-LC4vI-GjNAG0PbSNRnhujg-1; Wed, 06 Apr 2022 03:47:59 -0400
X-MC-Unique: LC4vI-GjNAG0PbSNRnhujg-1
Received: by mail-ej1-f70.google.com with SMTP id x2-20020a1709065ac200b006d9b316257fso743738ejs.12
        for <linux-crypto@vger.kernel.org>; Wed, 06 Apr 2022 00:47:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tnMN3pUaj7lJGkHw7ZLvt0aTt3QjufyLZHnTLczmUJE=;
        b=R7UnDj7IrzQtxD5Iz7/JoyEUFP0mkVb/2BJWFpf4DU1vr4uh5awszEiU+zsYIg/+wP
         AKQCZ3pdOPRkRoohlbNxUfQvwfHdCfqEt8cgwJWM2cdXYldohx+cRKJCmHpfCFvKDLK/
         0r2fk7/WXFlJiDf5shV7eoBl/cU8A+DC7DDDnVosM5x+W7WDTa898gmW76HnznGSAzM6
         euLO4OGC85Jp3umpsO3Y//rcQE5MTDSjhWGp8gpZuENIrQXOtDZBGhiArw5qPonMXWTg
         R9m+nUS3eGBAZ5I2d3h8hakGctuR7T8QMKKaC6aI5KsCWnP1ZxZJOW7BKolYFrJJFEn9
         Fa0Q==
X-Gm-Message-State: AOAM533WITSdV0/NtLIiECj1PGCSMtnOuL4gc7UQMhDMMawWOyUzFWqx
        4/YfYbGBf7PbyAS27b4Ar1+Xh35M4z/sb9q1GYD9STAXTcOdb4zwv1VQWnLValeMIvR4YfA5UPj
        Iydt49smXCVUYcNu/xUyxD0d3
X-Received: by 2002:a05:6402:183:b0:410:fde:887a with SMTP id r3-20020a056402018300b004100fde887amr7228685edv.243.1649231278379;
        Wed, 06 Apr 2022 00:47:58 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyLcLipZLH882pfJA3h0lLGi++W3jsGhKM/fA7YIjyDbCflYB4XnGKFeaNybu/dm01/9LLhtA==
X-Received: by 2002:a05:6402:183:b0:410:fde:887a with SMTP id r3-20020a056402018300b004100fde887amr7228671edv.243.1649231278152;
        Wed, 06 Apr 2022 00:47:58 -0700 (PDT)
Received: from redhat.com ([2.53.144.12])
        by smtp.gmail.com with ESMTPSA id k23-20020a1709062a5700b006ccd8fdc300sm6132409eje.180.2022.04.06.00.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 00:47:57 -0700 (PDT)
Date:   Wed, 6 Apr 2022 03:47:53 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     zhenwei pi <pizhenwei@bytedance.com>, arei.gonglei@huawei.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, helei.sig11@bytedance.com
Subject: Re: [PATCH v3 0/4] Introduce akcipher service for virtio-crypto
Message-ID: <20220406034721-mutt-send-email-mst@kernel.org>
References: <20220302033917.1295334-1-pizhenwei@bytedance.com>
 <a9d1dfc1-080e-fba2-8fbb-28718b067e0d@bytedance.com>
 <20220307040431-mutt-send-email-mst@kernel.org>
 <87h778g8nn.fsf@redhat.com>
 <20220405012015-mutt-send-email-mst@kernel.org>
 <87ee2cexp5.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ee2cexp5.fsf@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Apr 05, 2022 at 10:33:42AM +0200, Cornelia Huck wrote:
> On Tue, Apr 05 2022, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > On Mon, Apr 04, 2022 at 05:39:24PM +0200, Cornelia Huck wrote:
> >> On Mon, Mar 07 2022, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> >> 
> >> > On Mon, Mar 07, 2022 at 10:42:30AM +0800, zhenwei pi wrote:
> >> >> Hi, Michael & Lei
> >> >> 
> >> >> The full patchset has been reviewed by Gonglei, thanks to Gonglei.
> >> >> Should I modify the virtio crypto specification(use "__le32 akcipher_algo;"
> >> >> instead of "__le32 reserve;" only, see v1->v2 change), and start a new issue
> >> >> for a revoting procedure?
> >> >
> >> > You can but not it probably will be deferred to 1.3. OK with you?
> >> >
> >> >> Also cc Cornelia Huck.
> >> 
> >> [Apologies, I'm horribly behind on my email backlog, and on virtio
> >> things in general :(]
> >> 
> >> The akcipher update had been deferred for 1.2, so I think it will be 1.3
> >> material. However, I just noticed while browsing the fine lwn.net merge
> >> window summary that this seems to have been merged already. That
> >> situation is less than ideal, although I don't expect any really bad
> >> problems, given that there had not been any negative feedback for the
> >> spec proposal that I remember.
> >
> > Let's open a 1.3 branch? What do you think?
> 
> Yes, that's probably best, before things start piling up.

OK, want to do it? And we can then start voting on 1.3 things
straight away.

-- 
MST

