Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19E59C433FE
	for <linux-crypto@archiver.kernel.org>; Mon,  9 May 2022 09:28:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbiEIJbo (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 9 May 2022 05:31:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237774AbiEIJR4 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 9 May 2022 05:17:56 -0400
Received: from laurent.telenet-ops.be (laurent.telenet-ops.be [IPv6:2a02:1800:110:4::f00:19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79C51C5E01
        for <linux-crypto@vger.kernel.org>; Mon,  9 May 2022 02:14:02 -0700 (PDT)
Received: from ramsan.of.borg ([IPv6:2a02:1810:ac12:ed40:7048:8ec9:5f5b:8cb])
        by laurent.telenet-ops.be with bizsmtp
        id UZDc2700P1UlgJi01ZDc2B; Mon, 09 May 2022 11:13:37 +0200
Received: from geert (helo=localhost)
        by ramsan.of.borg with local-esmtp (Exim 4.93)
        (envelope-from <geert@linux-m68k.org>)
        id 1nnzSS-003WbP-Ju; Mon, 09 May 2022 11:13:36 +0200
Date:   Mon, 9 May 2022 11:13:36 +0200 (CEST)
From:   Geert Uytterhoeven <geert@linux-m68k.org>
X-X-Sender: geert@ramsan.of.borg
To:     linux-kernel@vger.kernel.org
cc:     linux-crypto@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: Build regressions/improvements in v5.18-rc6B
In-Reply-To: <20220509084005.4133902-1-geert@linux-m68k.org>
Message-ID: <alpine.DEB.2.22.394.2205091113010.840289@ramsan.of.borg>
References: <CAHk-=wi0vqZQUAS67tBsJQW+dtt89m+dqA-Z4bOs8CH-mm8u2w@mail.gmail.com> <20220509084005.4133902-1-geert@linux-m68k.org>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, 9 May 2022, Geert Uytterhoeven wrote:
> JFYI, when comparing v5.18-rc6[1] to v5.18-rc5[3], the summaries are:
>  - build errors: +1/-0

   + /kisskb/src/crypto/blake2b_generic.c: error: the frame size of 2288 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]:  => 109:1

sparc64-gcc11/sparc-allmodconfig

> [1] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/c5eb0a61238dd6faf37f58c9ce61c9980aaffd7a/ (131 out of 138 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/branch/linus/head/672c0c5173427e6b3e2a9bbb7be51ceeec78093a/ (all 138 configs)

Gr{oetje,eeting}s,

 						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
 							    -- Linus Torvalds
