From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH 0/4] crypto: Key Derivation Function (SP800-108)
Date: Wed, 27 Jan 2016 09:03:51 +0100
Message-ID: <4346719.HxfQU1UIAf@tauon.atsec.com>
References: <4445045.XP4c23S4mB@positron.chronox.de> <2095039.8tz9kMju3S@tauon.atsec.com> <20160127073541.GA30898@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:42634 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbcA0IDy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2016 03:03:54 -0500
In-Reply-To: <20160127073541.GA30898@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Mittwoch, 27. Januar 2016, 15:35:41 schrieb Herbert Xu:

Hi Herbert,

>On Wed, Jan 27, 2016 at 08:33:00AM +0100, Stephan Mueller wrote:
>> With the current development of EXT4 encryption we currently have the
>> logic that the files are either open (read/writable) or closed (not
>> accessible).
>> 
>> There is a scenario for a third option: a file is writable in a "device-
>> locked" state, but not readable. The logic that would implement such
>> mechanism is nicely described in [1] section D.3.3, especially figure 4.
>> To use such a mechanism, the generated shared secret should definitely go
>> through a KDF to ensure that the key has the right size for the underlying
>> symmetric cipher.
>> 
>> This approach would allow locking your device, but yet the system could
>> still write confidential data (like getting emails, generating logs, etc.)
>> but the data is not accessible unless you unlock the device.
>> 
>> So, my idea was to provide a building block for such encryption scenarios
>> which I would think will come.
>> 
>> Besides, if crypto network protocols are contemplated to be included into
>> the kernel (like TLS), I would think that the KDF should be handled by the
>> kernel crypto API as a central place for such logic. Thus, my patch would
>> provide the framework by providing the RNG template handling to have that
>> KDF here.
>While this is all very nice until such a user is ready for submission
>into the kernel I'd rather not add this.

Ok, I have no problems with that. I put the patches onto my web server if 
people are interested in it [1].

[1] http://www.chronox.de/kdf.html

Ciao
Stephan
