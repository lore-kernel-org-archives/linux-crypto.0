Return-Path: <SRS0=IkvS=ZM=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59102C432C0
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 10:55:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B76D22445
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Nov 2019 10:55:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbfKTKz4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Nov 2019 05:55:56 -0500
Received: from mx2.suse.de ([195.135.220.15]:34622 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727230AbfKTKz4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Nov 2019 05:55:56 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id E8F146A54D;
        Wed, 20 Nov 2019 10:55:53 +0000 (UTC)
Message-ID: <1574247349.14298.30.camel@suse.com>
Subject: Re: INFO: task hung in chaoskey_disconnect
From:   Oliver Neukum <oneukum@suse.com>
To:     Stephen Boyd <swboyd@chromium.org>, alexandre.belloni@bootlin.com,
        andreyknvl@google.com, arnd@arndb.de, b.zolnierkie@samsung.com,
        gregkh@linuxfoundation.org, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, lvivier@redhat.com,
        mchehab+samsung@kernel.org, mpm@selenic.com,
        syzbot <syzbot+f41c4f7c6d8b0b778780@syzkaller.appspotmail.com>,
        syzkaller-bugs@googlegroups.com
Date:   Wed, 20 Nov 2019 11:55:49 +0100
In-Reply-To: <5dcee59a.1c69fb81.188d.e4b9@mx.google.com>
References: <000000000000cdaa560596acbc4e@google.com>
         <5dcee59a.1c69fb81.188d.e4b9@mx.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Freitag, den 15.11.2019, 09:51 -0800 schrieb Stephen Boyd:
> Quoting syzbot (2019-11-06 04:32:09)
> > Hello,
> > 
> > syzbot found the following crash on:
> > 
> > HEAD commit:    b1aa9d83 usb: raw: add raw-gadget interface
> > git tree:       https://github.com/google/kasan.git usb-fuzzer
> > console output: https://syzkaller.appspot.com/x/log.txt?x=16ae2adce00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=79de80330003b5f7
> > dashboard link: https://syzkaller.appspot.com/bug?extid=f41c4f7c6d8b0b778780
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10248158e00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16afbf7ce00000
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+f41c4f7c6d8b0b778780@syzkaller.appspotmail.com
> 
> I suspect this is because of the kthread getting stuck problem reported
> by Maciej. Maybe try the commit that Herbert picked up.

Do you have a commit ID so we can test an exported patch?

	Regards
		Oliver

