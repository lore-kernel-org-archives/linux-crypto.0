From: Sandy Harris <sandyinchina@gmail.com>
Subject: Re: Fostering linux community collaboration on hardware accelerators
Date: Wed, 11 Oct 2017 11:51:49 -0400
Message-ID: <CACXcFmk3RDaKo0uasnXBeQvgq8aaX88vExv+GOqMAdZTL7=iXQ@mail.gmail.com>
References: <20171009112425.00003966@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        John Gilmore <gnu@toad.com>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:48663 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751462AbdJKPvv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 11 Oct 2017 11:51:51 -0400
Received: by mail-wm0-f68.google.com with SMTP id i124so5950983wmf.3
        for <linux-crypto@vger.kernel.org>; Wed, 11 Oct 2017 08:51:50 -0700 (PDT)
In-Reply-To: <20171009112425.00003966@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I shortened the cc list radically. If the discussion continues, it may
be a good idea to add people back. I added John Gilmore since I cite
one of his posts below.

Jonathan Cameron <Jonathan.Cameron@huawei.com> wrote:

> On behalf of Huawei, I am looking into options to foster a wider community
> around the various ongoing projects related to Accelerator support within
> Linux.  The particular area of interest to Huawei is that of harnessing
> accelerators from userspace, but in a collaborative way with the kernel
> still able to make efficient use of them, where appropriate.
>
> We are keen to foster a wider community than one just focused on
> our own current technology.

Good stuff, but there are problems. e.g. see the thread starting
with my message here:
https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg27274.html

My perspective is that of a crypto guy working on general-purpose
CPUs, anything from 32-bit ARM up. There are certainly problems for
devices with massive loads like a high-end router or with more limited
CPUs that I will not even pretend to address.

For me, far & away the biggest issue is having a good source of random
numbers; more-or-less all crypto depends on that. The Linux random(4)
RNG gets close, but there are cases where it may not be well
initialized soon enough on some systems. If a system provides a
hardware RNG, I will certainly use it to feed random(4). I do not care
nearly as much about anything else that might be in a hardware crypto
accelerator.

Separate accelerator devices require management, separating accesses
by different kernel threads or by user processes if they are allowed
to play, keeping them from seeing each other's keys, perhaps saving &
restoring state sometimes. Things that can be built into the CPU --
RNG instruction or register, AES instructions, Intel's instruction for
128-bit finite field multiplication which accelerates AES-GCM,
probably some I have not heard of -- require less management and are
usable by  any process, assuming either compiler support or some
assembler code. As a software guy, I'd far rather the hardware
designers gave me those than anything that needs a driver.
