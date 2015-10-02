From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v4 0/3] crypto: akcipher - Changes to asymmetric key API
Date: Thu, 1 Oct 2015 20:40:26 -0700
Message-ID: <560DFCAA.2040609@intel.com>
References: <20151001202845.7193.51602.stgit@tstruk-mobl1>
 <20151002032000.GA32754@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:24735 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbbJBDmb (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 23:42:31 -0400
In-Reply-To: <20151002032000.GA32754@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/01/2015 08:20 PM, Herbert Xu wrote:
>> Changes in v4:
>> > - add back src_len and dst_len
> So why do you still use sg_len? The length of the SG list is
> irrelevant now that you have src_len/dst_len.

I do use src_len for processing. The sg_len() is still useful for
parameter checking to make sure that src_len <= sg_len(req->src)
Thanks
