From: Oliver Mangold <o.mangold@gmail.com>
Subject: Poor RNG performance on Ryzen
Date: Fri, 21 Jul 2017 09:12:01 +0200
Message-ID: <1218e9b7-4eeb-d8a0-02b2-8ddd672ec454@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:35114 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751880AbdGUHME (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 03:12:04 -0400
Received: by mail-wr0-f181.google.com with SMTP id k71so25278691wrc.2
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jul 2017 00:12:04 -0700 (PDT)
Received: from [192.168.50.103] (HSI-KBW-5-158-160-18.hsi19.kabel-badenwuerttemberg.de. [5.158.160.18])
        by smtp.gmail.com with ESMTPSA id y191sm409746wmy.28.2017.07.21.00.12.02
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jul 2017 00:12:02 -0700 (PDT)
Content-Language: de-DE
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

I was wondering why reading from /dev/urandom is much slower on Ryzen 
than on Intel, and did some analysis. It turns out that the RDRAND 
instruction is at fault, which takes much longer on AMD.

if I read this correctly:

--- drivers/char/random.c ---
     862         spin_lock_irqsave(&crng->lock, flags);
     863         if (arch_get_random_long(&v))
     864                 crng->state[14] ^= v;
     865         chacha20_block(&crng->state[0], out);

one call to RDRAND (with 64-bit operand) is issued per computation of a 
chacha20 block. According to the measurements I did, it seems on Ryzen 
this dominates the time usage:

On Broadwell E5-2650 v4:

---
# dd if=/dev/urandom of=/dev/null bs=1M status=progress
28827451392 bytes (29 GB) copied, 143.290349 s, 201 MB/s
# perf top
   49.88%  [kernel]            [k] chacha20_block
   31.22%  [kernel]            [k] _extract_crng
---

On Ryzen 1800X:

---
# dd if=/dev/urandom of=/dev/null bs=1M status=progress
3169845248 bytes (3,2 GB, 3,0 GiB) copied, 42,0106 s, 75,5 MB/s
# perf top
   76,40%  [kernel]                       [k] _extract_crng
   13,05%  [kernel]                       [k] chacha20_block
---

An easy improvement might be to replace the usage of 
arch_get_random_long() by arch_get_random_int(), as the state array 
contains just 32-bit elements, and (contrary to Intel) on Ryzen 32-bit 
RDRAND is supposed to be faster by roughly a factor of 2.

Best regards,

OM
