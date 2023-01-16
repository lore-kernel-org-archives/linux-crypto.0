Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A05FCC46467
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Jan 2023 07:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjAPHk0 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Jan 2023 02:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231864AbjAPHkZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Jan 2023 02:40:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6EB55BA
        for <linux-crypto@vger.kernel.org>; Sun, 15 Jan 2023 23:40:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4751560EB6
        for <linux-crypto@vger.kernel.org>; Mon, 16 Jan 2023 07:40:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A928DC433EF
        for <linux-crypto@vger.kernel.org>; Mon, 16 Jan 2023 07:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673854823;
        bh=FfIcLNRdGqP+gxRzz5WI3OMzLIKJZ5maa6ZX3yWR+Cg=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=cdWT5P2TVxrnkpl3N1WdwciEtpC3NPblsxCD2P5nh+7OdjHA392qXxSQuyOwdoFtv
         WBLGbcveWkw3P3TiyGvnd/MX2FO3fNdMNG1ecFbb1bAhhFUvqrYR639Q1YRbwv63AU
         MWvaXa3tHu32bHghmMH5yCaVEmnHuDjg2gQIuQukgoAAKPM8Ppaqne5bRpxxzj6Yld
         8jSd5apLL91iMnXkH9/ZKl6oa3e1xeVphm1xEt7kCbJ3Zo6sCgLb5bHY3SYhpCbqhP
         r2/qZC5ZVO+ZCuzNuveSM18C6bg4nHNY3aAkl8Ob8VR/lLAhsl9H/5V5GtEXJ7jOzm
         wVOHm+UDi/BUg==
Received: by mail-lj1-f181.google.com with SMTP id n5so28582838ljc.9
        for <linux-crypto@vger.kernel.org>; Sun, 15 Jan 2023 23:40:23 -0800 (PST)
X-Gm-Message-State: AFqh2kr4QtZV9+wEb+bj7zxOqiiAc29NslGLBDPpsk3esuR0LBC4MygD
        qZ49T+XCde66DsSZM/HxyjTu6HtjH/3smrqOI2I=
X-Google-Smtp-Source: AMrXdXtsnV5QfFn02CMBXjwGq/nd+AfANJ1OwD4gbwOP+GtxfB+GYbVErJSTQ5mmLnqQv/GVfwm+6RfIhtc3Rz0dvTc=
X-Received: by 2002:a2e:a901:0:b0:27f:ef88:3ecb with SMTP id
 j1-20020a2ea901000000b0027fef883ecbmr2287639ljq.189.1673854821723; Sun, 15
 Jan 2023 23:40:21 -0800 (PST)
MIME-Version: 1.0
References: <20221214171957.2833419-1-ardb@kernel.org> <CAMj1kXG_btjHUVpN9m5NoBdFv=3JWt-piPx_u40KTv70CC-sRQ@mail.gmail.com>
 <Y8TEqNJuEmWE5Tg/@gondor.apana.org.au>
In-Reply-To: <Y8TEqNJuEmWE5Tg/@gondor.apana.org.au>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Mon, 16 Jan 2023 08:40:09 +0100
X-Gmail-Original-Message-ID: <CAMj1kXExpt4U64ncX6wSU_0zLNNQGiP3RFGNbAXwpuBjeV=fPg@mail.gmail.com>
Message-ID: <CAMj1kXExpt4U64ncX6wSU_0zLNNQGiP3RFGNbAXwpuBjeV=fPg@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] crypto: Accelerated GCM for IPSec on ARM/arm64
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 16 Jan 2023 at 04:29, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Fri, Jan 13, 2023 at 05:00:59PM +0100, Ard Biesheuvel wrote:
> >
> > These prerequisite changes have now been queued up in the ARM tree.
> >
> > Note that these are runtime prerequisites only so I think this series
> > can be safely merged as well, as I don't think anyone builds cryptodev
> > for 32-bit ARM and tests it on 64-bit hardware (which is the only
> > hardware that implements the AES instructions that patch #1 relies on)
>
> Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
>
> I don't have any objections for merging this through the arm tree.
>

Thanks.

Will you be taking the rest of the series? (patches #2 - #4). Or we
might defer this to v6.4 entirely it if makes things easier. (The
other changes really shouldn't go through the ARM tree)
