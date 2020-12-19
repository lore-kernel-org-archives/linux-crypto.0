Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEC07C4361B
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 00:02:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CFC923BAC
	for <linux-crypto@archiver.kernel.org>; Sat, 19 Dec 2020 00:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725868AbgLSACs (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Dec 2020 19:02:48 -0500
Received: from mail.zx2c4.com ([192.95.5.64]:46447 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725855AbgLSACr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Dec 2020 19:02:47 -0500
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 42770fd4
        for <linux-crypto@vger.kernel.org>;
        Fri, 18 Dec 2020 23:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=bkR1yLEqiPk/LbWl/sSMnksv9a0=; b=jpLr2L
        kIftMAwsa4ysRZkzR86P+cI/8ft2WmRWTnJrciWQ4UUiD+C6HdTiOTmHpkNW+0zC
        uKUVATg9lCmj3ukEW+FchKkz3E5aZVCyqrENlc1ELrAMHkwvEu5HWzlBSPuu8PhG
        aGejV5KBa3kPeluzHaig5GDEBKz60sMyRz1hzWkqTNH2FbJ6aG8aWAE1IUPyZ7/T
        tBqkh1gE5ijbsprYlHDTflRU4E3mkuMAjinGU26ZJDGjbbCQ2GklrwC7Hq75Fo6z
        /sMQYDODbEa9OqgzLF0o4yKOsN7sWRdGT/Km+k1YeqtifosFHrDDe1EWbl/2Ms/a
        JK7wzG7YqWwcecgg==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id e96acc76 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Fri, 18 Dec 2020 23:54:08 +0000 (UTC)
Received: by mail-yb1-f176.google.com with SMTP id k78so3446272ybf.12
        for <linux-crypto@vger.kernel.org>; Fri, 18 Dec 2020 16:02:04 -0800 (PST)
X-Gm-Message-State: AOAM531Rmi6vR4kvneNZo24BwBLwXmKuiOmmv/hcMzmHafTeQXO8m+A/
        F9za/OsTvkdW7g+QwdPGkDXFRCSb7dJ2RLFjfZM=
X-Google-Smtp-Source: ABdhPJyjYDTMwTgN4YuZDlaxdwp/1OgBv2p5IAlEqli0PXqbVa6wr9sPYZKiXGIHKYvJyxrJpx+ICU10Xuuivwwof1E=
X-Received: by 2002:a25:2cd6:: with SMTP id s205mr9316601ybs.279.1608336124079;
 Fri, 18 Dec 2020 16:02:04 -0800 (PST)
MIME-Version: 1.0
References: <20201217222138.170526-1-ebiggers@kernel.org> <20201217222138.170526-10-ebiggers@kernel.org>
 <CAHmME9oW-_GXJ+nVwyiEV7wfjmzqBgqrSynnJ6xoN5UA_Nzh1Q@mail.gmail.com> <X90MPh/uwXXu3F/Y@sol.localdomain>
In-Reply-To: <X90MPh/uwXXu3F/Y@sol.localdomain>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sat, 19 Dec 2020 01:01:53 +0100
X-Gmail-Original-Message-ID: <CAHmME9pAEssKZGUchD6kh=waNnUcK=MOW2-=9Qv0Tsec4=0xgQ@mail.gmail.com>
Message-ID: <CAHmME9pAEssKZGUchD6kh=waNnUcK=MOW2-=9Qv0Tsec4=0xgQ@mail.gmail.com>
Subject: Re: [PATCH v2 09/11] crypto: blake2s - share the "shash" API
 boilerplate code
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        Paul Crowley <paulcrowley@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Eric,

The solution you've proposed at the end of your email is actually kind
of similar to what we do with curve25519. Check out
include/crypto/curve25519.h. The critical difference between that and
the blake proposal is that it's in the header for curve25519, so the
indirection disappears.

Could we do that with headers for blake?

Jason
