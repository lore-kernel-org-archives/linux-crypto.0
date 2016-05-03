From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: vmx - comply with ABIs that specify vrsave as
 reserved.
Date: Tue, 3 May 2016 16:13:45 +0800
Message-ID: <20160503081345.GA17118@gondor.apana.org.au>
References: <1461938585-7933-1-git-send-email-pfsmorigo@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	"Leonidas S. Barbosa" <leosilva@linux.vnet.ibm.com>,
	"David S. Miller" <davem@davemloft.net>,
	"open list:IBM Power VMX Cryptographic instructions"
	<linux-crypto@vger.kernel.org>
To: Paulo Flabiano Smorigo <pfsmorigo@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:44888 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751412AbcECINy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 3 May 2016 04:13:54 -0400
Content-Disposition: inline
In-Reply-To: <1461938585-7933-1-git-send-email-pfsmorigo@linux.vnet.ibm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 29, 2016 at 11:03:05AM -0300, Paulo Flabiano Smorigo wrote:
> It gives significant improvements ( ~+15%) on some modes.
> 
> These code has been adopted from OpenSSL project in collaboration
> with the original author (Andy Polyakov <appro@openssl.org>).

No sign-off.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
