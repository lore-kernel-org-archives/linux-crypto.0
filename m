Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A78DC4167D
	for <linux-crypto@archiver.kernel.org>; Thu,  2 Nov 2023 13:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjKBNRl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 2 Nov 2023 09:17:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234957AbjKBNRk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Nov 2023 09:17:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4580134
        for <linux-crypto@vger.kernel.org>; Thu,  2 Nov 2023 06:16:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698931007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fTaJOMcX/m2U9bWMbervVcOi3b96Z0mEX8mhdx6J3a4=;
        b=Us7E1zcYMF23E5Jdj3unHyznAidIM9rsMlHtsKeGnuHDTGuL59AAu3paemnfC3FCGMFw2u
        8JnnoBxy5WfDLv+PsuozWLGT5rTtVB/MxRZnbpVAR52E71ZAPRRhR/tbMZAj3UVigkcj9Q
        dLPrGHR7qvMrr3pgqG2JROfC3tkwsTU=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-Llpzpk0NNju3bi483cK7tA-1; Thu, 02 Nov 2023 09:16:46 -0400
X-MC-Unique: Llpzpk0NNju3bi483cK7tA-1
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-40855a91314so6107985e9.1
        for <linux-crypto@vger.kernel.org>; Thu, 02 Nov 2023 06:16:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698931004; x=1699535804;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fTaJOMcX/m2U9bWMbervVcOi3b96Z0mEX8mhdx6J3a4=;
        b=CjHxapvDutQUyGbFVyAImTyTZlGfVjvLB/LRk+8vQ8fRNLwzl2gCHZJLQXNBt8Is31
         4j+i+sb8oyRiUXC6Si3z7mA/qpktzAR6ndL/W9q4LlfgLKeIPAdHedoo7ieEMC4I4LNx
         q8r/Fux6RZi3FnO2cTaulSltsB/cM753VL+0qEITWwYxd5feiCxGpUBgeIUbb1i/ao9F
         qsdivSws4AD0gY8jUdyrHY2TMToMj5fE7OikSqWTl3Kl7s+eY07tUJlPMV24msCZ5sBm
         geMGxvZtGsyOxxMeuIfAO1o3btN8Ms/bPyypwNmTMYDDfKwP4+qrsqwJlROS6faiyLpq
         szcw==
X-Gm-Message-State: AOJu0Yzmg8P04nySALMl8irP48y5SClqCZ7cPYbbve0IH01pRFm3mJVa
        I7VbIqBySvkWKjSPBBiX6fyI2y1RuyxK7jATlw9CrjuDZtX9vG3Fm53M4c2R/xuCr2myjYwJrDo
        bFo9nt73EOFDQUXshHDoVIMw5
X-Received: by 2002:a05:600c:4e92:b0:406:51a0:17ea with SMTP id f18-20020a05600c4e9200b0040651a017eamr9900344wmq.10.1698931004651;
        Thu, 02 Nov 2023 06:16:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFaiGvYRPB3UU8Dnub6u0GQi1jlrdIYAhApAmi5nhz29fIPl/sa2bLHv0xaM+iBx8P/nk59HA==
X-Received: by 2002:a05:600c:4e92:b0:406:51a0:17ea with SMTP id f18-20020a05600c4e9200b0040651a017eamr9900315wmq.10.1698931004333;
        Thu, 02 Nov 2023 06:16:44 -0700 (PDT)
Received: from redhat.com ([2a02:14f:174:efc3:a5be:5586:34a6:1108])
        by smtp.gmail.com with ESMTPSA id bh27-20020a05600c3d1b00b004063d8b43e7sm2903119wmb.48.2023.11.02.06.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Nov 2023 06:16:43 -0700 (PDT)
Date:   Thu, 2 Nov 2023 09:16:39 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     "Gonglei (Arei)" <arei.gonglei@huawei.com>
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Jason Wang <jasowang@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Marc Hartmayer <mhartmay@linux.ibm.com>
Subject: Re: virtcrypto_dataq_callback calls crypto_finalize_request() from
 irq context
Message-ID: <20231102091548-mutt-send-email-mst@kernel.org>
References: <20230922154546.4f7447ce.pasic@linux.ibm.com>
 <ed47fb73ad634ca395bd6c8e979dda8e@huawei.com>
 <20230924193941.6a02237f.pasic@linux.ibm.com>
 <20231101092521-mutt-send-email-mst@kernel.org>
 <5d9ebbdb042845009b47e6a9ee149231@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d9ebbdb042845009b47e6a9ee149231@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Nov 02, 2023 at 01:04:07PM +0000, Gonglei (Arei) wrote:
> 
> 
> > -----Original Message-----
> > From: Michael S. Tsirkin [mailto:mst@redhat.com]
> > Sent: Wednesday, November 1, 2023 9:26 PM
> > To: Halil Pasic <pasic@linux.ibm.com>
> > Cc: Gonglei (Arei) <arei.gonglei@huawei.com>; Herbert Xu
> > <herbert@gondor.apana.org.au>; Jason Wang <jasowang@redhat.com>;
> > virtualization@lists.linux-foundation.org; linux-kernel@vger.kernel.org;
> > linux-crypto@vger.kernel.org; Marc Hartmayer <mhartmay@linux.ibm.com>
> > Subject: Re: virtcrypto_dataq_callback calls crypto_finalize_request() from irq
> > context
> > 
> > On Sun, Sep 24, 2023 at 07:39:41PM +0200, Halil Pasic wrote:
> > > On Sun, 24 Sep 2023 11:56:25 +0000
> > > "Gonglei (Arei)" <arei.gonglei@huawei.com> wrote:
> > >
> > > > Hi Halil,
> > > >
> > > > Commit 4058cf08945 introduced a check for detecting crypto
> > > > completion function called with enable BH, and indeed the
> > > > virtio-crypto driver didn't disable BH, which needs a patch to fix it.
> > > >
> > > > P.S.:
> > > > https://lore.kernel.org/lkml/20220221120833.2618733-5-clabbe@baylibr
> > > > e.com/T/
> > > >
> > > > Regards,
> > > > -Gonglei
> > >
> > > Thanks Gonglei!
> > >
> > > Thanks! I would be glad to test that fix on s390x. Are you about to
> > > send one?
> > >
> > > Regards,
> > > Halil
> > 
> > 
> > Gonglei did you intend to send a fix?
> 
> Actually I sent a patch a month ago, pls see another thread.
> 
> 
> Regards,
> -Gonglei

And I think there was an issue with that patch that you
wanted to fix?
config changed callback got fixed but this still didn't.

-- 
MST

