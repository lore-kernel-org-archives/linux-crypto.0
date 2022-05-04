Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCFD0C433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  4 May 2022 19:52:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbiEDTzs (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 May 2022 15:55:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356258AbiEDTzr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 May 2022 15:55:47 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9890C4DF7D
        for <linux-crypto@vger.kernel.org>; Wed,  4 May 2022 12:52:09 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id q130so3016139ljb.5
        for <linux-crypto@vger.kernel.org>; Wed, 04 May 2022 12:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Ruflxs9cgYtfpu+uYRY9OHjS7xb2bTFhKtX7f5MDGy0=;
        b=diBNaFT6RJQyFbUyjS0yj1S62NtDgDQ/oqU4vbBO3+GpjfpqNEy69JLlmTmH19CK0x
         tHpOFu35+fkkKowJQ9Uw2Zkc6+DoiqPCJ6FKhYalmvF+3p43xvtmvaN4BIa5DwkTyjVt
         awUxmk/s7sd/YUL1z68Hl375tvBz/uTcAf4Z4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Ruflxs9cgYtfpu+uYRY9OHjS7xb2bTFhKtX7f5MDGy0=;
        b=MZVibzFnvIDY7JhmCrvoM5K5x2O+s7+iHJ2wBjlFaP19qXVQoZwDSumrj19iacJv8p
         j+pSA+GLOFo79OD8afo2f2wxr2Z2wu/A1OPF6nLk2/3qbKR4FTvIm8LR3a6bnFpaqwnK
         SZFbjV17rikmbdo4dFCpqmuBwAVl66B0YiFgjR8Tdb4h131WRoOLoSgKlYnS9hbJVDL6
         jNWg3DcXS+0Bvowrza29tugrZ9uVr6Fo7ltK/SR+TmxkJTgvShpmJPafihPan07juls2
         R2fBXr/PtD0+W5Kpd46eotUe8Enfx8qabO+ZR3aq3SsLNLHgNOuvVOBIfGXRoLevTmea
         wqIQ==
X-Gm-Message-State: AOAM533Ci0D5sSPBV6mCzJb6kNAjjFu/R/l/hT0Jan5UwnxucpW3zJpH
        xt1FCUgu8xCoQBxgyansIMhzE2HSh0COQ9IDpyI=
X-Google-Smtp-Source: ABdhPJwpzOSPsKMSOgslgysfYcp2EJ20zvoBwYtPSziKMtkrJeCc3g+yDSLhkDBjKQzDhTWTuN4yFA==
X-Received: by 2002:a2e:8089:0:b0:24f:ee6:b25f with SMTP id i9-20020a2e8089000000b0024f0ee6b25fmr13529712ljg.318.1651693927707;
        Wed, 04 May 2022 12:52:07 -0700 (PDT)
Received: from mail-lj1-f182.google.com (mail-lj1-f182.google.com. [209.85.208.182])
        by smtp.gmail.com with ESMTPSA id e9-20020a056512090900b0047255d211e8sm1291880lft.279.2022.05.04.12.52.05
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 12:52:06 -0700 (PDT)
Received: by mail-lj1-f182.google.com with SMTP id v4so3002045ljd.10
        for <linux-crypto@vger.kernel.org>; Wed, 04 May 2022 12:52:05 -0700 (PDT)
X-Received: by 2002:a2e:8245:0:b0:24b:48b1:a1ab with SMTP id
 j5-20020a2e8245000000b0024b48b1a1abmr13338399ljh.152.1651693925440; Wed, 04
 May 2022 12:52:05 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com> <YnJOCbLtdATzC+jn@zx2c4.com>
 <YnJQXr3igEMTqY3+@smile.fi.intel.com> <YnJSQ3jJyvhmIstD@zx2c4.com>
 <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com> <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
In-Reply-To: <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 4 May 2022 12:51:49 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiaj8SMSQTWAx2cUFqzRWRqBspO5YV=qA8M+QOC2vDorw@mail.gmail.com>
Message-ID: <CAHk-=wiaj8SMSQTWAx2cUFqzRWRqBspO5YV=qA8M+QOC2vDorw@mail.gmail.com>
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

On Wed, May 4, 2022 at 12:43 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> =D7=90.cc is correct. If you can't load it, your browser or something in
> your stack is broken.

It's just google-chrome.

And honestly, the last thing I want to ever see is non-ASCII URL's.

Particularly from a security person. It's a *HORRIBLE* idea with
homoglyphs, and personally I think any browser that refuses to look it
up would be doing the right thing.

But I don't think that it's the browser, actually. Even 'nslookup'
refuses to touch it with

   ** server can't find =D7=90.cc: SERVFAIL

and it seems it's literally the local dns caching (dnsmasq?)

> Choosing a non-ASCII domain like that clearly a
> bad decision because people with broken stacks can't load it?

No. It's a bad idea. Full stop. Don't do it.

               Linus
