From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Proposal for adding setpubkey callback to akcipher_alg
Date: Wed, 5 Aug 2015 13:10:25 +0800
Message-ID: <20150805051025.GA4980@gondor.apana.org.au>
References: <905E1812-AD9B-4188-A668-3CD8985EA1BF@holtmann.org>
 <1704807.Rn4DsddD6R@tauon.atsec.com>
 <70C201C0-233D-4912-9856-C8C0E7A6A0FA@holtmann.org>
 <14682477.78a1L9JDin@myon.chronox.de>
 <3743CED6-E3E0-416E-9B82-F1677628E35E@holtmann.org>
 <20150805024600.GA3878@gondor.apana.org.au>
 <DDF4B0CD-92AE-4EB4-97BE-9218CF7FA784@holtmann.org>
 <20150805040641.GA4398@gondor.apana.org.au>
 <5591E036-386D-40D4-B906-4D014B20667A@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephan Mueller <smueller@chronox.de>,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	David Howells <dhowells@redhat.com>,
	linux-crypto@vger.kernel.org
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:50916 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751226AbbHEFKk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 5 Aug 2015 01:10:40 -0400
Content-Disposition: inline
In-Reply-To: <5591E036-386D-40D4-B906-4D014B20667A@holtmann.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Aug 04, 2015 at 09:33:27PM -0700, Marcel Holtmann wrote:
>
> I think it actually is the correct interface. And it will still stay a purely algorithmic interface. It is just that the algorithm is bound to specific hardware with a specific key. I really do not understand your distinction here.

The crypto API provides a platform where you can provide hardware
accelerated implementations for pure software algorithms.  Hardware
keys are fundamentally incompatible with that as you cannot do it
in software.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
