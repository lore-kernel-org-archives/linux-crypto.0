Return-Path: <SRS0=SVjD=ZH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B92DC43141
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 17:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48CE72077B
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 17:51:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EorYr20i"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbfKORv0 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Nov 2019 12:51:26 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34815 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726599AbfKORvZ (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Nov 2019 12:51:25 -0500
Received: by mail-pg1-f196.google.com with SMTP id z188so6357833pgb.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 Nov 2019 09:51:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=message-id:mime-version:content-transfer-encoding:in-reply-to
         :references:to:subject:from:user-agent:date;
        bh=dLhYkfUvuM3MR/JcrrR7Nokdc6ORsY2H2jUYzk/2iMw=;
        b=EorYr20iszXneZR3cFgWw+iMhIgDDQXoL2/uXYakczV+sXoukhMfHWMbzspvnCFdxg
         kAwA6q3qrOE3B5BWKlVn0ruxtti1+d5w6tOTNC+cIbDCekuAZbgvcjjKh4duLjDGWiip
         JtuFNGj/xEp7OOMwY3CiHkt/F0ypAKegBWMU0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:in-reply-to:references:to:subject:from
         :user-agent:date;
        bh=dLhYkfUvuM3MR/JcrrR7Nokdc6ORsY2H2jUYzk/2iMw=;
        b=CZ7AbRmk27L6z+JIABwR+IF81JUVtJ8KVBaTfpW4uA9qAgxDy2ZtSiirqyrRAK3H0f
         OAzhTbh77gR2tic/GFRpZm7u1sOn9TXuY8DGBk3NpBYA+UHOyRx6KJhyzUdHH5hrUE0y
         hd5ysbgEq0E2+Xp1ESmZ2t9+H7KYXWgLBZZbG8RhYLekBXsxhZ4/q1z92Eu1db+552vz
         PbFtq2yDwj93dMgvfcDa7xckJ+yM4Q/KRBdUEb2fnbyCMpdhwLmVV+09qojr4LUEOi1z
         GMZ5W8Qugqyz0oiU6T3x1+PvqCXpsvWCKN/2OWXArezk+IaH8Xg8ROjBh2W+/JQrBI5O
         COxA==
X-Gm-Message-State: APjAAAWjEyTUzLwtRLAYTdZ98nT0UA5Y7Si2CQnp11Av8CbeKsz03RUE
        CIdWBp88AYTGSqNHs+n685OIsg==
X-Google-Smtp-Source: APXvYqwcLOBA5BoQIkVOeY36QAMv4CCxUyLegLofHm0JXeFtgI1ujTzkBTIiWgzH4iVDJ99l3Wkk2g==
X-Received: by 2002:a63:1d0a:: with SMTP id d10mr2492394pgd.242.1573840282995;
        Fri, 15 Nov 2019 09:51:22 -0800 (PST)
Received: from chromium.org ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id v10sm10079543pgr.37.2019.11.15.09.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 09:51:22 -0800 (PST)
Message-ID: <5dcee59a.1c69fb81.188d.e4b9@mx.google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <000000000000cdaa560596acbc4e@google.com>
References: <000000000000cdaa560596acbc4e@google.com>
To:     alexandre.belloni@bootlin.com, andreyknvl@google.com,
        arnd@arndb.de, b.zolnierkie@samsung.com,
        gregkh@linuxfoundation.org, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, lvivier@redhat.com,
        mchehab+samsung@kernel.org, mpm@selenic.com,
        syzbot <syzbot+f41c4f7c6d8b0b778780@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com
Subject: Re: INFO: task hung in chaoskey_disconnect
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.8.1
Date:   Fri, 15 Nov 2019 09:51:21 -0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting syzbot (2019-11-06 04:32:09)
> Hello,
>=20
> syzbot found the following crash on:
>=20
> HEAD commit:    b1aa9d83 usb: raw: add raw-gadget interface
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D16ae2adce00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D79de80330003b=
5f7
> dashboard link: https://syzkaller.appspot.com/bug?extid=3Df41c4f7c6d8b0b7=
78780
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D10248158e00=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D16afbf7ce00000
>=20
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+f41c4f7c6d8b0b778780@syzkaller.appspotmail.com

I suspect this is because of the kthread getting stuck problem reported
by Maciej. Maybe try the commit that Herbert picked up.

#syz test: git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6=
.git linus

