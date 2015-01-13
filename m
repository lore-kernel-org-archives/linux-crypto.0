From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: qat - Fix for qat_aes_cbc_hmac_sha512
Date: Tue, 13 Jan 2015 14:55:24 -0800
Message-ID: <54B5A25C.9070007@intel.com>
References: <20150113202753.32216.26250.stgit@tstruk-mobl1> <20150113212515.GA11562@gondor.apana.org.au> <54B59A86.10803@intel.com> <20150113224756.GA12432@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, linux-crypto@vger.kernel.org,
	qat-linux@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34796 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193AbbAMW6q (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Jan 2015 17:58:46 -0500
In-Reply-To: <20150113224756.GA12432@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/13/2015 02:47 PM, Herbert Xu wrote:
> Why are you allocating this qat_auth_state anyway? Just do
> ipad/opad[block_size] and be done with it.

You are right. I don't need qat_auth_state really. Let me send you v2 in
2 mins.
Thanks
