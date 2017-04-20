From: Eric Biggers <ebiggers3@gmail.com>
Subject: [PATCH 0/5] KEYS: fixes for new keyctl_dh_compute() KDF extension
Date: Wed, 19 Apr 2017 22:46:28 -0700
Message-ID: <20170420054633.14572-1-ebiggers3@gmail.com>
Cc: linux-crypto@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>,
        David Howells <dhowells@redhat.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        mathew.j.martineau@linux.intel.com,
        Eric Biggers <ebiggers@google.com>
To: keyrings@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33419 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763400AbdDTFsU (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 20 Apr 2017 01:48:20 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

This patch series fixes several bugs in the KDF extension to
keyctl_dh_compute() currently sitting in keys-next: a way userspace could
cause an infinite loop, two ways userspace could cause the use of
uninitialized memory, a misalignment, and missing __user annotations.

Eric Biggers (5):
  KEYS: DH: forbid using digest_null as the KDF hash
  KEYS: DH: don't feed uninitialized "otherinfo" into KDF
  KEYS: DH: don't feed uninitialized result memory into KDF
  KEYS: DH: ensure the KDF counter is properly aligned
  KEYS: DH: add __user annotations to keyctl_kdf_params

 include/uapi/linux/keyctl.h |  4 ++--
 security/keys/dh.c          | 50 ++++++++++++++++++++++-----------------------
 2 files changed, 26 insertions(+), 28 deletions(-)

-- 
2.12.2
