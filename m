From: Jeffrey Walton <noloader@gmail.com>
Subject: Data type for aio_buf under X32?
Date: Thu, 11 Aug 2016 13:55:28 -0400
Message-ID: <CAH8yC8miUYx-zZH=UqLz-rdhXVJssRakTL1u+_tDMdzm62_xKA@mail.gmail.com>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f195.google.com ([209.85.223.195]:36122 "EHLO
	mail-io0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301AbcHKRz3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2016 13:55:29 -0400
Received: by mail-io0-f195.google.com with SMTP id y34so194050ioi.3
        for <linux-crypto@vger.kernel.org>; Thu, 11 Aug 2016 10:55:29 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Everyone,

My apologies for this question and my confusion.

When interfacing with the kernel crypto through AF_ALG, what is the
type of 'aio_buf' under X32?

I know is X32 uses ILP32 data model, so integers/longs/pointers are
32-bits (cf., http://www.unix.org/version2/whatsnew/lp64_wp.html). I
believe Glibc uses a 'void*' for 'aio_buf' (cf.,
http://man7.org/linux/man-pages/man7/aio.7.html). But I believe the
kernel's 'aio_buf' is a u64 under X32.

I'm asking due a failure under X32 because GCC sign extends the
pointer value when upsizing to 64-bits (cf., GCC manual 4.7 Arrays and
Pointers, http://gcc.gnu.org/onlinedocs/gcc/Arrays-and-pointers-implementation.html).

Thanks in advance.

Jeff
