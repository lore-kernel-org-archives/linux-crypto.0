From: James Hartley <james.hartley@imgtec.com>
Subject: Re: [PATCH V2 1/2] crypto: Add Imagination Technologies hw hash accelerator
Date: Wed, 28 Jan 2015 19:19:09 +0000
Message-ID: <54C9362D.1050409@imgtec.com>
References: <54C826EC.8050103@imgtec.com> <54C82D69.9070200@imgtec.com> <20150128005640.GA12143@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Andrew Bresticker <abrestic@chromium.org>,
	Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
	<linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailapp01.imgtec.com ([195.59.15.196]:43399 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991AbbA2DE0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 Jan 2015 22:04:26 -0500
In-Reply-To: <20150128005640.GA12143@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


On 01/28/15 00:56, Herbert Xu wrote:
> On Wed, Jan 28, 2015 at 12:29:29AM +0000, James Hartley wrote:
>> - If it is mandatory to impement a fallback driver (because the
>> potential users of the framework would not know only digest is
>> supported?)
> Yes it is mandatory.
>   
>> If I need to implement fallback drivers, would the Niagra2 SPU
>> driver be a good reference
>> http://lxr.free-electrons.com/source/drivers/crypto/n2_core.c ?
> Yes it's a good example.
>
> Cheers,
Great, I'll prepare a new patchset.  For the previous patches I did some 
basic testing using the built in crypto manager tests, but these all 
pass without the fallback implemented - is there another more 
appropriate set of tests that you would recommend I use to verify that 
my implementation is correct?

Thanks,
James
