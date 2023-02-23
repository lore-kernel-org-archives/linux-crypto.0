Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70DE0C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu, 23 Feb 2023 09:52:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbjBWJwe (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 Feb 2023 04:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233734AbjBWJwd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Feb 2023 04:52:33 -0500
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484C7515D0
        for <linux-crypto@vger.kernel.org>; Thu, 23 Feb 2023 01:52:29 -0800 (PST)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-53852143afcso29777517b3.3
        for <linux-crypto@vger.kernel.org>; Thu, 23 Feb 2023 01:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WyLlud2sMTYzZimgt3LXDWS5h05sJ2yVKAsksslDR6M=;
        b=ZLQtg4FtpfbiG3pBPGZhMDpS7wCOS2l/Vb/EzOb30N3BpV6OVBj7JZJcCdktYZtAS2
         RGW0dtqmnR+dfXUGssVahvHzdlIIb3Wr6NT5kUUJrlu7BrbwGV02bV3l6E5fzO6bDj70
         SvP2iiqLVg6LEFnvB4bPhSTHAD+gDohAdIL888wz1YBebd/zeDePN5CA8aEU002zeqpO
         ZcehMW3NdG05r1TlY879Hxp5xNtowiQ88BYx74B5pMhCj0t8remt3/dVwp6+clGooA2h
         jjbouEQg1rLtL49fdfDKchmHDrOXR/tW5qzs7HMR9ZX/tYH9q7MbxhVJDA529CYGk8kN
         AOdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WyLlud2sMTYzZimgt3LXDWS5h05sJ2yVKAsksslDR6M=;
        b=Wmv5dk7usDNpFcMnlRuIixm4Vrddd/WyNxd6ygbP7Ue/m2yXlIOdGba5W+hD7lIzIq
         lsVm0Mww6g82wUT7JFtEo46uQ7ck/GFWjVRPgEOVBjwb0ho/mbNqOXB/2L0FPuRxweaP
         dR6W6r4G7d9uczhVnF0z0puAlxOMN0EQ2s1Y7KySfUBkqiuF16hP8TAdVpMFsp1ytSav
         XJKJASS65t94vJC0G5LByI52JWcmJenqqCl/ywvYvp+CMsYTSpR0jDbalYL5nxxHMk4z
         td7u3w8pQEt9ZqFlYUkOcEyutH0GoeKUfWA63HPv9zN/IVbh0mLjytcK6WoQt65aQz5l
         soog==
X-Gm-Message-State: AO0yUKXMRd8HZEm10oIU2gEYoPIV0kwiKkMWzHvg4EPERIFysrr36fYU
        oG748B6kUqIb2VjyOWSyt2ITcgsZW+ue/vetkdyLdg==
X-Google-Smtp-Source: AK7set/KtoAzQrIYU+2Mgk/pLUdmIb9s9QFOvjUwjQxM7F7nAZs/oSVNu3EBJvX3mgr7i2poBtd8kJyvbE4QOnKDsUs=
X-Received: by 2002:a25:918c:0:b0:8da:d0ab:258a with SMTP id
 w12-20020a25918c000000b008dad0ab258amr1705814ybl.5.1677145948475; Thu, 23 Feb
 2023 01:52:28 -0800 (PST)
MIME-Version: 1.0
References: <Y/cBB+q0Ono9j2Jy@gondor.apana.org.au> <20230224231430.2948-1-kunyu@nfschina.com>
 <Y/cy5wUtk10OahpO@gondor.apana.org.au>
In-Reply-To: <Y/cy5wUtk10OahpO@gondor.apana.org.au>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 23 Feb 2023 10:52:17 +0100
Message-ID: <CACRpkdYyB=-UnE1bmdVszSSB5ReECZ0fUoWJX6XtYbKHEe52tA@mail.gmail.com>
Subject: Re: [PATCH] stm32: stm32-hash: Add kmalloc_array allocation check
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        Lionel Debieve <lionel.debieve@foss.st.com>
Cc:     Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 23, 2023 at 10:33 AM Herbert Xu <herbert@gondor.apana.org.au> w=
rote:
> On Sat, Feb 25, 2023 at 07:14:29AM +0800, Li kunyu wrote:
> >
> > hello senior:
> >   'rctx->hw_context' is a member of the rctx pointer array object and w=
ill pass 'memcpy(out, rctx, sizeof(*rctx)) at the end of the function;  ', =
copied to the out pointer memory, it cannot be released, I think this patch=
 does an allocation check on the 'rctx->hw_context' pointer should help a b=
it.
>
> Ugh that's completely broken.  You can't export pointers.
>
> I guess this driver needs to be disabled.

Added Lionel to the To: line so he can look at this, I guess we should
also add an entry to MAINTAINERS so that the reports come to the right
address.

Can we fix the actual problem? It seems to have been there since the
initial submission in 2017.

I guess the right fix is to export the *actual* hardware state into "out"
and read it back from there instead of copying out the rctx struct.
Also .statesize needs to be fixed to correspond to that.
I can just use a roof:ed constant size for this.

If Lionel does not have time to look at it I can try to come up with a
quick fix.

Yours,
Linus Walleij
