Return-Path: <SRS0=qsSA=CV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52280C43461
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Sep 2020 11:13:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1167621D6C
	for <linux-crypto@archiver.kernel.org>; Sat, 12 Sep 2020 11:13:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="h9/2Cx33"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725850AbgILLNa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 12 Sep 2020 07:13:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725847AbgILLN0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 12 Sep 2020 07:13:26 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB91EC061573
        for <linux-crypto@vger.kernel.org>; Sat, 12 Sep 2020 04:13:25 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id r24so14654797ljm.3
        for <linux-crypto@vger.kernel.org>; Sat, 12 Sep 2020 04:13:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8kJorjEAS2sshdFf7fzymk8HS88x43/0TW3TqJZZypQ=;
        b=h9/2Cx33+XfsGiZPgpZ6oW94JX9rIxBrKDyjbYvv0SSm7pl8Cc6xqlozgtRSix0hmN
         TKCjv4ry2HYgeKWaM9KkQH8Or9P8iatpnpo9i4V13S7BmG2LSvcu3yD4X0GMcukHB55D
         yaLvAV7PMK9hSKsTj5rGhZBU/xCyLtQ7uU3NcIPSOqAR4Vzq73ez5cQ+Veiyj+ZRgix5
         i3UF8GJIDDGuAW8cw905uGjXC5dyF0LdIJyHUjqBbA47hYZ4rFwOKScSUaol9Axny43Q
         bRE7CvuaQFw0x6W/2swatMIMG8QkpvKuzxNbi0ZkmW18+RC+2j4aDzKk0DcNg/W7rcIn
         VCng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8kJorjEAS2sshdFf7fzymk8HS88x43/0TW3TqJZZypQ=;
        b=A7F5q+NxblrC3YcvOaYDovt+W/IG1gyjfjoj1WREg5geBXqX2uDojGTe4FhoQT2yKG
         HKzYhxtjCs/WS6WEeGORRRamBmfbYv3Nh8jCgYzdVsNm1J7AxQGajSQ683vKoSaYPg0C
         4jSuHoPNgBzcc8tYqO3dr4a4zUjRvT1ngIDnYioxLlnC37DYKEURx+EDIPJvgseE2Pb8
         EXZCcIPzmlubutl4X6vlaAnHCmyBW/GoBHb7mX57ocg442OV25VTAM86iwoVuHFmSzzN
         ZKrEX0xLk0+xRMRhdIibm2+PaRtadx7bdF/WC2rzurTb1helP1jSeqSfQJ4dJsyb8WZa
         whFQ==
X-Gm-Message-State: AOAM532T0ltK5qSym27SuJnz8BNCY/4bdk0m/bS9Es8zgE/lxZtjVOQD
        wJN7F8zXu1mzxnNs4gFZYdibKjhjXeGFS7lKHqtRDh1hW2s=
X-Google-Smtp-Source: ABdhPJxmj7K8eit65gZ0vrTKHrtXBcH0KGQQTD6O2tEzV4ZaLHxMl8pKFM8Brk4MO2jHURP7Xkce+4Cf1FJ0ZaKCCHg=
X-Received: by 2002:a2e:9988:: with SMTP id w8mr2379696lji.286.1599909204195;
 Sat, 12 Sep 2020 04:13:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200904082705.GA1139@gondor.apana.org.au>
In-Reply-To: <20200904082705.GA1139@gondor.apana.org.au>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Sat, 12 Sep 2020 13:13:13 +0200
Message-ID: <CACRpkdYzw0v9Fcvb8FoFNQ_ppSNwLdhRssGxHaA0Q3-QZ5NQ+A@mail.gmail.com>
Subject: Re: [PATCH] crypto: ux500 - Fix sparse endianness warnings
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 4, 2020 at 10:27 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:

> This patch fixes a couple of sparse endianness warnings in the
> ux500 driver.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
