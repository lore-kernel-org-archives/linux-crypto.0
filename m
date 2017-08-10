From: Sandy Harris <sandyinchina@gmail.com>
Subject: Fwd: [Freedombox-discuss] Hardware Crypto
Date: Thu, 10 Aug 2017 10:12:20 -0400
Message-ID: <CACXcFm=CBZmSaiwt7RaGUtS1u-q5HUrACKrvj=7Y201R6Fzmtw@mail.gmail.com>
References: <87pqldrq15.fsf@freedomboxfoundation.org> <CAMhXSQpkScTzZB4fZ0KGbTPKmtiwv_o7cz7MrWXc_rqrCfO3Pg@mail.gmail.com>
 <4E1FF66C.6010908@mray.de> <87wrfe1acu.fsf@freedomboxfoundation.org>
 <CA+FSnD1NO97U1zQQZV=VD+dbCGR0oQTgEYBmH6VupGUKo8uRFA@mail.gmail.com>
 <87r55m175w.fsf@freedomboxfoundation.org> <CAJVWO9aUCLb6k87do-ckOdkV-1U7d2SiG3gtBOVVXouog04Tpw@mail.gmail.com>
 <CAJVWO9YDKD72Sbb9_wWvxFVEppDg=4+XfBAY3uxvxcZ0b2t3yg@mail.gmail.com>
 <20110720063824.GA15748@havelock.liw.fi> <CAJVWO9bXs7_bx8-37O++n8kSJTuASC_benwmyeLgfiik8nGrmA@mail.gmail.com>
 <8762mx14co.fsf@freedomboxfoundation.org> <6556610b-9ddf-4bc2-b235-a2c91598a040@email.android.com>
 <201107220153.p6M1rVDn004794@new.toad.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f180.google.com ([209.85.128.180]:38388 "EHLO
        mail-wr0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751975AbdHJOMW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 10 Aug 2017 10:12:22 -0400
Received: by mail-wr0-f180.google.com with SMTP id f21so3454287wrf.5
        for <linux-crypto@vger.kernel.org>; Thu, 10 Aug 2017 07:12:21 -0700 (PDT)
In-Reply-To: <201107220153.p6M1rVDn004794@new.toad.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Cleaning up old email, ran across this post & it seemed to me it might
be relevant here:

---------- Forwarded message ----------
From: John Gilmore <gnu@toad.com>
Date: Thu, Jul 21, 2011 at 9:53 PM
Subject: Re: [Freedombox-discuss] Hardware Crypto
To: "erik.e.harmon@gmail.com" <erik.e.harmon@gmail.com>
Cc: freedombox list <freedombox-discuss@lists.alioth.debian.org>


> Can someone detail the steps required to get hardware crypto
> acceleration going on the Marvell platform so that its working in the
> kernel, openssl, etc? Kernel config, system setup, and so-on. A blog
> post would be excellent. Maybe it's just me, but it seems nonobvious.

It *is* nonobvious.

Which Marvell platform?

It looks like the Marvell Kirkwood 88F6281 chip in the DreamPlug does
include a crypto accelerator, that does AES, DES, 3DES, SHA-1 and MD5.
No random number generator, apparently.  See:

  http://www.marvell.com/processors/embedded/kirkwood/
  http://www.marvell.com/processors/embedded/kirkwood/assets/88F6281-004_ver1.pdf
  http://www.marvell.com/processors/embedded/kirkwood/assets/HW_88F6281_OpenSource.pdf
  http://www.marvell.com/processors/embedded/kirkwood/assets/FS_88F6180_9x_6281_OpenSource.pdf

Most hardware crypto accelerators are useless, because they were
designed by hardware guys who know nothing about software.  The
overhead required to use most of them is such that it's faster to do
almost all crypto in the CPU directly.  For example, the accelerator
in the OLPC XO-1's Geode LX processor required that you feed it with
DMA, but DMA uses physical rather than virtual addresses, so doing a
crypto operation requires a trip through the kernel.  By the time you
get in and out, lock down the page, copy the whole operand elsewhere
if it crosses a page boundary, set up the DMA, get it started, wait
for the answer, unlock the pages, and return, you might as well have
just computed the answer in userspace using ordinary instructions.

This Marvell chip has both a "Cryptographic Engine" and a "Security
Accelerator".  The Security Accelerator looks like the losing kind of
DMA device I just described, so it should probably just be ignored.
The Cryptographic Engine is managed by ordinary writes to registers in
the chip.  However, these can probably not be done by userspace code
or libraries.  No more than one process could have these registers
mapped into its address space, otherwise one process could read out
the keys loaded by another; the hardware lets keys be read out.  So
doing each encryption or decryption probably requires a kernel ioctl()
call, which adds significant overhead.

The Linux kernel has an internal kernel interface for hardware crypto,
which may already include support for this cryptographic engine.  Last
time I looked (in 2007), there was a proposed user-process interface
("/dev/crypto") that would match the interface on NetBSD and OpenBSD.
This would allow all the library and application level code to stay
the same on all three systems.  However, /dev/crypto hadn't been
accepted upstream in Linux.  That may have changed since I last
looked.  I do see a couple of recent Fedora Feature pages for this,
but it looks like they are motivated by a stupid idea (forcing crypto
users to push their keys into the kernel, even if it's slower, because
the US Government tells them to - probably so they can be most easily
wiretapped):

  http://fedoraproject.org/wiki/Features/DevCrypto
  http://fedoraproject.org/wiki/Features/CryptographyInKernel

It's unclear how or whether this work is progressing.

Even if a /dev/crypto interface existed and was faster for some kinds
of operations than just doing the crypto manually, the standard crypto
libraries would have to be portably tuned to detect when to use
hardware and when to use software.  The libraries generally use
hardware if it's available, since they were written with the
assumption that nobody would bother with hardware crypto if it was
slower than software.

"Just make it fast for all cases" is hard when the hardware is poorly
designed.  When the hardware is well designed, it *is* faster for all
cases.  But that's uncommon.

Making this determination in realtime would be a substantial
enhancement to each crypto library.  Since it'd have to be written
portably (or the maintainers of the portable crypto libraries won't
take it back), it couldn't assume any particular timings of any
particular driver, either in hardware or software.  So it would have
to run some fraction of the calls (perhaps 1%) in more than one
driver, and time each one, and then make decisions on which driver to
use by default for the other 99% of the calls.  The resulting times
differ dramatically, based on many factors, block size being one of
the key ones in the case of the Geode.  So it would have to have
infrastructure to make different decisions based on different block
sizes of its input (not just based on different algorithms, for
example).

Another reason that a particular call to hardware might be slower than
software is if there is competition for the hardware (i.e. if other
processes are also using the hardware, and you have to wait in a
queue).  There might be competition for the CPU itself, or you might
have CPU cores lying around idle when the hardware crypto is busy.  Do
you measure CPU time or realtime, or both, of the hardware
implementation?  Ditto for the software implementation?  Both can be
affected by competing processes.  For example, in this page:

  http://www.docunext.com/wiki/My_Notes_on_Patching_2.6.22_with_OCF#The_Result

it says things like:

  /usr/local/ssl/bin/openssl speed -evp aes-128-cbc -engine cryptodev
  Doing aes-128-cbc for 3s on 16 size blocks: 344779 aes-128-cbc's in 0.24s

That 3s must be wall clock time, and 0.24s must be process CPU time.
The rest of the 3 seconds was probably time spent in the kernel and in
waiting for the DMA engine to do its work.  But library timing code won't
be able to tell that kind of timing mismatch from the delays caused by
sharing the processor, or the crypto processor, with another
CPU-intensive job.

One advantage of running some of the calls using both hardware and
software is that the library can check that the results match exactly,
and abort with a clear message.  That would likely have caught some bugs
that snuck through in earlier crypto libraries.

        John Gilmore


_______________________________________________
Freedombox-discuss mailing list
Freedombox-discuss@lists.alioth.debian.org
http://lists.alioth.debian.org/cgi-bin/mailman/listinfo/freedombox-discuss
