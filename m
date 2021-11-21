Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E310C433EF
	for <linux-crypto@archiver.kernel.org>; Sun, 21 Nov 2021 22:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbhKUWvE (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 21 Nov 2021 17:51:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231975AbhKUWvB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 21 Nov 2021 17:51:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 52E2760F51;
        Sun, 21 Nov 2021 22:47:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GbMot8tS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1637534855;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=49KbcxfJNV1n2RVKWCTE0quBozAdXkzBFMwyBg1S/h4=;
        b=GbMot8tS1/NzLBe/1J2Znlh4M24QodTJPJAPlISv7VIWiYUfAeUfueVuDqmtoBCwJSmQrE
        9fwN8LfrtPtO+IK3E74PJMyfj76HM9NHDb4hpdGrqQtK5F0zGk6rw598gmC0SKBJNjr9yK
        25OSHk8ley2HzHd9If00dnOBE9cYRHI=
Received: by mail.zx2c4.com (OpenSMTPD) with ESMTPSA id f956d940 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sun, 21 Nov 2021 22:47:35 +0000 (UTC)
Received: by mail-yb1-xb2b.google.com with SMTP id v7so45059052ybq.0;
        Sun, 21 Nov 2021 14:47:35 -0800 (PST)
X-Gm-Message-State: AOAM5313tSlXau9NcXM9p8iVzLgh6nW0mL0//sW1IERbbYyWa9/pzagB
        KotG0Ph+ahe0KBwNwXPRjECpwcRy7OGRm1YkXJ4=
X-Google-Smtp-Source: ABdhPJyEkNWUKO62KpzDGR/PTn5oAIPQpcQVOMJVxDDxppJOrJiVeFLFrRWTvw9jqnE9AatgYl9O47/Gy0oH4Ho7KkI=
X-Received: by 2002:a25:ba0f:: with SMTP id t15mr62225836ybg.62.1637534554276;
 Sun, 21 Nov 2021 14:42:34 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:a243:b0:111:6be9:cf8a with HTTP; Sun, 21 Nov 2021
 14:42:33 -0800 (PST)
In-Reply-To: <4641592.OV4Wx5bFTl@positron.chronox.de>
References: <2036923.9o76ZdvQCi@positron.chronox.de> <4641592.OV4Wx5bFTl@positron.chronox.de>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Sun, 21 Nov 2021 23:42:33 +0100
X-Gmail-Original-Message-ID: <CAHmME9oaS4TOpk7rQ73BRKeVLjMUNyt6EFyeOX=hZSkFBPDu0g@mail.gmail.com>
Message-ID: <CAHmME9oaS4TOpk7rQ73BRKeVLjMUNyt6EFyeOX=hZSkFBPDu0g@mail.gmail.com>
Subject: Re: [PATCH v43 01/15] Linux Random Number Generator
To:     =?UTF-8?Q?Stephan_M=C3=BCller?= <smueller@chronox.de>
Cc:     Tso Ted <tytso@mit.edu>, linux-crypto@vger.kernel.org,
        Willy Tarreau <w@1wt.eu>, Nicolai Stange <nstange@suse.de>,
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
        Petr Tesarik <ptesarik@suse.cz>,
        John Haxby <john.haxby@oracle.com>,
        Alexander Lobakin <alobakin@mailbox.org>,
        Jirka Hladky <jhladky@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Stephan,

You've posted it again, and yet I still believe this is not the
correct design or direction. I do not think the explicit goal of
extended configurability ("flexibility") or the explicit goal of being
FIPS compatible represent good directions, and I think this introduces
new problems rather than solving any existing ones. While there are
ways the current RNG could or even should be improved -- or rewritten
-- this approach is still not that, no matter how many times you post
it. It is almost as though you hope this somehow gets accepted through
a general apathy that might develop by the 1000th revision, when
cranks like me and others no longer have the motivation to keep
responding with the same thing. But here we are again.

My own experience pushing something that didn't have substantial
enough buy-in from existing maintainers (the Zinc crypto library)
ultimately led me to stop pushing in order to not alienate folks, step
back, and listen a bit. Eventually somebody reached out to work with
me (Ard) and we submitted a good compromise collaboration that we all
generally felt better about. In this case, your cryptographic design
tastes are sufficiently divergent from mine that I'm not sure how far
such a thing would go, but it also seems to me that continually
pushing the same thing over and over isn't winning you any points here
either. Submission by attrition is not an outcome anybody should want.

Sorry to be so blunt. It's just that my, "I don't like this" is the
same as it was the last time, and I'm not aware of anything
significant in that area changing this time.

Jason
