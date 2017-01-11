From: Rob Rice <rob.rice@broadcom.com>
Subject: arm64 broken
Date: Wed, 11 Jan 2017 13:37:19 -0500
Message-ID: <0795D328-B031-4EFA-AA0B-603B66F9F035@broadcom.com>
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:34173 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752479AbdAKSh0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Jan 2017 13:37:26 -0500
Received: by mail-pg0-f42.google.com with SMTP id 14so38908947pgg.1
        for <linux-crypto@vger.kernel.org>; Wed, 11 Jan 2017 10:37:26 -0800 (PST)
Received: from dhcp-10-27-64-110.rtp.broadcom.com ([192.19.218.250])
        by smtp.gmail.com with ESMTPSA id c15sm15533471pfd.36.2017.01.11.10.37.24
        for <linux-crypto@vger.kernel.org>
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 11 Jan 2017 10:37:25 -0800 (PST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I=E2=80=99m working on updating a patchset. The master branch in =
crypto-2.6 doesn=E2=80=99t compile for ARM64. The first couple errors =
are listed below. A colleague believes that the following commit in rc2 =
fixes the problem.

commit b4b8664d291ac1998e0f0bcdc96b6397f0fe68b3
Author: Al Viro <viro@zeniv.linux.org.uk =
<mailto:viro@zeniv.linux.org.uk>>
Date:   Mon Dec 26 04:10:19 2016 -0500

    arm64: don't pull uaccess.h into *.S
   =20
    Split asm-only parts of arm64 uaccess.h into a new header and use =
that
    from *.S.
   =20
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk =
<mailto:viro@zeniv.linux.org.uk>>

Any chance we could either pull in the fix or move to rc2?

Thanks,

Rob
=20

  AS      arch/arm64/kernel/entry.o
In file included from ./include/linux/sched.h:17:0,
                 from ./include/linux/uaccess.h:4,
                 from arch/arm64/kernel/entry.S:34:
./include/linux/kernel.h:49:0: warning: "ALIGN" redefined
 #define ALIGN(x, a)  __ALIGN_KERNEL((x), (a))
 ^
In file included from arch/arm64/kernel/entry.S:22:0:
./include/linux/linkage.h:78:0: note: this is the location of the =
previous definition
 #define ALIGN __ALIGN
 ^
In file included from ./include/linux/time.h:7:0,
                 from ./include/uapi/linux/timex.h:56,
                 from ./include/linux/timex.h:56,
                 from ./include/linux/sched.h:19,
                 from ./include/linux/uaccess.h:4,
                 from arch/arm64/kernel/entry.S:34:
./include/linux/time64.h:36:0: warning: "NSEC_PER_SEC" redefined
 #define NSEC_PER_SEC 1000000000L=
