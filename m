Return-Path: <SRS0=IKCX=CF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 084D7C433DF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 14:41:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D5CC722B4E
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Aug 2020 14:41:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UG3mzNuX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgH0Oli (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Aug 2020 10:41:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727999AbgH0OlT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Aug 2020 10:41:19 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60150C061264;
        Thu, 27 Aug 2020 07:41:18 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id a5so5631824wrm.6;
        Thu, 27 Aug 2020 07:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=crqoUDoVI2GahOjG/uInXq2IOADeVeHTS/KrzK3bGe8=;
        b=UG3mzNuXy4XJ6CQBJLWvFDGyPYOZdBE6IHM/880S3XB7KGehVvGelv0JkAbELqG2x+
         FMToy3GlRs6YVPjgxtUhJu91Viv99ZNSkjPaBuh1Dw2OiC/h+MTWbWHv3gmzp726By3n
         RtZ/UV8+nI+U4qm0PFr1GXzxQXun5kPGy0ToueNNFW5sYAmn45dcZuEANVMukTlOKqJi
         KR1Pyf07kja156AI3INm+X9tSagbbB3JMQtMJEaN0pWVreM4lt5DeL/VoJ1p5elOY/1Q
         xdyQCXiBBcts6z2h/falIUgYkf0N6y6i3o96Njs4LtG/SkJREWULaU9FAXO9w762w/0/
         oubA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=crqoUDoVI2GahOjG/uInXq2IOADeVeHTS/KrzK3bGe8=;
        b=maCgWvQ4p/YshvNTpZHSkpFsiPqXiQkU5ZodZG+xPm8dos1LT+TGEYUZq6OTDZf1gt
         8K9jmhWxqCRkzzgD/mEVPg3N/TuBmdveWyLUMgw6LpUljW7x2nlRw9jxWK030Z5M7Vsf
         50ixu8pRUhBYKu23Fy2KuKlEEc3tEIdQB2kdym7vEoyFOz2KuJbbMWMqwnjXjOk/Tb7Z
         9mYba3HtRf8OQmfBDrfIRpPtMSsuvJ7nFrkVrReEmiQIBpKZ0hSXIX04UrEZTFzCg0hv
         D0wEguKbbqA9zTGBlJOFaepG/Ar9UkliFVYh89ccAKRDgEIX9UDZUidf1tl0pnK9oA1E
         UqZA==
X-Gm-Message-State: AOAM533WUyS8rKTJdxY8yt0Qf3xkyPakbsuEedRBxjBY+dY2t6yW9kf3
        /1/c3UdnozF1HIom47RwiDPixiHKjGs=
X-Google-Smtp-Source: ABdhPJwp8q4V4P34CkZy0trs88ZOw1wBVk43Ait/5AtPVgDwuVPMn/leocLfh9V43Z8tFi1vh4dAAw==
X-Received: by 2002:adf:cf10:: with SMTP id o16mr19130873wrj.380.1598539277151;
        Thu, 27 Aug 2020 07:41:17 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id f6sm7417864wme.32.2020.08.27.07.41.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2020 07:41:16 -0700 (PDT)
Date:   Thu, 27 Aug 2020 16:41:14 +0200
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Denis Efremov <efremov@linux.com>
Cc:     linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] crypto: sun8i-ss - use kfree_sensitive()
Message-ID: <20200827144114.GB11280@Red>
References: <20200827064402.7130-1-efremov@linux.com>
 <20200827064402.7130-5-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827064402.7130-5-efremov@linux.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 27, 2020 at 09:44:02AM +0300, Denis Efremov wrote:
> Use kfree_sensitive() instead of open-coding it.
> 
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c   | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 

Acked-by: Corentin Labbe <clabbe.montjoie@gmail.com>
Tested-by: Corentin Labbe <clabbe.montjoie@gmail.com>

Thanks
