Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E197C38A02
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Oct 2022 17:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiJ1RCo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Oct 2022 13:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiJ1RCO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Oct 2022 13:02:14 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C505E1E8B96
        for <linux-crypto@vger.kernel.org>; Fri, 28 Oct 2022 10:00:52 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id x15so4468657qvp.1
        for <linux-crypto@vger.kernel.org>; Fri, 28 Oct 2022 10:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RYQ/XmUKTLIxg2/bBmBEhVhgLpDBA+IR/MiWfkS8faQ=;
        b=eK2T2BFZsMmVIyYtBs0TxAqvAjJMJJviEskSG1mmTefcz83Qzml2HsKCVNkCupdd2Q
         kMtz6rPibF59y3E35JL6+FcUdlPBl8oOyyT2G043EshulM6VnuWi8moV2m573xCNnV55
         2YzXQCGz/TXOJnFhLZ4U4gZ35iLyjiLt2nuu4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RYQ/XmUKTLIxg2/bBmBEhVhgLpDBA+IR/MiWfkS8faQ=;
        b=tH1pNf2xJm5MM4RbMMOEYn+NUL2VeDLam47jD5ftKarxt7wWKS7dxnM4Rpi8ZieFVd
         2tf+byjgeEXKPwfj9p74iW/ghDSJwEP6KgPj6v7vY7JFRsSK2v7W6jEPOSdpdNBHj7Fo
         VHn41i05CooQ8myirePKzRXBLr0fKuEBW9i89PuyevJElnMj54o3hj0wI0TFo0LqJ3I0
         GVYQYKVTe0s/1o+xxdZNelDkFSpPa6ZbjN6iRZqtNkGhzm9Id05RIg5hoJpoXxtghC8P
         T435rGeXbfsImihrw0+SNxlL9pnU5ml3ctyQXUTNCOYBMM3XvyD4dkJ68/AYJl0rVqEh
         BLmg==
X-Gm-Message-State: ACrzQf0ImQaBSU7nUy3S8ppvkQVS8tABIYNQpcjGXguD+5LNf+Uq5VBr
        fJJHEq94Gff3LmNo8kESk/VIqE7/W2gPKQ==
X-Google-Smtp-Source: AMsMyM4ppepQ1kqA5MSuW74q4FuY3mSPiCGBiHIFHxtCJquSsPWoQKHKb9a65cKhWmxEcyiWr1sUhw==
X-Received: by 2002:a05:6214:d0a:b0:4bb:ae9f:63e0 with SMTP id 10-20020a0562140d0a00b004bbae9f63e0mr393292qvh.1.1666976451886;
        Fri, 28 Oct 2022 10:00:51 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id u15-20020a05620a454f00b006ce2c3c48ebsm3448050qkp.77.2022.10.28.10.00.50
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 10:00:50 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id y72so6766646yby.13
        for <linux-crypto@vger.kernel.org>; Fri, 28 Oct 2022 10:00:50 -0700 (PDT)
X-Received: by 2002:a25:bb44:0:b0:6bb:a336:7762 with SMTP id
 b4-20020a25bb44000000b006bba3367762mr148973ybk.501.1666976450437; Fri, 28 Oct
 2022 10:00:50 -0700 (PDT)
MIME-Version: 1.0
References: <20211029041408.GA3192@gondor.apana.org.au> <20211112104815.GA14105@gondor.apana.org.au>
 <YcKz4wHYTe3qlW7L@gondor.apana.org.au> <YgMn+1qQPQId50hO@gondor.apana.org.au>
 <YjE5yThYIzih2kM6@gondor.apana.org.au> <YkUdKiJflWqxBmx5@gondor.apana.org.au>
 <YpC1/rWeVgMoA5X1@gondor.apana.org.au> <Yqw7bf7ln6vtU/VH@gondor.apana.org.au>
 <Yr1XPJsAH2l1cx3A@gondor.apana.org.au> <Y0zcWCmNmdXnX8RP@gondor.apana.org.au> <Y1thZ/+Gh/ONyf7x@gondor.apana.org.au>
In-Reply-To: <Y1thZ/+Gh/ONyf7x@gondor.apana.org.au>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 28 Oct 2022 10:00:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjtC_Z5_xU1q3HTvvLKhjeq--EmSEtkJdfzuFtJs8uQfA@mail.gmail.com>
Message-ID: <CAHk-=wjtC_Z5_xU1q3HTvvLKhjeq--EmSEtkJdfzuFtJs8uQfA@mail.gmail.com>
Subject: Re: [GIT PULL] Crypto Fixes for 6.1
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Oct 27, 2022 at 9:58 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> This push fixes an alignment crash in x86/polyval.

I'm surprised that there isn't a cra_ctxalignment field. Instead there
is crypto_tfm_ctx_alignment(), but that is just an odd way to write
CRYPTO_MINALIGN.

            Linus
