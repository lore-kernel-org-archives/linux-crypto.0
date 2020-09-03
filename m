Return-Path: <SRS0=A9EK=CM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70775C43461
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 08:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2FD2320767
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Sep 2020 08:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1599123112;
	bh=0rOXJO8v3Xk2V4JE+ff9DFNPnBObB4XSASn1EHHlVXw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Ot4j8i9ldmU7tEs6ptPVthYEchcEVhwgq3MvHPDdf4/FHjbI4RRaTg/Jxk2gXFnBs
	 GOgwC64TmzcbbHKGxCmMQf7yeovvQzKLtfTCqQQTPjUdlOYRl9+8+3hIeQ1AOUrbiD
	 UGgm2uKd0DZYD5PJKvvhbBFF7qSkRu6m9APGXBTo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726726AbgICIvv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Sep 2020 04:51:51 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:33378 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726397AbgICIvs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Sep 2020 04:51:48 -0400
Received: by mail-wm1-f67.google.com with SMTP id e11so4888776wme.0;
        Thu, 03 Sep 2020 01:51:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pkx/vNHdqQFBvx8rQoFeCp/YpLcZ1iPwGvVTv1CC2PA=;
        b=Li9V0EpwaC7H2HFqvUGIZUtJO+McinXSgJN8YePpOeGDA41DDYfNJYSFYqwga7wozh
         jAoXBijNtJxybvDmsIbS/NPKQWVW+6LAEdbE1sNYUEWFXAV7F3xTaPl+rShTMjSCzdBN
         E1aljlKSUVabLo2duwnR6uBlC9Jq4MJSDG5iNeddLiFb1c7fJV9L8P/KnhRSGBTM+0gI
         X/cH9+tF/1k33Cha8sWwt9UGWan/7Qb1RKDuk8Z0RS34GPMVXsnuqV5RmsERUhbv16nm
         9ZVZs9L125+ffRGLGB0ToBoODMf5r3vN9Ny+EFiJrX2fbsN76N0HabDV+SZPaBM9Xa0I
         jSqw==
X-Gm-Message-State: AOAM5322bipR0ZLIs9IcX3/omZ4ofUbq0nMRcJ3F+f/KWWKmnnU6iuXe
        sFF2FmvgjYuVEYbwbQ3ItTQ=
X-Google-Smtp-Source: ABdhPJzPpcPqET8UF18b8l6TLsP6EZdrCqT0umG8b7WuORAfF0aHk+zx366xNIvqIe7k0pIC6d1V9w==
X-Received: by 2002:a1c:2781:: with SMTP id n123mr1336045wmn.27.1599123104524;
        Thu, 03 Sep 2020 01:51:44 -0700 (PDT)
Received: from kozik-lap ([194.230.155.106])
        by smtp.googlemail.com with ESMTPSA id h6sm3153472wmb.22.2020.09.03.01.51.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 03 Sep 2020 01:51:43 -0700 (PDT)
Date:   Thu, 3 Sep 2020 10:51:41 +0200
From:   Krzysztof Kozlowski <krzk@kernel.org>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     vz@mleia.com, k.konieczny@samsung.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: s5p-sss: remove redundant null check
Message-ID: <20200903085141.GA30833@kozik-lap>
References: <20200903083738.85345-1-vulab@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200903083738.85345-1-vulab@iscas.ac.cn>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 03, 2020 at 08:37:38AM +0000, Xu Wang wrote:
> Because clk_disable_unprepare already checked NULL clock
> parameter, so the additional checks are unnecessary, just remove them.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>
> ---
>  drivers/crypto/s5p-sss.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Best regards,
Krzysztof
