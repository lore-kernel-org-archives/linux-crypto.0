From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RFC 4/4] crypto: qat - Add new algif interface for userspace
Date: Thu, 06 Nov 2014 21:24:22 -0800
Message-ID: <545C5786.4030205@intel.com>
References: <20141106195931.13328.90501.stgit@tstruk-mobl1> <20141106195953.13328.77022.stgit@tstruk-mobl1> <20141107025607.GA9474@gondor.apana.org.au> <545C3FDB.4010106@intel.com> <20141107040531.GA9865@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15222 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996AbaKGF05 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 7 Nov 2014 00:26:57 -0500
In-Reply-To: <20141107040531.GA9865@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/06/2014 08:05 PM, Herbert Xu wrote:
> I see.  What we need to do is first fold the current asymmetric
> crypto code under crypto/asymmetric into the crypto API properly
> and then export that through algif.
> 
> You can then simply implement a hardware driver for such algorithms
> as you currently do for other crypto API algorithms.
> 
> I'll try to work on that.

What about aead? Using my algif_qat I can build a single request to HW
that preforms both encryption and authentication in one go, ever for
things like aes-cbc-hmac-sha1. This allows me to get great performance
of authenticated encryption from user space.
Regards,
Tadeusz
