From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6 1/1] crypto: SHA1 transform x86_64 AVX2
Date: Thu, 20 Mar 2014 20:21:19 -0700
Message-ID: <532BB02F.7030506@zytor.com>
References: <1395353640.2367.56.camel@pegasus.jf.intel.com> <532B6A5F.7070104@zytor.com> <20140321000939.GA20397@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: chandramouli narayanan <mouli@linux.intel.com>,
	"David S.Miller" <davem@davemloft.net>,
	Ilya Albrekht <ilya.albrekht@intel.com>,
	Maxim Locktyukhin <maxim.locktyukhin@intel.com>,
	Ronen Zohar <ronen.zohar@intel.com>,
	Wajdi Feghali <wajdi.k.feghali@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Jussi Kivilinna <jussi.kivilinna@iki.fi>,
	Marek Vasut <marex@denx.de>, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:59144 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754987AbaCUDWE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 20 Mar 2014 23:22:04 -0400
In-Reply-To: <20140321000939.GA20397@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/20/2014 05:09 PM, Herbert Xu wrote:
> On Thu, Mar 20, 2014 at 03:23:27PM -0700, H. Peter Anvin wrote:
>> Again... Herbert, David... yours or mine?
> 
> Yes I will be taking this through cryptodev.
> 

Thanks!

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

	-hpa
