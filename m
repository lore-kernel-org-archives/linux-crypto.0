From: Jan Glauber <jglauber@cavium.com>
Subject: Re: Poor RNG performance on Ryzen
Date: Fri, 21 Jul 2017 11:26:57 +0200
Message-ID: <20170721092656.GA18604@wintermute>
References: <1218e9b7-4eeb-d8a0-02b2-8ddd672ec454@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Oliver Mangold <o.mangold@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38386 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932091AbdGUJ1A (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 05:27:00 -0400
Received: by mail-wm0-f42.google.com with SMTP id w191so8865688wmw.1
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jul 2017 02:26:59 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1218e9b7-4eeb-d8a0-02b2-8ddd672ec454@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jul 21, 2017 at 09:12:01AM +0200, Oliver Mangold wrote:
> Hi,
> 
> I was wondering why reading from /dev/urandom is much slower on
> Ryzen than on Intel, and did some analysis. It turns out that the
> RDRAND instruction is at fault, which takes much longer on AMD.
> 
> if I read this correctly:
> 
> --- drivers/char/random.c ---
>     862         spin_lock_irqsave(&crng->lock, flags);
>     863         if (arch_get_random_long(&v))
>     864                 crng->state[14] ^= v;
>     865         chacha20_block(&crng->state[0], out);
> 
> one call to RDRAND (with 64-bit operand) is issued per computation
> of a chacha20 block. According to the measurements I did, it seems
> on Ryzen this dominates the time usage:
> 
> On Broadwell E5-2650 v4:
> 
> ---
> # dd if=/dev/urandom of=/dev/null bs=1M status=progress
> 28827451392 bytes (29 GB) copied, 143.290349 s, 201 MB/s
> # perf top
>   49.88%  [kernel]            [k] chacha20_block
>   31.22%  [kernel]            [k] _extract_crng
> ---
> 
> On Ryzen 1800X:
> 
> ---
> # dd if=/dev/urandom of=/dev/null bs=1M status=progress
> 3169845248 bytes (3,2 GB, 3,0 GiB) copied, 42,0106 s, 75,5 MB/s
> # perf top
>   76,40%  [kernel]                       [k] _extract_crng
>   13,05%  [kernel]                       [k] chacha20_block
> ---
> 
> An easy improvement might be to replace the usage of
> arch_get_random_long() by arch_get_random_int(), as the state array
> contains just 32-bit elements, and (contrary to Intel) on Ryzen
> 32-bit RDRAND is supposed to be faster by roughly a factor of 2.

Nice catch. How much does the performance improve on Ryzen when you
use arch_get_random_int()?

--Jan

> Best regards,
> 
> OM
