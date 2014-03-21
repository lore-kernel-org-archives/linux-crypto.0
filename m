From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v6 1/1] crypto: SHA1 transform x86_64 AVX2
Date: Fri, 21 Mar 2014 08:09:39 +0800
Message-ID: <20140321000939.GA20397@gondor.apana.org.au>
References: <1395353640.2367.56.camel@pegasus.jf.intel.com>
 <532B6A5F.7070104@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: chandramouli narayanan <mouli@linux.intel.com>,
	"David S.Miller" <davem@davemloft.net>,
	Ilya Albrekht <ilya.albrekht@intel.com>,
	Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
	Ronen Zohar <ronen.zohar@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	Marek Vasut <marex@denx.de>, linux-crypto@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:37751 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966254AbaCUAKL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Mar 2014 20:10:11 -0400
Content-Disposition: inline
In-Reply-To: <532B6A5F.7070104@zytor.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Mar 20, 2014 at 03:23:27PM -0700, H. Peter Anvin wrote:
> Again... Herbert, David... yours or mine?

Yes I will be taking this through cryptodev.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
