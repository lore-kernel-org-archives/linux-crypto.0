Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08C40C433EF
	for <linux-crypto@archiver.kernel.org>; Sat,  7 May 2022 08:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383752AbiEGIpf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 7 May 2022 04:45:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383733AbiEGIpe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 May 2022 04:45:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C86093F304
        for <linux-crypto@vger.kernel.org>; Sat,  7 May 2022 01:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1651912907;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pH/8q4WWU1F57uoZuiEXN9uHXlw/jrDUSuY49/KnKJw=;
        b=XnlBjqlNMMhQWursFY6HaANegJABInZXYtHnLusS/w38WdKjUdO/sftkkMVIYkJ+0gWijt
        TGJpUPv7dAWjTnBmiq88QRFZEDw0esipV7NLFtGa996X31kB9ajnU8WtkFoOdL9eBFVON+
        AKiQWkgU9NwAE0EMw0rRq0TzZberYuU=
Received: from mail-yb1-f198.google.com (mail-yb1-f198.google.com
 [209.85.219.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-583-IyRHl51iNSmzypx0h1FHww-1; Sat, 07 May 2022 04:41:45 -0400
X-MC-Unique: IyRHl51iNSmzypx0h1FHww-1
Received: by mail-yb1-f198.google.com with SMTP id z14-20020a5b0b0e000000b0064848b628cfso8163064ybp.0
        for <linux-crypto@vger.kernel.org>; Sat, 07 May 2022 01:41:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pH/8q4WWU1F57uoZuiEXN9uHXlw/jrDUSuY49/KnKJw=;
        b=5gjWT5Aw3lsTJ4x32SbzCFjeO5U0PckcKT4f9IbptjO/1nbYQp/yUdgXDqqUKOccMV
         Z+Z6/z0mkDEZsQsoGeDcvFg5UdPyNf7b5PAz1eM/Az/LxHg8gRgLIWCfxMvgCctLSni0
         VAtOAOb/jav8mjS6BU1noUIr/cTnu5QXhkiqIWo3EkaTJO/6wMfYjz6U6o9lCW469U32
         nMPvfKy6pEx7ORGOLBUuyDyrdPg7GiK3Hk26vo0ka7NQ+IArHOrbKcY6hM5tmqdXnjJJ
         t3jvFM71wyfC2/0PiFZUH8cSpYMA2k27kVQ0Z/TJ9j0HaFlxNpYw4NnpfdNpiBReuMuz
         owYQ==
X-Gm-Message-State: AOAM532wDlxReEZRo0lJ4d91VKmZR6oXi9tMAbkZ4GYVDLQpwP0F7J1d
        0/WtMMfVuqat1rXx3aSq2v8C5e6Xkvx0525KbJoX/kSuwSkO/LncgIEvHtON3hoszPidp/wbElr
        qpN36Nc4Y8ASsGp02tDPLikxiNWzTKV+ftyXKRnM6
X-Received: by 2002:a25:d209:0:b0:648:370f:573c with SMTP id j9-20020a25d209000000b00648370f573cmr5570210ybg.255.1651912904428;
        Sat, 07 May 2022 01:41:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyL8lHgmhm01MbdmhDDqtcHd5MtPPN2X8/3Y6Vo0COEyOTfbsiMCUsGQj/N/qrO0ZhjLJ/gcTEuPNxd2WmE35I=
X-Received: by 2002:a25:d209:0:b0:648:370f:573c with SMTP id
 j9-20020a25d209000000b00648370f573cmr5570202ybg.255.1651912904261; Sat, 07
 May 2022 01:41:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220503115010.1750296-1-omosnace@redhat.com> <YnFUH6nyVs8fBgED@x1>
In-Reply-To: <YnFUH6nyVs8fBgED@x1>
From:   Ondrej Mosnacek <omosnace@redhat.com>
Date:   Sat, 7 May 2022 10:41:32 +0200
Message-ID: <CAFqZXNsQK-0knY-W4YojJEFapJyWZBsf9sE=L=0drXnb4SPQeA@mail.gmail.com>
Subject: Re: [PATCH] crypto: qcom-rng - fix infinite loop on requests not
 multiple of WORD_SZ
To:     Brian Masney <bmasney@redhat.com>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-msm@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Stable maillist <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, May 3, 2022 at 6:11 PM Brian Masney <bmasney@redhat.com> wrote:
> On Tue, May 03, 2022 at 01:50:10PM +0200, Ondrej Mosnacek wrote:
> > The commit referenced in the Fixes tag removed the 'break' from the else
> > branch in qcom_rng_read(), causing an infinite loop whenever 'max' is
> > not a multiple of WORD_SZ. This can be reproduced e.g. by running:
> >
> >     kcapi-rng -b 67 >/dev/null
> >
> > There are many ways to fix this without adding back the 'break', but
> > they all seem more awkward than simply adding it back, so do just that.
> >
> > Tested on a machine with Qualcomm Amberwing processor.
> >
> > Fixes: a680b1832ced ("crypto: qcom-rng - ensure buffer for generate is completely filled")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
>
> Reviewed-by: Brian Masney <bmasney@redhat.com>
>
> We should add '# 5.17+' to the end of the stable line.

Is that really relied upon any more? AFAIK, the stable maintainer(s)
already compute the target versions from the Fixes: tag. And the
version based on the original commit would be inaccurate in many
cases, as the commit may have been already backported to earlier
streams and you need to patch those as well. Thus, I believe it's
better to leave out the version hint and force people to look up the
Fixes: commit instead, which is more reliable. Also if you grep the
latest mainline commits for 'Cc: stable@vger.kernel.org', you'll see
that most commits don't include the version hint any more.

-- 
Ondrej Mosnacek
Software Engineer, Linux Security - SELinux kernel
Red Hat, Inc.

