Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D81DFC433EF
	for <linux-crypto@archiver.kernel.org>; Tue,  5 Apr 2022 05:21:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiDEFXs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 5 Apr 2022 01:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229847AbiDEFXa (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 5 Apr 2022 01:23:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1E6E32DC3
        for <linux-crypto@vger.kernel.org>; Mon,  4 Apr 2022 22:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649136049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hXNd3S63I+/DnvIHKzVjn0CsQfzi1GKX7Atsgl6DyUY=;
        b=Aj8viwLBQejEOhZ4x+8nLx/BkAe0HyKtHO8v1WZ6hPVfiGO728bj6zCLDd7rTgjnEL+LQ1
        9sZqfcLgTBmClRPjoxGsIHjH5cTIUKis1GwX7yHp3cCPpzh+zKSYelCUW4q6bYMXIxviso
        GUDg2k8vi8e1A4j0g1KYoVWtcuQhT2I=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-331-07UXkeM_MOa6v5P6ZyydUg-1; Tue, 05 Apr 2022 01:20:48 -0400
X-MC-Unique: 07UXkeM_MOa6v5P6ZyydUg-1
Received: by mail-wm1-f71.google.com with SMTP id r206-20020a1c44d7000000b0038e6a1b25f1so756394wma.7
        for <linux-crypto@vger.kernel.org>; Mon, 04 Apr 2022 22:20:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hXNd3S63I+/DnvIHKzVjn0CsQfzi1GKX7Atsgl6DyUY=;
        b=nOUEE3zGOiqcoSWifcDxyYODgikBP4uMvIPrAQOO6s7yeCZqr0KDTR+Z8agxIYzqSX
         CJh370q7ESnzdNOApBeN1P3bXTw3OBZed6qs0M1xfVlVlYtrgxDZTNYdwSWVjNkS4aCy
         4F8Ejxi6A6Y+hutGFBv3m6U89whUcTdHpdMLJ5YIGzQw2i+rf0+PDXom7OvoLGGVsQA5
         H3FcFl2iJWxDwX3z4QTtwKmh3/5i+jNN+FSuKlnaCg3ejUO/bTsn6uFppR5BZuANZ9UG
         D5jK7yrFzP+Sizu9Gr9XF1RBOl8G4VT8CMmWMyDGjaiYWqU4ylxV4sfIXK/cI4q6kmns
         LOWA==
X-Gm-Message-State: AOAM5328aCyBXAjyGibhGdFHb7HfG6gIYwzKMdSML6pXr6TP3uubS2PL
        SbuyQMYuVUnWJYbwNlOwCEweB9Af7zy77N7sLkle90g7mvPM9SsjogxZhTygx71amuUKv5Ug74C
        /9Atwlc54AjIAaUoqOfV3Nahe
X-Received: by 2002:a7b:cb87:0:b0:38e:7464:f796 with SMTP id m7-20020a7bcb87000000b0038e7464f796mr1343555wmi.133.1649136046821;
        Mon, 04 Apr 2022 22:20:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz5pSIpqXDbMjBhGhF2Ym8NkkUzOiS8ugQkJZJSUEkD8mJRZ/i+6rvspLskok00+YPdm3I8bA==
X-Received: by 2002:a7b:cb87:0:b0:38e:7464:f796 with SMTP id m7-20020a7bcb87000000b0038e7464f796mr1343528wmi.133.1649136046521;
        Mon, 04 Apr 2022 22:20:46 -0700 (PDT)
Received: from redhat.com ([2.52.17.211])
        by smtp.gmail.com with ESMTPSA id d14-20020a056000186e00b0020405198faasm12295878wri.52.2022.04.04.22.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 22:20:45 -0700 (PDT)
Date:   Tue, 5 Apr 2022 01:20:41 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Cornelia Huck <cohuck@redhat.com>
Cc:     zhenwei pi <pizhenwei@bytedance.com>, arei.gonglei@huawei.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        herbert@gondor.apana.org.au, helei.sig11@bytedance.com
Subject: Re: [PATCH v3 0/4] Introduce akcipher service for virtio-crypto
Message-ID: <20220405012015-mutt-send-email-mst@kernel.org>
References: <20220302033917.1295334-1-pizhenwei@bytedance.com>
 <a9d1dfc1-080e-fba2-8fbb-28718b067e0d@bytedance.com>
 <20220307040431-mutt-send-email-mst@kernel.org>
 <87h778g8nn.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h778g8nn.fsf@redhat.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 04, 2022 at 05:39:24PM +0200, Cornelia Huck wrote:
> On Mon, Mar 07 2022, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> 
> > On Mon, Mar 07, 2022 at 10:42:30AM +0800, zhenwei pi wrote:
> >> Hi, Michael & Lei
> >> 
> >> The full patchset has been reviewed by Gonglei, thanks to Gonglei.
> >> Should I modify the virtio crypto specification(use "__le32 akcipher_algo;"
> >> instead of "__le32 reserve;" only, see v1->v2 change), and start a new issue
> >> for a revoting procedure?
> >
> > You can but not it probably will be deferred to 1.3. OK with you?
> >
> >> Also cc Cornelia Huck.
> 
> [Apologies, I'm horribly behind on my email backlog, and on virtio
> things in general :(]
> 
> The akcipher update had been deferred for 1.2, so I think it will be 1.3
> material. However, I just noticed while browsing the fine lwn.net merge
> window summary that this seems to have been merged already. That
> situation is less than ideal, although I don't expect any really bad
> problems, given that there had not been any negative feedback for the
> spec proposal that I remember.

Let's open a 1.3 branch? What do you think?

-- 
MST

