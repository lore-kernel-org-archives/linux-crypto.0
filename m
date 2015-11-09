From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [Linux-ima-user] [RFC] i.MX6 CAAM blob generator for IMA/EVM
 initialization
Date: Mon, 09 Nov 2015 15:29:41 -0500
Message-ID: <1447100981.2728.23.camel@linux.vnet.ibm.com>
References: <1447082306-19946-1-git-send-email-s.trumtrar@pengutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, keyrings@linux-nfs.org,
	linux-ima-user@lists.sourceforge.net,
	David Howells <dhowells@redhat.com>, kernel@pengutronix.de,
	linux-ima-devel@lists.sourceforge.net,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:54594 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750851AbbKIU3y (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Nov 2015 15:29:54 -0500
Received: from /spool/local
	by e28smtp01.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <zohar@linux.vnet.ibm.com>;
	Tue, 10 Nov 2015 01:59:52 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
	by d28dlp02.in.ibm.com (Postfix) with ESMTP id 011AB394005B
	for <linux-crypto@vger.kernel.org>; Tue, 10 Nov 2015 01:59:48 +0530 (IST)
Received: from d28av01.in.ibm.com (d28av01.in.ibm.com [9.184.220.63])
	by d28relay04.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id tA9KTlNf3015106
	for <linux-crypto@vger.kernel.org>; Tue, 10 Nov 2015 01:59:47 +0530
Received: from d28av01.in.ibm.com (localhost [127.0.0.1])
	by d28av01.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id tA9KTkYs001195
	for <linux-crypto@vger.kernel.org>; Tue, 10 Nov 2015 01:59:47 +0530
In-Reply-To: <1447082306-19946-1-git-send-email-s.trumtrar@pengutronix.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 2015-11-09 at 16:18 +0100, Steffen Trumtrar wrote:
> Hi!
> 
> The RFC Patch attached after this cover letter is mostly for illustration
> purposes, so please don't waste too much time reviewing the code ;-)
> 
> For context I'll try to describe the problem that this patch tries to solve.
> 
> I need to be able to boot an EVM signed (and dongled) rootfs. The CAAM on
> the i.MX6 has support for an OTP key and can en/decrypt data.
> It also has a feature for generating red blobs: basically a chunk of data,
> that is encrypted with the OTP key, which can be saved on some medium as a
> secret to decrypt the EVM HMAC secret for one specific device.
> 
> To open the rootfs, the secret is handed from the bootloader to the kernel
> as a base64 encoded string via the cmdline to an initramfs.
> In the initramfs the sysfs file "modifier" is set to something starting with
> "kernel:evm" and the base64 string is written to the sysfs file "blob".
> The CAAM than decodes the red blob and, in case of "kernel:evm", initializes
> the EVM or otherwise writes the result to "payload" if the modifier starts
> with "user:". Therefore a blob that was generated for EVM never leaves the
> kernel on decryption.
> Generation of blobs goes like: echoing "modifier" to something and echoing
> the payload to "payload". The red blob can than be read from "blob".
> 
> 
> So, the sysfs interface is not the best option, I guess. The question is:
> What is the right approach for a setup like this?
> I need to:
>   - be able to encrypt the secret and store it somewhere
>   - to load the stored secret and decrypt it later
>   - initialize IMA/EVM with the secret
> 
> Would something like
>   - security/keys/encrypted-keys/encrypted.c
> be the correct approach?

Instead of using the CAAM for OTP encrypting/decrypting, can it be used
to load the EVM key directly?  Dmitry's patches, which will be
upstreamed in 4.5
https://git.kernel.org/cgit/linux/kernel/git/zohar/linux-integrity.git/log/?h=for-next-4.5?   adds support for a crypto device to directly load the EVM key.

FYI, the EVM key is an encrypted key, which encrypts/decrypts either a
trusted or user type key.

Mimi
