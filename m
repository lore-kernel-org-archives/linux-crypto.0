From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: qat - add support for cbc(aes) ablkcipher
Date: Mon, 08 Dec 2014 12:13:08 -0800
Message-ID: <54860654.4050300@intel.com>
References: <20141208200849.15367.87433.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:59396 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754147AbaLHUQK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 8 Dec 2014 15:16:10 -0500
In-Reply-To: <20141208200849.15367.87433.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/08/2014 12:08 PM, Tadeusz Struk wrote:
> Add support for cbc(aes) ablkcipher.
> 

Hi Herbert,
These two:
[PATCH] crypto: qat - add support for cbc(aes) ablkcipher
[PATCH] crypto: qat - Fix assumption that sg in and out will have the...

are generated against cryptodev with these two on top:

[PATCH v2 1/2] crypto: qat - Prevent dma mapping zero length assoc data
[PATCH v2 2/2] crypto: qat - Enforce valid numa configuration

Thanks,
Tadeusz
