Return-Path: <SRS0=nygc=5L=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54594C43331
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Mar 2020 04:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0DFA620772
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Mar 2020 04:32:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="QTq6QyWw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725842AbgCZEcz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 26 Mar 2020 00:32:55 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:40809 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbgCZEcy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Mar 2020 00:32:54 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 2ab3d581
        for <linux-crypto@vger.kernel.org>;
        Thu, 26 Mar 2020 04:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=hEhI+k6WqG2OcGt1PUU/x9Kk37A=; b=QTq6Qy
        WwVzISenrP0aBSzc4j1xbeDUs/a6yuTwktbraIFaLMOFjxQl2M7pQ5HY/BYJCM8F
        cMsnNxY74UlBTINXrboWalflqTlZp5zX1TaQUcoYZQHxS12O/kG+yVP1N01DPf3a
        gN7L8obEPdsAToYWEvFfxtKBVZGs5ld6MaWWbzlefV7XruFpkr6DmowZMw22AUFi
        uU4hMHyCmj2A5nkqP2c45I3SnhbfpcXYE+nkv4uCwBoXHwZLmCQrdpFvCpql4dOl
        1r+OrRNB7kV/+vRESOJTbFRWN9n2KGdfK7SuDdPJUut7frFOSJbVyfquHpZgD37E
        f4cGCZ0Wnb3sCFMg==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 2bf81f74 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Thu, 26 Mar 2020 04:25:32 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id q128so4720501iof.9
        for <linux-crypto@vger.kernel.org>; Wed, 25 Mar 2020 21:32:52 -0700 (PDT)
X-Gm-Message-State: ANhLgQ1eDtz9oBmoNPzrMZp2GcUOZQEt1xlA8YQInwaJJii7+pStQaZ7
        OVp374ynr4xc2k2/mJUl/FGYYy15wwTL5IuP+LM=
X-Google-Smtp-Source: ADFU+vsKsq7+Uc97+mA1aGs8pHlXne46EQ5mL5Is36jIIHjGXTjrwhSASym5cXhYuluDZDLC/DVbHC/dt0MyofxNfC0=
X-Received: by 2002:a5e:a50f:: with SMTP id 15mr6096399iog.67.1585197172015;
 Wed, 25 Mar 2020 21:32:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200319180114.6437-1-Jason@zx2c4.com>
In-Reply-To: <20200319180114.6437-1-Jason@zx2c4.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 25 Mar 2020 22:32:41 -0600
X-Gmail-Original-Message-ID: <CAHmME9p5KnsUpRCve3_6ugobG9c-fnqQgNOE8F28CX4SvsTX1w@mail.gmail.com>
Message-ID: <CAHmME9p5KnsUpRCve3_6ugobG9c-fnqQgNOE8F28CX4SvsTX1w@mail.gmail.com>
Subject: Re: [PATCH crypto] crypto: arm[64]/poly1305 - add artifact to
 .gitignore files
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

I think this might have slipped through the cracks?
