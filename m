From: Stephan Mueller <smueller@chronox.de>
Subject: [PATCH 0/3] AF_ALG interface for akcipher
Date: Wed, 22 Jul 2015 00:12:29 +0200
Message-ID: <3908391.JkjAozYBaW@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: tadeusz.struk@intel.com, linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:47985 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932408AbbGUWOg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jul 2015 18:14:36 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

The patchset provides the implementation of the AF_ALG userspace interface
for the asymmetric cipher API of the kernel crypto API.

Unlike any other crypto API, the akcipher API operates on linear buffers.
This implies that the AF_ALG interface also only operates with linear buffers
by allocating a kernel internal buffer of the size of the modulus as follows:

	* sendmsg: Copy in all user data until the kernel buffer is full or
	recvmsg is called. Multiple invocations of sendmsg are allowed to
	provide data until the buffer is full.

	* sendpage: The caller is allowed to only make one invocation to provide
	the input data. Any subsequent invocation fails until the recvmsg has
	been invoked to obtain the result.

Recvmsg copies out the calculation result to user space. It only copies out
the exact size of the calculated data set. recvmsg returns the size of the
data in the return code to user space. That value may be smaller than the
buffer size the caller was required to provide.

Note, setkey requires the key in BER format.

The sig ver operation may return EBADMSG which is returned by recvmsg without
sending the calcuated data to user space. This error message indicates a
signature verification failure.

Please note that the DocBook documentation extension for this interface will
come with a future patch set as the DocBook needs a general update (AEAD update,
akcipher addition).

The test code can be obtained from [1]. The test code uses the same vectors
as the testmgr.h file for testing the generic RSA implementation.

[1] http://www.chronox.de/libkcapi.html

Stephan Mueller (3):
  crypto: af_alg - add sig gen / verify API
  crypto: algif_akcipher user space interface
  crypto: algif_akcipher - enable compilation

 crypto/Kconfig              |   9 +
 crypto/Makefile             |   1 +
 crypto/algif_akcipher.c     | 480 ++++++++++++++++++++++++++++++++++++++++++++
 include/uapi/linux/if_alg.h |   2 +
 4 files changed, 492 insertions(+)
 create mode 100644 crypto/algif_akcipher.c

-- 
2.4.3
