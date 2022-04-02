Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D4E2C433F5
	for <linux-crypto@archiver.kernel.org>; Sat,  2 Apr 2022 04:45:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237214AbiDBEqs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 2 Apr 2022 00:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236134AbiDBEqs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 2 Apr 2022 00:46:48 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC98A103BA8;
        Fri,  1 Apr 2022 21:44:56 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id lr4so9660725ejb.11;
        Fri, 01 Apr 2022 21:44:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=huB97C9JBbD4NTragcMdF5Fe+et3P5wIBlAUz2Cnm5I=;
        b=pkItxN8skI+/hoTjotTO11YLRC79aIEmK9zrlQYQGwHFPTYzrmxMYRdEyohxMNAaqH
         VdDrr/d4JSaUHhWA6GeFPQVUEMAT6PUMOnoIgntfbqZYlg7y53a8JHLc3LiZ3NgQJ+Q6
         mDK3FS3+yXP4gwKgxdioMVmQn71Ldm2RRIsypCLBVVMI14nAYI7rPc02LnWR0ZfMWg9s
         FGsCRKtMeY+dyJFREY8NAbkulli4VBrcu/hKk8TQ9HDMgbvynToOjg4rhsBAqYYfgAc6
         MInrRIYSk6hFKDUdND7aLHJwzPlUi8I70WTXkUH30jPIq9KHvg74wR0tspRfGcwhkxhE
         7MGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=huB97C9JBbD4NTragcMdF5Fe+et3P5wIBlAUz2Cnm5I=;
        b=euaHCe2jQ6rvJ+5eWS5KdCDfCuiN4KbNCiWgILl/tVapuEykRnwzrY5IHXZ5ZggeHb
         rXu73QF35IXvlJxWUyfr1cKFsUQ4N8tbX27aGBznWNJQxMtNlBpQ5yL3bwN5/qa/bX2F
         UrnxvBqQ8nmnGDFcr19+EBX8kTgmhyj6g4mpGnF3ivryXK86OLRbe4Yy6TUTfJj0LbX2
         haJ41a+RzyFyLTT3RrfT/qUADWQqIaD/kg+rnYWH/S+P5Lrcp1sZq2hVqhe+mK/8w0L5
         rVO0RFCRxwjH3LCF3891V+GUMPP6tyUkzSK5pDQkPHj+sYV5VN4RbtgOi/iTng6QNbTw
         EjxA==
X-Gm-Message-State: AOAM531AfbtXh2TJ5VznTpfIJgyC8L14ltSCba380rfVHegR2gJ7iKVS
        h+yLjdpTYdEmknGsy8ze6PjRG2ReBA+EueQyvXY=
X-Google-Smtp-Source: ABdhPJxGUbe2S/w0yEZATeM3Hg+1QWKhd1I/yFnFNIB5iULEMsTrThhTL9l10t/icmfRuf01nhoUGdG88OHyKDLm3v4=
X-Received: by 2002:a17:907:7e96:b0:6da:f7ee:4a25 with SMTP id
 qb22-20020a1709077e9600b006daf7ee4a25mr2509602ejc.436.1648874695341; Fri, 01
 Apr 2022 21:44:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220331150706.124075-1-Jason@zx2c4.com> <20220331152641.169301-1-Jason@zx2c4.com>
In-Reply-To: <20220331152641.169301-1-Jason@zx2c4.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Sat, 2 Apr 2022 12:44:42 +0800
Message-ID: <CACXcFm=vw6XCnO8peYH4V+sPR076O-Gav46r83+CZJ8oXM8iHA@mail.gmail.com>
Subject: Re: [PATCH v2] random: mix build-time latent entropy into pool at init
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Theodore Ts'o" <tytso@mit.edu>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 1, 2022 at 11:16 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:

> Prior, the "input_pool_data" array needed no real initialization, and so
> it was easy to mark it with __latent_entropy to populate it during
> compile-time.

As I see it, that was the correct approach.

> In switching to using a hash function, this required us to
> specifically initialize it to some specific state,

Hash functions do not require that. Any such function must
work correctly with a new input block and a more-or-less
random state from hashing previous blocks.

In general, except perhaps at boot time, I do not think
any of the hopefully-random data structures -- input
pool, hash context or chacha context -- should ever be
set to any specific state. Update them only with += or
^= and preferably not with constants.

What requires a fixed initialisation is your decision to
eliminate the input pool & just collect entropy in a hash
context. In effect you are reducing the driver to a
Yarrow-like design, which I think is an error.

Yarrow is a good design, but it has limitations; in particular
the Yarrow paper says the cryptographic strength is limited
to the size of the hash context, 160 bits for their SHA-1 &
512 for our Blake.

512 bits is more than enough for nearly all use cases, but
we may have some where it is not. How many random bits
are needed to generate a 4k-bit PGP key?

Will some users try to generate one-time pads from /dev/random?
The OTP security proof requires truly random data as long as the
message; with anything short of that the proof fails & you get
a stream cipher.

Patches will follow, but likely not soon; I'm busy with
other things.
