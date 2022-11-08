Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 326A1C4332F
	for <linux-crypto@archiver.kernel.org>; Tue,  8 Nov 2022 08:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbiKHIcY (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 8 Nov 2022 03:32:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbiKHIcW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 8 Nov 2022 03:32:22 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98B22791E;
        Tue,  8 Nov 2022 00:32:21 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1667896339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8pfGe51aDCtJLfkDBJjFWz87K+4Z00C3/Nyvbv/ZufU=;
        b=JpkRroxIuiKYwNNwCR62L0nUkId0vv0KShqlTvtcbwIFOCXmEK1Ijp6DbOoS9YGEfgOhdb
        qnCIz2Nhq1+3lkOIFVb5j9Qp2FmgjRS+mfOJAKaf5MssGCyTWvQONI/GE3aTnnuKCHB0rj
        o2sk6/YTdTcWd1YoGwb6D/ET7RTIML9F9woehAWA7HzZdSZY6YIi9Q3sZnNV31FtGmT9HM
        Q/lONxT1dfgO4ZFvDOY6jGLKlmzeYD1sCXHXAoCY0tjw0ITRqqDoQy4XWh7dWlhCbUMn3b
        QR2+HcSrNam0G4NS1AqsQujDnUNnGXeEaK5d4FO2bFCzPf5YU9ABn3vhGl1U+A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1667896339;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8pfGe51aDCtJLfkDBJjFWz87K+4Z00C3/Nyvbv/ZufU=;
        b=JNbl06FFH9Wdisu/eOljA6OMgxZlx7ILLDSAmU8yGh65tKdxBzI/f2QG9iJ6oUj+orRUMr
        TTNDfr64odE2a/BQ==
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-kernel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        linux-crypto@vger.kernel.org, x86@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
        Carlos O'Donell <carlos@redhat.com>
Subject: Re: [PATCH RFC v3] random: implement getrandom() in vDSO
In-Reply-To: <20220916125916.652546-1-Jason@zx2c4.com>
References: <20220916125916.652546-1-Jason@zx2c4.com>
Date:   Tue, 08 Nov 2022 09:32:19 +0100
Message-ID: <87v8np978s.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Sep 16 2022 at 13:59, Jason A. Donenfeld wrote:
> ---
>  MAINTAINERS                            |   2 +
>  arch/x86/entry/syscalls/syscall_32.tbl |   1 +
>  arch/x86/entry/syscalls/syscall_64.tbl |   1 +
>  arch/x86/entry/vdso/Makefile           |   3 +-
>  arch/x86/entry/vdso/vdso.lds.S         |   2 +
>  arch/x86/entry/vdso/vgetrandom.c       |  16 ++++
>  arch/x86/include/asm/vdso/getrandom.h  |  37 ++++++++
>  arch/x86/include/asm/vvar.h            |  16 ++++
>  drivers/char/random.c                  |  64 ++++++++++++++
>  include/vdso/datapage.h                |   6 ++
>  lib/crypto/chacha.c                    |   4 +
>  lib/vdso/getrandom.c                   | 117 +++++++++++++++++++++++++
>  lib/vdso/getrandom.h                   |  25 ++++++
>  13 files changed, 293 insertions(+), 1 deletion(-)
>  create mode 100644 arch/x86/entry/vdso/vgetrandom.c
>  create mode 100644 arch/x86/include/asm/vdso/getrandom.h
>  create mode 100644 lib/vdso/getrandom.c
>  create mode 100644 lib/vdso/getrandom.h

This is not how it works. Please split this apart into reviewable bits
and pieces:

1) Add the new syscall
2) Add the vdso infrastructure
3) Wire it up on x86

Thanks,

        tglx
