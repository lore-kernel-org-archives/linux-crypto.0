Return-Path: <SRS0=O5Fb=WI=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2B1C31E40
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 17:57:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 704FF20663
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Aug 2019 17:57:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WRZkDvCO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726509AbfHLR5B (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 12 Aug 2019 13:57:01 -0400
Received: from mail-ot1-f68.google.com ([209.85.210.68]:41736 "EHLO
        mail-ot1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726424AbfHLR5A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 12 Aug 2019 13:57:00 -0400
Received: by mail-ot1-f68.google.com with SMTP id o101so9230741ota.8;
        Mon, 12 Aug 2019 10:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cu1PSO9C5Z82oaeLJkQVFAzUUfrU4eyOeJf2/ioPt3k=;
        b=WRZkDvCOV26ZyXE/CbSb5sHEDyli4uhvIH7gvEWkxSIEYz31WVkzoPEydgnH4k5kRg
         B5gT3HfQbebqxqVD2aUF2HxXIni0ochD31CB2mEDZeGX2qDR9WGbCosVvydleNRaDAbC
         YkSlmmjaRo23i6YfOfTImXEABxNnDGZV5p3Nc3wMzUglvk+whKxmzsKOEPnuxJiylZJk
         Zd8FO4uIhQf/DgtgtFFwp3xdl7GW4Oy3xlGvRwfMYO6T04fvWcoDS3gIeMMuwXDlHgMY
         6dztTxjJsyt3UFLYPYHwk66/LkavPO67I5RilA5A4bkBpNxeCpk11X7qfyjZ1AAtel1n
         IM8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cu1PSO9C5Z82oaeLJkQVFAzUUfrU4eyOeJf2/ioPt3k=;
        b=Kqx1K8huY6uTYXLFaCyMU34athAiHJxlNckZ10nHBsiq/OMnJV1i8L4YOFdaR4Me+V
         q1B3OZw4JqZcwBWyjLt4QB7BujfQ6PMrSr1kgSbdl4V7couZQydnVKvFQP2QAmQOLunA
         Oswx03506bfPb/q5IhOWPXKWKELHIhChWFWRBFXNGrF+x/37qpp9regttKIEe3TivgiH
         HkE5kq87IQPDQZb27oUKTOYkaDuCt5itvQ+i084BDw6N88bp/wAlxOt6yYb7rfg3DcPE
         Gk3mziG5F71Rwxj0Rjs/4BdGwWnjzxnPDrJ7F39tLzcwM89+713T/c/sUlbFqi4/FA8P
         +kLg==
X-Gm-Message-State: APjAAAU8Ua+5yzI1NzCAV8kbhL9+g85JQRUtH6nZdTtWhWZ7Ryf6tOAE
        42DWK/mbfjxRBK1HZoRYMTsHDvVxFlnWaoQhNZg=
X-Google-Smtp-Source: APXvYqwioB/0o7g7gXKoeA4VY7ctTqqIDuqjjJVZU4vEp4Ft0NqbBVRD8cE8u8rvi0hyFQzjkIekgrfHtGo03XkBaiI=
X-Received: by 2002:a6b:4107:: with SMTP id n7mr11444756ioa.12.1565632619742;
 Mon, 12 Aug 2019 10:56:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190717152458.22337-1-andrew.smirnov@gmail.com>
 <20190717152458.22337-9-andrew.smirnov@gmail.com> <VI1PR0402MB3485472C45A477FB0848802498C70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
In-Reply-To: <VI1PR0402MB3485472C45A477FB0848802498C70@VI1PR0402MB3485.eurprd04.prod.outlook.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Mon, 12 Aug 2019 10:56:48 -0700
Message-ID: <CAHQ1cqEGZNUtAzprVLasM9aFL0rBBOUbtKVEt0KBkfQMvG0u0g@mail.gmail.com>
Subject: Re: [PATCH v6 08/14] crypto: caam - make CAAM_PTR_SZ dynamic
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Chris Spencer <christopher.spencer@sea.co.uk>,
        Cory Tusar <cory.tusar@zii.aero>,
        Chris Healy <cphealy@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 23, 2019 at 2:57 AM Horia Geanta <horia.geanta@nxp.com> wrote:
>
> On 7/17/2019 6:25 PM, Andrey Smirnov wrote:
> > In order to be able to configure CAAM pointer size at run-time, which
> > needed to support i.MX8MQ, which is 64-bit SoC with 32-bit pointer
> > size, convert CAAM_PTR_SZ to refer to a global variable of the same
> > name ("caam_ptr_sz") and adjust the rest of the code accordingly. No
> > functional change intended.
> >
> I am seeing compilation errors like:
>
> In file included from drivers/crypto/caam/ctrl.c:25:0:
> drivers/crypto/caam/qi.h:87:6: error: variably modified 'sh_desc' at file scope
>   u32 sh_desc[MAX_SDLEN];
>       ^
>
> Adding comments for this commit, since it looks like the fixes
> should be included here (related to DESC_JOB_IO_LEN vs. DESC_JOB_IO_LEN_MAX).
>
> Please make sure caam/qi and and caam/qi2 drivers are at least compile-tested.
>
> By caam/qi I am referring to:
> CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI=y/m
>
> and caam/qi2:
> CONFIG_CRYPTO_DEV_FSL_DPAA2_CAAM=y/m
>

Sorry about that, should be fixed in v7.

Thanks,
Andrey Smirnov
