From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
Subject: Re: [Linux-ima-user] [RFC] i.MX6 CAAM blob generator for IMA/EVM initialization
Date: Wed, 27 Jan 2016 11:04:42 +0100
Message-ID: <73d1snz6bp.fsf@unicorn.hi.pengutronix.de>
References: <1447082306-19946-1-git-send-email-s.trumtrar@pengutronix.de> <1447100981.2728.23.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: linux-crypto@vger.kernel.org, keyrings@linux-nfs.org,
	linux-ima-user@lists.sourceforge.net,
	David Howells <dhowells@redhat.com>, kernel@pengutronix.de,
	linux-ima-devel@lists.sourceforge.net,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from metis.ext.4.pengutronix.de ([92.198.50.35]:40517 "EHLO
	metis.ext.4.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932099AbcA0KE7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2016 05:04:59 -0500
In-reply-to: <1447100981.2728.23.camel@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


Hi!

Mimi Zohar writes:

> On Mon, 2015-11-09 at 16:18 +0100, Steffen Trumtrar wrote:
>> Hi!
>> 
>> The RFC Patch attached after this cover letter is mostly for illustration
>> purposes, so please don't waste too much time reviewing the code ;-)
>> 
>> For context I'll try to describe the problem that this patch tries to solve.
>> 
>> I need to be able to boot an EVM signed (and dongled) rootfs. The CAAM on
>> the i.MX6 has support for an OTP key and can en/decrypt data.
>> It also has a feature for generating red blobs: basically a chunk of data,
>> that is encrypted with the OTP key, which can be saved on some medium as a
>> secret to decrypt the EVM HMAC secret for one specific device.
>> 
>> To open the rootfs, the secret is handed from the bootloader to the kernel
>> as a base64 encoded string via the cmdline to an initramfs.
>> In the initramfs the sysfs file "modifier" is set to something starting with
>> "kernel:evm" and the base64 string is written to the sysfs file "blob".
>> The CAAM than decodes the red blob and, in case of "kernel:evm", initializes
>> the EVM or otherwise writes the result to "payload" if the modifier starts
>> with "user:". Therefore a blob that was generated for EVM never leaves the
>> kernel on decryption.
>> Generation of blobs goes like: echoing "modifier" to something and echoing
>> the payload to "payload". The red blob can than be read from "blob".
>> 
>> 
>> So, the sysfs interface is not the best option, I guess. The question is:
>> What is the right approach for a setup like this?
>> I need to:
>>   - be able to encrypt the secret and store it somewhere
>>   - to load the stored secret and decrypt it later
>>   - initialize IMA/EVM with the secret
>> 
>> Would something like
>>   - security/keys/encrypted-keys/encrypted.c
>> be the correct approach?
>
> Instead of using the CAAM for OTP encrypting/decrypting, can it be used
> to load the EVM key directly?  Dmitry's patches, which will be
> upstreamed in 4.5
> https://git.kernel.org/cgit/linux/kernel/git/zohar/linux-integrity.git/log/?h=for-next-4.5?   adds support for a crypto device to directly load the EVM key.
>

The patches look good and I use them for loading the EVM key from the
CAAM driver. But I still need the OTP decryption functionality.

The key data that I hand to evm_set_key must be device specific but I
don't want to use the fused OTP in the CAAM directly.
The OTP is used to protect multiple random keys. Therefore I need to
generate encrypted blobs that I can store on some unsecure memory
(EEPROM, NAND,...) and be able to hand that later back to the CAAM
module, to then get back an IMA/EVM, ecryptfs, $something key.

> FYI, the EVM key is an encrypted key, which encrypts/decrypts either a
> trusted or user type key.
>
So the normal approach would be to have a key in the kernel keyring
and decrypt it with the key loaded with evm_set_key?

Can I somehow use the keyring framework as an abstraction around my
blobbing/deblobbing functionality?
So that the "keyring" calls into the crypto driver to decrypt the data
and uses the crypto driver to encrypt the keys when I want to "dump"
them?


Thanks,
Steffen

-- 
Pengutronix e.K.                           | Steffen Trumtrar            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
