Return-Path: <SRS0=jBdH=UR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D0FAC31E51
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3F2D32085A
	for <linux-crypto@archiver.kernel.org>; Tue, 18 Jun 2019 09:37:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WLhARJow"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbfFRJh3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 18 Jun 2019 05:37:29 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:34167 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729113AbfFRJh3 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 18 Jun 2019 05:37:29 -0400
Received: by mail-yb1-f193.google.com with SMTP id x32so1509235ybh.1
        for <linux-crypto@vger.kernel.org>; Tue, 18 Jun 2019 02:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KnB6xK4HiQoJS5/13fsK8xxNIgyVPR5SQYTgXV9IFVg=;
        b=WLhARJowtoGMcEvJRAnKSywn8KHofN+Bj8GZJT2bzMsrTwt/5+QY8YHcQ89VdWvqi1
         Cfz9SoLmtn7gwCmULSi9859h6+B8KTAOdC2J6iQC5TkBwlDgkTqkTgkCZng+feqgRqh/
         K1YXPkWJ59jMZed7P8fvjOuAJBB36/YgwRpRQEdhn/NnWcyb5clNX5wRaflHcMIV+XS+
         5rmkHC4f9CVjoLNdAPU0fPLaDsP4/XjfI9eptJLWFs/W5woXifjhmRzIyhMk1PQypij0
         lkZ4e46ttOu0dkjwIdEGYzpMr5iVnhcmf6YC7yIEJsdCRae1Caw6hvvxGXvIZHZorxWl
         /blw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KnB6xK4HiQoJS5/13fsK8xxNIgyVPR5SQYTgXV9IFVg=;
        b=UQazXW8Vs8G2kDuEvNhqmh6AMwJVV9htX9nIT2/NYkqK2eqtX0kYRJEv4YsbFE3cbB
         kCKihSAb18Tyu2X5V1C8WR8I9ZuIqQjOu79F4sRZdus69qG4Ts6S7TAIeAapYjjwqnoF
         GD6cz3D4mojsiFeme81wARNi/XH2abydQ9I8aBwnU7Q7I6YgZbJJK9dy0S6kl6d2eh0n
         jMj7zK0A8c4LA4cO/rEILM28d/J8REn2EaK86QC+WukKLW3w3wHF9J61Ljb6RIhFhINb
         +gQo2LRIvoSPa4WOr88K1ppZxTDuJmK5Ou+FNbmRJvoM/u/RobfUnThz93gdqwHO4ody
         dedg==
X-Gm-Message-State: APjAAAUVhT3JCnsvnF1KGYGgkWiAzJZffDDGyshh9LSUYtG95Nj0EPwc
        78NU5F/kz5DkiH/9jE05vfP/MhA8Z7l8JKQ/ir9C2w==
X-Google-Smtp-Source: APXvYqyON9JJ13ycv/7UNw8g/mJ0iS83UQ+LPfcdhghrZb9ImY7kP41P7TEXf/pLYuS13/imQ8r8Rx5aBbzSL+DO/X0=
X-Received: by 2002:a25:4557:: with SMTP id s84mr56059096yba.504.1560850648071;
 Tue, 18 Jun 2019 02:37:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190618093207.13436-1-ard.biesheuvel@linaro.org>
From:   Eric Dumazet <edumazet@google.com>
Date:   Tue, 18 Jun 2019 02:37:16 -0700
Message-ID: <CANn89i+Hcp5nxteWHOq-Uv9VzneCemVEkyyZJD=UG9-wsrLAwQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] net: fastopen: follow-up tweaks for SipHash switch
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Christoph Paasch <cpaasch@apple.com>,
        David Laight <David.Laight@aculab.com>,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jun 18, 2019 at 2:32 AM Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
>
> A pair of tweaks for issues spotted by Eric Biggers. Patch #1 is
> mostly cosmetic, since the error check it adds is unreachable in
> practice, and the other changes are syntactic cleanups. Patch #2
> adds endian swabbing of the SipHash output for big endian systems
> so that the in-memory representation is the same as on little
> endian systems.
>

Please always add net or net-next in your patches for netdev@

( Documentation/networking/netdev-FAQ.rst )

Thanks.
