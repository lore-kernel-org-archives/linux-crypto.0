From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 0/3] padata cpu awareness fixes
Date: Fri,  8 Sep 2017 20:57:08 +0200
Message-ID: <1504897031-27523-1-git-send-email-minipli@googlemail.com>
Cc: linux-crypto@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37304 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756210AbdIHS5U (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 Sep 2017 14:57:20 -0400
Received: by mail-wm0-f66.google.com with SMTP id f4so2291270wmh.4
        for <linux-crypto@vger.kernel.org>; Fri, 08 Sep 2017 11:57:20 -0700 (PDT)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Steffen, Herbert,

this series solves multiple issues of padata I ran into while trying to
make use of pcrypt for IPsec.

The first issue is that the reorder timer callback may run on a CPU that
isn't part of the parallel set, as it runs on the CPU where the timer
interrupt gets handled. As a result, padata_reorder() may run on a CPU
with uninitialized per-cpu parallel queues, so the __this_cpu_read() in
padata_get_next() refers to an uninitialized cpu_index. However, as
per-cpu memory gets memset(0) on allocation time, it'll read 0. If the
next CPU index we're waiting for is 0 too, the compare will succeed and
we'll return with -ENODATA, making padata_reorder() think there's
nothing to do, stop any pending timer and return immediately. This is
wrong as the pending timer might have been the one to trigger the needed
reordering, but, as it was canceled, will never happen -- if no other
parallel requests arrive afterwards.

That issue is addressed with the first two patches, ensuring we're not
using a bogus cpu_index value for the compare and thereby not wrongly
cancel a pending timer. The second patch then ensures the reorder timer
callback runs on the correct CPU or, at least, on a CPU from the
parallel set to generate forward progress.

The third patch addresses a similar issues for the serialization
callback. We implicitly require padata_do_serial() to be called on the
very same CPU padata_do_parallel() was called on to ensure the correct
ordering of requests -- and correct functioning of padata, even. If the
algorithm we're parallelizing is asynchronous itself, that invariant
might not be true, as, e.g. crypto hardware may execute the callback on
the CPU its interrupt gets handled on which isn't necessarily the one
the request got issued on.

To handle that issue we track the CPU we're supposed to handle the
request on and ensure we'll call padata_reorder() on that CPU when
padata_do_serial() gets called -- either by already running on the
corect CPU or by deferring the call to a worker. 

Please apply!

Mathias Krause (3):
  padata: set cpu_index of unused CPUs to -1
  padata: ensure the reorder timer callback runs on the correct CPU
  padata: ensure padata_do_serial() runs on the correct CPU

 include/linux/padata.h |    4 +++
 kernel/padata.c        |   71 ++++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 72 insertions(+), 3 deletions(-)

-- 
1.7.10.4
