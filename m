Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 504F5C433F5
	for <linux-crypto@archiver.kernel.org>; Mon,  3 Oct 2022 12:14:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiJCMO5 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 3 Oct 2022 08:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiJCMO4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 3 Oct 2022 08:14:56 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C65D15FCF
        for <linux-crypto@vger.kernel.org>; Mon,  3 Oct 2022 05:14:54 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bj12so21658618ejb.13
        for <linux-crypto@vger.kernel.org>; Mon, 03 Oct 2022 05:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=g5n031yg49jSl8KXQQbrCZvmJMDawrHsM/RBuMG5G4w=;
        b=VfJ0Xy8aDG2rDz0lZVdWtctILvo/Dg4xp9bQNbrUq5ff+GdLsSc1YQgpJJeOh1C/lt
         Ei2Ua2sTGYKgSEPivRsaDG/WctWzh+tBt9RtmRltJKG81jcHmf6jgmJWKNCyhllEf/QS
         oTpjmDbmMwGGUIeuckUw1unuzhhwapZpZdKy1BlfuYusXDQqwt2YiIOXXMlRpmrFa8QV
         NoX2FRSaZqIIgK+9iZ+uPpYaYiwYgKfwMRKRf4jeBwH+uKFaYVeZLESUfK+JvLFpoI5v
         ajhfTH7rGRH4oYSNazF6lw2BQgmLUKLE3GXM7IHLmmsj+HNO+CrfRKAb3ZM0E8bg6hvP
         G1OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=g5n031yg49jSl8KXQQbrCZvmJMDawrHsM/RBuMG5G4w=;
        b=8GKVlyJguBgPQMWDaM3o3okf5HNe2aZOIFVxnnnx55jp0JjbFe5d5qd/cjIIb4XSGR
         L9XRYnA+1GZAJ1BYcgYdNKpkFZjRGR/HUU09zJzIJZOh22QyNOLHOCdG+3moaDswAY8e
         NVG/9HEH97QMOqy5o/m3k2vL1713FMKyLbBlRLpvMupe67CkB0fxKMV1rb836nVtsRFQ
         pjmeY9SqYh2bldJyOM3+kDKjq3jKsJCuotXM/T+jMneht/MgQTFcrRAh+ITJvEsu1ttR
         +qiN+MV8/ziIS8CnlbfLXCQBRjaIFSMH2Mw9J2PAx2gMo7MsGx79Zm08GDKZ3dsVRXJ8
         dxKw==
X-Gm-Message-State: ACrzQf3rkAAjYyzm1ZJqEOlJDxkBnJhS5gSulS+eKyKP/nu8Pl+j2Hnt
        xMDxa6IAI0/CRIxXMzbHXgP/wLiZL8DXU51qfZNaCOhQasI=
X-Google-Smtp-Source: AMsMyM5MFXEpfRpFCxSg0Sg36EL702VfJlj180YQGBaHr79I3uHu/OK0WaTngL40kWEbSiHyZVd8LEiMwi1CaB/pegw=
X-Received: by 2002:a17:906:5d04:b0:77f:ca9f:33d1 with SMTP id
 g4-20020a1709065d0400b0077fca9f33d1mr15429810ejt.526.1664799292681; Mon, 03
 Oct 2022 05:14:52 -0700 (PDT)
MIME-Version: 1.0
References: <YzaIHqpGR60bQMt0@gondor.apana.org.au>
In-Reply-To: <YzaIHqpGR60bQMt0@gondor.apana.org.au>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 3 Oct 2022 14:14:41 +0200
Message-ID: <CACRpkdY3L4-ea4P=rsnZqG8EEPd0yba2P8RmcvdwUvu7knMm9w@mail.gmail.com>
Subject: Re: crypto: ixp4xx - Fix sparse warnings
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linus Walleij <linusw@kernel.org>,
        Imre Kaloz <kaloz@openwrt.org>,
        Krzysztof Halasa <khalasa@piap.pl>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 30, 2022 at 8:09 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:

> This fixes a number of trivial sparse warnings in ixp4xx.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Looks good to me!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
