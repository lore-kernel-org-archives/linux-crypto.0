Return-Path: <SRS0=SwA+=7B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 758CEC433DF
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 19:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5370F206C3
	for <linux-crypto@archiver.kernel.org>; Tue, 19 May 2020 19:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589915100;
	bh=5wUA2kw9gi9NGUOPlTqxvEngtjEwdS/z9ZQ0DwPRQKI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=I/YYsXq69bra7ngkl2eMm94yYvS0AdH9BVxcXT6lsRv5vGhkhkofS40a5/bgAkEDS
	 QyF+AEDes1+rnrid/hGCV8YUEvJgMfPBhTHjtaDQgZ3DbCwq8mahMKMYfKTNh6qvgW
	 Op/xvIUvjhHlYna2oETPnkyYpf40iP3x0C2oqrs4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbgESTE7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 May 2020 15:04:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:57458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726290AbgESTE7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 May 2020 15:04:59 -0400
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F262206C3
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 19:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589915099;
        bh=5wUA2kw9gi9NGUOPlTqxvEngtjEwdS/z9ZQ0DwPRQKI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Wo9CiWmYQaEpKbvJnXiL/gkwQUMPuCIuKSj3bjAm3313ObpQcUOq6yvBt6Eo6Cdxo
         MUhqJZHd3dI1dEAYXgiXsmg7eilLcrDdEf69gy8QEFEFzIxRZMFwfzGbLVTgja9JJl
         STRJpV8ZJPZPBeWoPPwsgS9ozKlcQmv2Z0+5N+tM=
Received: by mail-io1-f52.google.com with SMTP id k18so406771ion.0
        for <linux-crypto@vger.kernel.org>; Tue, 19 May 2020 12:04:59 -0700 (PDT)
X-Gm-Message-State: AOAM530B+iIORrEmMNjprfc7SccP+uXoQQ9v3BIcBm35k+DXoc8uHBFk
        Aeajfn3Gdsc2NqVOctfqXvPXhL9+8WNsLuu9D5U=
X-Google-Smtp-Source: ABdhPJzdM446lwy+w5EhFYeIWCa0NRFUvx+N+9/U7j7zeiwe+oc/IRDmuMyfOTUmB2GjrXJLbgkmr91t/kyBQcTEzRo=
X-Received: by 2002:a05:6638:41b:: with SMTP id q27mr1094617jap.68.1589915098721;
 Tue, 19 May 2020 12:04:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200519190211.76855-1-ardb@kernel.org>
In-Reply-To: <20200519190211.76855-1-ardb@kernel.org>
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Tue, 19 May 2020 21:04:47 +0200
X-Gmail-Original-Message-ID: <CAMj1kXE-e8VatDyVW-ptRtpk81FTrXbLyJgHXojbyFMAi_WF0w@mail.gmail.com>
Message-ID: <CAMj1kXE-e8VatDyVW-ptRtpk81FTrXbLyJgHXojbyFMAi_WF0w@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH 0/2] crypto: add CTS output IVs for arm64 and testmgr
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Stephan Mueller <smueller@chronox.de>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

(add Gilad for cc-ree)

On Tue, 19 May 2020 at 21:02, Ard Biesheuvel <ardb@kernel.org> wrote:
>
> Stephan reports that the arm64 implementation of cts(cbc(aes)) deviates
> from the generic implementation in what it returns as the output IV. So
> fix this, and add some test vectors to catch other non-compliant
> implementations.
>
> Stephan, could you provide a reference for the NIST validation tool and
> how it flags this behaviour as non-compliant? Thanks.
>
> Cc: Stephan Mueller <smueller@chronox.de>
>
> Ard Biesheuvel (2):
>   crypto: arm64/aes - align output IV with generic CBC-CTS driver
>   crypto: testmgr - add output IVs for AES-CBC with ciphertext stealing
>
>  arch/arm64/crypto/aes-modes.S |  2 ++
>  crypto/testmgr.h              | 12 ++++++++++++
>  2 files changed, 14 insertions(+)
>
> --
> 2.20.1
>
