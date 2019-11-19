Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C161C43215
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 07:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3481021850
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 07:39:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bEgICEq7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfKSHj3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 02:39:29 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39043 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbfKSHj3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 02:39:29 -0500
Received: by mail-wm1-f67.google.com with SMTP id t26so2240745wmi.4;
        Mon, 18 Nov 2019 23:39:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hh4VbnNsZd0cQjCcxR1lcKBnthPXIf0SZTjvhg2Wu+o=;
        b=bEgICEq769u8g2rEZbD8dQT+znw/d/3WiyLyxRoRw2phf9OfSNgEj8y7rBFWslHOfR
         CiDX77/A2ElzxR1iC6wn+xj3FwhUSO1TYld/LPBHJisQ26P/zTwkIc2faQKEab7S9K5B
         HsH8dMCSHs/jsDlCzwdlZl8P42r0ysTzoTlKPEhcOd/U6WJ8NYaSCsSwPONBhtWibdVU
         SaHbl7L/aToxU7ObEv/bZMg9vy9ctB82/goQrJvUIEM+ALSx/ebIDGYx97nXEBsoQ5WG
         b3wj/0dg22lPqwiTsNcqSgc9D20S/yZXLdypRwgJ4EhsEqTuwdOdADXw1Nm8sCNBDoAQ
         ySOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hh4VbnNsZd0cQjCcxR1lcKBnthPXIf0SZTjvhg2Wu+o=;
        b=qsE8YujaLHU1tTa7hnLuScZ5jvQpKiJcEQ8C+XMVQCIWPCab7mxcMnCMuqyPAuFAkX
         m7oyX5Vk/qi0NbVbKcnR3tkTChAOAa4jsSAZ8p0rS/WO3OF30vIL6YtcvQI0PGnqZRfU
         eZ7tFGhzV4I9xVnBXPXDiN4QYDzg4+fX+SEPg9os2U54f/qaO7vAlFJIyCnM7OXpa23G
         XR6q2jfDVtmsGRE9M1J/MGybRfmwYEWILpMoFR+v7AniTmpdsVqR26uUuUCxF3YKBJ/b
         wAY+bT8HuTHzaqqXXSJLoweKoiOHpeM8/eMaH3sFqRNwRuw23U9sha3Bpj9gcxLm1Z/4
         go0Q==
X-Gm-Message-State: APjAAAUz5EGHvtok/Oz9gRVlYnQADcyusy2Rn+0HYLrggxLKmVTLARnF
        ec43VyUfMlseUn4RhXeYmzOXY4HE
X-Google-Smtp-Source: APXvYqz0gH537B8rU2w00QiT/qNEHBVmoinFUpSwuRNgUqOSFjcLDQplIaEzENzq42pnIhByD4QFUw==
X-Received: by 2002:a05:600c:22c1:: with SMTP id 1mr3946744wmg.142.1574149166955;
        Mon, 18 Nov 2019 23:39:26 -0800 (PST)
Received: from Red ([2a01:cb1d:147:7200:2e56:dcff:fed2:c6d6])
        by smtp.googlemail.com with ESMTPSA id k125sm2206895wmf.2.2019.11.18.23.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2019 23:39:26 -0800 (PST)
Date:   Tue, 19 Nov 2019 08:39:24 +0100
From:   Corentin Labbe <clabbe.montjoie@gmail.com>
To:     Maxime Ripard <mripard@kernel.org>
Cc:     davem@davemloft.net, herbert@gondor.apana.org.au,
        mark.rutland@arm.com, robh+dt@kernel.org, wens@csie.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH 2/3] ARM: dts: sun8i: a33: add the new SecuritySystem
 compatible
Message-ID: <20191119073924.GA32060@Red>
References: <20191114144812.22747-1-clabbe.montjoie@gmail.com>
 <20191114144812.22747-3-clabbe.montjoie@gmail.com>
 <20191118111143.GF4345@gilmour.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191118111143.GF4345@gilmour.lan>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Nov 18, 2019 at 12:11:43PM +0100, Maxime Ripard wrote:
> Hi,
> 
> On Thu, Nov 14, 2019 at 03:48:11PM +0100, Corentin Labbe wrote:
> > Add the new A33 SecuritySystem compatible to the crypto node.
> >
> > Signed-off-by: Corentin Labbe <clabbe.montjoie@gmail.com>
> > ---
> >  arch/arm/boot/dts/sun8i-a33.dtsi | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/arch/arm/boot/dts/sun8i-a33.dtsi b/arch/arm/boot/dts/sun8i-a33.dtsi
> > index 1532a0e59af4..5680fa1de102 100644
> > --- a/arch/arm/boot/dts/sun8i-a33.dtsi
> > +++ b/arch/arm/boot/dts/sun8i-a33.dtsi
> > @@ -215,7 +215,8 @@
> >  		};
> >
> >  		crypto: crypto-engine@1c15000 {
> > -			compatible = "allwinner,sun4i-a10-crypto";
> > +			compatible = "allwinner,sun8i-a33-crypto",
> > +				     "allwinner,sun4i-a10-crypto";
> 
> If some algorithms aren't working properly, we can't really fall back
> to it, we should just use the a33 compatible.
> 

Since crypto selftest detect the problem, the fallback could be used and SS will just be in degraded mode (no sha1).
But since nobody reported this problem since 4 years (when SS was added in a33 dts), the absence of sha1 is clearly not an issue.

Regards
