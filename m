From: Oliver Mangold <o.mangold@gmail.com>
Subject: Re: Poor RNG performance on Ryzen
Date: Fri, 21 Jul 2017 13:39:13 +0200
Message-ID: <09c9be2b-8b4d-ee06-8071-4f748fdb5970@gmail.com>
References: <1218e9b7-4eeb-d8a0-02b2-8ddd672ec454@gmail.com>
 <20170721092656.GA18604@wintermute>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36355 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750861AbdGULjP (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 21 Jul 2017 07:39:15 -0400
Received: by mail-wr0-f196.google.com with SMTP id y67so11333809wrb.3
        for <linux-crypto@vger.kernel.org>; Fri, 21 Jul 2017 04:39:15 -0700 (PDT)
Received: from [192.168.50.103] (HSI-KBW-5-158-160-18.hsi19.kabel-badenwuerttemberg.de. [5.158.160.18])
        by smtp.gmail.com with ESMTPSA id c34sm9149389wra.80.2017.07.21.04.39.13
        for <linux-crypto@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jul 2017 04:39:13 -0700 (PDT)
In-Reply-To: <20170721092656.GA18604@wintermute>
Content-Language: de-DE
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 21.07.2017 11:26, Jan Glauber wrote:
>
> Nice catch. How much does the performance improve on Ryzen when you
> use arch_get_random_int()?

Okay, now I have some results for you:

On Ryzen 1800X (using arch_get_random_int()):

---
# dd if=/dev/urandom of=/dev/null bs=1M status=progress
8751415296 bytes (8,8 GB, 8,2 GiB) copied, 71,0079 s, 123 MB/s
# perf top
    57,37%  [kernel]                    [k] _extract_crng
    26,20%  [kernel]                    [k] chacha20_block
---

Better, but obviously there is still much room for improvement by 
reducing the number of calls to RDRAND.

On Ryzen 1800X (with nordrand kernel option):

---
# dd if=/dev/urandom of=/dev/null bs=1M status=progress
22643998720 bytes (23 GB, 21 GiB) copied, 67,0025 s, 338 MB/s
---

Here is the patch I used:

--- drivers/char/random.c.orig  2017-07-03 01:07:02.000000000 +0200
+++ drivers/char/random.c       2017-07-21 11:57:40.541677118 +0200
@@ -859,13 +859,14 @@
   static void _extract_crng(struct crng_state *crng,
                            __u8 out[CHACHA20_BLOCK_SIZE])
   {
-       unsigned long v, flags;
+       unsigned int v;
+       unsigned long flags;

          if (crng_init > 1 &&
              time_after(jiffies, crng->init_time + CRNG_RESEED_INTERVAL))
                  crng_reseed(crng, crng == &primary_crng ? &input_pool 
: NULL);
          spin_lock_irqsave(&crng->lock, flags);
-       if (arch_get_random_long(&v))
+       if (arch_get_random_int(&v))
                  crng->state[14] ^= v;
          chacha20_block(&crng->state[0], out);
          if (crng->state[12] == 0)
