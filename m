Return-Path: <SRS0=xlEn=32=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52518C352A2
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 20:46:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27F4522522
	for <linux-crypto@archiver.kernel.org>; Thu,  6 Feb 2020 20:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581021979;
	bh=vqnje4SrK7zmksL6qpw8d1YvwCA2XTOc+khujOgY4kM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=p3HUaDE/enB7ZfxytImnLLu6bV4Hwgah7mGifuRbglMg/X9P00JGQ+oRBNtp9GoN/
	 DElm9BNp+r7PKURFHmswfl4ljglXYhiBMWHF0K91fNwl1S6Ik8Q1OSO27o2+7c5G/p
	 JET1w6xVHaZPM2TIak2lozwiQQNpGjxh8wK/AwOs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgBFUqJ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 6 Feb 2020 15:46:09 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33799 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728150AbgBFUqI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 6 Feb 2020 15:46:08 -0500
Received: by mail-pg1-f195.google.com with SMTP id j4so3356516pgi.1;
        Thu, 06 Feb 2020 12:46:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=8CEel95Qe0K0FMLgiCiTMequMG6yZDFIWpQ5eQwLax4=;
        b=qwuTV2bGE5go6Dr3hk/G9xxmRw/YSrJGgeLoMC/iiRzHARB7EdSUgLGnOZ8JhU2Gku
         Bh17V0Pl0N7l4wP9FW+PsyLFWmV7DSZVxkzSkIwbfnttYiswqubQ6xFWP2MFn3bdcwCc
         1ChkoSEDaCcK/Rlu+gx6tEHQqZYzKwrRHBgVvpDMB6xk1+KxMDFZ0dLGpcBO8rU0aGs4
         9aNIYSMfTrAw1uvCfwoFomiQ/kS6xkmDLUkS9cYxoc7iJT9BgvxDzHrCS6qsbhhHDH+z
         ei/BSlk2JI3D/oh5o4eY/fDwmHuZHXIMEOPADI4UGy1MzrDin1/JTYVGIZxK0q4WhHjA
         WxlA==
X-Gm-Message-State: APjAAAV6NYTIp93DnC93iPZ6EVCMy/KuYo/XmbTNRThDB6O/Y77d0O6z
        EYbXdUEfM3mFuUV5LGna3shnuRpJ5Q==
X-Google-Smtp-Source: APXvYqx1NnBAhQrChlAlk+joiqFOCP58iYcXSFU1wddrjPp0aH7Qq0MEkUwXPJE9lP0gLPlBBbd93w==
X-Received: by 2002:a62:8246:: with SMTP id w67mr5850174pfd.107.1581021968038;
        Thu, 06 Feb 2020 12:46:08 -0800 (PST)
Received: from rob-hp-laptop (63-158-47-182.dia.static.qwest.net. [63.158.47.182])
        by smtp.gmail.com with ESMTPSA id 133sm293844pfy.14.2020.02.06.12.46.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 12:46:07 -0800 (PST)
Received: (nullmailer pid 27633 invoked by uid 1000);
        Thu, 06 Feb 2020 18:30:53 -0000
Date:   Thu, 6 Feb 2020 18:30:53 +0000
From:   Rob Herring <robh@kernel.org>
To:     =?iso-8859-1?Q?Andr=E9?= Draszik <git@andred.net>
Cc:     linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Andr=E9?= Draszik <git@andred.net>,
        Anson Huang <Anson.Huang@nxp.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-crypto@vger.kernel.org, devicetree@vger.kernel.org,
        linux-input@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: dts: imx7s: add snvs clock to pwrkey
Message-ID: <20200206183053.GA27553@bogus>
References: <20200130204516.4760-1-git@andred.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200130204516.4760-1-git@andred.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 30 Jan 2020 20:45:14 +0000, =?UTF-8?q?Andr=C3=A9=20Draszik?= wrote:
> On i.MX7, the SNVS requires a clock. This is similar to the clock
> bound to the SNVS RTC node, but if the SNVS RTC driver isn't enabled,
> then SNVS doesn't work, and as such the pwrkey driver doesn't
> work (i.e. hangs the kernel, as the clock isn't enabled).
> 
> Also see commit ec2a844ef7c1
> ("ARM: dts: imx7s: add snvs rtc clock")
> for a similar fix.
> 
> Signed-off-by: André Draszik <git@andred.net>
> Cc: Anson Huang <Anson.Huang@nxp.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: "Horia Geantă" <horia.geanta@nxp.com>
> Cc: Aymen Sghaier <aymen.sghaier@nxp.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Cc: linux-input@vger.kernel.org
> ---
>  .../devicetree/bindings/crypto/fsl-sec4.txt     | 17 +++++++++++++++++
>  arch/arm/boot/dts/imx7s.dtsi                    |  2 ++
>  2 files changed, 19 insertions(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
