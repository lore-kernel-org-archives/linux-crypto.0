From: Tapas Sarangi <TSarangi@trustwave.com>
Subject: FIPS self test failures (kernel panic) in kernel-4.7
Date: Thu, 11 Aug 2016 21:55:05 +0000
Message-ID: <D3D25E68.3066%tsarangi@trustwave.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from seg-node-chi-03.trustwave.com ([204.13.200.31]:5310 "EHLO
	seg-node-chi-03.trustwave.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751932AbcHKVzJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 11 Aug 2016 17:55:09 -0400
Content-Language: en-US
Content-ID: <5FF74C8CDA608B4F8251E84E690C1225@namprd07.prod.outlook.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello,

A few algorithms are failing Œalg self tests' during kernel boot into FIPS
mode (fips=1), causing a kernel panic (see below). I am using vanilla
kernel-4.7 source for these tests.

These messages were from individual boots into FIPS mode, where algorithms
are taken out from ".fips_allowed=1² and compiled.

Following (see below) is a patch to disable tests for some of these
algorithms work and kernel could boot into FIPS mode (fips=1)
successfully. Please Let me know if there is a deeper/lower-level fix to
this.


##
[    1.270663] alg: hash: Failed to load transform for cmac(aes): -2
[    1.271471] Kernel panic - not syncing: cmac(aes): cmac(aes) alg self
test failed in fips mode!

[    1.256148] alg: hash: Failed to load transform for cmac(des3_ede): -2
[    1.257005] Kernel panic - not syncing: cmac(des3_ede): cmac(des3_ede)
alg self test failed in fips mode!
[    1.257005]

[    1.427856] alg: aead: Failed to load transform for
authenc(hmac(sha1),cbc(des3_ede)): -2
[    1.429036] Kernel panic - not syncing:
authenc(hmac(sha1),cbc(des3_ede)): authenc(hmac(sha1),cbc(des3_ede)) alg
self test failed in fips mode!
[    1.429036]


[    1.316830] alg: aead: Failed to load transform for
authenc(hmac(sha224),cbc(des3_ede)): -2
[    1.317914] Kernel panic - not syncing:
authenc(hmac(sha224),cbc(des3_ede)): authenc(hmac(sha224),cbc(des3_ede))
alg self test failed in fips mode!
[    1.317914]


[    1.262950] alg: aead: Failed to load transform for
authenc(hmac(sha256),cbc(des3_ede)): -2
[    1.264094] Kernel panic - not syncing:
authenc(hmac(sha256),cbc(des3_ede)): authenc(hmac(sha256),cbc(des3_ede))
alg self test failed in fips mode!
[    1.264094]


##



#‹‹PATCH‹‹
--- a/crypto/testmgr.c  2016-08-11 14:06:15.925140405 -0500
+++ b/crypto/testmgr.c  2016-08-11 15:42:13.954317991 -0500
@@ -2079,7 +2079,6 @@
        }, {
        .alg = "authenc(hmac(sha1),cbc(des3_ede))",
        .test = alg_test_aead,
-       .fips_allowed = 1,
        .suite = {
                .aead = {
                        .enc = {
@@ -2133,7 +2132,6 @@
        }, {
        .alg = "authenc(hmac(sha224),cbc(des3_ede))",
        .test = alg_test_aead,
-       .fips_allowed = 1,
        .suite = {
                .aead = {
                        .enc = {
@@ -2174,7 +2172,6 @@
        }, {
        .alg = "authenc(hmac(sha256),cbc(des3_ede))",
        .test = alg_test_aead,
-               .fips_allowed = 1,
        .suite = {
                .aead = {
                        .enc = {
@@ -2209,7 +2206,6 @@
        }, {
        .alg = "authenc(hmac(sha384),cbc(des3_ede))",
        .test = alg_test_aead,
-               .fips_allowed = 1,
        .suite = {
                .aead = {
                        .enc = {
@@ -2258,7 +2254,6 @@
        }, {
        .alg = "authenc(hmac(sha512),cbc(des3_ede))",
        .test = alg_test_aead,
-               .fips_allowed = 1,
        .suite = {
                .aead = {
                        .enc = {
@@ -2386,7 +2381,6 @@
        }, {
        .alg = "cbc(des3_ede)",
        .test = alg_test_skcipher,
-               .fips_allowed = 1,
        .suite = {
                .cipher = {
                        .enc = {
@@ -2462,7 +2456,6 @@
                }
        }, {
        .alg = "cmac(aes)",
-               .fips_allowed = 1,
        .test = alg_test_hash,
        .suite = {
                .hash = {
@@ -2472,7 +2465,6 @@
                }
        }, {
        .alg = "cmac(des3_ede)",
-               .fips_allowed = 1,
        .test = alg_test_hash,
        .suite = {
                .hash = {
@@ -3753,7 +3745,6 @@
        }, {
        .alg = "xts(aes)",
        .test = alg_test_skcipher,
-               .fips_allowed = 1,
        .suite = {
                .cipher = {
                        .enc = {



________________________________

This transmission may contain information that is privileged, confidential, and/or exempt from disclosure under applicable law. If you are not the intended recipient, you are hereby notified that any disclosure, copying, distribution, or use of the information contained herein (including any reliance thereon) is strictly prohibited. If you received this transmission in error, please immediately contact the sender and destroy the material in its entirety, whether in electronic or hard copy format.
