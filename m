From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 0/4] crypto: Key Derivation Function (SP800-108)
Date: Wed, 27 Jan 2016 08:33 +0100
Message-ID: <2095039.8tz9kMju3S@tauon.atsec.com>
References: <4445045.XP4c23S4mB@positron.chronox.de> <20160127051409.GA30212@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42630 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568AbcA0HdE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2016 02:33:04 -0500
In-Reply-To: <20160127051409.GA30212@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 27. Januar 2016, 13:14:09 schrieb Herbert Xu:

Hi Herbert,

>On Tue, Jan 26, 2016 at 07:19:17AM +0100, Stephan Mueller wrote:
>> Hi,
>> 
>> this patch set implements all three key derivation functions defined in
>> SP800-108.
>> 
>> The implementation is provided as a template for random number generators,
>> since a KDF can be considered a form of deterministic RNG where the key
>> material is used as a seed.
>> 
>> With the KDF implemented as a template, all types of keyed hashes can be
>> utilized, including HMAC and CMAC. The testmgr tests are derived from
>> publicly available test vectors from NIST.
>> 
>> The KDF are all tested with a complete round of CAVS testing on 32 and 64
>> bit.
>> 
>> The patch set introduces an extension to the kernel crypto API in the first
>> patch by adding a template handling for random number generators based on
>> the same logic as for keyed hashes.
>
>What is this going to use this inside the kernel?

With the current development of EXT4 encryption we currently have the 
logic that the files are either open (read/writable) or closed (not 
accessible).

There is a scenario for a third option: a file is writable in a "device-
locked" state, but not readable. The logic that would implement such mechanism 
is nicely described in [1] section D.3.3, especially figure 4. To use such a 
mechanism, the generated shared secret should definitely go through a KDF to 
ensure that the key has the right size for the underlying symmetric cipher.

This approach would allow locking your device, but yet the system could still 
write confidential data (like getting emails, generating logs, etc.) but the 
data is not accessible unless you unlock the device.

So, my idea was to provide a building block for such encryption scenarios 
which I would think will come.

Besides, if crypto network protocols are contemplated to be included into the 
kernel (like TLS), I would think that the KDF should be handled by the kernel 
crypto API as a central place for such logic. Thus, my patch would provide the 
framework by providing the RNG template handling to have that KDF here.

[1] https://www.niap-ccevs.org/pp/pp_md_v2.0.pdf

(PS: please only read D.3.3 and especially figure 4 from that document as I 
think this is the only real nice and generally useful information in there)

Ciao
Stephan
