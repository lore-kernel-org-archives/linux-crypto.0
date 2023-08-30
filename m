Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E889C83F19
	for <linux-crypto@archiver.kernel.org>; Wed, 30 Aug 2023 18:46:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240991AbjH3So2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 30 Aug 2023 14:44:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245536AbjH3P3g (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 30 Aug 2023 11:29:36 -0400
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40690113
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 08:29:34 -0700 (PDT)
Received: by mail-lf1-x134.google.com with SMTP id 2adb3069b0e04-500913779f5so9212997e87.2
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 08:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1693409372; x=1694014172; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=8BUETPg5jywMfGefGnBSJMhz3gp4xWIJkQEYcHq56ng=;
        b=S67KVmKPQifEtkrdWUTLiFxRfIxoRfsr+9r7hbldmMnVShCmlC9bVN9dlRIMs41+mU
         ES3s2Tlk1E/HBPUgiWh80FNEOi8nrDjI92LH+UxXGQJOL4++V19NsF9SyVsVQIh2anil
         UU0GcGlHpLrMtg5mBs/dJIYsAbYr4hiDf01oM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693409372; x=1694014172;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8BUETPg5jywMfGefGnBSJMhz3gp4xWIJkQEYcHq56ng=;
        b=VD9mfOb9qSEcQ4E0qHWZBRAaahPh3qKZmDotZHZbw7PNA0w0QA0dBJgE8ps9q4SbXh
         I8nkQtUK1qAp80kdRqSwVpABLAp5rZYEL2xPAIflcAtqP2PIS/zaEj+kc3A4DRTvFrIu
         qqAjXqwEXrda9P5qtErKdjuEYuFa3Oe8k6hVSmi+sviCHgSbO9EpHfYzG9Ety2RuY7YT
         Tf9g5UdEWF+Sux5Y+OsH2BAZSY0hVU4NWdH668I5rwlXY5/qWqRbOfUk+m9+RWGxZPXb
         7goDDsekVD4pXqW7K5RK/1Gxk6zuljux5bp5gKM0uy9JaRTx6L11xrcpDd0kSS1Ggzu4
         XWeQ==
X-Gm-Message-State: AOJu0YyJs+2lhSizdWcXFJ0lF3D6Nx0vFHqCFI0gTFprKgSh9XX6Fp4v
        b9UhVhsRP3ZHkvrxCp+pWYOUJI6WLw5vC68Cn0Xt0IwF
X-Google-Smtp-Source: AGHT+IEF1MCZmsvpPsQG9QQYMO3nt62LLW6NPG+izBaQj5x3ZrJzkUFXpgr/6Ppc9k73XvdE9rLE+Q==
X-Received: by 2002:ac2:58f0:0:b0:500:bb99:69a7 with SMTP id v16-20020ac258f0000000b00500bb9969a7mr1325093lfo.14.1693409372261;
        Wed, 30 Aug 2023 08:29:32 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id v29-20020a056512049d00b005007dcecd56sm2428039lfq.125.2023.08.30.08.29.30
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Aug 2023 08:29:31 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-2bceca8a41aso84513971fa.0
        for <linux-crypto@vger.kernel.org>; Wed, 30 Aug 2023 08:29:30 -0700 (PDT)
X-Received: by 2002:a2e:850a:0:b0:2bc:fb79:d165 with SMTP id
 j10-20020a2e850a000000b002bcfb79d165mr2402634lji.39.1693409370537; Wed, 30
 Aug 2023 08:29:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAHk-=wgaY2+_KyqVpRS+MrO6Y7bXQp69odTu7JT3XSpdUsgS=g@mail.gmail.com>
 <ZO8HcBirOZnX9iRs@gondor.apana.org.au> <ZO8ULhlJSrJ0Mcsx@gondor.apana.org.au>
In-Reply-To: <ZO8ULhlJSrJ0Mcsx@gondor.apana.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 30 Aug 2023 08:29:13 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjBkjrp-s8HqOVGbaGzM=0FMWLxTMPW5bwqgBe4cdKhEg@mail.gmail.com>
Message-ID: <CAHk-=wjBkjrp-s8HqOVGbaGzM=0FMWLxTMPW5bwqgBe4cdKhEg@mail.gmail.com>
Subject: Re: [PATCH 0/4] crypto: Remove zlib-deflate
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     ardb@kernel.org, kees@kernel.org, enlin.mu@unisoc.com,
        ebiggers@google.com, gpiccoli@igalia.com, willy@infradead.org,
        yunlong.xing@unisoc.com, yuxiaozhang@google.com,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        qat-linux@intel.com,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Yang Shen <shenyang39@huawei.com>,
        Zhou Wang <wangzhou1@hisilicon.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, 30 Aug 2023 at 03:04, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This patch series removes all implementations of zlib-deflate from
> the Crypto API because they have no users in the kernel.

Lovely. Thanks,

                Linus
