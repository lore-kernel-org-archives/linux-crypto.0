Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B8DC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Mar 2022 07:40:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354245AbiCYHmB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Mar 2022 03:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241585AbiCYHmA (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Mar 2022 03:42:00 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6849BAC4
        for <linux-crypto@vger.kernel.org>; Fri, 25 Mar 2022 00:40:26 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id k124-20020a1ca182000000b0038c9cf6e2a6so3879779wme.0
        for <linux-crypto@vger.kernel.org>; Fri, 25 Mar 2022 00:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=dnODPaJY/J+n3BkIXlCmsZJUqQLCC5eiwNXYnqqukBk=;
        b=bqhz2zWMvRkdTQBDj6ZAZIlYrvJPAcKBIWzKZeB+/CBBucdnqvI52PJthfpFSq+v5U
         gXqOV2I/8IDY7tAerS3IsF8S1vXomCZ1TkWfwbcmlpEgxTPxHvU+zVX3G2N0DTAcHLMJ
         xOUOaDwTZW9KOGyD2L0A4rv7QA0/M+fARHBAeMn3SCe/jeZPkLW3Dj3jiq3n+2iluKQE
         cAhJiVZqDkYed4GWxHxsLQw3DW4OsTsw3ovEleJL41j1eDpnGyH2ilSHffmU2sYL02Gm
         xR1hyx4LtKVBwt6pwVXtAWjX8dqRx7hdnRbdg5huBC4C2NnohFwIHSQmBkkuIzhrg8hK
         w5ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=dnODPaJY/J+n3BkIXlCmsZJUqQLCC5eiwNXYnqqukBk=;
        b=Z6A8GEnotca7AFF3CAlURvJ4327zUiWcubncGVKIo4GvQKS8K44pp/0vdx2o8MG/Cb
         /PzpvBGQIqxutIsmQOmyjtzL2e2aavrLSgl5dEjRGmrxwZSTlkdDqFXWz1Q0UQ6RPJMT
         NsrqWAgp/Nw6cdvdaoBSqGmipJehfsAPHaKw08z5oTipUWYqgL8HK0ePtqti5p+pN0LO
         jj0l6iGVLTr/3ljdKHG4v/MfTV05RKk8pUfcsyAatmOgeKUhf6B5Zby27/rtVj420Z8A
         cQvc588O1XWfiVFTflZjfiYrs549TOLXeyWiOw8yqe+rbtGExAb0ADQl3sImvzGzS8mK
         H68Q==
X-Gm-Message-State: AOAM531Gxy7d8cp+JAoOxysBOP9M4uyRDEAKxHPOhGtxmm+DgVUd8ELp
        sfyR3lmx6V5G8b9zLhgPdLvVyw==
X-Google-Smtp-Source: ABdhPJx8uYzQeFEFXzUdYuZYNV0f37cM+IUTkBkG2uijMoKDe1z93YfbCiKDAtPpG64eUg9/BDRz/Q==
X-Received: by 2002:a05:600c:34c5:b0:38c:30e3:1e6c with SMTP id d5-20020a05600c34c500b0038c30e31e6cmr18251767wmq.144.1648194024977;
        Fri, 25 Mar 2022 00:40:24 -0700 (PDT)
Received: from Red ([2a01:cb1d:3d5:a100:264b:feff:fe03:2806])
        by smtp.googlemail.com with ESMTPSA id q16-20020adfea10000000b00203e0735791sm4407043wrm.39.2022.03.25.00.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 00:40:24 -0700 (PDT)
Date:   Fri, 25 Mar 2022 08:40:22 +0100
From:   LABBE Corentin <clabbe@baylibre.com>
To:     Stephen Boyd <sboyd@kernel.org>
Cc:     heiko@sntech.de, herbert@gondor.apana.org.au, krzk+dt@kernel.org,
        mturquette@baylibre.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org
Subject: Re: [PATCH v3 17/26] clk: rk3399: use proper crypto0 name
Message-ID: <Yj1x5hJEKVL71JZ1@Red>
References: <20220321200739.3572792-1-clabbe@baylibre.com>
 <20220321200739.3572792-18-clabbe@baylibre.com>
 <20220325004125.C80FDC340EC@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220325004125.C80FDC340EC@smtp.kernel.org>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Le Thu, Mar 24, 2022 at 05:41:23PM -0700, Stephen Boyd a écrit :
> Quoting Corentin Labbe (2022-03-21 13:07:30)
> > rk3399 has 2 crypto instance, reset for crypto1 is correctly named, but
> > crypto0 not.
> > Add a 0 to be consistent.
> 
> This is OK because nothing is using the define today?

Yes, nothing use this rk3399 define.

> 
> > 
> > Signed-off-by: Corentin Labbe <clabbe@baylibre.com>
> > ---
> >  include/dt-bindings/clock/rk3399-cru.h | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/dt-bindings/clock/rk3399-cru.h b/include/dt-bindings/clock/rk3399-cru.h
> > index 44e0a319f077..39169d94a44e 100644
> > --- a/include/dt-bindings/clock/rk3399-cru.h
> > +++ b/include/dt-bindings/clock/rk3399-cru.h
> > @@ -547,8 +547,8 @@
> >  #define SRST_H_PERILP0                 171
> >  #define SRST_H_PERILP0_NOC             172
> >  #define SRST_ROM                       173
> > -#define SRST_CRYPTO_S                  174
> > -#define SRST_CRYPTO_M                  175
> > +#define SRST_CRYPTO0_S                 174
> > +#define SRST_CRYPTO0_M                 175
> >  
> >  /* cru_softrst_con11 */
> >  #define SRST_P_DCF                     176
> > @@ -556,7 +556,7 @@
> >  #define SRST_CM0S                      178
> >  #define SRST_CM0S_DBG                  179
> >  #define SRST_CM0S_PO                   180
> > -#define SRST_CRYPTO                    181
> > +#define SRST_CRYPTO0                   181
> 
> $ git grep SRST_CRYPTO
> Documentation/devicetree/bindings/crypto/rockchip-crypto.txt:           resets = <&cru SRST_CRYPTO>;
> arch/arm/boot/dts/rk3288.dtsi:          resets = <&cru SRST_CRYPTO>;
> 
> Uh oh. Just don't change it and think about something else when it
> starts to feel inconsistent.

This is on rk3288, so not related to rk3399.
Even on the RK3399 TRM, all crypto clocks are called either crypto0 or crypto1 (neither just crypto)

Regards
