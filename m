Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E624C38A2A
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 11:49:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E092C2145D
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 11:49:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726636AbgEHLtm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 07:49:42 -0400
Received: from mail.thorsis.com ([92.198.35.195]:59647 "EHLO mail.thorsis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbgEHLtm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 07:49:42 -0400
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 May 2020 07:49:41 EDT
Received: from localhost (localhost [127.0.0.1])
        by mail.thorsis.com (Postfix) with ESMTP id CA36D2A4F
        for <linux-crypto@vger.kernel.org>; Fri,  8 May 2020 13:40:16 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at mail.thorsis.com
Received: from mail.thorsis.com ([127.0.0.1])
        by localhost (mail.thorsis.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id wqVJSZUIiQHo for <linux-crypto@vger.kernel.org>;
        Fri,  8 May 2020 13:40:12 +0200 (CEST)
Received: by mail.thorsis.com (Postfix, from userid 109)
        id A1BDD29B3; Fri,  8 May 2020 13:40:12 +0200 (CEST)
From:   Alexander Dahl <ada@thorsis.com>
To:     linux-crypto@vger.kernel.org
Cc:     Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: jitterentropy_rng on armv5 embedded target
Date:   Fri, 08 May 2020 13:40:08 +0200
Message-ID: <2567555.LKkejuagh6@ada>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hello,

after upgrading OpenSSL to 1.1.1g on an armv5 based embedded target I had a=
=20
deeper look into entropy generation for that device and stumbled over the i=
n=20
kernel 'jitterentropy_rng' module.

As far as I understood it's supposed to do the same as the well known=20
'haveged' or the userspace daemon 'jitterentropy-rngd' by Stephan M=FCller =
[1],=20
right? (Although those daemons would solve my problem, I currently try to=20
avoid them, because memory on my platform is very restricted and every=20
additional running userspace process costs at least around 1 MB.)

If so, then how is it supposed to be set up? I built it for 4.9.x LTS, but=
=20
after loading it with 'modprobe' I see nothing in the kernel log and there'=
s=20
no significant change in /proc/sys/kernel/random/entropy_avail (stays well=
=20
below 100 most of the time). Isn't that module supposed to gather entropy f=
rom=20
cpu timing jitter?

Puzzled
Alex

[1] https://www.chronox.de/jent.html


