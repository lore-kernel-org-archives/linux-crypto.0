From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH v4 0/3] crypto: akcipher - Changes to asymmetric key API
Date: Thu, 1 Oct 2015 21:09:54 -0700
Message-ID: <560E0392.4020005@intel.com>
References: <20151001202845.7193.51602.stgit@tstruk-mobl1>
 <20151002032000.GA32754@gondor.apana.org.au> <560DFCAA.2040609@intel.com>
 <20151002040409.GA557@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:27646 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbbJBEL7 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 2 Oct 2015 00:11:59 -0400
In-Reply-To: <20151002040409.GA557@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/01/2015 09:04 PM, Herbert Xu wrote:
>> I do use src_len for processing. The sg_len() is still useful for
>> > parameter checking to make sure that src_len <= sg_len(req->src)
> I don't see the point.  We don't check that anywhere else in the
> crypto API.  It's the caller's responsibility to provide valid input
> parameters.
> 
> Untrusted callers must be vetted at the point of entry, i.e.,
> algif.

This is used not only in rsa, but also in the new mpi sgl helpers.
Should I drop all the params checking?
