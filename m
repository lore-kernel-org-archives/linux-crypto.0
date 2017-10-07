From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [ANNOUNCE] libkcapi v1.0.0 released
Date: Sat, 07 Oct 2017 21:23:12 +0200
Message-ID: <1581309.8npj5YphvV@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34734 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751251AbdJGTXQ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 7 Oct 2017 15:23:16 -0400
Received: from positron.chronox.de (50-255-10-49-static.hfc.comcastbusiness.net [50.255.10.49])
        by mail.eperm.de (Postfix) with ESMTPA id 16DC818160CA
        for <linux-crypto@vger.kernel.org>; Sat,  7 Oct 2017 21:23:14 +0200 (CEST)
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

The Linux kernel exports a network interface of type AF_ALG to allow user 
space to utilize the kernel crypto API. libkcapi uses this network interface 
and exports an easy to use API so that a developer does not need to consider 
the low-level network interface handling. 

The library does not implement any low level cipher algorithms. All consumer 
requests are sent to the kernel for processing. Results from the kernel crypto 
API are returned to the consumer via the library API.

The kernel interface and therefore this library can be used by unprivileged 
processes. By using the convenience API functions, one API call performs one 
complete cipher operation.

The library code archive also provides a drop-in replacement for the command 
line tools of sha*sum, fipscheck/fipshmac and sha512hmac. It also contains 
command line tools to use the hashing, symmetric ciphers and random number 
generation on the command line.

The source code and the documentation is available at [1].

[1] http://www.chronox.de/libkcapi.html

Changes 1.0.0
 * Fix: Small compile fixes for new checks of GCC 7
 * API Change: Rename all LOG_* enums to KCAPI_LOG_* to prevent namespace
   poisoning
 * Fix: soname and file name of library now compiles with
   conventions (thanks to Marcus Meissner)
 * Fix: kcapi-rng.c: unify FD/syscall read code and fix
   __NR_getrandom resolution
 * Enhancement: add kcapi-enc application to access symmetric encryption on
   command line
 * Fix: consolidate duplicate code in kcapi-hasher
 * Enhancement: add kcapi-dgst application to access hashes on command line
 * Enhancement: add kcapi-rng man page
 * Enhancement: add kcapi-rng --hex command line option
 * Fix: enable full symmetric AIO support
 * Fix: consolidate all test code into test/ and invoke all tests
   with test-invocation.sh
 * Fix: fix memleaks in error code paths as reported by clang
 * Fix: reduce memory footprint by rearranging data structures
 * Fix: kcapi-hasher is now fully FIPS 140-2 compliant as it now
   includes the integrity test for libkcapi.so
 * Enhancement: Add speed tests for MV-CESA accelerated ciphers and hash
   algorithms (thanks to Bastian Stender)
 * Test Enhancement: add kcapi-enc-test-large.c test testing edge conditions
   of AF_ALG
 * Test Enhancement: add virttest.sh - use of test system based on
   eudyptula-boot to test on linux-4.3.6, linux-4.4.86, linux-4.5, linux-4.7,
   linux-4.10, linux-4.12
 * Test Enhancement: add kcapi-fuzz-test.sh to support fuzzing the AF_ALG
   interfaces
 * Enhancement: add RPM SPEC file (tested with Fedora 26)
 * API Change: replace --disable-lib-asym with --enable-lib-asym as the
   algif_akcipher.c kernel interface is not likely to be added to the kernel
   anytime soon
 * API Enhancement: add KPP API which is not compiled by default, use
   --enable-lib-kpp (the algif_kpp.c kernel interface is not likely to be
   added to the Linux kernel any time soon)
 * Test Enhancement: Add KPP tests
 * Enhancement: Re-enable AIO support for symmetric and AEAD ciphers down to
   Linux kernels 4.1 and 4.7, respectively. This is due to integrating a
   fix against a kernel crash when using AIO.
 * Fix: simply KDF code base
 * API Enhancement: add message digest convenience functions kcapi_md_*sha*
 * API Enhancement: add cipher convenience functions kcapi_cipher_*_aes_*
 * API Enhancement: add rng convenience function kcapi_rng_get_bytes
 * API Change: remove kcapi_aead_getdata, use kcapi_aead_getdata_input and
   kcapi_aead_getdata_output instead
 * API Change: remove kcapi_aead_outbuflen, use kcapi_aead_outbuflen_enc and
   kcapi_aead_outbuflen_dec instead

Ciao
Stephan
