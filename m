Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95B35CDB465
	for <linux-crypto@archiver.kernel.org>; Sat, 14 Oct 2023 23:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjJNXDO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 14 Oct 2023 19:03:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbjJNXDN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 14 Oct 2023 19:03:13 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E156B7
        for <linux-crypto@vger.kernel.org>; Sat, 14 Oct 2023 16:03:10 -0700 (PDT)
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id A5D393F546
        for <linux-crypto@vger.kernel.org>; Sat, 14 Oct 2023 23:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1697324588;
        bh=g4FZTSl0d4ZJADlSvm57nChfceUNZzU0dP0RCDb94EA=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=g6IRxgfbQK3zPzzy8ZM4tHFvebXOwaBBDqrCHAP8FETXV8N5PYtQnfnUnd73aglwL
         TWqJQdwOTz/GxjVnyhDLFzdzb1xzHsCRf6Xl7ditzx8UtVUodBqrc8+T4tEzoLv4Hk
         Ws222R8dpFMHhuwYg5F/YUIkK79LVkHIUu4qrexu3la1tBia9q6MpWTXS6mrN8HnRr
         9whh4Ejmic4GTBd8aUeabjzSv5skocfNijJUebWkDlHpWJW91rVV12T3oMMpecgm2e
         L5deCUhkzrGSCPw1odN9ECRzVmxemqw89iBScgnizuylz3Mv9opmTIkBjwPMwQ3GsK
         HPEsLKx39u5Ow==
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-32da47641b5so480104f8f.0
        for <linux-crypto@vger.kernel.org>; Sat, 14 Oct 2023 16:03:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697324588; x=1697929388;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g4FZTSl0d4ZJADlSvm57nChfceUNZzU0dP0RCDb94EA=;
        b=XGzN0dKOU0jsbLCI2X01GOBN2Y8qOpvWThFPkqYXPM3Uw/z1rULwTMTN/XViQOnMDh
         wkbBiPnAkBp24JFZduKIvFV3CIZny3gLN9m2222Yhsgh+Z+bTgxW6KRBkGKMh07pFa9r
         2lEuEykQgHLFZItuNKFVDKo4ToadXTsUj2qNXsRHZRQLZHSPexXMZiC5dlqYc1My0swt
         +aengFNx+ZeqDIqvMsBmq6taMYqHSCTm8IP2bahsxWzw16Y4NhALN1jfxlREpZfkNm9/
         P0XhTIJSYj7FZYwqlV7S8d/xkZa2KTSiilp6zLu9zD35qIGBUD99Exs5tYKTkrV0STFa
         gvXw==
X-Gm-Message-State: AOJu0Yzwn4uyGkdM9tnJIsMnO8HuzihqLL6gkBLcnqc01YplHLsvGK2L
        aRRQoO0o1QWTfrcuhtBVDU12sP4R2jo1sexjSWDO0ba0LUOxm0B7hrbaJBzwXbzfSvjIGi3gMYb
        RLhf0nwAOXZIvGcBdV4EKyO/XJq8pv0NXhWtJ1Rg5Kj9fM1WR2tPJya0/6g==
X-Received: by 2002:a05:6000:1b07:b0:321:6450:62ea with SMTP id f7-20020a0560001b0700b00321645062eamr26180425wrz.36.1697324588153;
        Sat, 14 Oct 2023 16:03:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJOb0XCESRaZNsKxGDIHX5HswxMXGFvre7WUTS/9leErz6A4oyrNkphQTIFfBH43Pd5OvGYb6ogvO9KIDWmeU=
X-Received: by 2002:a05:6000:1b07:b0:321:6450:62ea with SMTP id
 f7-20020a0560001b0700b00321645062eamr26180409wrz.36.1697324587746; Sat, 14
 Oct 2023 16:03:07 -0700 (PDT)
MIME-Version: 1.0
References: <20231008040140.1647892-1-dimitri.ledkov@canonical.com>
 <ZSkeWHdOAOfjtpwJ@gondor.apana.org.au> <2e52c8b4-e70a-453f-853a-1962c8167dfa@gmail.com>
In-Reply-To: <2e52c8b4-e70a-453f-853a-1962c8167dfa@gmail.com>
From:   Dimitri John Ledkov <dimitri.ledkov@canonical.com>
Date:   Sun, 15 Oct 2023 00:02:32 +0100
Message-ID: <CADWks+ZV=BNzEUUgw4YuE_1cr7O7puunBy5FJf-_jyWJyPz=sg@mail.gmail.com>
Subject: Re: [PATCH] crypto: remove md4 driver
To:     Denis Kenzior <denkenz@gmail.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        James Prestwood <prestwoj@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, 13 Oct 2023 at 15:37, Denis Kenzior <denkenz@gmail.com> wrote:
>
> Hi Herbert,
>
> On 10/13/23 05:39, Herbert Xu wrote:
> > On Sun, Oct 08, 2023 at 05:01:39AM +0100, Dimitri John Ledkov wrote:
> >> No internal users left and cryptographically insecure. Users should
> >> upgrade to something else, e.g. sha256 blake3.
> >>
> >> Some drivers have their own full or partial md4 implementation without
> >> using crypto/md4.
> >>
> >> Userspace code search indicates a few copies of hash_info.h
> >> https://codesearch.debian.net/search?q=HASH_ALGO_MD4&literal=1 without
> >> need for MD4.
> >>
> >> Preserve uapi hash algorithm indexes and array length, but rename the
> >> MD4 enum.
> >>
> >> Signed-off-by: Dimitri John Ledkov <dimitri.ledkov@canonical.com>
> >> ---
> >>   crypto/Kconfig                 |   6 -
> >>   crypto/Makefile                |   1 -
> >>   crypto/hash_info.c             |   4 +-
> >>   crypto/md4.c                   | 241 ---------------------------------
> >>   crypto/tcrypt.c                |  12 --
> >>   crypto/testmgr.c               |   6 -
> >>   crypto/testmgr.h               |  42 ------
> >>   include/uapi/linux/hash_info.h |   2 +-
> >>   8 files changed, 3 insertions(+), 311 deletions(-)
> >>   delete mode 100644 crypto/md4.c
> >
> > Patch applied.  Thanks.
>
> Does this patch break userspace?
>
> Here's a thread regarding MD4 the last time its removal was attempted:
> https://lore.kernel.org/linux-crypto/20210818144617.110061-1-ardb@kernel.org/
>
> Please note that iwd does use MD4 hashes here:
> https://git.kernel.org/pub/scm/libs/ell/ell.git/tree/ell/checksum.c#n63
>
> https://git.kernel.org/pub/scm/network/wireless/iwd.git/tree/src/eap-mschapv2.c#n165
>

Thank you for this reference. The WiFI eap mschapv2 based
authentication indeed relies on MD4. The IWD code uses kernel as a
basically impromptu userspace library to gain access to MD4, which
sounds like a poor way of doing this. In comparison NetworkManager
uses userspace crypto libraries to compute that.

Note that iwd has an alternative code path of using md4 hashed
password, meaning it does still work on kernels without MD4.

It worries me a lot that this is still in active use.

MS-CHAPv2 has been completely broken since 2012 with a cloud service
at the time offered to automatically crack any communication. It is
insecure, does not provide any confidentiality, and worse off allows
to steal & reuse credentials to later impersonate the original user.
It is worse than unencrypted WiFi in that sense. Even Windows 11 since
at least 22H2 release prohibits such connections.  I will propose
patches to IWD to stop using the md5 crypto kernel interface. As much
as it is convenient, users of insecure & obsolete cryptography must
not hold up removal of such methods from the kernel.

-- 
okurrr,

Dimitri
