Return-Path: <SRS0=XS/1=OS=vger.kernel.org=linux-crypto-owner@kernel.org>
Received: from mslow2.mail.gandi.net ([217.70.178.242]:58512 "EHLO
        mslow2.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbeLIQEb (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Dec 2018 11:04:31 -0500
Received: from relay7-d.mail.gandi.net (unknown [217.70.183.200])
        by mslow2.mail.gandi.net (Postfix) with ESMTP id 0345D3A68E4
        for <linux-crypto@vger.kernel.org>; Sun,  9 Dec 2018 16:57:20 +0100 (CET)
Received: from d.localdomain (unknown [185.107.83.75])
        (Authenticated sender: out@gert.gr)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id CEDDB20004
        for <linux-crypto@vger.kernel.org>; Sun,  9 Dec 2018 15:57:18 +0000 (UTC)
To: linux-crypto@vger.kernel.org
From: Gert Robben <t2@gert.gr>
Subject: PROBLEM: geode-aes not working with skcipher cbc
Message-ID: <1c3a4df0-23bd-193c-2b4a-b549c74321aa@gert.gr>
Date: Sun, 9 Dec 2018 16:57:18 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15; format=flowed
Content-Language: nl-NL
Content-Transfer-Encoding: 7bit
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,
I try to use geode-aes/CRYPTO_DEV_GEODE, but it gives errors in dmesg 
and openssl (see below), and doesn't function.

I found that the change "crypto: cbc - Convert to skcipher" gives the 
problem:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/crypto/cbc.c?id=79c65d179a40e145287e59b33dc782a7c4bf0986
When I use cbc from before this change, it works fine.
When I use cbc from right after, it doesn't.
(cbc from right after, and from Linux 4.20-rc5, makes no difference in 
dmesg, /proc/crypto, openssl).

System is a PC Engines ALIX 2C.2 with Geode LX800, Linux 4.20-rc5.

As it has been broken for a while, I assume there are not many users, 
but that might increase at the next Debian stable release.

Thank you,
Gert

--- dmesg-old
+++ dmesg-new
+Error allocating fallback algo cbc(aes)
+alg: skcipher: Failed to load transform for cbc-aes-geode: -2

--- proc-crypto-old
+++ proc-crypto-new
-name         : cbc(aes)
-driver       : cbc(geode-aes)
-module       : kernel
-priority     : 300
-refcnt       : 1
-selftest     : passed
-internal     : no
-type         : blkcipher
-blocksize    : 16
-min keysize  : 16
-max keysize  : 32
-ivsize       : 16
-geniv        : <default>
-
  name         : cbc(aes)
  driver       : cbc-aes-geode
  module       : kernel
  priority     : 400
  refcnt       : 1
-selftest     : passed
+selftest     : unknown

benchmark new cbc:
# openssl speed -evp aes-128-cbc -elapsed -engine afalg
engine "afalg" set.
You have chosen to measure elapsed time instead of user CPU time.
Doing aes-128-cbc for 3s on 16 size blocks: ALG_PERR: 
../engines/e_afalg.c(388): Failed to bind socket : Accessing a corrupted 
shared library
2187795 aes-128-cbc's in 3.01s
Doing aes-128-cbc for 3s on 64 size blocks: ALG_PERR: 
../engines/e_afalg.c(388): Failed to bind socket : Accessing a corrupted 
shared library
2145693 aes-128-cbc's in 3.00s
Doing aes-128-cbc for 3s on 256 size blocks: ALG_PERR: 
../engines/e_afalg.c(388): Failed to bind socket : Accessing a corrupted 
shared library
2143373 aes-128-cbc's in 3.00s
Doing aes-128-cbc for 3s on 1024 size blocks: ALG_PERR: 
../engines/e_afalg.c(388): Failed to bind socket : Accessing a corrupted 
shared library
2152109 aes-128-cbc's in 3.01s
Doing aes-128-cbc for 3s on 8192 size blocks: ALG_PERR: 
../engines/e_afalg.c(388): Failed to bind socket : Accessing a corrupted 
shared library
2149864 aes-128-cbc's in 3.00s
Doing aes-128-cbc for 3s on 16384 size blocks: ALG_PERR: 
../engines/e_afalg.c(388): Failed to bind socket : Accessing a corrupted 
shared library
2154310 aes-128-cbc's in 3.00s
OpenSSL 1.1.1a  20 Nov 2018
built on: Thu Nov 22 18:40:54 2018 UTC
options:bn(64,32) rc4(4x,int) des(long) aes(partial) blowfish(ptr)
compiler: gcc -fPIC -pthread -Wa,--noexecstack -Wall -Wa,--noexecstack 
-g -O2 -fdebug-prefix-map=/build/openssl-5z4Qxa/openssl-1.1.1a=. 
-fstack-protector-strong -Wformat -Werror=format-security 
-DOPENSSL_USE_NODELETE -DL_ENDIAN -DOPENSSL_PIC -DOPENSSL_CPUID_OBJ 
-DOPENSSL_BN_ASM_PART_WORDS -DOPENSSL_IA32_SSE2 -DOPENSSL_BN_ASM_MONT 
-DOPENSSL_BN_ASM_GF2m -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM -DRC4_ASM 
-DMD5_ASM -DRMD160_ASM -DAES_ASM -DVPAES_ASM -DWHIRLPOOL_ASM -DGHASH_ASM 
-DECP_NISTZ256_ASM -DPADLOCK_ASM -DPOLY1305_ASM -DNDEBUG -Wdate-time 
-D_FORTIFY_SOURCE=2
The 'numbers' are in 1000s of bytes per second processed.
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 
bytes  16384 bytes
aes-128-cbc      11629.48k    45774.78k   182901.16k   732146.05k 
5870561.96k 11765405.01k
3080304384:error:80065067:lib(128):afalg_create_sk:socket bind 
failed:../engines/e_afalg.c:389:
3080304384:error:80065067:lib(128):afalg_create_sk:socket bind 
failed:../engines/e_afalg.c:389:
3080304384:error:80065067:lib(128):afalg_create_sk:socket bind 
failed:../engines/e_afalg.c:389:
3080304384:error:80065067:lib(128):afalg_create_sk:socket bind 
failed:../engines/e_afalg.c:389:
3080304384:error:80065067:lib(128):afalg_create_sk:socket bind 
failed:../engines/e_afalg.c:389:
3080304384:error:80065067:lib(128):afalg_create_sk:socket bind 
failed:../engines/e_afalg.c:389:

benchmark old cbc:
# openssl speed -evp aes-128-cbc -elapsed -engine afalg
engine "afalg" set.
You have chosen to measure elapsed time instead of user CPU time.
Doing aes-128-cbc for 3s on 16 size blocks: 29843 aes-128-cbc's in 3.00s
Doing aes-128-cbc for 3s on 64 size blocks: 29598 aes-128-cbc's in 3.00s
Doing aes-128-cbc for 3s on 256 size blocks: 28635 aes-128-cbc's in 3.00s
Doing aes-128-cbc for 3s on 1024 size blocks: 25262 aes-128-cbc's in 3.01s
Doing aes-128-cbc for 3s on 8192 size blocks: 11125 aes-128-cbc's in 3.00s
Doing aes-128-cbc for 3s on 16384 size blocks: 6524 aes-128-cbc's in 3.00s
OpenSSL 1.1.1a  20 Nov 2018
built on: Thu Nov 22 18:40:54 2018 UTC
options:bn(64,32) rc4(4x,int) des(long) aes(partial) blowfish(ptr)
compiler: gcc -fPIC -pthread -Wa,--noexecstack -Wall -Wa,--noexecstack 
-g -O2 -fdebug-prefix-map=/build/openssl-5z4Qxa/openssl-1.1.1a=. 
-fstack-protector-strong -Wformat -Werror=format-security 
-DOPENSSL_USE_NODELETE -DL_ENDIAN -DOPENSSL_PIC -DOPENSSL_CPUID_OBJ 
-DOPENSSL_BN_ASM_PART_WORDS -DOPENSSL_IA32_SSE2 -DOPENSSL_BN_ASM_MONT 
-DOPENSSL_BN_ASM_GF2m -DSHA1_ASM -DSHA256_ASM -DSHA512_ASM -DRC4_ASM 
-DMD5_ASM -DRMD160_ASM -DAES_ASM -DVPAES_ASM -DWHIRLPOOL_ASM -DGHASH_ASM 
-DECP_NISTZ256_ASM -DPADLOCK_ASM -DPOLY1305_ASM -DNDEBUG -Wdate-time 
-D_FORTIFY_SOURCE=2
The 'numbers' are in 1000s of bytes per second processed.
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 
bytes  16384 bytes
aes-128-cbc        159.16k      631.42k     2443.52k     8594.12k 
30378.67k    35629.74k

benchmark new cbc with aes-i586 instead of geode-aes (for reference):
# openssl speed -evp aes-128-cbc -elapsed -engine afalg
engine "afalg" set.
You have chosen to measure elapsed time instead of user CPU time.
Doing aes-128-cbc for 3s on 16 size blocks: 27674 aes-128-cbc's in 2.97s
Doing aes-128-cbc for 3s on 64 size blocks: 26473 aes-128-cbc's in 3.00s
Doing aes-128-cbc for 3s on 256 size blocks: 21845 aes-128-cbc's in 3.01s
Doing aes-128-cbc for 3s on 1024 size blocks: 12879 aes-128-cbc's in 3.00s
Doing aes-128-cbc for 3s on 8192 size blocks: 2621 aes-128-cbc's in 3.00s
Doing aes-128-cbc for 3s on 16384 size blocks: 1371 aes-128-cbc's in 3.00s
OpenSSL 1.1.1a  20 Nov 2018
built on: Thu Nov 22 18:40:54 2018 UTC
options:bn(64,32) rc4(4x,int) des(long) aes(partial) blowfish(ptr)
compiler: gcc -fPIC -pthread -Wa,--noexecstack -Wall -Wa,--noexecstack 
-g -O2 -fdebug-prefix-map=/build/openssl-5z4Qxa/openssl-1.1.1a=. 
-fstack-protector-strong -Wformat -Werror=format-security -DOPENSSL_USE_NOD
The 'numbers' are in 1000s of bytes per second processed.
type             16 bytes     64 bytes    256 bytes   1024 bytes   8192 
bytes  16384 bytes
aes-128-cbc        149.09k      564.76k     1857.91k     4396.03k 
7157.08k     7487.49k
