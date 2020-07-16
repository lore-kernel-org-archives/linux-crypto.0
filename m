Return-Path: <SRS0=7zOR=A3=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADDE2C433E4
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 14:13:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 817BC2083B
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jul 2020 14:13:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K77ER9aR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726986AbgGPONK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jul 2020 10:13:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgGPONK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jul 2020 10:13:10 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FE7C061755;
        Thu, 16 Jul 2020 07:13:10 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id h17so2756167qvr.0;
        Thu, 16 Jul 2020 07:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MunR6GZ/FxKH9Lu0jf46UJO1MCI3dtMcL3Xjnx8nY0k=;
        b=K77ER9aR+pqx/w1FjvCLoGx4bmnx/2ysFiLoCUKUY743rR4JHoFmv5q72gUKIDhEbL
         uq9bCW1jTLMn5WJKuKz2As/WzA3039C1Y2yWBCVe+uxNC8upI5Z/dvX777At+scMYozm
         y7lHDAFd6Pj7h1TzD6TEGTSD34DunHCjsV15uFKKnOYSnHM+xpOVW2EERo7Q/XBywkzO
         l5tiSnIjnASSa+Pzxm2FzMVCTbnQdKv/gbbIYYYXEfEukhN5Qy9ksfqg1pUn+W35LJUA
         SDvyzW1Zir1Po3jZUJQUceDtPlKN6iWas44Rk0J2lVdo/kZQSaP7mLgHyhq2Fno4PKpo
         N4vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MunR6GZ/FxKH9Lu0jf46UJO1MCI3dtMcL3Xjnx8nY0k=;
        b=b5omWWBeJ89zzkqEgRvkyk19OpihynKp0yVcFa1/dA6wfpYjGatZHJO0R+YyhshCRd
         16wMJv72t2znFp+lFd1X1nnBy28Ju1jUgqDMeSQZmLstqPsvnEz7zzJWkNIoD7AxUaPF
         FXfCN4TGqsoqkqXNrK/xbFsUfbZGb/hs0HMPV1Nn/71S11ffIDLTVvjxs5Y12Ts53ANW
         5EDDjyPwAmHxTR+WRLzlFB4WgcR8l3U5oOHdA5DegDwa7qKJJeW3Jb1lq6+GZk9Wpvus
         y2v9FzDx8lL2P9ShW09F5MFGgV4gjb74f6aZzLXpVY8715LvnpRM+EKZZv44KI+UoSvR
         UtNw==
X-Gm-Message-State: AOAM53025JsILQHGGUR8fUackYqlT4tcvoMy+gVhD7aiKNCuXo5FyxIQ
        ZhembtiE4gpxEEKVFOeEcOXn05RZ+zN2DVu1KMPhkg==
X-Google-Smtp-Source: ABdhPJwFWc0PEVtHziMstDPi7O8TugU93MCmYBWkGd/i/93U0H14vOAYd5IncF2biXwh9nK49UJ+CCk32Ziy/XJFvTQ=
X-Received: by 2002:a05:6214:a85:: with SMTP id ev5mr4277615qvb.153.1594908789189;
 Thu, 16 Jul 2020 07:13:09 -0700 (PDT)
MIME-Version: 1.0
References: <1594591536-531-1-git-send-email-iuliana.prodan@nxp.com> <1594591536-531-3-git-send-email-iuliana.prodan@nxp.com>
In-Reply-To: <1594591536-531-3-git-send-email-iuliana.prodan@nxp.com>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Thu, 16 Jul 2020 16:12:57 +0200
Message-ID: <CAFLxGvy0T-E-YecWbGZsDVPajuYVc8L-Uf8UCST_61+t+nfhrA@mail.gmail.com>
Subject: Re: [PATCH 2/2] crypto: caam - support tagged keys for skcipher algorithms
To:     Iuliana Prodan <iuliana.prodan@nxp.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Silvano Di Ninno <silvano.dininno@nxp.com>,
        Franck Lenormand <franck.lenormand@nxp.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-imx <linux-imx@nxp.com>, David Gstir <david@sigma-star.at>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 13, 2020 at 12:09 AM Iuliana Prodan <iuliana.prodan@nxp.com> wrote:
>
> Tagged keys are keys that contain metadata indicating what
> they are and how to handle them using tag_object API.
>
> Add support, for tagged keys, to skcipher algorithms by
> adding new transformations, with _tk_ prefix to distinguish
> between plaintext and tagged keys.
>
> For job descriptors a new option (key_cmd_opt) was added for KEY command.
> Tagged keys can be loaded using only a KEY command with ENC=1
> and the proper setting of the EKT bit. The EKT bit in the
> KEY command indicates which encryption algorithm (AES-ECB or
> AES-CCM) should be used to decrypt the key. These options will be kept in
> key_cmd_opt.
>
> The tk_ transformations can be used directly by their name:
> struct sockaddr_alg sa = {
>     .salg_family = AF_ALG,
>     .salg_type = "skcipher", /* this selects the symmetric cipher */
>     .salg_name = "tk(cbc(aes))" /* this is the cipher name */
> };
> or for dm-crypt, e.g. using dmsetup:
> dmsetup -v create encrypted --table "0 $(blockdev --getsz /dev/mmcblk2p10)
> crypt capi:tk(cbc(aes))-plain :32:logon:seckey 0 /dev/mmcblk2p10 0 1
> sector_size:512".

How to use it with cryptsetup?
I'm asking because it is not clear to me why you are not implementing
a new kernel key type (KEYS subsystem)
to utilize tagged keys.
Many tools already support the keyctl userspace interface (cryptsetup,
fscrypt, ...).

-- 
Thanks,
//richard
