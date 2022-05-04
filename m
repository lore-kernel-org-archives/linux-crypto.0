Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D39C8C433FE
	for <linux-crypto@archiver.kernel.org>; Wed,  4 May 2022 18:26:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376817AbiEDS3f (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 May 2022 14:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376825AbiEDS3K (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 May 2022 14:29:10 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE7C10C9
        for <linux-crypto@vger.kernel.org>; Wed,  4 May 2022 11:00:20 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id x33so3688995lfu.1
        for <linux-crypto@vger.kernel.org>; Wed, 04 May 2022 11:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=X7nnFcBo5MIhDYQNnEavKTW+QBw/a5S/8r1dgvWPgx4=;
        b=HydzbIEsqYx4gbpn6Of0F/idsQ70FsOBI/yLQ3l1wlbBjcoSGQqp8LilhBOa//uEDx
         EWnmRcF4BEWKWbTlT+gtSe5/NRwGYnfkr6Qy6WpkKKFSMAkUba/bzP88tFQGiyyP5qzR
         slNInsc4mTa9BKrS4jYwCcQzeao9bKelEatb4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=X7nnFcBo5MIhDYQNnEavKTW+QBw/a5S/8r1dgvWPgx4=;
        b=u32M/LnCEy5CZd2vlp/0xRN4xxds9HYkzgV8/7FckJnF7x5w6lnbqkdVbrWhkTk4I6
         UXp+PWifzXO0/SgaX33Po/bzkBKOhQIs4bPfDR90QUaJG5/JANlkICIESuCdpJoG3/tR
         2EZeycssnvYhftDDFWqVJf+V28lVSrGZ9U92zn4OT+Wq/V4IwmlYNNED3pTkbynkFWO6
         S94N2s3+ekDBiarZhAj20gJ6ncpW6Wp+hY60F1MGnnb25PwuMF9m3Vs92oSeTiDpn2Y9
         q6ooal8tNq18Xs84dlVLThG0SzFwgTyEW5zUY1EFqistRiPK8PtND5hDzNvrG1oVZzDq
         NQmQ==
X-Gm-Message-State: AOAM5330pP+V81Um1Qcpf0munU7YNQIxZ6/+jtBHSBzdACtTccrBDjmF
        1D2EHVxaWjX634le5uQBN+eL+esBhcpw5LIw
X-Google-Smtp-Source: ABdhPJzDReeBwVsWGjzPJFzhJNcc5own85QO9OI9rFUfpB5nplndbu72ZsMHbUxd2V0H1L35JjWJ6A==
X-Received: by 2002:a05:6512:3f96:b0:44a:f504:597f with SMTP id x22-20020a0565123f9600b0044af504597fmr14815111lfa.621.1651687218996;
        Wed, 04 May 2022 11:00:18 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id n12-20020a19550c000000b0047255d211b8sm1263961lfe.231.2022.05.04.11.00.17
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 11:00:17 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id x17so3651877lfa.10
        for <linux-crypto@vger.kernel.org>; Wed, 04 May 2022 11:00:17 -0700 (PDT)
X-Received: by 2002:a05:6512:3c93:b0:44b:4ba:c334 with SMTP id
 h19-20020a0565123c9300b0044b04bac334mr15264136lfv.27.1651687217327; Wed, 04
 May 2022 11:00:17 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com> <YnJOCbLtdATzC+jn@zx2c4.com>
 <YnJQXr3igEMTqY3+@smile.fi.intel.com> <YnJSQ3jJyvhmIstD@zx2c4.com>
In-Reply-To: <YnJSQ3jJyvhmIstD@zx2c4.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 4 May 2022 11:00:00 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
Message-ID: <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
Subject: Re: [PATCH v2] hex2bin: make the function hex_to_bin constant-time
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Andy Shevchenko <andriy.shevchenko@intel.com>,
        Stafford Horne <shorne@gmail.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Andy Shevchenko <andy@kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mike Snitzer <msnitzer@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 4, 2022 at 3:15 AM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> > Alignment? Compiler bug? HW issue?
>
> Probably one of those, yea. Removing the instruction addresses, the only
> difference between the two compiles is: https://xn--4db.cc/Rrn8usaX/diff#=
line-440

Well, that address doesn't work for me at all. It turns into =D7=90.cc.

I'd love to see the compiler problem, since I find those fascinating
(mainly because they scare the hell out of me), but those web
addresses you use are not working for me.

It most definitely looks like an OpenRISC compiler bug - that code
doesn't look like it does anything remotely undefined (and with the
"unsigned char", nothing implementation-defined either).

             Linus
