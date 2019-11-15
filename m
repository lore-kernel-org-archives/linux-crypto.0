Return-Path: <SRS0=SVjD=ZH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55171C432C3
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 18:20:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F3C52073A
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Nov 2019 18:20:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EaoAKkm4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfKOSTZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Nov 2019 13:19:25 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34500 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727001AbfKOSTY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Nov 2019 13:19:24 -0500
Received: by mail-pg1-f193.google.com with SMTP id z188so6390653pgb.1
        for <linux-crypto@vger.kernel.org>; Fri, 15 Nov 2019 10:19:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=message-id:mime-version:content-transfer-encoding:in-reply-to
         :references:to:subject:from:user-agent:date;
        bh=/nPbsdCJvwt5lKKSjGD3DLzTdGucI41FrjpblwIsypo=;
        b=EaoAKkm4BqcYz0t8roJcx9ZGH2ZwnA35uEWBR9b+b+UfNnEGGPfkn2GMxv+SW2BrwE
         kT/LksAzxIDphLmWMWfjlHn57yIe0BUhKtAumfwEy+E0QujKRxuLjqrx5sDVKcQEBB22
         lSgKZXpa6E+Cz/zv/IT9DVHmE/Ol4XZE15gGk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:in-reply-to:references:to:subject:from
         :user-agent:date;
        bh=/nPbsdCJvwt5lKKSjGD3DLzTdGucI41FrjpblwIsypo=;
        b=QvmJZl+47wUfnBnwiKYVTKWdAnJNgOHgbvKYrk5ye3dJo8hjsmSfUiUqTb+YK6pnFN
         WUcWCH88SETdDKPVrWEwqzneP12Xc2qNH41+SFuP+FNjOi52GDjzCqHnpYpEVeWtEEpG
         YxYKGrlF1KcNO7XEnoTSLZV4/fuLbz87Ymxv//njfUVpSQsqG3aD3wf6vbQO0qrLlpAG
         VCU0Zvw3MkEpQ6XsJhnV8yjV7a+d7rtKCB4tiaCPItsz9IKjey+FF7I+2UL6qYC9oR4/
         X5VtAy8UpuD3W0CcEcs9CB4iruxUiFqdTtQiMKUuy+UodHHFq3EqZuLFVegUjX3htUL5
         SnJA==
X-Gm-Message-State: APjAAAVDpB1nnBqzsg7eSMR+LQOwEfV/MB3ZcU7fuiIIwlyw4POOsjf0
        23LnOixsgWvtWrU+mZxegsfErA==
X-Google-Smtp-Source: APXvYqw4aSsYPurq2VMWDwYSwROjnsjmTt0F1DX8PauKVTqLhoSLVwwxc6wZfCS/R0GLPZtK1TVkQA==
X-Received: by 2002:a62:ea0b:: with SMTP id t11mr19675909pfh.182.1573841961943;
        Fri, 15 Nov 2019 10:19:21 -0800 (PST)
Received: from chromium.org ([2620:15c:202:1:fa53:7765:582b:82b9])
        by smtp.gmail.com with ESMTPSA id k13sm10639792pgl.69.2019.11.15.10.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2019 10:19:21 -0800 (PST)
Message-ID: <5dceec29.1c69fb81.4c2d0.e24d@mx.google.com>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <0000000000006062280596203360@google.com>
References: <0000000000006062280596203360@google.com>
To:     alexandre.belloni@bootlin.com, andreyknvl@google.com,
        arnd@arndb.de, gregkh@linuxfoundation.org,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        lvivier@redhat.com, mchehab+samsung@kernel.org, mpm@selenic.com,
        syzbot <syzbot+6d8505fcdf25f00ac276@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com, tytso@mit.edu
Subject: Re: KASAN: use-after-free Read in chaoskey_disconnect
From:   Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.8.1
Date:   Fri, 15 Nov 2019 10:19:20 -0800
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Quoting syzbot (2019-10-30 05:52:08)
> Hello,
>=20
> syzbot found the following crash on:
>=20
> HEAD commit:    ff6409a6 usb-fuzzer: main usb gadget fuzzer driver
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D15e1ba24e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3D3230c37d44289=
5b7
> dashboard link: https://syzkaller.appspot.com/bug?extid=3D6d8505fcdf25f00=
ac276
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D169b8904e00=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D166f3104e00000
>=20
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+6d8505fcdf25f00ac276@syzkaller.appspotmail.com
>=20

Ok, let's try that again

#syz test: https://github.com/google/kasan.git ff6409a6

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
