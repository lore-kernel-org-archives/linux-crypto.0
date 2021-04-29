Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C32B7C43461
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 14:05:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F0656143A
	for <linux-crypto@archiver.kernel.org>; Thu, 29 Apr 2021 14:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238595AbhD2OGA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Apr 2021 10:06:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239049AbhD2OF6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Apr 2021 10:05:58 -0400
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC07C06138B;
        Thu, 29 Apr 2021 07:05:11 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id a36so65713287ljq.8;
        Thu, 29 Apr 2021 07:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y6odb9TW+6unlb0u1kmwWgOwlmmDgi1XBtwxHyVRntg=;
        b=Ln6wZyd2hkc4PwaDRTAFNM06A+bwtzAw0AqBWHNuWQSh0SXjmN0Ev5KYMtxqjYEb3F
         durCpqsOSoNillWO0eMdQY4GlXKm71VhhC5cYrfDNWsUmf+JDXSKWD83MsuykSaJ9Lik
         tCkz6V1sip2rGoERzhy/jMfPcqD/m2qQmFwx5kZWyPi0+H8wkNIBqsY4EvURMljWYukR
         7Kog60p9Si2V1TeTECCWVcZVFUMCRasRJkUxAwrAte+VBU/ydKzHxJpJ6YNaMb91nkGD
         lMrk7n2SNy2PGrBRS+cAffXvnekn8xFkO+kshy+FpZ/SwwryIFo60qrw0hpLOnsiWV+0
         HNCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y6odb9TW+6unlb0u1kmwWgOwlmmDgi1XBtwxHyVRntg=;
        b=pRvji8o9mMVkahD8IMhvnEajN9i3HeEvVOu/AOB8zbTm0K86gQKGblZLM0p/W8Mmn5
         Z51J6x+WvlEHsFCqymct/m+Fe5FBALmDYVF7A09QC3zb/U8YcOwpOpwN4aMyTFngNg2b
         sIeffiQsAKoJNDiV1768HphDHAckOJNAAiWeMCQq3mxgHfMQXffgFgcCvmcB1NZLmabY
         7dmH3Vmu0UoTi5FbSlYUa5WHw3y0FGFI9ayE8pl5EZK7bnJc/TI06frqbOIlusBEdH/I
         c7TTLTeaBqPvi0kNxCAW1Z8Q10SM0uk4fxF2Xk0oiqe2IzhU/8upG6ADOWzjyZoi+VAX
         V6ig==
X-Gm-Message-State: AOAM533BHmGpn2uaIMwkhnyMi1ORNpMc6XwYSL8Fy5KiU/ofPmiw+d99
        IpNMO1V/onTuMruJyvHrq+QH6dK6dfI67kSoYlE=
X-Google-Smtp-Source: ABdhPJwx4t1tAnURqC3cIXrCQ9MYDyCneDMRS6iP4fzjzrcrxfCRfpoLO16QkB+XdR5dd9BybJbBRrESpxlRoa448/Y=
X-Received: by 2002:a2e:95d7:: with SMTP id y23mr22044832ljh.444.1619705109668;
 Thu, 29 Apr 2021 07:05:09 -0700 (PDT)
MIME-Version: 1.0
References: <20210429140250.2321-1-alice.guo@oss.nxp.com> <20210429140250.2321-2-alice.guo@oss.nxp.com>
In-Reply-To: <20210429140250.2321-2-alice.guo@oss.nxp.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Thu, 29 Apr 2021 11:04:58 -0300
Message-ID: <CAOMZO5Cbfh3Aj5-i2y+GDZ=-SZw-wLMbPMew=YTcf9Yr6ohVCw@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] caam: imx8m: change to use of_match_node in run_descriptor_deco0
To:     "Alice Guo (OSS)" <alice.guo@oss.nxp.com>
Cc:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Sascha Hauer <kernel@pengutronix.de>,
        Horia Geanta Neag <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        dominique.martinet@atmark-techno.com,
        NXP Linux Team <linux-imx@nxp.com>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Alice

On Thu, Apr 29, 2021 at 11:02 AM Alice Guo (OSS) <alice.guo@oss.nxp.com> wrote:
>
> From: Alice Guo <alice.guo@nxp.com>
>
> Patch "fix the built-in caam driver cannot match soc_id" provides
> imx8m_machine_match to match i.MX8M{Q,M,N,P}, so change to use to
> of_match_node which can simplify the code.

Shouldn't these patches be squashed?
