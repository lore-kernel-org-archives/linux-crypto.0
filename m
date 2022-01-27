Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB453C433EF
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jan 2022 09:04:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234567AbiA0JEV (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jan 2022 04:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234573AbiA0JEU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jan 2022 04:04:20 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D60DC061714
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 01:04:20 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id ka4so4176094ejc.11
        for <linux-crypto@vger.kernel.org>; Thu, 27 Jan 2022 01:04:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=ufqOzcf7/E89VOK7/ROtJFtuJTogMX2K8iCroA8sc2k=;
        b=nMHtAWcbUm82teCSPFm7rxv4FsxFZAr3HoaxWxC55dygVFxn/afhIvFowg9KkxnLmH
         mzxXagRWbNkozY7lFn/1RJuiYjsf17kMgAdHUpI2T/sDzzPZrAf/EpD5g/fNKKleIQDg
         d81Rc/O80wDXOJjZvDv9Ma/BPvX6Y5tm9S5MA+N9g9Kgzp6tQ9y23XfQnJE/NFkrFPRM
         uRpMJCxp3gQ+XMVgRCH1sXoNtMmp94zj0t4moVk7sFKqnsZ3NccJV0beXHBUvLlqBvkm
         40WwA0sFIqxicZZ+cAnr3aIXHNPV1bYotLSFEeOIxwYulw87uhHgsVG/DPWYgLjInLKS
         UrCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=ufqOzcf7/E89VOK7/ROtJFtuJTogMX2K8iCroA8sc2k=;
        b=CTRxfhvnQmKhe/d1CfDEsEkjOgNNqQOlIs6TcNZi7whG8/+8nhXN8mE6B/YmfmqBLm
         AoHE8b2J0hgv4jq3tuanuTcck+7bL2X9IIwF8hbiE0h6zJ5OvG3cmX4KSe4GITJd/OFZ
         cDqYgdevQzuuHgzVsVoaT/OtBc4PlsInWppHsJ9/zNNT6MiKf2tUzDLcjjnCtbaX2TOh
         uFO943E0bMJ0j99u4Lsc31BkL6tV890nN+auAnqwXSbca2F30W1XoFpOPEW2RuQMazPT
         HqI0vQoXHOq3tColio4QGe0SL6XMMouiN0xNSyTIxzufGO2TE/r/VslPQknXMgI53sSy
         pFcA==
X-Gm-Message-State: AOAM530AQGZ1ZGVqN+APTblVRS4YWpPY0H6HA9Ug6pI14YBkR82MMx5J
        lzdKikG3sNgQWdzHzQ6ebteO1gyos/rG5g7R0NIIo38QtOs=
X-Google-Smtp-Source: ABdhPJx/Jf5MCKPFpALWuyYXNZsldXCOLHoE48RzSOsdmsik/PIULwou6E3ztVGegsnspTOIIGZoiWGE3mX9H4bZH0k=
X-Received: by 2002:a17:907:d86:: with SMTP id go6mr2244933ejc.482.1643274258678;
 Thu, 27 Jan 2022 01:04:18 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Thu, 27 Jan 2022 17:04:07 +0800
Message-ID: <CACXcFmkhWDwJ2AwpBFnyYrM-YXDgBfFyCeJsmMux3gM8G+Gveg@mail.gmail.com>
Subject: RFC random(4) We don't need no steenking ...
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        John Denker <jsd@av8n.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

In normal usage of either a hash or a cipher, consistent results are
needed because we want the hash to be usable for authentication and
the cipher to be decryptable. We therefore require a standard
initialisation using known constants, macros to deal with endinanness
so different systems can get the same results, and sometimes locking
of the inputs to avoid having a hash give indeterminate results.

I would contend that in the context of random(4), none of the above
are desirable, except perhaps for the first initialisation at boot
time & even that should use random data rather than constants if
possible, Thereafter, the input pool, hash context & chacha context
should all be updated only with ^= or += so they cannot lose entropy.
Nor should any code here lock any structure it only reads or
manipulate data for endianness.

Current code in extract_buf() declares a local struct blake2s_state,
calls blake2s_init() which uses initialisation constants, and moves
data into the chacha state with memcpy(). As I see it, those are
mistakes.

I'm inclined to think we need only one 512-bit context[]; use chacha
on it to generate output and hash directly into it to rekey. I have
not yet worked out the details or all the implications.

Other opinions?
