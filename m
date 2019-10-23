Return-Path: <SRS0=Ux5j=YQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76DE9CA9EB6
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 14:08:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A86621920
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Oct 2019 14:08:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Es8gLIsC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388504AbfJWOIz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Oct 2019 10:08:55 -0400
Received: from frisell.zx2c4.com ([192.95.5.64]:58269 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730622AbfJWOIz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Oct 2019 10:08:55 -0400
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id d55c3c44
        for <linux-crypto@vger.kernel.org>;
        Wed, 23 Oct 2019 13:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=gYi7JHyaBWH7zkBXmQlG2HyJa7E=; b=Es8gLI
        sCJ26X8m8j2fuS6EM3nvDeI4qw3GJ4zxtyc4ZydFngHzgPDJUGwy3ng6ZJC+amSI
        74ztB3X90BmXFFT7BdXCqpJISacch4/WePEtQfC/D09JCYpNth2UUdAt/YK4+/fy
        OiGf897uhSz9wJipkNMGU6JKtAQZixYXoYA/UWkmm0yHVdYSc6Yo/Ng6HEVVHqPr
        MvXnTpprfRLYHBiW5bPRNoDi67K94E89e3ff3aK1exx+r0Ce2lIwp/YTgx4A+8af
        x9bYhao0XCWdhjNcEEoob2Re3/tUN3JdzULfLqXtXcwgFAxiufrL3y4LnciqBGd9
        C68+/pEapyFcvnvw==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id a43bfade (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Wed, 23 Oct 2019 13:19:31 +0000 (UTC)
Received: by mail-ot1-f49.google.com with SMTP id g13so17506570otp.8
        for <linux-crypto@vger.kernel.org>; Wed, 23 Oct 2019 07:08:52 -0700 (PDT)
X-Gm-Message-State: APjAAAW/rssdl5tpsj2xFR/QTA/y/e7sM1++x+X9Kl4ZrcArrndrnHPF
        Uw9Sd3aWx7DeeoMiUIDsHn1qCqnAQ1Jxj1HxKJY=
X-Google-Smtp-Source: APXvYqzR5dF/WkFdMG1GcLDtcgLofHVgT4peuofaEiO2g5xoLoDI++KyNLz8ESe2YcHm0oSyx0ANxeAxRGEzM+rEJWI=
X-Received: by 2002:a9d:7f8d:: with SMTP id t13mr7632788otp.369.1571839730960;
 Wed, 23 Oct 2019 07:08:50 -0700 (PDT)
MIME-Version: 1.0
References: <20191017190932.1947-1-ard.biesheuvel@linaro.org>
 <20191017190932.1947-26-ard.biesheuvel@linaro.org> <20191023045511.GC361298@sol.localdomain>
In-Reply-To: <20191023045511.GC361298@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 23 Oct 2019 16:08:39 +0200
X-Gmail-Original-Message-ID: <CAHmME9oei5_9CpXoeMgD2MO5JWGc=Sm_pXJpmUfOuipbFRSTsg@mail.gmail.com>
Message-ID: <CAHmME9oei5_9CpXoeMgD2MO5JWGc=Sm_pXJpmUfOuipbFRSTsg@mail.gmail.com>
Subject: Re: [PATCH v4 25/35] crypto: BLAKE2s - x86_64 SIMD implementation
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Oct 23, 2019 at 6:55 AM Eric Biggers <ebiggers@kernel.org> wrote:
> There are no comments in this 685-line assembly language file.
> Is this the original version, or is it a generated/stripped version?

It looks like Ard forgot to import the latest one from Zinc, which is
significantly shorter and has other improvements too:

https://git.zx2c4.com/WireGuard/tree/src/crypto/zinc/blake2s/blake2s-x86_64.S
