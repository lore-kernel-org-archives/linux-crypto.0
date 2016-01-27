From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 0/4] crypto: Key Derivation Function (SP800-108)
Date: Wed, 27 Jan 2016 15:35:41 +0800
Message-ID: <20160127073541.GA30898@gondor.apana.org.au>
References: <4445045.XP4c23S4mB@positron.chronox.de>
 <20160127051409.GA30212@gondor.apana.org.au>
 <2095039.8tz9kMju3S@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58393 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbcA0Hfq (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 27 Jan 2016 02:35:46 -0500
Content-Disposition: inline
In-Reply-To: <2095039.8tz9kMju3S@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 27, 2016 at 08:33:00AM +0100, Stephan Mueller wrote:
>
> With the current development of EXT4 encryption we currently have the 
> logic that the files are either open (read/writable) or closed (not 
> accessible).
> 
> There is a scenario for a third option: a file is writable in a "device-
> locked" state, but not readable. The logic that would implement such mechanism 
> is nicely described in [1] section D.3.3, especially figure 4. To use such a 
> mechanism, the generated shared secret should definitely go through a KDF to 
> ensure that the key has the right size for the underlying symmetric cipher.
> 
> This approach would allow locking your device, but yet the system could still 
> write confidential data (like getting emails, generating logs, etc.) but the 
> data is not accessible unless you unlock the device.
> 
> So, my idea was to provide a building block for such encryption scenarios 
> which I would think will come.
> 
> Besides, if crypto network protocols are contemplated to be included into the 
> kernel (like TLS), I would think that the KDF should be handled by the kernel 
> crypto API as a central place for such logic. Thus, my patch would provide the 
> framework by providing the RNG template handling to have that KDF here.

While this is all very nice until such a user is ready for submission
into the kernel I'd rather not add this.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
