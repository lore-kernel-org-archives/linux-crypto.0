Return-Path: <SRS0=iH/+=X4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=DATE_IN_PAST_12_24,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE27CC10F14
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Oct 2019 10:51:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1CBB20842
	for <linux-crypto@archiver.kernel.org>; Thu,  3 Oct 2019 10:51:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728234AbfJCKvL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 3 Oct 2019 06:51:11 -0400
Received: from lb2-smtp-cloud7.xs4all.net ([194.109.24.28]:39081 "EHLO
        lb2-smtp-cloud7.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728140AbfJCKvL (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 3 Oct 2019 06:51:11 -0400
Received: from yessica.powercraft.nl ([80.127.158.83])
        by smtp-cloud7.xs4all.net with ESMTP
        id FyhPin291jZ8vFyhQineSx; Thu, 03 Oct 2019 12:51:08 +0200
Received: from [192.168.24.203] (ebony.powercraft.nl [80.127.158.83])
        by yessica.powercraft.nl (Postfix) with ESMTPSA id 972C821E0D;
        Thu,  3 Oct 2019 12:51:05 +0200 (CEST)
Subject: Re: PROBLEM: geode-aes not working with skcipher cbc
To:     Gert Robben <t2@gert.gr>, linux-crypto@vger.kernel.org
References: <1c3a4df0-23bd-193c-2b4a-b549c74321aa@gert.gr>
From:   Jelle de Jong <jelledejong@powercraft.nl>
Message-ID: <b573de3f-7891-3017-35ea-9a8d5c219af4@powercraft.nl>
Date:   Wed, 2 Oct 2019 20:18:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1c3a4df0-23bd-193c-2b4a-b549c74321aa@gert.gr>
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4wfDm7ZJIAkGGrz5pjTADgf+tiPEjuA4zle2DUJYDzfAg5dCBAMWmQt6dkfl5u5dHgclkRyAagtTwxi4yKhDFHuHUiywvA0ZO7yUOYT10H/30LaAo9OKzz
 0gMH1rI5l+x34PnhhZmpRW9nckMcYRdufJJ6YrM0G9yb45j/ozeeiTcCeTOlKp0ZhjJb0GhvI/fQ35YqkbIyhxzHeYUCI5OJpnL8AF/hAq7+dAPakba+pr16
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Gert and others,

Would it be possible to fix the geode-aes module?

[Wed Oct  2 18:57:38 2019] Error allocating fallback algo cbc(aes)
[Wed Oct  2 18:57:38 2019] alg: skcipher: Failed to load transform for 
cbc-aes-geode: -2
[Wed Oct  2 18:57:38 2019] Geode LX AES 0000:00:01.2: GEODE AES engine 
enabled.

# uname -a
Linux firewall12 4.19.0-6-686 #1 SMP Debian 4.19.67-2+deb10u1 
(2019-09-20) i586 GNU/Linux

# cat /etc/debian_version
10.1

I know it it and old CPU, but I got more then 50 of them still in use 
and I can not use a newer kernel anymore, since the cpu load just goes 
to 100% without aes hw support.

Kind regards,

Jelle de Jong


On 12/9/18 4:57 PM, Gert Robben wrote:
> Hi,
> I try to use geode-aes/CRYPTO_DEV_GEODE, but it gives errors in dmesg 
> and openssl (see below), and doesn't function.
> 
> I found that the change "crypto: cbc - Convert to skcipher" gives the 
> problem:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/crypto/cbc.c?id=79c65d179a40e145287e59b33dc782a7c4bf0986 
> 
> When I use cbc from before this change, it works fine.
> When I use cbc from right after, it doesn't.
> (cbc from right after, and from Linux 4.20-rc5, makes no difference in 
> dmesg, /proc/crypto, openssl).
> 
> System is a PC Engines ALIX 2C.2 with Geode LX800, Linux 4.20-rc5.
> 
> As it has been broken for a while, I assume there are not many users, 
> but that might increase at the next Debian stable release.
> 
> Thank you,
> Gert
> 
> --- dmesg-old
> +++ dmesg-new
> +Error allocating fallback algo cbc(aes)
> +alg: skcipher: Failed to load transform for cbc-aes-geode: -2
> 
> --- proc-crypto-old
> +++ proc-crypto-new
> -name         : cbc(aes)
> -driver       : cbc(geode-aes)
> -module       : kernel
> -priority     : 300
> -refcnt       : 1
> -selftest     : passed
> -internal     : no
> -type         : blkcipher
> -blocksize    : 16
> -min keysize  : 16
> -max keysize  : 32
> -ivsize       : 16
> -geniv        : <default>
> -
>   name         : cbc(aes)
>   driver       : cbc-aes-geode
>   module       : kernel
>   priority     : 400
>   refcnt       : 1
> -selftest     : passed
> +selftest     : unknown
> 
> benchmark new cbc:
> # openssl speed -evp aes-128-cbc -elapsed -engine afalg
> engine "afalg" set.
> You have chosen to measure elapsed time instead of user CPU time.
> Doing aes-128-cbc for 3s on 16 size blocks: ALG_PERR: 
> ../engines/e_afalg.c(388): Failed to bind socket : Accessing a corrupted 
> shared library
> 2187795 aes-128-cbc's in 3.01s
> Doing aes-128-cbc for 3s on 64 size blocks: ALG_PERR: 
> ../engines/e_afalg.c(388): Failed to bind socket : Accessing a corrupted 
> shared library
> 2145693 aes-128-cbc's in 3.00s
> Doing aes-128-cbc for 3s on 256 size blocks: ALG_PERR: 
> ../engines/e_afalg.c(388): Failed to bind socket : Accessing a corrupted 
> shared library
> 2143373 aes-128-cbc's in 3.00s
> Doing aes-128-cbc for 3s on 1024 size blocks: ALG_PERR: 
> ../engines/e_afalg.c(388): Failed to bind socket : Accessing a corrupted 
> shared library
> 2152109 aes-128-cbc's in 3.01s
> Doing aes-128-cbc for 3s on 8192 size blocks: ALG_PERR: 
> ../engines/e_afalg.c(388): Failed to bind socket : Accessing a corrupted 
> shared library
> 2149864 aes-128-cbc's in 3.00s
> Doing aes-128-cbc for 3s on 16384 size blocks: ALG_PERR: 
> ../engines/e_afalg.c(388): Failed to bind socket : Accessing a corrupted 
> shared library
> 2154310 aes-128-cbc's in 3.00s
> OpenSSL 1.1.1a  20 Nov 2018
> built on: Thu Nov 22 18:40:54 2018 UTC
> options:bn(64,32) rc4(4x,int) des(long) aes(partial) blowfish(ptr)
> compiler: gcc -fPIC -pthread -Wa,--noexecstack -Wall -Wa,--noexecstack 
> -g -O2 -fdebug-prefix-map=/build/openssl-5z4Qxa/openssl-1.1.1a=. 
> -fstack-protector-strong -Wformat -Werror=format-security 
> -DOPENSSL_USE_NODELETE -DL_ENDIAN -DOPENSSL_PIC -DOPENSSL_CPUID_OBJ 
> -DOPENSSL_BN_ASM_PART_WORDS -DOPENSSL_IA32_SSE2 -DOPENSSL_BN_ASM_MONT 
> -DOPENSSL_BN_ASM_GF2m -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM -DRC4_ASM 
> -DMD5_ASM -DRMD160_ASM -DAES_ASM -DVPAES_ASM -DWHIRLPOOL_ASM -DGHASH_ASM 
> -DECP_NISTZ256_ASM -DPADLOCK_ASM -DPOLY1305_ASM -DNDEBUG -Wdate-time 
> -D_FORTIFY_SOURCE=2
> The 'numbers' are in 1000s of bytes per second processed.
> type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 
> bytes  16384 bytes
> aes-128-cbc      11629.48k    45774.78k   182901.16k   732146.05k 
> 5870561.96k 11765405.01k
> 3080304384:error:80065067:lib(128):afalg_create_sk:socket bind 
> failed:../engines/e_afalg.c:389:
> 3080304384:error:80065067:lib(128):afalg_create_sk:socket bind 
> failed:../engines/e_afalg.c:389:
> 3080304384:error:80065067:lib(128):afalg_create_sk:socket bind 
> failed:../engines/e_afalg.c:389:
> 3080304384:error:80065067:lib(128):afalg_create_sk:socket bind 
> failed:../engines/e_afalg.c:389:
> 3080304384:error:80065067:lib(128):afalg_create_sk:socket bind 
> failed:../engines/e_afalg.c:389:
> 3080304384:error:80065067:lib(128):afalg_create_sk:socket bind 
> failed:../engines/e_afalg.c:389:
> 
> benchmark old cbc:
> # openssl speed -evp aes-128-cbc -elapsed -engine afalg
> engine "afalg" set.
> You have chosen to measure elapsed time instead of user CPU time.
> Doing aes-128-cbc for 3s on 16 size blocks: 29843 aes-128-cbc's in 3.00s
> Doing aes-128-cbc for 3s on 64 size blocks: 29598 aes-128-cbc's in 3.00s
> Doing aes-128-cbc for 3s on 256 size blocks: 28635 aes-128-cbc's in 3.00s
> Doing aes-128-cbc for 3s on 1024 size blocks: 25262 aes-128-cbc's in 3.01s
> Doing aes-128-cbc for 3s on 8192 size blocks: 11125 aes-128-cbc's in 3.00s
> Doing aes-128-cbc for 3s on 16384 size blocks: 6524 aes-128-cbc's in 3.00s
> OpenSSL 1.1.1a  20 Nov 2018
> built on: Thu Nov 22 18:40:54 2018 UTC
> options:bn(64,32) rc4(4x,int) des(long) aes(partial) blowfish(ptr)
> compiler: gcc -fPIC -pthread -Wa,--noexecstack -Wall -Wa,--noexecstack 
> -g -O2 -fdebug-prefix-map=/build/openssl-5z4Qxa/openssl-1.1.1a=. 
> -fstack-protector-strong -Wformat -Werror=format-security 
> -DOPENSSL_USE_NODELETE -DL_ENDIAN -DOPENSSL_PIC -DOPENSSL_CPUID_OBJ 
> -DOPENSSL_BN_ASM_PART_WORDS -DOPENSSL_IA32_SSE2 -DOPENSSL_BN_ASM_MONT 
> -DOPENSSL_BN_ASM_GF2m -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM -DRC4_ASM 
> -DMD5_ASM -DRMD160_ASM -DAES_ASM -DVPAES_ASM -DWHIRLPOOL_ASM -DGHASH_ASM 
> -DECP_NISTZ256_ASM -DPADLOCK_ASM -DPOLY1305_ASM -DNDEBUG -Wdate-time 
> -D_FORTIFY_SOURCE=2
> The 'numbers' are in 1000s of bytes per second processed.
> type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 
> bytes  16384 bytes
> aes-128-cbc        159.16k      631.42k     2443.52k     8594.12k 
> 30378.67k    35629.74k
> 
> benchmark new cbc with aes-i586 instead of geode-aes (for reference):
> # openssl speed -evp aes-128-cbc -elapsed -engine afalg
> engine "afalg" set.
> You have chosen to measure elapsed time instead of user CPU time.
> Doing aes-128-cbc for 3s on 16 size blocks: 27674 aes-128-cbc's in 2.97s
> Doing aes-128-cbc for 3s on 64 size blocks: 26473 aes-128-cbc's in 3.00s
> Doing aes-128-cbc for 3s on 256 size blocks: 21845 aes-128-cbc's in 3.01s
> Doing aes-128-cbc for 3s on 1024 size blocks: 12879 aes-128-cbc's in 3.00s
> Doing aes-128-cbc for 3s on 8192 size blocks: 2621 aes-128-cbc's in 3.00s
> Doing aes-128-cbc for 3s on 16384 size blocks: 1371 aes-128-cbc's in 3.00s
> OpenSSL 1.1.1a  20 Nov 2018
> built on: Thu Nov 22 18:40:54 2018 UTC
> options:bn(64,32) rc4(4x,int) des(long) aes(partial) blowfish(ptr)
> compiler: gcc -fPIC -pthread -Wa,--noexecstack -Wall -Wa,--noexecstack 
> -g -O2 -fdebug-prefix-map=/build/openssl-5z4Qxa/openssl-1.1.1a=. 
> -fstack-protector-strong -Wformat -Werror=format-security -DOPENSSL_USE_NOD
> The 'numbers' are in 1000s of bytes per second processed.
> type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 
> bytes  16384 bytes
> aes-128-cbc        149.09k      564.76k     1857.91k     4396.03k 
> 7157.08k     7487.49k
> 
