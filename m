Return-Path: <SRS0=ov1/=SZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9309DC282DD
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Apr 2019 20:04:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6418B217D9
	for <linux-crypto@archiver.kernel.org>; Tue, 23 Apr 2019 20:04:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="BAFFKENl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbfDWUEr (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 23 Apr 2019 16:04:47 -0400
Received: from mail-vs1-f65.google.com ([209.85.217.65]:34408 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfDWUEq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 23 Apr 2019 16:04:46 -0400
Received: by mail-vs1-f65.google.com with SMTP id n17so734966vsr.1
        for <linux-crypto@vger.kernel.org>; Tue, 23 Apr 2019 13:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pZSJahBImGp5goo8nvjTMJttMM1GHqLupimfQ6N20KY=;
        b=BAFFKENlKP6uq62FbGRc0pFV0dPw5/S7P232XJWdODaOdY+WRCJpWjN/jKaVhlivVB
         5DtllP9khNAO9jBlWbomEMgBLMil2fJtEiqAdflnP3tlJhfmxZQJXr08n4Ifu9Dbmicz
         zRn4NDkYszIp5RijsnnxRfogXf2xCH9xBcXww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pZSJahBImGp5goo8nvjTMJttMM1GHqLupimfQ6N20KY=;
        b=KgyfEomDAvcBOcbR/l2KM8meK/BML364aFjmdbOAGtnZRxD6PrsHf6u1mVWogtMFzR
         NvYyO171/D/GNkySPHaWhRbmFA66UTJ4lsUtmPNo4F3jpgyvEuiJhs0h7ejouEdpjo1a
         agis5v4x9JZo4ZIvxB0nFX48wXE2/XENdMzo0cKqhbt38TozNSJ2VcaJ7BQig5UdKTQo
         5Sm1VTbBn1pNCUWrkWCgtUZHQ0uqQB4S8ByTQuM5OAPsbHuBj6nszMJHYREAxPAJtvgF
         HrL7TZu2FhVlcRKBfClDMWQR2SGT5V33JnpM4woiS36GbwsyrazHsMtCLd/nfwGPPoSE
         xhsw==
X-Gm-Message-State: APjAAAXMwjKhXM8yiK+hlR9f0rtEJU3ylQoj8rgA7drZ9aRwZhPjs4df
        e4HPf787sPFbvUHtRWctmf0aJ+8GgwE=
X-Google-Smtp-Source: APXvYqyCgo48XzbGFkrJN2M9RKUeSKwURl2VMW5eF10EaQWJYeA16rbCx3NO3l6Zfcyd9QMHFc786g==
X-Received: by 2002:a67:e446:: with SMTP id n6mr14482116vsm.183.1556049884739;
        Tue, 23 Apr 2019 13:04:44 -0700 (PDT)
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com. [209.85.217.42])
        by smtp.gmail.com with ESMTPSA id 8sm4521622vkw.38.2019.04.23.13.04.42
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Apr 2019 13:04:43 -0700 (PDT)
Received: by mail-vs1-f42.google.com with SMTP id w13so9036766vsc.4
        for <linux-crypto@vger.kernel.org>; Tue, 23 Apr 2019 13:04:42 -0700 (PDT)
X-Received: by 2002:a05:6102:417:: with SMTP id d23mr5316366vsq.48.1556049882301;
 Tue, 23 Apr 2019 13:04:42 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000060e0ae057a092be8@google.com> <0000000000009e8ef30584976ca9@google.com>
In-Reply-To: <0000000000009e8ef30584976ca9@google.com>
From:   Kees Cook <keescook@chromium.org>
Date:   Tue, 23 Apr 2019 13:04:31 -0700
X-Gmail-Original-Message-ID: <CAGXu5jJuU8PjPW-K=wDEaShKTenbADKwF4DcKPwNBrrynD0thg@mail.gmail.com>
Message-ID: <CAGXu5jJuU8PjPW-K=wDEaShKTenbADKwF4DcKPwNBrrynD0thg@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in crypto_gcm_init_common
To:     syzbot <syzbot+e736399a2c4054612307@syzkaller.appspotmail.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        aviadye@mellanox.com, borisp@mellanox.com,
        Daniel Borkmann <daniel@iogearbox.net>, davejwatson@fb.com,
        "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>,
        Eric Biggers <ebiggers3@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        john.fastabend@gmail.com, k.marinushkin@gmail.com,
        linux-crypto <linux-crypto@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Security Officers <security@kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 21, 2019 at 2:33 AM syzbot
<syzbot+e736399a2c4054612307@syzkaller.appspotmail.com> wrote:
>
> syzbot has bisected this bug to:
>
> commit 428490e38b2e352812e0b765d8bceafab0ec441d
> Author: Jason A. Donenfeld <Jason@zx2c4.com>
> Date:   Wed Sep 20 14:58:39 2017 +0000
>
>      security/keys: rewrite all of big_key crypto
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=160eabcf200000
> start commit:   428490e3 security/keys: rewrite all of big_key crypto
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=150eabcf200000
> console output: https://syzkaller.appspot.com/x/log.txt?x=110eabcf200000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9384ecb1c973baed
> dashboard link: https://syzkaller.appspot.com/bug?extid=e736399a2c4054612307
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17902f5b400000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=111377e5400000
>
> Reported-by: syzbot+e736399a2c4054612307@syzkaller.appspotmail.com
> Fixes: 428490e38b2e ("security/keys: rewrite all of big_key crypto")

Did this regression get fixed?

-- 
Kees Cook
