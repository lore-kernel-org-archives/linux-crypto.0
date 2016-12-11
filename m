From: Stephan =?ISO-8859-1?Q?M=FCller?= <smueller@chronox.de>
Subject: [ANNOUNCE] libkcapi v0.13.0 released
Date: Sun, 11 Dec 2016 21:31:54 +0100
Message-ID: <5613658.GNh6GxY9RR@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:39238 "EHLO mail.eperm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752588AbcLKUcB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Dec 2016 15:32:01 -0500
Received: from positron.chronox.de (mail.eperm.de [89.247.134.16])
        by mail.eperm.de (Postfix) with ESMTPA id 7B398181607E
        for <linux-crypto@vger.kernel.org>; Sun, 11 Dec 2016 21:31:58 +0100 (CET)
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
processes.

The library code archive also provides a drop-in replacement for the command 
line tools of sha*sum, fipscheck/fipshmac and sha512hmac.

The source code and the documentation is available at [1].

[1] http://www.chronox.de/libkcapi.html

Changes v0.13.0:

 * change kcapi_aead_encrypt_aio, kcapi_aead_decrypt_aio,
   kcapi_cipher_encrypt_aio and kcapi_cipher_decrypt_aio to require the
   user to provide IOVECs for input and output buffers separately
 * addition of kcapi_aead_inbuflen_enc, kcapi_aead_inbuflen_dec,
   kcapi_aead_outbuflen_enc, kcapi_aead_outbuflen_dec, 
kcapi_aead_getdata_input,
   kcapi_aead_getdata_output to allow apps to be programmed without specific
   code handling for old and new AEAD AF_ALG interface (AAD and tag handling).
   See the documentation section "AEAD Memory Structure" for an explanation
   on how to use the API in a way to make the calling application agnostic
   of the kernel interface differences.
 * significant addition to library to handle old / new AEAD AF_ALG interface
   without the caller being aware of that
 * change AEAD tests such to use the new API calls to make code independent
   of AEAD interface changes
 * split up of the library implementation into individual files to allow
   a more clear code management and to allow even to selectively disable
   code to make the library smaller
 * various small fixes suggested by Zbigniew Jędrzejewski-Szmek
 * fix memleak in kcapi_*_destroy suggested by Zbigniew Jędrzejewski-Szmek
 * use hard-links for the kcapi-hasher apps
 * add bi-arch tests
 * add check that AIO interface is only initialized if the kernel supports
   AIO (library requires kernel 4.1.0 or larger for skcipher AIO and
   4.7.0 or larger for AEAD AIO support)
 * add transparent fallback in case the caller requests AIO operation but
   the AIO interface was not or could not be initialized -- the AIO API can be
   used on systems without AIO support as the library transparently falls back
   to the non-AIO operation (however, the library complains at the beginning
   about the use of the AIO API on unsupported systems).

Ciao
Stephan
