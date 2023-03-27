Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1422FC76195
	for <linux-crypto@archiver.kernel.org>; Mon, 27 Mar 2023 16:26:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbjC0Q0e (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Mar 2023 12:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjC0Q0c (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Mar 2023 12:26:32 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1829FB
        for <linux-crypto@vger.kernel.org>; Mon, 27 Mar 2023 09:26:31 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id z17so1375122vsf.4
        for <linux-crypto@vger.kernel.org>; Mon, 27 Mar 2023 09:26:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1679934391;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=STHUvTYbsFLxECkk6Ly3TGpifupwlelS3imRFFmcQ1g=;
        b=I3xcPyZz0Nt3ES4tHyCTFf23qez+BpAxS/rO/QjdDLM+z/s2hBidzFRiZcqntrPSDS
         Z5qWZK168IgAAc+Fusp+l//Mek01dRDhZivNtiPtvOiu5oj8hbbtcTJJiftgaiv7X0di
         hG59TxwL1YL/w5/hxH1Bd6LyaKXVxw+Ql4OO4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679934391;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=STHUvTYbsFLxECkk6Ly3TGpifupwlelS3imRFFmcQ1g=;
        b=rHgCnTd9wLqubsAMUzeL0H/+p1KWJuQucKZQwUyR1JqPtmwrcuKnnKByh++0rfOjuw
         nSmDswsBZDpsjRAiQv9xqLQYLz+MxAFio+GTjwW5vjlO8HdyNd5j8JZMoa0HDjzrGoHv
         kdWKLpFWZaL6IFnfEAQEuKRq0qCxU1ciikKxhcRd1U4UK9StBRzx+CpivH5nzmxE5VS+
         0OSg2JwOAKdqGfT2mePjxbzV0/St/tMiI8Dk8kw9XkpOCUvlzImeoPpbSJ6zKjje1sDI
         Dbz5+LJuDRZIkZY1bto0txZYpvrcSZ3PO1W0RzB45sZXN3ybJpVXtOf/ZbHUlhmlhJ2z
         dkNA==
X-Gm-Message-State: AAQBX9fiFU2HR1m1pCIR95sHpiY2U/O4zqSrXT5BU5Jx0qK5OfG++g4s
        dAH4z/hlxckb5XcwBvGhVc0qoHw2XI4ia5lyo6zbLg==
X-Google-Smtp-Source: AKy350bn+gneDCey7btdlGuOb4uNyw6uKx89wGx6d6nUkuM0Seabm5DPMfnDkpjY1BJK9O/Fjs0NUgmKxLEbIuX6o1g=
X-Received: by 2002:a67:c202:0:b0:425:d096:fd42 with SMTP id
 i2-20020a67c202000000b00425d096fd42mr6060497vsj.5.1679934390956; Mon, 27 Mar
 2023 09:26:30 -0700 (PDT)
MIME-Version: 1.0
References: <20230322210227.464-1-mario.limonciello@amd.com> <20230322210227.464-3-mario.limonciello@amd.com>
In-Reply-To: <20230322210227.464-3-mario.limonciello@amd.com>
From:   Mark Hasemeyer <markhas@chromium.org>
Date:   Mon, 27 Mar 2023 10:26:20 -0600
Message-ID: <CANg-bXCcbQn3CfDh6YVrSsxUAAAySR05+dVzvQ=XxLb0HaHeaQ@mail.gmail.com>
Subject: Re: [PATCH v6 2/4] crypto: ccp: Return doorbell status code as an argument
To:     Mario Limonciello <mario.limonciello@amd.com>
Cc:     =?UTF-8?B?SmFuIETEhWJyb8Wb?= <jsd@semihalf.com>,
        Grzegorz Bernacki <gjb@semihalf.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        John Allen <john.allen@amd.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

> -int psp_ring_platform_doorbell(int msg)
> +int psp_ring_platform_doorbell(int msg, u32 *result)
>  {
>         struct psp_device *psp = psp_get_master_device();
>         struct psp_platform_access_device *pa_dev;
> @@ -184,6 +184,8 @@ int psp_ring_platform_doorbell(int msg)
>
>         val = FIELD_GET(PSP_CMDRESP_STS, ioread32(cmd));
>         if (val) {
> +               if (result)
> +                       *result = val;
>                 ret = -EIO;
>                 goto unlock;
>         }
The bitfields in the new mailbox architecture have changed, as it is
now a dedicated mailbox for I2C arbitration. The 8 lsbs are used for
command and response status, and bit 31 is the ready bit.
Accounting for these changes, I was able to get the TPM contention
test to pass locally. I also removed calls to "check_doorbell" and
"check_recovery" as those steps weren't described in the design doc.
