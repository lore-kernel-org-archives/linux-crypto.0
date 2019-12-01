Return-Path: <SRS0=52Dc=ZX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02104C432C0
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 17:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BEC82073C
	for <linux-crypto@archiver.kernel.org>; Sun,  1 Dec 2019 17:58:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=chronox.de header.i=@chronox.de header.b="U88j2J0d"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbfLAR6m (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 1 Dec 2019 12:58:42 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.52]:9521 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726155AbfLAR6m (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 1 Dec 2019 12:58:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1575223117;
        s=strato-dkim-0002; d=chronox.de;
        h=References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=uuWwMAnIY+jWgt+AzE4WAcb/LRiPfvPqr7K1tcaJXxQ=;
        b=U88j2J0dwHaoN//WGjXIrc/lOjfYS3ivltNxCMaWt2J4sxEkl7Ana+YPMhmyqzSSbF
        jQvOXZIZMWpuWKQrA8DIcozOdAsB+TniGGvkInpgRL8OG9sGyUbiZNvJ0nI+h5/TLYAW
        MLNODPldSCg9ITsM9aZgVnl25gO4Pg8ku/jizdsRnsqisdK4QJ4N5nOHc0lA0MzwT0h8
        +e5Ik8wc/zHzEM4NtlHgHUS25Jeob7WylG65TsSK48/eDkqMPHv4cXu0WHZmUmGnxsBl
        XAkp8hTJfu0PD4T+xsYpSkq4/zPCzFfDXhVs4e3fHUIoepgQLa0I2o50tDLbblkg3kz/
        5Ouw==
X-RZG-AUTH: ":P2ERcEykfu11Y98lp/T7+hdri+uKZK8TKWEqNyiHySGSa9k9xmwdNnzGHXvcOe6ZPA=="
X-RZG-CLASS-ID: mo00
Received: from positron.chronox.de
        by smtp.strato.de (RZmta 45.0.2 DYNA|AUTH)
        with ESMTPSA id m074f2vB1HwIUg1
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Sun, 1 Dec 2019 18:58:18 +0100 (CET)
From:   Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
To:     syzbot 
        <syzbot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, dvyukov@google.com, ebiggers3@gmail.com,
        herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        peterz@infradead.org, steffen.klassert@secunet.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: INFO: task hung in aead_recvmsg
Date:   Sun, 01 Dec 2019 18:58:17 +0100
Message-ID: <2842590.QEqkPaeV8v@positron.chronox.de>
In-Reply-To: <00000000000065e61505989fd2c3@google.com>
References: <00000000000065e61505989fd2c3@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Am Sonntag, 1. Dezember 2019, 08:58:00 CET schrieb syzbot:

Hi,

> syzbot has bisected this bug to:
> 
> commit 0c1e16cd1ec41987cc6671a2bff46ac958c41eb5
> Author: Stephan Mueller <smueller@chronox.de>
> Date:   Mon Dec 5 14:26:19 2016 +0000
> 
>      crypto: algif_aead - fix AEAD tag memory handling
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12d6d0a6e00000
> start commit:   618d919c Merge tag 'libnvdimm-fixes-5.1-rc6' of git://git...
> git tree:       upstream
> final crash:    https://syzkaller.appspot.com/x/report.txt?x=11d6d0a6e00000
> console output: https://syzkaller.appspot.com/x/log.txt?x=16d6d0a6e00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=856fc6d0fbbeede9
> dashboard link:
> https://syzkaller.appspot.com/bug?extid=56c7151cad94eec37c521f0e47d2eee53f93
> 61c4 syz repro:     
> https://syzkaller.appspot.com/x/repro.syz?x=11ef592d200000 C reproducer:  
> https://syzkaller.appspot.com/x/repro.c?x=16b865fd200000
> 
> Reported-by:
> syzbot+56c7151cad94eec37c521f0e47d2eee53f9361c4@syzkaller.appspotmail.com
> Fixes: 0c1e16cd1ec4 ("crypto: algif_aead - fix AEAD tag memory handling")
> 
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection

This issue seems to be triggered when using pcrypt. Pcrypt received a number 
of fixes recently.

Did the test include all of those fixes?

Thanks a lot for the testing!

Ciao
Stephan


