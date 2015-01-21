From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH] crypto: Documentation: remove colons in comments
Date: Tue, 20 Jan 2015 16:28:30 -0800
Message-ID: <54BEF2AE.7050007@infradead.org>
References: <4431066.AhB5zCO9nr@tachyon.chronox.de> <20150120034750.GB11274@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, 'LKML' <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:54938 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075AbbAUA2b (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 20 Jan 2015 19:28:31 -0500
In-Reply-To: <20150120034750.GB11274@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 01/19/15 19:47, Herbert Xu wrote:
> On Mon, Jan 19, 2015 at 12:13:39AM +0100, Stephan Mueller wrote:
>> As documented in Documentation/kernel-doc-nano-HOWTO.txt lines
>> terminated with a colon are treated as headings.
>>
>> The current layout of the documentation when compiling the kernel
>> crypto API DocBook documentation is messed up by by treating some lines
>> as headings. The patch removes colons from comments that shall not be
>> treated as headings.
>>
>> Signed-off-by: Stephan Mueller <smueller@chronox.de>
> 
> Applied.
> 

Ack. Thanks.

-- 
~Randy
