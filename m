From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Proposal for adding setpubkey callback to akcipher_alg
Date: Wed, 5 Aug 2015 12:06:41 +0800
Message-ID: <20150805040641.GA4398@gondor.apana.org.au>
References: <905E1812-AD9B-4188-A668-3CD8985EA1BF@holtmann.org>
 <1704807.Rn4DsddD6R@tauon.atsec.com>
 <70C201C0-233D-4912-9856-C8C0E7A6A0FA@holtmann.org>
 <14682477.78a1L9JDin@myon.chronox.de>
 <3743CED6-E3E0-416E-9B82-F1677628E35E@holtmann.org>
 <20150805024600.GA3878@gondor.apana.org.au>
 <DDF4B0CD-92AE-4EB4-97BE-9218CF7FA784@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	David Howells <dhowells@redhat.com>,
	linux-crypto@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:35136 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbbHEEGy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 00:06:54 -0400
Content-Disposition: inline
In-Reply-To: <DDF4B0CD-92AE-4EB4-97BE-9218CF7FA784@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 04, 2015 at 09:02:36PM -0700, Marcel Holtmann wrote:
>
> We already have an interface that can handle asymmetric keys and it is easy to extend with new key formats and key types. So lets use that. I can clearly see that after RSA, we get DSA, ECDH etc. So having a simple way to handle these key formats is a good idea. That infrastructure is already in place and easy to extend if needed. Especially with the background that some keys might be actually in hardware or compiled into the kernel, the current asymmetric key interface has the right abstraction. It is also the right abstraction to deal with crypto hardware like TPM or even UEFI.

The crypto API akcipher interface is never going to be used for TPM
or UEFI.  This is a purely algorithmic interface intended for
hardware acceleration devices.  If your key is embedded into the
hardware or otherwise hidden then this is not the interface for you.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
