From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: GCM aesni and 192/256-bit keys
Date: Mon, 05 Jan 2015 09:51:35 -0800
Message-ID: <54AACF27.6090300@intel.com>
References: <20150105100644.GA24595@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:21485 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884AbbAERzF (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 5 Jan 2015 12:55:05 -0500
In-Reply-To: <20150105100644.GA24595@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/05/2015 02:06 AM, Herbert Xu wrote:
> Hi Tadeusz:
> 
> It appears that the GCM aesni implementation does not support
> 192/256-bit keys.  This is not allowed as accelerated drivers
> must support everything supported by the software implementation.
> 
> Could we add 192/256-bit support to it please? If for some reason
> this cannot be done then at least implement a software fallback
> so that it continues to work.
> 
> Thanks,
> 

Hi Herbert,
Yes, you are right. I'll look into it.
Thanks,
Tadeusz
