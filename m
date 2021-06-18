Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DEE0C48BE8
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jun 2021 18:02:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35FEF613EE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Jun 2021 18:02:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbhFRSEX (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Jun 2021 14:04:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230512AbhFRSEX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Jun 2021 14:04:23 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EDBC061574
        for <linux-crypto@vger.kernel.org>; Fri, 18 Jun 2021 11:02:13 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id v22-20020a0568301416b029044e2d8e855eso1306271otp.8
        for <linux-crypto@vger.kernel.org>; Fri, 18 Jun 2021 11:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gm6MYYB9NnNxdkRuQyLBTfy2a1l9+kymVbo6dLCaxp8=;
        b=IX/TeFICHe0M9eY2FgHiWrn+tdb/q5XFgD8uXsgjTWA8ccYLhwkhmj5LVksZqDuyP/
         WO98d4+EqUEGVeNVRkwGXvDR2KFUUsjHgWYsSZNspeMbY0pyo5tCDjX5g3a0S5zJVn5J
         VVQVThsNKNWwgywn+UIOieUM+TDA8ZHnfFAZ0UJx9g4jXc4QSs4THTGKFETKMbtCQOhC
         oohAmV/ouLnwljoWkk30lA1Ew7AeSHyL7YWAUXHRppPW6exwVxxl6v4oWTx8GoKtepVU
         0FuNut9qWjAnX/+VsjdAfRTl/lf12Qwyt/IudALVfQNQswOIeBJ2fnVR25hgKkqCacht
         +gLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gm6MYYB9NnNxdkRuQyLBTfy2a1l9+kymVbo6dLCaxp8=;
        b=HlMmUfKNs8+Swz0UBeiFH8rP9I3QHBh0taFDuEKD3Nxkn8SXfejYtK3T9GPpR8lt4G
         NkxXasDJjVk6+8svK/4NrnUWS0kcIN5sycsH/SLLN0H62bXjDyyKSSF34ooVS1jjuuDC
         /15aDxcgDn3o+fOD4vPUhm/K4+NRJYZImlETEh8BGWc3MuRFxdfBIdCUQH1+sFXOHcSc
         DFKH443N1SbHDfJscTjGwCpDWiqoWqYbA6iK6FbDCmO8HLid9ywjl/mOSnEzV9KQTd4X
         QgS0ZgluBKmrINH7uTiVA/BLJwpm7R8KYWKqsAWRDFWf9KebmcwHdlqCixxCOYXZ0nJr
         4ecQ==
X-Gm-Message-State: AOAM531IsQtnMZ5y09PRn/en+VmNs782L24e0VQVg2EHJWc4SsyPWeck
        54c2xkGOd1xXpufy3vhuXpeFlyg2PYC0yg+j8KQCzg==
X-Google-Smtp-Source: ABdhPJzDjg2IGcepCwb5aVYpL0iyoVlRw7VwKmnVSWke5phSkT/PVMVrc8WMy+XMkfj6Q5UajD7a40VUOZZuPPBY+Tc=
X-Received: by 2002:a9d:1b41:: with SMTP id l59mr10406630otl.8.1624039332635;
 Fri, 18 Jun 2021 11:02:12 -0700 (PDT)
MIME-Version: 1.0
References: <YDkbCHHBUOmfI59K@Konrads-MacBook-Pro.local> <YL7XXNOnbaDgmTB9@atmark-techno.com>
 <2e899de2-4b69-c4b6-33a6-09fb8949d2fd@nxp.com> <20210611062153.GA30906@lst.de>
 <YMM8Ua0HMmErLIQg@0xbeefdead.lan> <CAMGD6P1v2JoJoxSuAYL8UjdtCaLCc4K_7xzVkumspeb0qn=LBQ@mail.gmail.com>
 <YMqW+/gQvM+uWUTw@fedora> <YMqZswFnSNKk4Z7B@atmark-techno.com>
 <20210617051232.GB27192@lst.de> <YMrfWBLsJxCRhX5U@atmark-techno.com>
In-Reply-To: <YMrfWBLsJxCRhX5U@atmark-techno.com>
From:   Jianxiong Gao <jxgao@google.com>
Date:   Fri, 18 Jun 2021 11:01:59 -0700
Message-ID: <CAMGD6P0=9RE1-q1WHkwR1jymK5jyvN6QgypQ2KgdvBQn0CUTHw@mail.gmail.com>
Subject: Re: swiotlb/caamjr regression (Was: [GIT PULL] (swiotlb) stable/for-linus-5.12)
To:     Dominique MARTINET <dominique.martinet@atmark-techno.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?Horia_Geant=C4=83?= <horia.geanta@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Hartmann <lukas@mntmn.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Marc Orr <marcorr@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Peter Gonda <pgonda@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> Jianxiong Gao, before spending more time on this, could you also try
> Chanho Park's patch?
> https://lore.kernel.org/linux-iommu/20210510091816.GA2084@lst.de/T/#m0d0df6490350a08dcc24c9086c8edc165b402d6f
>
I have tested Chanho Parks's patch and it works for us.
The NVMe driver performs correctly with the patch.

I have teste the patch on 06af8679449d

-- 
Jianxiong Gao
