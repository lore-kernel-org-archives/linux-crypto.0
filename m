Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A9A4C433E0
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 10:31:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 215D864DCE
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Jan 2021 10:31:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbhA1Kb3 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Jan 2021 05:31:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:34012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232361AbhA1KbR (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Jan 2021 05:31:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D733064DD8;
        Thu, 28 Jan 2021 10:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611829836;
        bh=5KExjknD5ROY6MJJH4AMpEpBg69K6IyRGy7DJFghQSU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MAYXKQPj7Phr0zKfdsdjR2NowUBYLccrkv2I6+gY2N6398NJOihK8JG+nh7rdDN8V
         SAQ9k+8cyUM+Zco07Q03Q5gkTVDYH5k7z0yTlatTFg4YLRFRJqZsYWXzI1Jqp542mS
         NLSHH7IrIPoBBOZ//T4vvZlkleINnEAFVTLK1gnFBP1aUqUWPqbaAmlPEpNcGRwQ0E
         tk272i1ALAQnXZu07LkjIt+U7AQYw50nPr0lOeQCEMFWNxFLjCoJ5UzLX5LLUZb6R9
         scnMfik+RQOt3rsjsv0X+OItouKYfbm6WDq4vq4Jr5RYKKMIxx6mqAfYYelMVo4M3Z
         2CGguzMFcf1qg==
Received: by mail-oo1-f41.google.com with SMTP id y72so1291889ooa.5;
        Thu, 28 Jan 2021 02:30:35 -0800 (PST)
X-Gm-Message-State: AOAM5324UhQmKWy2NI0HD3t2eUZSb4IWhlsxGagUNbE8jg0s8PttIeuy
        66TcRrKqJVFqWjdGfQEHmm3DyPZR7QrybAvCBzM=
X-Google-Smtp-Source: ABdhPJzHSC9XdWNrOQmX/yAuApqLH5pt/bDJz3I4uMWJFHE/10Ziwa+/MLdS5Z2Vg/1oxN0YXzDF1qdzso9mCWNhdLM=
X-Received: by 2002:a4a:e1e4:: with SMTP id u4mr565755ood.41.1611829835089;
 Thu, 28 Jan 2021 02:30:35 -0800 (PST)
MIME-Version: 1.0
References: <1611299395-675-1-git-send-email-yumeng18@huawei.com>
 <1611299395-675-5-git-send-email-yumeng18@huawei.com> <20210128050354.GA30874@gondor.apana.org.au>
In-Reply-To: <20210128050354.GA30874@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Thu, 28 Jan 2021 11:30:23 +0100
X-Gmail-Original-Message-ID: <CAMj1kXHvY9JveFyhtETALCH=AFGMGVbGGFMNDGc6ZVngEKbyDQ@mail.gmail.com>
Message-ID: <CAMj1kXHvY9JveFyhtETALCH=AFGMGVbGGFMNDGc6ZVngEKbyDQ@mail.gmail.com>
Subject: Re: [PATCH v7 4/7] crypto: add ecc curve and expose them
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Meng Yu <yumeng18@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Zaibo Xu <xuzaibo@huawei.com>, wangzhou1@hisilicon.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Daniele Alessandrelli <daniele.alessandrelli@linux.intel.com>,
        Mark Gross <mgross@linux.intel.com>,
        "Khurana, Prabhjot" <prabhjot.khurana@intel.com>,
        "Reshetova, Elena" <elena.reshetova@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 28 Jan 2021 at 06:04, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Jan 22, 2021 at 03:09:52PM +0800, Meng Yu wrote:
> > 1. Add ecc curves(P224, P384, P521) for ECDH;
>
> OK I think this is getting unwieldy.
>
> In light of the fact that we already have hardware that supports
> a specific subset of curves, I think perhaps it would be better
> to move the curve ID from the key into the algorithm name instead.
>
> IOW, instead of allocating ecdh, you would allocate ecdh-nist-pXXX.
>
> Any comments?
>

Agreed. Bluetooth appears to be the only in-kernel user at the moment,
and it is hard coded to use p256, so it can be easily updated.

But this also begs the question which ecdh-nist-pXXX implementations
we actually need? Why are we exposing these curves in the first place?
