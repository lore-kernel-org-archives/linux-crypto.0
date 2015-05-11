From: Stephan Mueller <smueller@chronox.de>
Subject: Re: [PATCH v2] SP800-38F / RFC3394 key wrapping
Date: Mon, 11 May 2015 12:15:56 +0200
Message-ID: <3967410.spMBXlI7nE@tauon>
References: <1515730.LIeS5qas5m@myon.chronox.de> <1472762.oGxlyZfssS@tauon> <20150511094212.GA4224@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:34765 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752814AbbEKKQE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 06:16:04 -0400
In-Reply-To: <20150511094212.GA4224@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 11. Mai 2015, 17:42:12 schrieb Herbert Xu:

Hi Herbert,

>On Fri, May 01, 2015 at 03:21:19PM +0200, Stephan Mueller wrote:
>> My idea would be to use keywrap in step 3.
>
>How is dm-crypt going to cope with the increase in ciphertext size?

The LUKS header is not fixed-size, so it would be able to handle the increased 
cipher text size.

But I think I should rather go back and write up the ideas that I have for key 
handling. Currently it seems that too many components in kernel and user space 
handle plaintext keys.

After writing that one up, I like to present it with an assoicated discussion 
of how to handle key wrapping considering that addition of it to the kernel 
crypto API is not possible at this point.

Thanks for your help.

Ciao
Stephan
