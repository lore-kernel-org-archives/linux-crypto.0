Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1931FC83F1A
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Aug 2023 18:46:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239588AbjH3SoE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:44:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244287AbjH3Mwz (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2023 08:52:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E79D132
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 05:52:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B08B261479
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 12:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D7C0C433D9
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 12:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693399972;
        bh=r0d5HhBS0S3imax1Mb7Wzse8YCCdAYUTOBQu6FlLm3k=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=IwetfIFZcQMzDMebnNaOEuFzEIme+xMjQ8lLYnXWDe2TeKnHG72g/m+DC5v8mvRsA
         aaG3GWp4nRm/UxMH5MawHtlUz62s8ycJTMPUaLYGN+1St7Bx7+BYL5X3Ty08SexqVP
         wisT3KWiOT+3coLTXnJyw80o+uYhlNiYJrXj7Q7AdL7iZMcTQQGrcTRQqjb0fqfReX
         fJ/Rs93bGjjt3ecWx6cwlWEl3WzIyMit1PsJPRLqxaSFWDNb0hyJsUCCtsxu9pEkBY
         Es520U8ipnkH97YSeMTD+AOZmgl+hS3o9x70VnqIyNZiNSLdW3qPvRz3hnsbBt7svn
         vPq1+vkSEwxYg==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-50078eba7afso8938280e87.0
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 05:52:51 -0700 (PDT)
X-Gm-Message-State: AOJu0YzRlC5XZyODYMWT76N7wFcjc8NxEuw4iPtvo3uWNs6mcR+u9NXI
        UtgVMJhjmIb4Dl7C9CIoD3Xm3vl8K0hbMj8KqOI=
X-Google-Smtp-Source: AGHT+IELHrqTpwFaHbd02+Ymu5wcV/HmP4Uq0DScl7iRG9QgQeXEO8/BqdKVdFwR0yRET/bin5j1XsOwG5PT4sL1iOI=
X-Received: by 2002:a05:6512:31c7:b0:4fb:8eec:ce49 with SMTP id
 j7-20020a05651231c700b004fb8eecce49mr1767895lfe.31.1693399970058; Wed, 30 Aug
 2023 05:52:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wgaY2+_KyqVpRS+MrO6Y7bXQp69odTu7JT3XSpdUsgS=g@mail.gmail.com>
 <ZO8HcBirOZnX9iRs@gondor.apana.org.au> <ZO8ULhlJSrJ0Mcsx@gondor.apana.org.au>
In-Reply-To: <ZO8ULhlJSrJ0Mcsx@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Wed, 30 Aug 2023 14:52:39 +0200
X-Gmail-Original-Message-ID: <CAMj1kXFUDP=GsuHOe9bAgv7J=ynrOsNbxdzj2fq9KGkTY7dTOw@mail.gmail.com>
Message-ID: <CAMj1kXFUDP=GsuHOe9bAgv7J=ynrOsNbxdzj2fq9KGkTY7dTOw@mail.gmail.com>
Subject: Re: [PATCH 0/4] crypto: Remove zlib-deflate
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>, kees@kernel.org,
        enlin.mu@unisoc.com, ebiggers@google.com, gpiccoli@igalia.com,
        willy@infradead.org, yunlong.xing@unisoc.com,
        yuxiaozhang@google.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        qat-linux@intel.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 30 Aug 2023 at 12:04, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Aug 30, 2023 at 05:10:08PM +0800, Herbert Xu wrote:
> >
> > Later on someone added "zlib-deflate" to the Crypto API which does
> > emit the zlib header/trailer.  It appears to be completely unused
> > and it was only added because certain hardware happened be able to
> > emit the same header/trailer.  We should remove zlib-defalte
> > and all the driver implementations of it from the Crypto API.
>
> This patch series removes all implementations of zlib-deflate from
> the Crypto API because they have no users in the kernel.
>

Reviewed-by: Ard Biesheuvel <ardb@kernel.org>
