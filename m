From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: Is a crypto_ahash_init required before invoking
 crypto_ahash_import?
Date: Thu, 25 Feb 2016 16:26:54 -0600
Message-ID: <56CF7FAE.6060402@amd.com>
References: <56CF788F.5050209@amd.com>
 <20160225221134.GA27728@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0090.outbound.protection.outlook.com ([65.55.169.90]:49869
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751030AbcBYW1D (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Feb 2016 17:27:03 -0500
In-Reply-To: <20160225221134.GA27728@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/25/2016 04:11 PM, Herbert Xu wrote:
> On Thu, Feb 25, 2016 at 03:56:31PM -0600, Tom Lendacky wrote:
>>
>> I can fix this in the driver by doing a memset to zero of the request
>> context area during the import. But I guess I'm also wondering if there
>> is an expectation/requirement that crypto_ahash_init() be called before
>> doing an import?  If there is the I can add that to the testmgr code
>> instead.
> 
> No init means wiping out the hash state so that a new hash can be
> computed.  Import means importing the hash state so that computation
> can be continued from that point onwards.
> 
> So they're independent of each other and you must be able to handle
> an import without an init and vice versa.

Thanks for the clarification Herbert.  I'll send in a patch to perform
the memset during the import.  I know it's late in the cycle, but will
you be able to apply it to the current cryptodev-2.6 tree which contains
the ccp import/export patches?

Thanks,
Tom

> 
> Cheers,
> 
