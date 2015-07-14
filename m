From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH 3/3] crypto: qat - Add support for RSA algorithm
Date: Tue, 14 Jul 2015 09:16:48 -0700
Message-ID: <55A535F0.5060700@intel.com>
References: <20150710170616.4483.44445.stgit@tstruk-mobl1> <20150710170632.4483.9019.stgit@tstruk-mobl1> <20150714064631.GA20343@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	pingchao.yang@intel.com, davem@davemloft.net
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:38386 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbbGNQRP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 14 Jul 2015 12:17:15 -0400
In-Reply-To: <20150714064631.GA20343@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/13/2015 11:46 PM, Herbert Xu wrote:
> As we discussed a while ago, the hardware implementation must not
> support a smaller feature set than the software implementation.
> 
> So please either add a software fallback for unsupported key sizes,
> or ensure that the software implementation also rejects these key
> sizes.

Ok, I'll add a software fallback in v2.
Thanks,
T
