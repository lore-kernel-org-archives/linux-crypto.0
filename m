From: <gregkh@linuxfoundation.org>
Subject: Patch "crypto: fix test vector for rsa" has been added to the 4.3-stable tree
Date: Sun, 14 Feb 2016 13:04:24 -0800
Message-ID: <14554838645539@kroah.com>
References: <56972AC4.4010501@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
To: tadeusz.struk@intel.com, dhowells@redhat.com,
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60123 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751398AbcBNVEZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 14 Feb 2016 16:04:25 -0500
In-Reply-To: <56972AC4.4010501@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


This is a note to let you know that I've just added the patch titled

    crypto: fix test vector for rsa

to the 4.3-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     crypto-fix-test-vector-for-rsa.patch
and it can be found in the queue-4.3 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From tadeusz.struk@intel.com  Sun Feb 14 12:56:09 2016
From: Tadeusz Struk <tadeusz.struk@intel.com>
Date: Wed, 13 Jan 2016 20:57:40 -0800
Subject: crypto: fix test vector for rsa
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, Herbert Xu <herbert@gondor.apana.org.au>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, Linux Kernel Developers List <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>
Message-ID: <56972AC4.4010501@intel.com>

From: Tadeusz Struk <tadeusz.struk@intel.com>

After the fix to the asn1_decoder in commit: 0d62e9dd
"ASN.1: Fix non-match detection failure on data overrun"
the rsa algorithm is failing to register in 4.3 stable kernels with
error: "alg: rsa: test failed on vector 4, err=-74"

This happens because the asn1 definition for the rsa key that has been
added in 4.2 defined all 3 components of the key as non-optional, as
the asn1_decoder before the fix was working fine for both the private
and public keys.

This patch adds the missing (fake) component to one key vector to allow
the algorithm to successfully register and be used with a valid private
keys later. This is only to make the asn1_decoder successfully parse the
key and the fake component is never used in the test as the vector is
marked as public key.

This patch applies only to 4.3 kernels as the 4.2 version of asn1_decoder
works fine with the asn1 definition.
4.4 is also ok because the akcipher interface has been changed, and
the set_key function has been split into set_public_key and set_priv_key
and there are two separate asn1 definitions for the two key formats
with all the required components correctly defined (commit 22287b0).

Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
---
---
 crypto/testmgr.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/crypto/testmgr.h
+++ b/crypto/testmgr.h
@@ -270,7 +270,7 @@ static struct akcipher_testvec rsa_tv_te
 	.c_size = 256,
 	}, {
 	.key =
-	"\x30\x82\x01\x09" /* sequence of 265 bytes */
+	"\x30\x82\x01\x0C" /* sequence of 268 bytes */
 	"\x02\x82\x01\x00" /* modulus - integer of 256 bytes */
 	"\xDB\x10\x1A\xC2\xA3\xF1\xDC\xFF\x13\x6B\xED\x44\xDF\xF0\x02\x6D"
 	"\x13\xC7\x88\xDA\x70\x6B\x54\xF1\xE8\x27\xDC\xC3\x0F\x99\x6A\xFA"
@@ -288,8 +288,9 @@ static struct akcipher_testvec rsa_tv_te
 	"\x55\xE6\x29\x69\xD1\xC2\xE8\xB9\x78\x59\xF6\x79\x10\xC6\x4E\xEB"
 	"\x6A\x5E\xB9\x9A\xC7\xC4\x5B\x63\xDA\xA3\x3F\x5E\x92\x7A\x81\x5E"
 	"\xD6\xB0\xE2\x62\x8F\x74\x26\xC2\x0C\xD3\x9A\x17\x47\xE6\x8E\xAB"
-	"\x02\x03\x01\x00\x01", /* public key - integer of 3 bytes */
-	.key_len = 269,
+	"\x02\x03\x01\x00\x01" /* public key - integer of 3 bytes */
+	"\x02\x01\x00", /* private key - integer of 1 byte */
+	.key_len = 272,
 	.m = "\x54\x85\x9b\x34\x2c\x49\xea\x2a",
 	.c =
 	"\xb2\x97\x76\xb4\xae\x3e\x38\x3c\x7e\x64\x1f\xcc\xa2\x7f\xf6\xbe"


Patches currently in stable-queue which might be from tadeusz.struk@intel.com are

queue-4.3/crypto-fix-test-vector-for-rsa.patch
queue-4.3/crypto-qat-don-t-use-userspace-pointer.patch
