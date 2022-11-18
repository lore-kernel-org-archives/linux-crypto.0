Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1F9AC433FE
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Nov 2022 22:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229720AbiKRWCU (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Nov 2022 17:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbiKRWCT (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Nov 2022 17:02:19 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0876291C16
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 14:02:18 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id kt23so16218384ejc.7
        for <linux-crypto@vger.kernel.org>; Fri, 18 Nov 2022 14:02:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+4RJOTB2BvCcQXli2TNiZVv8Xc8rRNSUHJ0opB/cm1U=;
        b=Nm5a/3tthXxF5oAPfgYg2Q0uAr1cXp4foC0RqZ4agxLqGrs/oLX90bFuvS70MRZiOU
         bzKvdQ+1KzmZQlRSUQbLL/Rqq12x5Fi1js5ODEPq6p+d99t0PL6RN13BLJmb4Xtc4vMW
         4pyIx3eCBaTi/ShgCGpunJ7EQIHL/yRrcxDs/FrcNK2FvicP0Bkj46ELF50Jek6+0bXG
         eqIMueMUHJMJbfpiwCrJziHeOwxM/STgbXnYjvbGpzhyP7o3PgCxVM8VTNTTe9XUkX/N
         3u3peBrD/wYcW0pCHaDZxUwlYAf0CyUJyQO/QVlPgv51U8EInN75/eZq+a6+dfR3jCTv
         m/zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+4RJOTB2BvCcQXli2TNiZVv8Xc8rRNSUHJ0opB/cm1U=;
        b=7pm1HftVhl3KJGBVQl78L0XQrUmfr63SmFcxxYbwy0QKtsTDcAPtvgDlOFGAIfManJ
         V0wKe5px7Em3Bj8Kd+QfnetJVQL5MJdm40KSV2dofH3+bBXwicxYYjEmZ4mBrY5VYT0X
         KpVrILvuemmLFfTlKK4RkTPXidJXsjjxg1IzbcY26XD/cCrVUjxQTV2KqawK6B+YyxNJ
         4cvjOtjhS3gKMYt63q98Uzd6EMyO8t6bic72N86NUK6OOoi3qnMgV9OAP1PpPuv1F5oz
         X0nqzlgesO56Woytbsy3hByY070KthZ9gX+L41hxZLLxdlDaprG6t8HeLGFBSMkF9z5Y
         5qpw==
X-Gm-Message-State: ANoB5ploWdu/h4wAt4Nz1tVmTAk3qiGw+uRFZYtP+0qBakEiHUCmLee6
        l7b8cJushdnsX3791EpvsrbbSH0Lzfnufa6rNLO1gw==
X-Google-Smtp-Source: AA0mqf4zQjlFamCGqjF8auCf9m1ktL45kn469Fw28Zv6RB6qr5s/4EhQ8DRjUOmHzJm8M7Mv6h7KhJJe1GjHInykSso=
X-Received: by 2002:a17:906:39c8:b0:7ad:79c0:5482 with SMTP id
 i8-20020a17090639c800b007ad79c05482mr7320316eje.730.1668808936450; Fri, 18
 Nov 2022 14:02:16 -0800 (PST)
MIME-Version: 1.0
References: <20221118194421.160414-1-ebiggers@kernel.org> <20221118194421.160414-9-ebiggers@kernel.org>
 <Y3fmskgfAb/xxzpS@sol.localdomain> <CABCJKudPXbDx2MSURDxGanTLhBkJjpMx=G=2RPDi6+96LGxcvw@mail.gmail.com>
 <CABCJKueoEkn7rWnDs7hb0nm84kKyyQuj5EVS_MtFNcfdT0D-EA@mail.gmail.com>
In-Reply-To: <CABCJKueoEkn7rWnDs7hb0nm84kKyyQuj5EVS_MtFNcfdT0D-EA@mail.gmail.com>
From:   Sami Tolvanen <samitolvanen@google.com>
Date:   Fri, 18 Nov 2022 14:01:40 -0800
Message-ID: <CABCJKuf4YeN++wYDrmwQyvzjfwWqjuctsezYQO9yOe2h9-TPrQ@mail.gmail.com>
Subject: Re: [PATCH v2 08/12] crypto: x86/sm4 - fix crash with CFI enabled
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     x86@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 18, 2022 at 12:53 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Fri, Nov 18, 2022 at 12:27 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > On Fri, Nov 18, 2022 at 12:10 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > > Sami, is it expected that a CFI check isn't being generated for the indirect
> > > call to 'func' in sm4_avx_cbc_decrypt()?  I'm using LLVM commit 4a7be42d922af0.
> >
> > If the compiler emits an indirect call, it should also emit a CFI
> > check. What's the assembly code it generates here?
>
> With CONFIG_RETPOLINE, the check is emitted as expected, but I can
> reproduce this issue without retpolines. It looks like the cfi-type
> attribute is dropped from the machine instruction in one of the X86
> specific passes. I'll take a look.

This should now be fixed in ToT LLVM after commit 7c96f61aaa4c. Thanks
for spotting the issue!

Sami
