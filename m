Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 734E9C433DB
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Feb 2021 17:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35DF164F22
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Feb 2021 17:41:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229999AbhBZRks convert rfc822-to-8bit (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Feb 2021 12:40:48 -0500
Received: from mail-io1-f70.google.com ([209.85.166.70]:34495 "EHLO
        mail-io1-f70.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbhBZRkq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Feb 2021 12:40:46 -0500
Received: by mail-io1-f70.google.com with SMTP id c3so7798572ioa.1
        for <linux-crypto@vger.kernel.org>; Fri, 26 Feb 2021 09:40:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to:content-transfer-encoding;
        bh=PQUkYOPypd5QA7wH0ZiOCBAtaTuHt1m0uYa+QbCHJ6U=;
        b=uepZrno6IeGktAcXhkv/T/cP9fjLmvSrIs4YOXVi12d1SbUU3bS4RwbolmONrGlHgr
         hSmhZS4ufpw828BxWD+kcl6YfzDdaqZlbEhbZKuhJN665NqkEuHtDbHGlhL2qUGNRNLP
         Xp9EaxEIqzlQ5CvbGvZ4OUvicdbGJsMK9nOXCl89STUA7rMEWfZrKjUs1Op+I36yfgQx
         ngi8JoCfuI6AgmA/ey/QJiE47urVnf4h8LyRiTAjW5XSrKqn2h71NUxeNa7s9YrgP5aL
         o6nqkXS8I2h+xSsZ57ZIUiJYHieQb+GM4NxMB63dHw7wbvsrC2hC3VeCOO4m3tD5mGR/
         ULqw==
X-Gm-Message-State: AOAM531JGocHBLP1ioKnS3quw620snZtEnoVopu2MNTxapTGBh6GE15w
        r+razT6yhKKIts1qg6FzxLMFW+PdBivDP0Hlt2TEqrWYWfpv
X-Google-Smtp-Source: ABdhPJwjcrDY3M3NySdVXsyY9Thnn/YytagkgN3LVwDBc1JZluRM0uR02sC/B0mrZ5cqBEHumS98eeNLfegZzpqZCSWbSUsV2Gd/
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:f06:: with SMTP id x6mr3067247ilj.287.1614361205201;
 Fri, 26 Feb 2021 09:40:05 -0800 (PST)
Date:   Fri, 26 Feb 2021 09:40:05 -0800
In-Reply-To: <000000000000b2d35705b7f31599@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000002ce0d905bc40c2df@google.com>
Subject: Re: INFO: task hung in virtio_cleanup
From:   syzbot <syzbot+1db88381b64aaa929ef6@syzkaller.appspotmail.com>
To:     andreyknvl@google.com, benjamin.tissoires@redhat.com,
        gregkh@linuxfoundation.org, hdanton@sina.com,
        herbert@gondor.apana.org.au, jikos@kernel.org, jkosina@suse.cz,
        linux-crypto@vger.kernel.org, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        mpm@selenic.com, mst@redhat.com, rafael@kernel.org,
        rikard.falkeborn@gmail.com, sammko@sammserver.com,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

syzbot has bisected this issue to:

commit 77a36a3ab4ff17fad23831192e3694a3c5a1750d
Author: Samuel Čavoj <sammko@sammserver.com>
Date:   Fri Mar 13 02:12:38 2020 +0000

    HID: Add driver fixing Glorious PC Gaming Race mouse report descriptor

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=129959ccd00000
start commit:   f40ddce8 Linux 5.11
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=119959ccd00000
console output: https://syzkaller.appspot.com/x/log.txt?x=169959ccd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e53d04227c52a0df
dashboard link: https://syzkaller.appspot.com/bug?extid=1db88381b64aaa929ef6
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12277728d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1135e198d00000

Reported-by: syzbot+1db88381b64aaa929ef6@syzkaller.appspotmail.com
Fixes: 77a36a3ab4ff ("HID: Add driver fixing Glorious PC Gaming Race mouse report descriptor")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
