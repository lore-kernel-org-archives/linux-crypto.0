From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH RESEND 2/2] crypto: algif - change algif_skcipher to be
 asynchronous
Date: Mon, 09 Mar 2015 13:06:14 -0700
Message-ID: <54FDFD36.5020204@intel.com>
References: <20150227193538.10553.6144.stgit@tstruk-mobl1> <20150227193549.10553.52267.stgit@tstruk-mobl1> <20150306114417.GA4949@gondor.apana.org.au> <54F997E1.8050601@intel.com> <20150306120956.GA5715@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:20709 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbbCIUKM (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 9 Mar 2015 16:10:12 -0400
In-Reply-To: <20150306120956.GA5715@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 03/06/2015 04:09 AM, Herbert Xu wrote:
>> It helps to make it faster.
>> > This way I can do some of the request setup beforehand and minimize overhead on the data path.
> Do you have numbers to back this up?

Ok, you are right. It was implemented that way when I used the qat type socket, which was rejected.
It made more sense to do it that way as there was some dma remapping that I could do upfront.
Now the difference in performance is negligible. I'll send v2 shortly.
Thanks for pointing this out.
