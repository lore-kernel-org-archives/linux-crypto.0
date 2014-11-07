From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC 4/4] crypto: qat - Add new algif interface for userspace
Date: Thu, 06 Nov 2014 19:43:23 -0800
Message-ID: <545C3FDB.4010106@intel.com>
References: <20141106195931.13328.90501.stgit@tstruk-mobl1> <20141106195953.13328.77022.stgit@tstruk-mobl1> <20141107025607.GA9474@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32812 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbaKGDp4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 6 Nov 2014 22:45:56 -0500
In-Reply-To: <20141107025607.GA9474@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,
On 11/06/2014 06:56 PM, Herbert Xu wrote:
>> Add new socket algif interface for userspace for symmetric and asymmetric
>> > crypto.
>> > 
>> > Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> No this is not acceptable.  algif is meant to expose generic
> algorithms to user-space not a specific hardware implementation.

Yes, I know that PF_ALG wasn't designed to expose hardware specific
implementation, but the problem is that currently there is no interface
that allows using HW acceleration for algorithms such as RSA, DSA, or
Diffie-Hellman.
Using PF_ALG works perfectly for this purpose. I can get around 130K RSA
decrypt operations per second with 1024 bits modulus. This also scales
very well for more accelerators.
PF_ALG meant to be crypto interface for user space and this is what I'm
using it for here :) Is there any way I can make it (more) acceptable?
Regards,
Tadeusz
