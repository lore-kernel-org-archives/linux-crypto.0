From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v3 0/4] crypto: qat - add RSA support to qat driver
Date: Fri, 17 Jul 2015 21:31:34 +0800
Message-ID: <20150717133134.GA23854@gondor.apana.org.au>
References: <20150715222821.22719.34149.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	pingchao.yang@intel.com, davem@davemloft.net
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57814 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982AbbGQNbl (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 17 Jul 2015 09:31:41 -0400
Content-Disposition: inline
In-Reply-To: <20150715222821.22719.34149.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jul 15, 2015 at 03:28:21PM -0700, Tadeusz Struk wrote:
> This series adds RSA support to the qat driver.
> First patch adds the logic in FW loader to load the Modular Math Processor(MMP)
> firmware to the device's internal memory.
> Second patch adds logic to load MMP firmware from disk.
> Third patch adds the actual RSA implementation.
> It also contains minor cleanup - namely removes unused TRNG rings.
> Fourth patch adds limitation for supported rsa key lengths to rsa-generic.
> 
> Once this is accepted updated version of qat_895xcc.bin firmware and the new mmp
> firmware will follow.

All applied.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
