Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAA56C48BE0
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 09:45:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ABC99613D5
	for <linux-crypto@archiver.kernel.org>; Fri, 11 Jun 2021 09:45:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbhFKJrE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 11 Jun 2021 05:47:04 -0400
Received: from mail-wm1-f50.google.com ([209.85.128.50]:53861 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231574AbhFKJrE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 11 Jun 2021 05:47:04 -0400
Received: by mail-wm1-f50.google.com with SMTP id b205so3037440wmb.3
        for <linux-crypto@vger.kernel.org>; Fri, 11 Jun 2021 02:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=Iohi461kjcJMARSaZJtMtzgG1Y04ZNwqpJYB6vEREOE=;
        b=Ym8Hcdc8JD8YE1hevYjwN5wHnINI60kjdJnJgyB0GfB8M66tpxkw+8vA1wrwbvQcV0
         jdFieWUBRPqTqAvQYpzXy1MogRF2dgdZzQ9Ei6bzEB7JQHrQL70S4/95mUZt0lLkAM28
         LqarfU7FK856wqutC5XWrjTOB3AVrT5sojFHhEFHyvo2nxH9SOPoKMqyLpQ4kbX73riK
         mHwrU7n2oNf8Gw3h1x4O7mkW8HgDmNyLF/tlCjW1CYsbFU733TEaWPfY6RGFvVoA8Y4H
         7/4TcOUnADQK8ACBIslL7bnRqhwkZVFHc5oaILZfpPfxTwVrx+OXvdQWfp4MCEJ66jTL
         3QQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Iohi461kjcJMARSaZJtMtzgG1Y04ZNwqpJYB6vEREOE=;
        b=HPQipksMsxp6/yv95C7FdAzi/IUDcb1URLZHvEYGHHC+I28t297Ajdf4dUBFHz/fI0
         y/8The2u/9xvShdrKfFJ1Lsas/I9+h1eVjMa2H/cP/vjZY+W5JYzkbskgCju3Mwq1IMn
         cVy2O8NAMnvkZKHK95TY3EEOWQZtaeo+H25mBO62uIlctptXBwNlpq57KabPeac/3VS9
         KzWj9eiJNThr/8W9PoA2hpdFACpXOBg1yrL1+CRx8t8uq47jFDfQycLBgvEh1+7E5c8f
         tUTrn1p70IDRVkgf8tHkuncj36wPAypGAp0x5sVd72UA/JyooLqMq28J2YBvuOJuYQRW
         oE0w==
X-Gm-Message-State: AOAM531zt63vQgUmg/t4vd2fKCaZX8alCG0C4imS7q+9xePCEaIWTcTf
        NzRC93JTVrkXdJv1sgYBtatGKLZb8wMt5Nk8G0T3mFwVZzw=
X-Google-Smtp-Source: ABdhPJy9m2r9OaAQWG+tlKB6rQYExtmtyg2ZFLH2qcpQ2fU7jqcOwtapOfWrdv/34RcyqMBvhSLWGyfItrQDf/UVbwk=
X-Received: by 2002:a7b:c192:: with SMTP id y18mr19502274wmi.65.1623404645585;
 Fri, 11 Jun 2021 02:44:05 -0700 (PDT)
MIME-Version: 1.0
References: <CALFqKjSnOWyFjp7NQZKMXQ+TfzXMCBS=y8xnv5GE56SHVr5tCg@mail.gmail.com>
 <CACXcFmnRAkrj0Q3uFjyLu7RaWQh0VPbmErkj+cUaxZMb=YiGCw@mail.gmail.com>
In-Reply-To: <CACXcFmnRAkrj0Q3uFjyLu7RaWQh0VPbmErkj+cUaxZMb=YiGCw@mail.gmail.com>
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Fri, 11 Jun 2021 17:43:52 +0800
Message-ID: <CACXcFmmW+tCUf8JS=a=wJEnBY2JojP8VwEGLncYcGLZqiU+5Jw@mail.gmail.com>
Subject: Re: Lockless /dev/random - Performance/Security/Stability improvement
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Ted Ts'o" <tytso@mit.edu>, Stephan Mueller <smueller@chronox.de>,
        John Denker <jsd@av8n.com>, m@ib.tc
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Sandy Harris <sandyinchina@gmail.com> wrote:

> The basic ideas here look good to me; I will look at details later.

Looking now, finding some things questionable.

Your doc has:

" /dev/random needs to be fast, and in the past it relied on using a
cryptographic primitive for expansion of PNRG to fill a given request

" urandom on the other hand uses a cryptographic primitive to compact
rather than expand,

This does not seem coherent to me & as far as I can tell, it is wrong as well.
/dev/random neither uses a PRNG nor does expansion.
/dev/urandom does both, but you seem to be saying the opposite.

" We can assume AES preserves confidentiality...

That is a reasonable assumption & it does make the design easier, but
is it necessary? If I understood some of Ted's writing correctly, one
of his design goals was not to have to trust the crypto too much. It
seems to me that is a worthy goal. One of John Denker's papers has
some quite nice stuff about using a hash function to compress input
data while preserving entropy. It needs only quite weak assumptions
about the hash.
https://www.av8n.com/turbid/

You want to use AES in OFB mode. Why? The existing driver uses ChaCha,
I think mainly because it is faster.

The classic analysis of how to use a block cipher to build a hash is
Preneel et al.
https://link.springer.com/content/pdf/10.1007%2F3-540-48329-2_31.pdf
As I recall, it examines 64 possibilities & finds only 9 are secure. I
do not know if OFB, used as you propose, is one of those. Do you?
