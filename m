Return-Path: <SRS0=f3/+=X6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD006C3E8AB
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 09:05:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8790120873
	for <linux-crypto@archiver.kernel.org>; Sat,  5 Oct 2019 09:05:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=vdorst.com header.i=@vdorst.com header.b="SLDbwDrK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726853AbfJEJFm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 5 Oct 2019 05:05:42 -0400
Received: from mx.0dd.nl ([5.2.79.48]:50088 "EHLO mx.0dd.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726654AbfJEJFm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 5 Oct 2019 05:05:42 -0400
Received: from mail.vdorst.com (mail.vdorst.com [IPv6:fd01::250])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.0dd.nl (Postfix) with ESMTPS id 7A59C5FBC5;
        Sat,  5 Oct 2019 11:05:38 +0200 (CEST)
Authentication-Results: mx.0dd.nl;
        dkim=pass (2048-bit key; secure) header.d=vdorst.com header.i=@vdorst.com header.b="SLDbwDrK";
        dkim-atps=neutral
Received: from www (www.vdorst.com [192.168.2.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.vdorst.com (Postfix) with ESMTPSA id 3504C395D1;
        Sat,  5 Oct 2019 11:05:38 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.vdorst.com 3504C395D1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vdorst.com;
        s=default; t=1570266338;
        bh=OlRLHenqNtuY7iNflaBDOnyUvmxRCxGwRrrCO+Zp/TU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SLDbwDrKN3lxjaVfmQfgfgLvHtQSPni0Uvi95Xrx2wLb8p5XxBb6oy8VIUlUCb3c0
         27LcGrEIxEC0zdtUNyOSuRczVrE1JQZbw0YLS8LIRfzMckeIe0mmUaJkTrNqnXNEzh
         6QPYbpL5wAM6cgV7Gyn7i1Hw2Tg8SwgG+1Vr3cPNB085MX7zGU2N+XR1s6hfytyyfz
         Ad3/ARdN10ZU5T+Fs0nZLP3y+ApJdcYvUNraO2rRF8gp4x8R5s14NAX0vVieUi8+d2
         XMhDh3x8VQRi3yjIk8pRvmRP7tp4hS2bwah+vtXmF01tqywgubc3byHelUSmRARYDN
         rSb7sRs+1jSTg==
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1]) by
 www.vdorst.com (Horde Framework) with HTTPS; Sat, 05 Oct 2019 09:05:38 +0000
Date:   Sat, 05 Oct 2019 09:05:38 +0000
Message-ID: <20191005090538.Horde.dzt7aQwgJ_6U7FWESkoYfm0@www.vdorst.com>
From:   =?utf-8?b?UmVuw6k=?= van Dorst <opensource@vdorst.com>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jason Donenfeld <jason@zx2c4.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Miller <davem@davemloft.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Samuel Neves <sneves@dei.uc.pt>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Eric Biggers <ebiggers@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Martin Willi <martin@strongswan.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v2 05/20] crypto: mips/chacha - import accelerated 32r2
 code from Zinc
References: <20191002141713.31189-1-ard.biesheuvel@linaro.org>
 <20191002141713.31189-6-ard.biesheuvel@linaro.org>
 <20191004134644.GE112631@zx2c4.com>
 <CAKv+Gu_X9DBgUiPqcyJ2hOQqi_FEBVpHOr9uG1ZAh-RWv6-z9Q@mail.gmail.com>
 <CAHmME9ojUTysb2kHKbSWaR+2Qat3qF1cNrVtphu3V+C+P_g8yQ@mail.gmail.com>
 <20191004151524.Horde.zXUzQP5eBQt7Ybx5I75Ig5X@www.vdorst.com>
 <CAKv+Gu-84O9wo3-w7bYxW41g3gjwGk5tBJX54TGN53MUPNpdvQ@mail.gmail.com>
In-Reply-To: <CAKv+Gu-84O9wo3-w7bYxW41g3gjwGk5tBJX54TGN53MUPNpdvQ@mail.gmail.com>
User-Agent: Horde Application Framework 5
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
MIME-Version: 1.0
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Ard and Jason,

Quoting Ard Biesheuvel <ard.biesheuvel@linaro.org>:

> On Fri, 4 Oct 2019 at 17:15, René van Dorst <opensource@vdorst.com> wrote:
>>
>> Hi Jason,
>>
>> Quoting "Jason A. Donenfeld" <Jason@zx2c4.com>:
>>
>> > On Fri, Oct 4, 2019 at 4:44 PM Ard Biesheuvel
>> > <ard.biesheuvel@linaro.org> wrote:
>> >> The round count is passed via the fifth function parameter, so it is
>> >> already on the stack. Reloading it for every block doesn't sound like
>> >> a huge deal to me.
>> >
>> > Please benchmark it to indicate that, if it really isn't a big deal. I
>> > recall finding that memory accesses on common mips32r2 commodity
>> > router hardware was extremely inefficient. The whole thing is designed
>> > to minimize memory accesses, which are the primary bottleneck on that
>> > platform.
>>
>> I also think it isn't a big deal, but I shall benchmark it this weekend.
>> If I am correct a memory write will first put in cache. So if you read
>> it again and it is in cache it is very fast. 1 or 2 clockcycles.
>> Also the value isn't used directly after it is read.
>> So cpu don't have to stall on this read.
>>
>
> Thanks René.
>
> Note that the round count is not being spilled. I [re]load it from the
> stack as a function parameter.
>
> So instead of
>
> li $at, 20
>
> I do
>
> lw $at, 16($sp)
>
>
> Thanks a lot for taking the time to double check this. I think it
> would be nice to be able to expose xchacha12 like we do on other
> architectures.

I dust off my old benchmark code and put it on top of latest WireGuard
source [0]. It benchmarks the chacha20poly1305_{de,en}crypt functions with
different data block sizes (x bytes).
It runs two tests, first one is see how many runs we get in 1 second  
results in
MB/Sec and other one measures the used cpu cycles per loop.

The test is preformed on a Mediatek MT7621A SoC running at 880MHz.

Baseline [1]:

root@OpenWrt:~# insmod wg-speed-baseline.ko
[ 2029.866393] wireguard: chacha20 self-tests: pass
[ 2029.894301] wireguard: poly1305 self-tests: pass
[ 2029.906428] wireguard: chacha20poly1305 self-tests: pass
[ 2030.121001] wireguard: chacha20poly1305_encrypt:    1 bytes,        
0.253 MB/sec,     1598 cycles
[ 2030.340786] wireguard: chacha20poly1305_encrypt:   16 bytes,        
4.178 MB/sec,     1554 cycles
[ 2030.561434] wireguard: chacha20poly1305_encrypt:   64 bytes,       
15.392 MB/sec,     1692 cycles
[ 2030.784635] wireguard: chacha20poly1305_encrypt:  128 bytes,       
22.106 MB/sec,     2381 cycles
[ 2031.081534] wireguard: chacha20poly1305_encrypt: 1420 bytes,       
35.480 MB/sec,    16751 cycles
[ 2031.371369] wireguard: chacha20poly1305_encrypt: 1440 bytes,       
36.117 MB/sec,    16712 cycles
[ 2031.589621] wireguard: chacha20poly1305_decrypt:    1 bytes,        
0.246 MB/sec,     1648 cycles
[ 2031.809392] wireguard: chacha20poly1305_decrypt:   16 bytes,        
4.064 MB/sec,     1598 cycles
[ 2032.030034] wireguard: chacha20poly1305_decrypt:   64 bytes,       
14.990 MB/sec,     1738 cycles
[ 2032.253245] wireguard: chacha20poly1305_decrypt:  128 bytes,       
21.679 MB/sec,     2428 cycles
[ 2032.540150] wireguard: chacha20poly1305_decrypt: 1420 bytes,       
35.480 MB/sec,    16793 cycles
[ 2032.829954] wireguard: chacha20poly1305_decrypt: 1440 bytes,       
35.979 MB/sec,    16756 cycles
[ 2032.850563] wireguard: blake2s self-tests: pass
[ 2033.073767] wireguard: curve25519 self-tests: pass
[ 2033.083600] wireguard: allowedips self-tests: pass
[ 2033.097982] wireguard: nonce counter self-tests: pass
[ 2033.535726] wireguard: ratelimiter self-tests: pass
[ 2033.545615] wireguard: WireGuard 0.0.20190913-4-g5cca99692496  
loaded. See www.wireguard.com for information.
[ 2033.565197] wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld  
<Jason@zx2c4.com>. All Rights Reserved.

Modified chacha20-mips.S [2]:

root@OpenWrt:~# rmmod wireguard.ko
root@OpenWrt:~# insmod wg-speed-nround-stack.ko
[ 2045.129910] wireguard: chacha20 self-tests: pass
[ 2045.157824] wireguard: poly1305 self-tests: pass
[ 2045.169962] wireguard: chacha20poly1305 self-tests: pass
[ 2045.381034] wireguard: chacha20poly1305_encrypt:    1 bytes,        
0.251 MB/sec,     1607 cycles
[ 2045.600801] wireguard: chacha20poly1305_encrypt:   16 bytes,        
4.174 MB/sec,     1555 cycles
[ 2045.821437] wireguard: chacha20poly1305_encrypt:   64 bytes,       
15.392 MB/sec,     1691 cycles
[ 2046.044650] wireguard: chacha20poly1305_encrypt:  128 bytes,       
22.082 MB/sec,     2379 cycles
[ 2046.341509] wireguard: chacha20poly1305_encrypt: 1420 bytes,       
35.615 MB/sec,    16739 cycles
[ 2046.631333] wireguard: chacha20poly1305_encrypt: 1440 bytes,       
36.117 MB/sec,    16705 cycles
[ 2046.849614] wireguard: chacha20poly1305_decrypt:    1 bytes,        
0.246 MB/sec,     1647 cycles
[ 2047.069403] wireguard: chacha20poly1305_decrypt:   16 bytes,        
4.056 MB/sec,     1600 cycles
[ 2047.290036] wireguard: chacha20poly1305_decrypt:   64 bytes,       
15.001 MB/sec,     1736 cycles
[ 2047.513253] wireguard: chacha20poly1305_decrypt:  128 bytes,       
21.666 MB/sec,     2429 cycles
[ 2047.800102] wireguard: chacha20poly1305_decrypt: 1420 bytes,       
35.480 MB/sec,    16785 cycles
[ 2048.089967] wireguard: chacha20poly1305_decrypt: 1440 bytes,       
35.979 MB/sec,    16759 cycles
[ 2048.110580] wireguard: blake2s self-tests: pass
[ 2048.333719] wireguard: curve25519 self-tests: pass
[ 2048.343547] wireguard: allowedips self-tests: pass
[ 2048.357926] wireguard: nonce counter self-tests: pass
[ 2048.785837] wireguard: ratelimiter self-tests: pass
[ 2048.795781] wireguard: WireGuard 0.0.20190913-5-gee7c7eec8deb  
loaded. See www.wireguard.com for information.
[ 2048.815389] wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld  
<Jason@zx2c4.com>. All Rights Reserved.


I don't see the extra store/load on the stack back in the results.
So I think that this test proves enough that the extra nround on the stack is
not a problem.

Ard, I shall take a look on your hchacha code later this weekend.

Greats,

René

[0]: https://github.com/vDorst/wireguard/commits/mips-bench
[1]:  
https://github.com/vDorst/wireguard/commit/5cca9969249632820cb96548813a65d1f297aa8c
[2]:  
https://github.com/vDorst/wireguard/commit/ee7c7eec8deb3d5d5dae2eec0be0aafca3fddbc2

>
> Note that for xchacha, I also added a hchacha_block() routine based on
> your code (with the round count as the third argument) [0]. Please let
> me know if you see anything wrong with that.
>
>
> +.globl hchacha_block
> +.ent hchacha_block
> +hchacha_block:
> + .frame $sp, STACK_SIZE, $ra
> +
> + addiu $sp, -STACK_SIZE
> +
> + /* Save s0-s7 */
> + sw $s0, 0($sp)
> + sw $s1, 4($sp)
> + sw $s2, 8($sp)
> + sw $s3, 12($sp)
> + sw $s4, 16($sp)
> + sw $s5, 20($sp)
> + sw $s6, 24($sp)
> + sw $s7, 28($sp)
> +
> + lw X0, 0(STATE)
> + lw X1, 4(STATE)
> + lw X2, 8(STATE)
> + lw X3, 12(STATE)
> + lw X4, 16(STATE)
> + lw X5, 20(STATE)
> + lw X6, 24(STATE)
> + lw X7, 28(STATE)
> + lw X8, 32(STATE)
> + lw X9, 36(STATE)
> + lw X10, 40(STATE)
> + lw X11, 44(STATE)
> + lw X12, 48(STATE)
> + lw X13, 52(STATE)
> + lw X14, 56(STATE)
> + lw X15, 60(STATE)
> +
> +.Loop_hchacha_xor_rounds:
> + addiu $a2, -2
> + AXR( 0, 1, 2, 3, 4, 5, 6, 7, 12,13,14,15, 16);
> + AXR( 8, 9,10,11, 12,13,14,15, 4, 5, 6, 7, 12);
> + AXR( 0, 1, 2, 3, 4, 5, 6, 7, 12,13,14,15, 8);
> + AXR( 8, 9,10,11, 12,13,14,15, 4, 5, 6, 7, 7);
> + AXR( 0, 1, 2, 3, 5, 6, 7, 4, 15,12,13,14, 16);
> + AXR(10,11, 8, 9, 15,12,13,14, 5, 6, 7, 4, 12);
> + AXR( 0, 1, 2, 3, 5, 6, 7, 4, 15,12,13,14, 8);
> + AXR(10,11, 8, 9, 15,12,13,14, 5, 6, 7, 4, 7);
> + bnez $a2, .Loop_hchacha_xor_rounds
> +
> + sw X0, 0(OUT)
> + sw X1, 4(OUT)
> + sw X2, 8(OUT)
> + sw X3, 12(OUT)
> + sw X12, 16(OUT)
> + sw X13, 20(OUT)
> + sw X14, 24(OUT)
> + sw X15, 28(OUT)
> +
> + /* Restore used registers */
> + lw $s0, 0($sp)
> + lw $s1, 4($sp)
> + lw $s2, 8($sp)
> + lw $s3, 12($sp)
> + lw $s4, 16($sp)
> + lw $s5, 20($sp)
> + lw $s6, 24($sp)
> + lw $s7, 28($sp)
> +
> + addiu $sp, STACK_SIZE
> + jr $ra
> +.end hchacha_block
> +.set at
>
>
> [0]  
> https://git.kernel.org/pub/scm/linux/kernel/git/ardb/linux.git/commit/?h=wireguard-crypto-library-api-v3&id=cc74a037f8152d52bd17feaf8d9142b61761484f



