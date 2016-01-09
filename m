From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: algif_hash bug?
Date: Sat, 9 Jan 2016 09:50:00 -0600
Message-ID: <56912C28.30809@amd.com>
References: <56902232.2010309@amd.com>
 <20160109054238.GB11188@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-by2on0065.outbound.protection.outlook.com ([207.46.100.65]:62209
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755381AbcAIPuJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Sat, 9 Jan 2016 10:50:09 -0500
In-Reply-To: <20160109054238.GB11188@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/08/2016 11:42 PM, Herbert Xu wrote:
> On Fri, Jan 08, 2016 at 02:55:14PM -0600, Tom Lendacky wrote:
>>
>> AF_ALG hash supports the accept() call to allow for partial hash states
>> to be cloned. If an accept() is issued against a socket before ever
>> doing a send(), crypto_ahash_init() will never have been called for the
>> original socket.  The hash_accept function in algif_hash will call
>> crypto_ahash_export() which will return an uninitialized request context
>> and then use that for import into the new socket. A problem arises here
>> because hash_accept sets the 'more' bit of the new context to 1
>> (ctx2->more = 1). This will cause the first send() call for the new
>> socket to skip calling crypto_ahash_init() which can result in an
>> error or oops because the request context for the cloned socket was
>> never initialized.
>>
>> Is it assumed that the accept() call should only ever be made after
>> having issued at least one send()? Should the ctx2->more value be the
>> value from the original context so that crypto_ahash_init() is called
>> when needed?
> 
> I thought we've already fixed this bug with
> 
> commit 4afa5f9617927453ac04b24b584f6c718dfb4f45
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Sun Nov 1 17:11:19 2015 +0800
> 
>     crypto: algif_hash - Only export and import on sockets with data
> 

I thought I was on the latest tree but I wasn't...  sorry for the
time and trouble.

Tom

> Cheers,
> 
