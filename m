Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F837C4707F
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 16:12:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6BDD661248
	for <linux-crypto@archiver.kernel.org>; Thu, 27 May 2021 16:12:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237061AbhE0QON (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 May 2021 12:14:13 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:10366 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235776AbhE0QOM (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 May 2021 12:14:12 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1622131879; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=L1Xnks6vErY0v6eEsjYD04tzc4I8FlY6WQ22pL41gMjxsVXMidOoKAOOwSSwsj3VAY
    RSIXZaMqzemZfWEfKT4/fKdAJVVJCSS7uIIO9gS+2+sKkp/aZzkUwA15FKU0blTABIdh
    20jGtMUZZso4Z+24VHlr4yRAy1GN5Qc5FLQ4WOO/Qjz6YH2jQJYkqvJKD4PUbfTZC/GR
    dZJ0bC6Z47IyHRpqMRh8XI6YI9D+HYiLgwnFKCLld8JHBylgMBR3tit+ajoQGYgUBbcK
    ZRmphbXFmdPm1ai6CNUcDx3zvJJY/4+XH7BgTdPieidbSfIG9njmEiaYweJ7QX5Jtz+V
    GUQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1622131879;
    s=strato-dkim-0002; d=strato.com;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=DaGsRIbTE+dpm/xL2jUOYDDmL1LWBM873TfFSQzlyAQ=;
    b=Gl9cE2GL4Agrz7BbmthTrttlmTRC6rgj4Ed/ZqML5cOeYz1HkOq6amogXceh1wmoku
    /IQGjcUGdt7Ym0JX9DLpf0kZfRwkM29pwTLALNGY5DLB2iE1dnHnU457enx17Dw4CpjE
    OSBQS9TpOMN2QqB5Uv7WF1ZQtV/wvK3FnxclnuCWhSQZvoxvWagQ4MioCIKEM6QqkHK1
    rpSMfPlttCUT5MbjFshK43pj5uh6iGec4bTgmgtRa0A5Kjc2udGTw8WXDD4Owre7Bare
    aFEmE5w7llyT4Ptu4/NdZlWCRUJzHejD8rXagahDOeZGGnWln+v76hV9at/NBp4qy29A
    Cy+g==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1622131879;
    s=strato-dkim-0002; d=chronox.de;
    h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Cc:Date:
    From:Subject:Sender;
    bh=DaGsRIbTE+dpm/xL2jUOYDDmL1LWBM873TfFSQzlyAQ=;
    b=UTxleyIp1j06XoUdO7jJdHSwlVK5i21B6ldGLZiwNzsAGpFvmmgW5Kqvi+Gp38CGEK
    az45TAmdNg5AAS8xaC3wRXnSvR0WJkL8mTCru56Tcpf647KYh5ht5i6hmePMf+ZKN+6H
    H9mj+AVG7k+cufv0sF+2spJm7Bfg2lHAjU2yWqlpEqkgW7PebjCuicdDzl/09KCZZ8Yy
    w4ybe2ypUcsgONfE+0cxL7Agjv1dvdewFl7SVIyAgGaC1CpENcs3096AKN9s04amvTuo
    sqNkesgjP2VlzUjK15FG2/1w1DOVenaUookzKAB7Dd12R5rnmUSHacQ10YhV8CyfMjQu
    Y27Q==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXPbJvSfFeK2"
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
    by smtp.strato.de (RZmta 47.26.3 DYNA|AUTH)
    with ESMTPSA id R0123ax4RGBG0Td
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Thu, 27 May 2021 18:11:16 +0200 (CEST)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     Tso Ted <tytso@mit.edu>, linux-crypto@vger.kernel.org
Cc:     Willy Tarreau <w@1wt.eu>, Nicolai Stange <nstange@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Alexander E. Patrakov" <patrakov@gmail.com>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Vito Caputo <vcaputo@pengaru.com>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jan Kara <jack@suse.cz>, Ray Strode <rstrode@redhat.com>,
        William Jon McCann <mccann@jhu.edu>,
        zhangjs <zachary@baishancloud.com>,
        Andy Lutomirski <luto@kernel.org>,
        Florian Weimer <fweimer@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Peter Matthias <matthias.peter@bsi.bund.de>,
        Marcelo Henrique Cerri <marcelo.cerri@canonical.com>,
        Neil Horman <nhorman@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <julia.lawall@inria.fr>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andy Lavr <andy.lavr@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Petr Tesarik <ptesarik@suse.cz>,
        John Haxby <john.haxby@oracle.com>
Subject: Re: [PATCH v40 00/13] /dev/random - a new approach
Date:   Thu, 27 May 2021 18:07:24 +0200
Message-ID: <11281728.7PdXrjIb7g@positron.chronox.de>
In-Reply-To: <18450229.rjpLZT9oXI@positron.chronox.de>
References: <18450229.rjpLZT9oXI@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,

I prepared a small presentation providing a good overview of the LRNG if you 
do not want to go through the lengthy design document.

It is available at [1].

[1] http://www.chronox.de/lrng/doc/lrng_presentation_v40.pdf

Ciao
Stephan


