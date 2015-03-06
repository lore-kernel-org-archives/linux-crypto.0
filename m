From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RESEND 2/2] crypto: algif - change algif_skcipher to be
 asynchronous
Date: Fri, 06 Mar 2015 12:04:49 +0000
Message-ID: <54F997E1.8050601@intel.com>
References: <20150227193538.10553.6144.stgit@tstruk-mobl1> <20150227193549.10553.52267.stgit@tstruk-mobl1> <20150306114417.GA4949@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:42744 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbbCFMIr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Mar 2015 07:08:47 -0500
In-Reply-To: <20150306114417.GA4949@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/06/2015 11:44 AM, Herbert Xu wrote:
> Are these separate caches really necessary? It looks like an
> overkill.  What's wrong with just kmalloc?

Hi Herbert,
It helps to make it faster.
This way I can do some of the request setup beforehand and minimize overhead on the data path.
Thanks,
Tadeusz
