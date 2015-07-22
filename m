From: Tadeusz Struk <tadeusz.struk@intel.com>
Subject: Re: [PATCH] crypto: rsa - fix invalid check for keylen in fips mode
Date: Wed, 22 Jul 2015 06:38:45 -0700
Message-ID: <55AF9CE5.7040303@intel.com>
References: <20150721001826.24499.51560.stgit@tstruk-mobl1> <20150721122521.GA25104@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, dan.carpenter@oracle.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:29947 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752929AbbGVNjU (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 22 Jul 2015 09:39:20 -0400
In-Reply-To: <20150721122521.GA25104@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 07/21/2015 05:25 AM, Herbert Xu wrote:
> On Mon, Jul 20, 2015 at 05:18:26PM -0700, Tadeusz Struk wrote:
>> The condition checking allowed key length was invalid.
>>
>> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>>
>> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> 
> Applied.
> 
Herbert, Shouldn't this one go to 4.2?
Thanks,
T
