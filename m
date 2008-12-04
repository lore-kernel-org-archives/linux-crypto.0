From: Adrian-Ken Rueegsegger <ken@codelabs.ch>
Subject: Re: [PATCH 0/4] Switch remaining algorithms to shash
Date: Thu, 04 Dec 2008 08:55:57 +0100
Message-ID: <49378D0D.8090201@codelabs.ch>
References: <12283498922490-git-send-email-ken@codelabs.ch> <20081204064812.GB18141@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org, steffen.klassert@secunet.com
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from [217.150.249.120] ([217.150.249.120]:34864 "EHLO
	fenrir.codelabs.ch" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbYLDH4I (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Dec 2008 02:56:08 -0500
In-Reply-To: <20081204064812.GB18141@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Herbert,

Herbert Xu wrote:
> On Thu, Dec 04, 2008 at 01:18:08AM +0100, Adrian-Ken Rueegsegger wrote:
>> The first patch removes the message schedule W from struct sha512_ctx
>> since it gets calculated anew on each execution of sha512_transform. This
>> reduces the size of sha512_ctx considerably and will allow it to be
>> registered as a shash algorithm (it will pass the size check in
>> crypto_register_shash (crypto/shash.c:490)).
>> Herbert, could you explain why descsize must be smaller (or equal)
>> than PAGE_SIZE / 8?
> 
> This is so that people can put it on the stack safely.  So moving
> things out of the context and onto the stack because it's too big
> is a no-no :)

Thanks for the explanation.

> Perhaps store in a static percpu area?
> 
>> The next two patches switch sha512 and wp512 to the new shash interface.
> 
> BTW, in order to add missing Kconfig dependencies on HASH I've
> just rebased my tree and updated all the shash conversion patches.
> So please resend them with the Kconfig bits added.

Will do. I will resubmit the patches later today.

>> The fourth patch is another try to convert michael_mic. The key values
>> l and r are duplicated in the descriptor part since they are used and
>> changed during the actual transformation. I would be gratefull for
>> comments on this patch since I am not sure it's the proper way to do it.
> 
> Since they're read-only they should be obtained from the tfm context
> when needed, just like crc32c.

If I read the code correctly l and r are not read-only, e.g. in
michael_update there are multiple assignments to mctx->l and mctx->r.
That's the reason why I left them in the desc context.

Thank you for your comments,
Adrian
