From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH v1] crypto: ccp - Add hash state import and export support
Date: Mon, 25 Jan 2016 08:58:41 -0600
Message-ID: <56A63821.1090501@amd.com>
References: <20160112171738.23496.44254.stgit@tlendack-t1.amdoffice.net>
 <56A26568.3000806@amd.com> <20160125072044.GB5609@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, David Miller <davem@davemloft.net>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-bl2on0056.outbound.protection.outlook.com ([65.55.169.56]:25863
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755517AbcAYO6w (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jan 2016 09:58:52 -0500
In-Reply-To: <20160125072044.GB5609@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/25/2016 01:20 AM, Herbert Xu wrote:
> On Fri, Jan 22, 2016 at 11:22:48AM -0600, Tom Lendacky wrote:
>> On 01/12/2016 11:17 AM, Tom Lendacky wrote:
>>> Commit 8996eafdcbad ("crypto: ahash - ensure statesize is non-zero")
>>> added a check to prevent ahash algorithms from successfully registering
>>> if the import and export functions were not implemented. This prevents
>>> an oops in the hash_accept function of algif_hash. This commit causes
>>> the ccp-crypto module SHA support and AES CMAC support from successfully
>>> registering and causing the ccp-crypto module load to fail because the
>>> ahash import and export functions are not implemented.
>>>
>>> Update the CCP Crypto API support to provide import and export support
>>> for ahash algorithms.
>>>
>>> Cc: <stable@vger.kernel.org> # 3.14.x-
>>> Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
>>
>> Herbert, is it possible this patch can be part of Crypto Fixes for 4.5?
> 
> While your patch is probably OK the rctx structure just contains
> too much crap for me to feel safe about pushing this in at this
> point in time.  So I'd like to have it cook for another cycle.
> 
> The reason I'm overly cautious is because import/export is directly
> exposed to user-space so if we get this wrong then we may open
> up a root hole.

Many of the fields in the rctx structure are set during the update
operation and don't matter to the driver from an export and import
perspective. I included them to make the routines simple, but if
user-space exposure is a concern I can pare down the amount of data
that is exported and imported. I can send a follow-on patch to do
that if you prefer.

Thanks,
Tom

> 
> Cheers,
> 
