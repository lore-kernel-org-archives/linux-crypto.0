Return-Path: <SRS0=SVjD=ZH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DEAAFC432C3
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 18:47:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B49462072D
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 18:47:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EQLOVGqY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726323AbfKOSrq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Nov 2019 13:47:46 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:44951 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbfKOSrq (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Nov 2019 13:47:46 -0500
Received: by mail-pj1-f66.google.com with SMTP id w8so121682pjh.11
        for <linux-crypto@vger.kernel.org>; Fri, 15 Nov 2019 10:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=message-id:mime-version:content-transfer-encoding:in-reply-to
         :references:to:subject:from:user-agent:date;
        bh=iS/Fqu32CYRsyYqI3nNewHGyeeTZ7Vyn3l2lS2Wx+I4=;
        b=EQLOVGqYrkyo+x9eBqaR38FivLhZb82i4BXqpCkgEtQbc5eP5cdH3D9uM6kDxJ5NSS
         0faGbqmYkX5A7cAuuymXwjY/NdAY3n+5XO9WW1BVZUMC9xvtcxX01fFTCwhzHLJrvmY6
         Xgfx56P0+DbzPUA4veZCjkLneUfU7DTBumXTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:in-reply-to:references:to:subject:from
         :user-agent:date;
        bh=iS/Fqu32CYRsyYqI3nNewHGyeeTZ7Vyn3l2lS2Wx+I4=;
        b=ikF1PZQnTq5iqWjU+MK0N6cjJKbzOqCA75kds//Rp48ddbcE3LOrhhMs3zBNkleGac
         kXImQCf/+QLYIaFXS1hqJnappS1IA5JME+iG+SYQzftHD0SA67Eh8s7SlAIpEsjfVN3e
         tX4P7821ARo9IyEHXT4G3uZ92v6DvGhltvVp/56EHJ9qocQ9YlFvRP7EBTezRmf6n1fF
         vDAZPFbcTitMgVK0hU0tXxXS48h9bWEHMM+CAndEwkF3rd06Jen00kIfEvUXc/QOuX6r
         3uno9zHvO1++eUaAtEl/JLUYtyNu4CbT4TxMZNeZfmpyvBmic7JqXPtY4SCFZkHJStGo
         pR1w==
X-Gm-Message-State: APjAAAV97UyzquALCVbhqwFnXlUAHANMESEvwLSIeXwmtLdyUuzy29Gu
        RWi9EvjGVe4Zhpu2hgKIzEIZ6g==
X-Google-Smtp-Source: APXvYqzo8ZTaeQMvkZzw76l4dUblfI2O5tBibpRcgatRhGZq8Uo9e3xMTJCYC85y6OhrsNVmUd0svw==
X-Received: by 2002:a17:902:7e4c:: with SMTP id a12mr16275022pln.219.1573843665716;
        Fri, 15 Nov 2019 10:47:45 -0800 (PST)
Received: from chromium.org ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id x12sm11001564pfm.130.2019.11.15.10.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 10:47:45 -0800 (PST)
Message-ID: <5dcef2d1.1c69fb81.803c0.0872@mx.google.com>
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
Date:   Fri, 15 Nov 2019 10:47:44 -0800
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
>=20

There are two reports. Let's test this one too.

#syz test: https://github.com/google/kasan.git b1aa9d83

diff --git a/drivers/char/random.c b/drivers/char/random.c
index 5b799aa973a3..c487709499fc 100644
--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2440,8 +2440,8 @@ void add_hwgenerator_randomness(const char *buffer, s=
ize_t count,
 	 * We'll be woken up again once below random_write_wakeup_thresh,
 	 * or when the calling thread is about to terminate.
 	 */
-	wait_event_freezable(random_write_wait,
-			kthread_should_stop() ||
+	wait_event_interruptible(random_write_wait,
+			kthread_should_stop() || freezing(current) ||
 			ENTROPY_BITS(&input_pool) <=3D random_write_wakeup_bits);
 	mix_pool_bytes(poolp, buffer, count);
 	credit_entropy_bits(poolp, entropy);
