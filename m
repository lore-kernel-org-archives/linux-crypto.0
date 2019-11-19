Return-Path: <SRS0=Veu2=ZL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1BBCC432C0
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 934E020679
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Nov 2019 15:18:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="qWNlTTBt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728054AbfKSPSz (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 19 Nov 2019 10:18:55 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:57501 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727937AbfKSPSz (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 19 Nov 2019 10:18:55 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id c2ce101c
        for <linux-crypto@vger.kernel.org>;
        Tue, 19 Nov 2019 14:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=rG3hS5SEuYJKJfNmhcmqK/2qzgk=; b=qWNlTT
        BtquDqSSt2XIr94OKPWUTK+sKlb83se3kK5/codwjsqC9pHtCXTbweXOhvgExA4e
        iAeZH5naXVjhRRAq7xPT82K+oaUew80quLacE++Up3NquLnHQTZ/LAFGLRXaeB47
        /j2BOOJjFI2ua5X3UlvyHbtD70UBlLXhcFVKvcEEVY21MhOcNomiaLgG7T99hGhW
        TtLkstxKXRPua+NDjKAAg6UUhN0IA2PGc6QZS6T2p0gMUq9uYNeHTEXW85YoVTZz
        ZdIatlSnrShBOoZEP9g2qN4J3fUxoqpqr3vaTa12gEBEwCDD0Qc6xdsjKV1zvxF3
        T/2CI4N+MSBmpIJA==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c5077d3a (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <linux-crypto@vger.kernel.org>;
        Tue, 19 Nov 2019 14:26:03 +0000 (UTC)
Received: by mail-ot1-f52.google.com with SMTP id 1so1322508otk.1
        for <linux-crypto@vger.kernel.org>; Tue, 19 Nov 2019 07:18:53 -0800 (PST)
X-Gm-Message-State: APjAAAXIFdJzDH9ZtopjEOmztFvA05m2pP2RAvNZOc4L8K7bTh5V06iU
        1mmUct+bCvKx71ZCP8ZMx1ofSxunbcEaQFziHs8=
X-Google-Smtp-Source: APXvYqyALN7Sy/66950m/ukIGFsxPAOBwZKCKqAcU1S0aHItUhoBQ4wUe8iWXc24NXo6jKeGLqYVP8IbB8pehN/sK0o=
X-Received: by 2002:a05:6830:4c7:: with SMTP id s7mr4298018otd.52.1574176731868;
 Tue, 19 Nov 2019 07:18:51 -0800 (PST)
MIME-Version: 1.0
References: <20191108122240.28479-1-ardb@kernel.org> <20191115060727.eng4657ym6obl4di@gondor.apana.org.au>
 <CAHmME9oOfhv6RN00m1c6c5qELC5dzFKS=mgDBQ-stVEWu00p_A@mail.gmail.com> <20191115090921.jn45akou3cw4flps@gondor.apana.org.au>
In-Reply-To: <20191115090921.jn45akou3cw4flps@gondor.apana.org.au>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 19 Nov 2019 16:18:40 +0100
X-Gmail-Original-Message-ID: <CAHmME9rxGp439vNYECm85bgibkVyrN7Qc+5v3r8QBmBXPZM=Dg@mail.gmail.com>
Message-ID: <CAHmME9rxGp439vNYECm85bgibkVyrN7Qc+5v3r8QBmBXPZM=Dg@mail.gmail.com>
Subject: Re: [PATCH v5 00/34] crypto: crypto API library interfaces for WireGuard
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Samuel Neves <sneves@dei.uc.pt>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Martin Willi <martin@strongswan.org>,
        Rene van Dorst <opensource@vdorst.com>,
        David Sterba <dsterba@suse.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hey Ard, Herbert, Dave,

The series looks fine. Ard -- thanks so much for picking up the work
and making this happen. As far as I'm concerned, this is "most" of
Zinc, simply without calling it "Zinc", and minus a few other things
that I think constitutes an okay compromise and good base for moving
forward.

Reviewed-by: Jason A. Donenfeld <Jason@zx2c4.com>

The TODO list for me remains the same, and now I can get moving with that:

- Zinc's generic C implementation of poly1305, which is faster and has
separate implementations for u64 and u128.
- x86_64 ChaCha20 from Zinc. Will be fun to discuss with Martin and Andy.
- x86_64 Poly1305 from Zinc.
- Resurrecting the big_keys patch and receiving DavidH's review on that.
- WireGuard! Hurrah!

If you have any feedback on how you'd like this prioritized, please
pipe up. For example Dave - would you like WireGuard *now* or sometime
later? I can probably get that cooking this week, though I do have
some testing and fuzzing of it to do on top of the patches that just
landed in cryptodev.

Jason
