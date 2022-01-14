Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A521BC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 14 Jan 2022 17:17:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243828AbiANRRl (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 14 Jan 2022 12:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbiANRRk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 14 Jan 2022 12:17:40 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F205C061574
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jan 2022 09:17:40 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id o6so36414522edc.4
        for <linux-crypto@vger.kernel.org>; Fri, 14 Jan 2022 09:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kXOG5wo/OKVwRxFyS9neGoQCZ8dRcTxFNJlCoH5deEM=;
        b=JGjX57M0KdUP0XnwMX13D4a+6OkY1ldLR7RAitZhW3+10noOa8C/PO/tgwUozRkz90
         qF6i7eVvTjO8Bpvf96atTWGLHUVAHPt0TD7yicALtLsd5anjLmomXFcFYag8n21lVx5Q
         cmlw+trk9JpX7ncBTfe4W73uHKx86J6/X+7dEWBWbO1JidCvDRIwEn4C6H3JPMX+KgfV
         X/cbwlMqJ39qWwFo3t9XSkcp/lbTsj/4pD8Jw8WSwNVJgBPezvC36mcZ6JKYLF5kURS6
         adx3VjXAa1cjC+/38xfkJJAlxvo0M7NFYUJtBT24Rkzr3F0eHFD2FKrTDJzcXk2NZjNI
         rZeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kXOG5wo/OKVwRxFyS9neGoQCZ8dRcTxFNJlCoH5deEM=;
        b=r/3BbCiVaJbGb49WKAvk7Kb/hATZckO4afEwNqJANwywLp8X6QZ0MAnuoiX7kkF/yC
         3RTLudd8hVth+iOWPM9e63R0bONz2z6eGkEVBF2czLmjY/S3IgHTu4SJWXC9Rtx9bv8Q
         XhHWX9A9BJfF110BGXRhwXp6Kz67tdwaVDkBpaU5eC6c29kUXdG6KGRDR8ScwfeBiw/+
         wFp+DyM6Q7FlUR6tNudN64DyY4am1sHhU8OLLELXt+LOELj6tOIsBfEpMwEvmoSG0lWi
         mHaLQIvg8iC4Ek60Z3uyGYdfDv3TTXX2h5VM6I4m+EcRAFv37jVTK3FjAvH74w8bszzE
         lncA==
X-Gm-Message-State: AOAM533OOBBfl3Y20QkKDHiBwU82cCdA1cw3OuRsYO7q3KOqNNjNUfIO
        CASNdke6mUd0/npw74CgWOampd/Ox3hejtaCXE9/cpyroPY=
X-Google-Smtp-Source: ABdhPJyyraqqv2bDOlbFJ4paIGqELkqbKkT/w0q0Ihl/eK3Z2j33S/YMb9hRMRoR5rOVyGP7+uCs2YbXQRKemc8DXk4=
X-Received: by 2002:a17:907:7601:: with SMTP id jx1mr7743571ejc.696.1642180658933;
 Fri, 14 Jan 2022 09:17:38 -0800 (PST)
MIME-Version: 1.0
References: <AM9PR04MB82114956521F134B09FF5D9CE8539@AM9PR04MB8211.eurprd04.prod.outlook.com>
In-Reply-To: <AM9PR04MB82114956521F134B09FF5D9CE8539@AM9PR04MB8211.eurprd04.prod.outlook.com>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Fri, 14 Jan 2022 14:17:27 -0300
Message-ID: <CAOMZO5DDvVo3Ziuq6_GM=NDm0TdygwBvQzAQ41H16E0rjVUWTQ@mail.gmail.com>
Subject: Re:
To:     Varun Sethi <V.Sethi@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "andrew.smirnov@gmail.com" <andrew.smirnov@gmail.com>,
        Horia Geanta <horia.geanta@nxp.com>,
        Gaurav Jain <gaurav.jain@nxp.com>,
        Pankaj Gupta <pankaj.gupta@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Varun,

On Thu, Jan 13, 2022 at 2:53 PM Varun Sethi <V.Sethi@nxp.com> wrote:
>
> Hi Fabio, Andrey,
> So far we have observed this issue on i.MX6 only. Disabling prediction resistance isn't the solution for the problem. We are working on identifying the proper fix for this issue and would post the patch for the same.

Please copy me when you submit a fix for this issue.

Thanks!

Fabio Estevam
