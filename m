Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EF42C61DA4
	for <linux-crypto@archiver.kernel.org>; Thu,  9 Mar 2023 07:36:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229801AbjCIHgH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 9 Mar 2023 02:36:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230204AbjCIHfs (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 9 Mar 2023 02:35:48 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48CF0DC0AF
        for <linux-crypto@vger.kernel.org>; Wed,  8 Mar 2023 23:35:34 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-536bf92b55cso19041627b3.12
        for <linux-crypto@vger.kernel.org>; Wed, 08 Mar 2023 23:35:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678347333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BdV+4ekYzEX2zluka+Ae9nWocB3Egh4fr8hk8d8QYXw=;
        b=EKqMsvpzCXKMI5aX8f3xs8CPEOPXJewyVNUUcFc3G1GZMv/azP+RNWKyKqL46InX6N
         hFsidcfiHk+6LTbg40j/pNi4FctywQqkqtTldJuHmmK2wWJn1CGiyvwXmPNFUd7MYS9s
         yBIzGzMnbRqvgBdI7k7BBCzZDBOLSa/MEd7XCq0eV4vRemoZEtoIyNo9ZhllagHDMGt+
         SvISprl8K2ROh7M+n/VGk22USiGzWlY90WvsynSqZ+IBRcJ0XEMrVx57kv/19euyyO3r
         pQtwcGlJksyL4OyHuGAloXQOjiSLg3amE7olnED8VAI2gGJ59whqvSJjl9YCF/g9Uhrm
         8lsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678347333;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BdV+4ekYzEX2zluka+Ae9nWocB3Egh4fr8hk8d8QYXw=;
        b=JgyAA+OT+M5zjeg3DPV06WPe64EOMUjm/+b3dAxPjaSQIc08+WaR6/NQ8DMIhMiqB4
         P1AMLVYZS8OX0VAL8p8Pk/DtjsL56v3/QXX/3N4o5l7xSg9S+zK+LH2Su/apavt4tsyJ
         AWn9u2NkF2D+pXrccq8hEbIBgQNuO2FpvmawAifm4lDBKpSHit2UjU3LcRt7rtIU8efx
         1T5+gdq+HREKnL4RBP1azeEq//rWfpilDYPTZj5LGVt5Px0b8IJYUMK/5MyRAfFpcLgS
         D1d5iIBNJDfzGyROYHcBgWHRaJKKIHQtJ5lXig0IM9/ftNaalqsyaAR8kgERGQSDH62V
         8VOQ==
X-Gm-Message-State: AO0yUKUmBvlmmsq06txXqv5vhoxFhqWhoeIz+klCAsjFDbX4vopI26Et
        M7+zDXiPO+9halLetw2Z5pPYMtu9ZaIP0isaU6GGqg==
X-Google-Smtp-Source: AK7set9Ja/GCRaDydWCAyQwBS9jZIATgAx4CvCrcuDDV4SJYEpzXZqeohZJdyNwu6e4Mu4KnpP+hODHjLJmyQAVNWdQ=
X-Received: by 2002:a81:b149:0:b0:530:b21f:d604 with SMTP id
 p70-20020a81b149000000b00530b21fd604mr5782757ywh.9.1678347333493; Wed, 08 Mar
 2023 23:35:33 -0800 (PST)
MIME-Version: 1.0
References: <E1pZ2fs-000e27-4H@formenos.hmeau.com> <CACRpkdY8iN_ga0VuQ-z=8KUWaJ6=5rh2vZEwcp+oNgcBuPFk=g@mail.gmail.com>
 <ZAcNhtm/+mik1N2m@gondor.apana.org.au> <CACRpkdbcrCa9v82xVWtixWdDPvCu6E6Rkw-3Vg3APisdvYGwqQ@mail.gmail.com>
 <ZAf/rAbc3bMIwBcr@gondor.apana.org.au> <ZAgDku9htWcetafb@gondor.apana.org.au>
 <CACRpkdZ-zPZG4jK-AF2YF0wUFb8qrKBeoa4feb1qJ9SPusjv+Q@mail.gmail.com>
 <ZAhfBmlNHUpGEwW3@gondor.apana.org.au> <ZAhhGch6TtI8LA6x@gondor.apana.org.au>
 <CACRpkdabjrpsiVgm=EyGrTK7PGXth6FdvxSp=QULA+LyqtdBgg@mail.gmail.com> <ZAl1gGCv51FKOXtm@gondor.apana.org.au>
In-Reply-To: <ZAl1gGCv51FKOXtm@gondor.apana.org.au>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 9 Mar 2023 08:35:21 +0100
Message-ID: <CACRpkdY4gAT7RUtL6ctcsqxEX2_rZMyjMktPta7e4UB19OyGow@mail.gmail.com>
Subject: Re: [v5 PATCH 7/7] crypto: stm32 - Save and restore between each request
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Lionel Debieve <lionel.debieve@foss.st.com>,
        Li kunyu <kunyu@nfschina.com>, davem@davemloft.net,
        linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, mcoquelin.stm32@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 9, 2023 at 6:58=E2=80=AFAM Herbert Xu <herbert@gondor.apana.org=
.au> wrote:
> On Wed, Mar 08, 2023 at 10:19:48PM +0100, Linus Walleij wrote:
> >
> > So now the driver is fixed from a Ux500 point of view.
>
> I think there is actually a nasty bug in it that may be hard to
> trigger.
>
> The stm32 driver as it stands will write up to 256 bytes into
> the FIFO which on the ux500 is limited to 64 bytes.  We need to
> change the fixed 256-byte size to be dependent on the hardware
> type.

Right so that is done implicitly by using a buffer of 256 bytes.

But actually I think the bug will never trigger, because the datasheet
for the DB8500 (Ux500) says this:

"Then the message can be sent, by writing it word per word into the
HASH_DIN register.
When a block of 512 bits, i.e. 16 words have been written, a partial
digest computation will
start upon writing the first data of the next block. The AHB bus will
be busy for 82 cycles for
SHA-1 algorithm (66 cycles for SHA-256 algorithm)."

The way I interpret it is that if you write 64 bytes (16 32bit words)
the AHB bus will simply
stall until the data is processed, so the writel() hangs there and
then 66/82 bus cycles
later it will continue.

This isn't the prettiest from a system PoV, as it can stall interrupt
handling and
cause latency jitter, but it's not actually a bug. It's kind of
similar to that user
experience "bug" on x86 PCs where the sound starts breaking up if you have =
too
intense graphics going on, because the bus is too busy so the sound FIFO go=
es
empty.

But I can certainly make a patch to shrink the buffer from 256 to 64 bytes =
on
Ux500 if it's the right thing to do.

Yours,
Linus Walleij
