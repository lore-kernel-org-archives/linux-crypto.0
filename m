From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 0/3] AF_ALG interface for akcipher
Date: Tue, 21 Jul 2015 21:19:28 -0700
Message-ID: <55AF19D0.5040700@intel.com>
References: <3908391.JkjAozYBaW@tachyon.chronox.de> <20150722013241.GA31240@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:54933 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752208AbbGVEUD (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 00:20:03 -0400
In-Reply-To: <20150722013241.GA31240@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/21/2015 06:32 PM, Herbert Xu wrote:
> I think we should finish the conversion of the only in-kernel
> user of RSA before we add the user-space interface.  Otherwise
> this unnecessarily ties our hands to the current API.
> 
> For example, do we want an SG interface for the input and output?
> As it stands even if a hardware device came with SG support we
> would not be able to use it.
> 
> Tadeusz, can you confirm again that qat does not support SG with
> respect to RSA input and output?

No, it doesn't. Even if we would add SG support on the API it will
need to be copied into contiguous buffers before it is sent to the HW.

Is there any other in-kernel user of RSA other than the module verifier?
If that's the only one I don't think we need any API changes.
I can refresh the old patches that converted it.
