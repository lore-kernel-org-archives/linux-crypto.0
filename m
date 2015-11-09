From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: [RFC] i.MX6 CAAM blob generator for IMA/EVM initialization
Date: Mon,  9 Nov 2015 16:18:25 +0100
Message-ID: <1447082306-19946-1-git-send-email-s.trumtrar@pengutronix.de>
Cc: linux-ima-devel@lists.sourceforge.net,
	linux-ima-user@lists.sourceforge.net, keyrings@linux-nfs.org,
	David Howells <dhowells@redhat.com>, kernel@pengutronix.de,
	Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:43199 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbbKIPTC (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Nov 2015 10:19:02 -0500
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi!

The RFC Patch attached after this cover letter is mostly for illustration
purposes, so please don't waste too much time reviewing the code ;-)

For context I'll try to describe the problem that this patch tries to solve.

I need to be able to boot an EVM signed (and dongled) rootfs. The CAAM on
the i.MX6 has support for an OTP key and can en/decrypt data.
It also has a feature for generating red blobs: basically a chunk of data,
that is encrypted with the OTP key, which can be saved on some medium as a
secret to decrypt the EVM HMAC secret for one specific device.

To open the rootfs, the secret is handed from the bootloader to the kernel
as a base64 encoded string via the cmdline to an initramfs.
In the initramfs the sysfs file "modifier" is set to something starting with
"kernel:evm" and the base64 string is written to the sysfs file "blob".
The CAAM than decodes the red blob and, in case of "kernel:evm", initializes
the EVM or otherwise writes the result to "payload" if the modifier starts
with "user:". Therefore a blob that was generated for EVM never leaves the
kernel on decryption.
Generation of blobs goes like: echoing "modifier" to something and echoing
the payload to "payload". The red blob can than be read from "blob".


So, the sysfs interface is not the best option, I guess. The question is:
What is the right approach for a setup like this?
I need to:
  - be able to encrypt the secret and store it somewhere
  - to load the stored secret and decrypt it later
  - initialize IMA/EVM with the secret

Would something like
  - security/keys/encrypted-keys/encrypted.c
be the correct approach?

Thanks,
Steffen


Steffen Trumtrar (1):
  crypto: caam - add red blobifier

 drivers/crypto/caam/Kconfig    |   9 +
 drivers/crypto/caam/Makefile   |   1 +
 drivers/crypto/caam/blob_gen.c | 528 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 538 insertions(+)
 create mode 100644 drivers/crypto/caam/blob_gen.c

-- 
2.6.1
