Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C04DC433EF
	for <linux-crypto@archiver.kernel.org>; Wed,  4 May 2022 20:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344279AbiEDUEe (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 4 May 2022 16:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343604AbiEDUEe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 4 May 2022 16:04:34 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C77B1F612
        for <linux-crypto@vger.kernel.org>; Wed,  4 May 2022 13:00:56 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id y19so3049604ljd.4
        for <linux-crypto@vger.kernel.org>; Wed, 04 May 2022 13:00:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LmVnCbPzQFTKVo2J8nBuP0OejuZI/MsiEmrhFI+epZk=;
        b=IZC4w5jnu/QO9Q2oZdB9KCQz8nOkDzcwjag3H6CKaK97vN+BaEHZ+jhwzac65rOZ7+
         48ojuixZFxaURG6EsMIJyxIqwbD+7Q9R5n52IgZ+3VJgF10qcua8LStnYEONl9dD3o0K
         YZ0ThZakHUlxetViKTNCGE76sgsrMnNjFCjoY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LmVnCbPzQFTKVo2J8nBuP0OejuZI/MsiEmrhFI+epZk=;
        b=hBhUf+6mpvV+Mg0eqtqhxIAyGyZm/lLyuIZTA6bdqXxxMpBTPhlixV5vXjKRnRZ/Q+
         y4Tk8RUG7AP2IOTMf8trBvSqase2h7ZFDsBmry8eF8+tyvnrsKpWb+TOq3cZWl385ZRx
         SiDVrqlsQCUVeXt1KPm266JklBFjoiMigrQli34yHkwauQefe747ul4e3gD3u3VnMBmF
         cH+lNF+dfcU7lV4fBh4zLMmohBYkp8I3sTdsxqN763TydWiFuWvnfKhF83BpZY9abkU7
         g/uNk1Hm4rKTz0IFbwr1VFbDK/wec/tMTO91mdwOJcMPrFcF0QXbNqkIx7OqfIkYUNDM
         /akw==
X-Gm-Message-State: AOAM530KzZVqpnyLSsHqVK2h3v3FGd0QECKeHmlWuIkgacRO25B83WiO
        ag8ACXPAkHBoDIBIw8D1COsNdBsVILgACeHTMp4=
X-Google-Smtp-Source: ABdhPJzYhEs5qdgGFYy1RzvYvbjs07/VjF6Aptn9IbHGyTF5GJ+hh9hT94cjVTd9v7kNWrdnimdZIw==
X-Received: by 2002:a2e:bb8e:0:b0:250:76dd:3bd9 with SMTP id y14-20020a2ebb8e000000b0025076dd3bd9mr4208143lje.71.1651694454930;
        Wed, 04 May 2022 13:00:54 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id 14-20020a2eb94e000000b0024f3d1dae8esm1757370ljs.22.2022.05.04.13.00.52
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 13:00:53 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id m23so3073791ljc.0
        for <linux-crypto@vger.kernel.org>; Wed, 04 May 2022 13:00:52 -0700 (PDT)
X-Received: by 2002:a2e:934b:0:b0:24f:cce:5501 with SMTP id
 m11-20020a2e934b000000b0024f0cce5501mr13625492ljh.443.1651694452466; Wed, 04
 May 2022 13:00:52 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.02.2204241648270.17244@file01.intranet.prod.int.rdu2.redhat.com>
 <CAHk-=wh+Z+OKH3jRttWGHbWSQq2wVMtdnA=ntDiadZu=VxAC7w@mail.gmail.com>
 <alpine.LRH.2.02.2204250723120.26714@file01.intranet.prod.int.rdu2.redhat.com>
 <YnI7hE4cIfjsdKSF@antec> <YnJI4Ru0AlUgrr9C@zx2c4.com> <YnJOCbLtdATzC+jn@zx2c4.com>
 <YnJQXr3igEMTqY3+@smile.fi.intel.com> <YnJSQ3jJyvhmIstD@zx2c4.com>
 <CAHk-=wgb_eBdjM_mzEvXfRG2EhrSK5MHNGyAj7=4vxvN4U9Rug@mail.gmail.com>
 <CAHmME9q_-nfGxp8_VCqaritm4N8v8g67AzRjXs9du846JhhpoQ@mail.gmail.com> <CAHk-=wiaj8SMSQTWAx2cUFqzRWRqBspO5YV=qA8M+QOC2vDorw@mail.gmail.com>
In-Reply-To: <CAHk-=wiaj8SMSQTWAx2cUFqzRWRqBspO5YV=qA8M+QOC2vDorw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 4 May 2022 13:00:36 -0700
X-Gmail-Original-Message-ID: <CAHk-=witNAEG7rRsbxD0-4mxhtijRT8fwSc3QCi5HN1sR=0YcA@mail.gmail.com>
Message-ID: <CAHk-=witNAEG7rRsbxD0-4mxhtijRT8fwSc3QCi5HN1sR=0YcA@mail.gmail.com>
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

On Wed, May 4, 2022 at 12:51 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> But I don't think that it's the browser, actually. Even 'nslookup'
> refuses to touch it with
>
>    ** server can't find =D7=90.cc: SERVFAIL
>
> and it seems it's literally the local dns caching (dnsmasq?)

Looks like Fedora builds dnsmasq with 'no-i18n', although "dnsmasq -v"
also shows "IDN2", so who knows.. Maybe it's some default config issue
rather than the build configuration.

                  Linus
