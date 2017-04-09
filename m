From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: Fwd: [linux-next:master 7274/8070] undefined reference to `crypto_alloc_shash'
Date: Sun, 09 Apr 2017 22:09:54 +0200
Message-ID: <1827882.yksAJm9a6v@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:58868 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752440AbdDIUKD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 9 Apr 2017 16:10:03 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

I got the attached error report. This is due to CRYPTO_HASH2 is selected as m 
whereas security/keys/dh.c is compiled as y. Note CRYPTO_HASH is selected as 
y.

dh.c requires shash.

Kconfig for dh.c contains:

config KEY_DH_OPERATIONS
       bool "Diffie-Hellman operations on retained keys"
       depends on KEYS
       select MPILIB
       select CRYPTO_HASH


Shall I select CRYPTO_HASH2 instead or in addition to CRYPTO_HASH?

Thanks.

Ciao
Stephan

----------  Weitergeleitete Nachricht  ----------

Betreff: [linux-next:master 7274/8070] undefined reference to 
`crypto_alloc_shash'
Datum: Donnerstag, 6. April 2017, 10:03:30 CEST
Von: kbuild test robot <fengguang.wu@intel.com>
An: Stephan Mueller <smueller@chronox.de>
Kopie: kbuild-all@01.org, David Howells <dhowells@redhat.com>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git 
master
head:   d203084e692ac2f656cf8c50449f8f90ca7875de
commit: f1c316a3ab9d24df6022682422fe897492f2c0c8 [7274/8070] KEYS: add 
SP800-56A KDF support for DH
config: x86_64-randconfig-s0-04061437 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        git checkout f1c316a3ab9d24df6022682422fe897492f2c0c8
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

   security/built-in.o: In function `__keyctl_dh_compute':
>> (.text+0xa4f7): undefined reference to `crypto_alloc_shash'
   security/built-in.o: In function `__keyctl_dh_compute':
>> (.text+0xa7b5): undefined reference to `crypto_shash_update'
   security/built-in.o: In function `__keyctl_dh_compute':
   (.text+0xa7ed): undefined reference to `crypto_shash_update'
   security/built-in.o: In function `__keyctl_dh_compute':
>> (.text+0xa832): undefined reference to `crypto_shash_final'
   security/built-in.o: In function `__keyctl_dh_compute':
   (.text+0xa881): undefined reference to `crypto_shash_final'
   security/built-in.o: In function `__keyctl_dh_compute':
>> (.text+0xa9bd): undefined reference to `crypto_destroy_tfm'

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

-------------------------------------------------------------
