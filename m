Return-Path: <SRS0=ICHr=4I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B527C11D07
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Feb 2020 12:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6952624656
	for <linux-crypto@archiver.kernel.org>; Thu, 20 Feb 2020 12:29:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=benyossef-com.20150623.gappssmtp.com header.i=@benyossef-com.20150623.gappssmtp.com header.b="F98XZC6w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727285AbgBTM3t (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 20 Feb 2020 07:29:49 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:33563 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727393AbgBTM3s (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Feb 2020 07:29:48 -0500
Received: by mail-ua1-f66.google.com with SMTP id w15so1497287uap.0
        for <linux-crypto@vger.kernel.org>; Thu, 20 Feb 2020 04:29:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WW2EUJXIobmq0i782fSsZkElehRlUl2WjpJFD2q+kAA=;
        b=F98XZC6wtUK9JFQJuaJd8ofnhq2RwFcttY5EroISu90H3yS4a3euVgH1cYPMyRpa6+
         EUCejDjiGK6BnHU5V6sxeaWacW9/c0rcQnYnqGjGOUPD+CXZ4XyqYswHYN9UQLQLEvZ+
         Ozr6+MT617nwg49bEIyaiFj/twboy2xxJ3jX88SWggF8WmQyagzbwu29Z+jLELgbCSiR
         j6Z3rmr2+3dZ7KDlLAWUwQeEY2nV1yYLow2+v+jXeZhQsvg2FlP0kGPCkyhMm0S8hJ5p
         s9bSmlVB4uZ/5gk//UzygMTsCblJHnYvcZ3HpEdcm0Lf9AN4kTpTRp358V1d5fu2Qz0I
         smoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WW2EUJXIobmq0i782fSsZkElehRlUl2WjpJFD2q+kAA=;
        b=VQ0MiRhusMW4Q6tdVJC6f69Qrw6t9WK2Y87WyhlnBYzFhZP/Oi9vxyxAQLZyULzrt7
         bnovWDNIlZs9A0Mjk0nOfS4Glx5GSVTRIUr+TAOK7XxIayW9I+rp64xPjRB0Zcp7Qfi2
         unk1kilWt9EtayTZ4cHpcbwGiyDOGk1JIrTr5pIfV/SkLMVDyUz5TrCGR3h+htJ/Lj0v
         HjocQGzLHkcliySFuLa0ZRC7EA94ojePRwS+sc+6vxUIol8dOS3sAt+JtE77RDuVOFwm
         oN3j8s7AAQwOF9SVCIhB4ot6md54K1yUwJZo1Lu18EcrBAkAszb2mHhra8UCeOVLyXyO
         qJSg==
X-Gm-Message-State: APjAAAXL2VVtZ0owlKNoKhPqfy+TFh/4pu7TuU20rlGmlFS2aXAtcgO1
        x7x5ZQj9QOQw1ewKnTQ253GAvn7dt/AKxwlMQi6Dk/czHXE=
X-Google-Smtp-Source: APXvYqxBKVhq2LOoXM5H2IHFB5cohNE+ksyyccOhU/gldGDh746cny8TL2Tj1mneTpwVQ3MmInBxAvOEOUVqMzqq0m4=
X-Received: by 2002:ab0:4144:: with SMTP id j62mr16087477uad.13.1582201787338;
 Thu, 20 Feb 2020 04:29:47 -0800 (PST)
MIME-Version: 1.0
References: <20200211181928.15178-1-geert+renesas@glider.be>
In-Reply-To: <20200211181928.15178-1-geert+renesas@glider.be>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Thu, 20 Feb 2020 14:29:36 +0200
Message-ID: <CAOtvUMdsQ+-HYLHg4JJ6_qeK-bn9WghuOJWpYH9G3xf1PWR5bw@mail.gmail.com>
Subject: Re: [PATCH v2 00/34] crypto: ccree - miscellaneous fixes and improvements
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Feb 11, 2020 at 8:19 PM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>
>         Hi all,
>
> This series contains several fixes, cleanups, and other improvements for
> the ARM TrustZone CryptoCell driver.
>
> The first 3 patches have been sent before:
>   - [PATCH 0/2] Fix debugfs register access while suspended[1],
>   - [PATCH] [RFC] crypto: ccree - fix retry handling in
>     cc_send_sync_request()[2.
>
> This is based on v5.6-rc1, with the following fixes from Gilad applied:
>   - [PATCH 0/4] crypto: ccree - fixes[3],
>   - [PATCH] crypto: ccree - dec auth tag size from cryptlen map[4].
>
> This has been tested on R-Car H3 ES2.0.
> To ease testing, I have pushed this series and its dependencies to the
> topic/ccree-misc-v2  branch of my renesas-drivers repository at
> git://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git.
>
> Thanks for your comments!
>
> [1] https://lore.kernel.org/r/20200124132957.15769-1-geert+renesas@glider=
.be/
> [2] https://lore.kernel.org/r/20200128190913.23086-1-geert+renesas@glider=
.be/
> [3] https://lore.kernel.org/r/20200129143757.680-1-gilad@benyossef.com/
> [4] https://lore.kernel.org/r/20200202161914.9551-1-gilad@benyossef.com/
>

OK, looks fine and all relevant tests pass on the newer hardware on
all platforms.

Acked-by: Gilad Ben-Yossef <gilad@benyossef.com>

Thanks,
Gilad

> Geert Uytterhoeven (34):
>   debugfs: regset32: Add Runtime PM support
>   crypto: ccree - fix debugfs register access while suspended
>   crypto: ccree - fix retry handling in cc_send_sync_request()
>   crypto: ccree - remove unneeded casts
>   crypto: ccree - swap SHA384 and SHA512 larval hashes at build time
>   crypto: ccree - drop duplicated error message on SRAM exhaustion
>   crypto: ccree - remove empty cc_sram_mgr_fini()
>   crypto: ccree - clean up clock handling
>   crypto: ccree - make mlli_params.mlli_virt_addr void *
>   crypto: ccree - use existing helpers to split 64-bit addresses
>   crypto: ccree - defer larval_digest_addr init until needed
>   crypto: ccree - remove bogus paragraph about freeing SRAM
>   crypto: ccree - use u32 for SRAM addresses
>   crypto: ccree - simplify Runtime PM handling
>   crypto: ccree - use of_device_get_match_data()
>   crypto: ccree - remove cc_pm_is_dev_suspended() wrapper
>   crypto: ccree - make cc_pm_{suspend,resume}() static
>   crypto: ccree - remove struct cc_sram_ctx
>   crypto: ccree - remove struct cc_debugfs_ctx
>   crypto: ccree - remove struct buff_mgr_handle
>   crypto: ccree - remove struct cc_cipher_handle
>   crypto: ccree - extract cc_init_copy_sram()
>   crypto: ccree - remove bogus kerneldoc markers
>   crypto: ccree - improve kerneldoc in cc_hw_queue_defs.h
>   crypto: ccree - improve kerneldoc in cc_buffer_mgr.c
>   crypto: ccree - improve kerneldoc in cc_hash.[ch]
>   crypto: ccree - improve kerneldoc in cc_request_mgr.[ch]
>   crypto: ccree - improve kerneldoc in cc_sram_mgr.[ch]
>   crypto: ccree - spelling s/Crytpcell/Cryptocell/
>   crypto: ccree - grammar s/not room/no room/
>   crypto: ccree - use existing dev helper in init_cc_resources()
>   crypto: ccree - use devm_k[mz]alloc() for AEAD data
>   crypto: ccree - use devm_k[mz]alloc() for cipher data
>   crypto: ccree - use devm_kzalloc() for hash data
>
>  drivers/crypto/ccree/cc_aead.c          |  61 +++---
>  drivers/crypto/ccree/cc_buffer_mgr.c    |  66 +++---
>  drivers/crypto/ccree/cc_buffer_mgr.h    |   4 +-
>  drivers/crypto/ccree/cc_cipher.c        |  61 ++----
>  drivers/crypto/ccree/cc_debugfs.c       |  29 +--
>  drivers/crypto/ccree/cc_driver.c        | 127 +++++-------
>  drivers/crypto/ccree/cc_driver.h        |  13 +-
>  drivers/crypto/ccree/cc_hash.c          | 225 +++++++++------------
>  drivers/crypto/ccree/cc_hash.h          |  31 ++-
>  drivers/crypto/ccree/cc_hw_queue_defs.h | 255 ++++++++++++------------
>  drivers/crypto/ccree/cc_pm.c            |  60 +-----
>  drivers/crypto/ccree/cc_pm.h            |  21 --
>  drivers/crypto/ccree/cc_request_mgr.c   |  47 +++--
>  drivers/crypto/ccree/cc_request_mgr.h   |  19 +-
>  drivers/crypto/ccree/cc_sram_mgr.c      |  78 +++-----
>  drivers/crypto/ccree/cc_sram_mgr.h      |  45 ++---
>  fs/debugfs/file.c                       |   8 +
>  include/linux/debugfs.h                 |   1 +
>  18 files changed, 456 insertions(+), 695 deletions(-)
>
> --
> 2.17.1
>
> Gr{oetje,eeting}s,
>
>                                                 Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m6=
8k.org
>
> In personal conversations with technical people, I call myself a hacker. =
But
> when I'm talking to journalists I just say "programmer" or something like=
 that.
>                                                             -- Linus Torv=
alds



--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
