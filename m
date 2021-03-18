Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE947C433E6
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 16:24:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88D9364F40
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Mar 2021 16:24:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231806AbhCRQXc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Mar 2021 12:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbhCRQXH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Mar 2021 12:23:07 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6E3C06174A;
        Thu, 18 Mar 2021 09:23:06 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id z9so5396093ilb.4;
        Thu, 18 Mar 2021 09:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0x7tcZe8hlmMUN/W+gzK7BvYODRvOL+XfP6k+eIgadg=;
        b=sZoQtg066poITjhwH0q/brYwoeDq3JAhLt3YJCsTssP/4jZPa894NUtFt/DRGW2U9/
         5VqwiO68mztTapLm6J0ejfIU10q+Xoqk2UhMRFEi3FT+LbOwqE7eh4ByZpeLQixyTXow
         BDoOg3zm8WQmMIyfbyoPhK0US5bNvx+URqegX3Ddl426ZhTNG2tOzGZNqciQINAUjuOS
         hldDluoqzLzNVznk4UVV/9jJgrnTqA7UJFrtZ/m88000r1zF1kjT8G3zYz+MX/nmry5f
         mI7UROzLqiiWY1RRazegy6DWv4a+JczIpdaOD3i8OPjvXOAgOhxaYAjGRWB0+p0yGG0z
         UJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0x7tcZe8hlmMUN/W+gzK7BvYODRvOL+XfP6k+eIgadg=;
        b=HtKQBI1cEeRZ2PHtRBE+y0BxSAd95o+XpEgZFmMO4qFNNagASB0dcstLaBnGhXVwvg
         1YPlGoU8Mj05NeZIEU1JOb9OJQo8H5aEqJb/RJ2kGMaQnvM1UQUmna5GyX/v3YA1kVfE
         fioEuaSLwKOz5xFzmR5gs4oTW03MYxxubDJt6uBtrMgJnHrQTgyxbzXlbC5ytTSpZ3cP
         rcVLfYuvZxWZtDrFfH8wrR/6MfWwuizZxTaLmuasLEWZ64hmGnecrOOK27degKHGAQFy
         72ukx+IncGPbJsddKuWZYWEa/eb+vV4pXqS01JIM/1ZjuskPE4VSK3+8ZGKcypyLABlz
         WTJA==
X-Gm-Message-State: AOAM5303Nekq9CpmcGxD/jgkt/3gIPNPMv37qdaD6VsMVvijDpn0HUrp
        BgDyfJN2U8GWng7A1Z7ygZDYN0SddqQj0k9YVQmLhANeS4Y=
X-Google-Smtp-Source: ABdhPJxIUB9184z1Vgcgji2Zb9OKkFoVio/Y58VTn4cto0Zw+VFLWVoJ4A88jc+htFYweqErWX83xDctC8N1FsQZxq8=
X-Received: by 2002:a92:5214:: with SMTP id g20mr2904374ilb.260.1616084586217;
 Thu, 18 Mar 2021 09:23:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210312162203.2416149-1-ztong0001@gmail.com> <20210312162203.2416149-2-ztong0001@gmail.com>
 <YFN3X6q8dzEaUp27@silpixa00400314> <YFN6hlz/L7erLO0H@silpixa00400314>
In-Reply-To: <YFN6hlz/L7erLO0H@silpixa00400314>
From:   Tong Zhang <ztong0001@gmail.com>
Date:   Thu, 18 Mar 2021 12:22:55 -0400
Message-ID: <CAA5qM4DJ7N=fR5T-VtuF0qr8jUPtRWbQMNiWQbQ2ysaDrAefQg@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] crypto: qat - dont release uninitialized resources
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>,
        Fiona Trahe <fiona.trahe@intel.com>, qat-linux@intel.com,
        linux-crypto <linux-crypto@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Thanks!
I have fixed typos and resent them as v4.
- Tong
