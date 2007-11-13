From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC] [crypto] S390-AES add fallback driver.
Date: Wed, 14 Nov 2007 00:14:01 +0100
Message-ID: <20071113231401.GB10680@Chamillionaire.breakpoint.cc>
References: <20071111211027.GA9003@Chamillionaire.breakpoint.cc> <1194890669.5656.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Jan Glauber <jang@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:49528 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755950AbXKMXOD (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 13 Nov 2007 18:14:03 -0500
Content-Disposition: inline
In-Reply-To: <1194890669.5656.46.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

* Jan Glauber | 2007-11-12 18:04:29 [+0000]:

>Sebastian, thanks for working on this! Do you know if I need other
>posted patches that are not yet in cryptodev-2.6 for this to work?
Nope I should work. I tested it on Herbert's cryptodev tree.

>I'm asking becuase I'm getting the following crash using tcrypt (aes
>192-bit key, ecb-mode) :(
Too bad it doesn't work out of the box :D

>Call Trace:
>(?<0000000002ee5680>? 0x2ee5680)
> ?<00000001008292ae>? crypto_ecb_setkey+0x52/0x74 ?ecb?
> ?<000000010082316e>? setkey_fallback_blk+0x5e/0x98 ?aes_s390?
> ?<0000000100886d76>? test_cipher+0x2da/0x8f0 ?tcrypt?
> ?<000000010080570e>? init+0x70e/0x1808 ?tcrypt?
> ?<00000000000674f4>? sys_init_module+0x148/0x1e64
> ?<00000000000222f8>? sysc_noemu+0x10/0x16
> ?<000002000011ff6e>? 0x2000011ff6e
>
>>From my limited understanding of the internals of crypto API I think
>this is because crypto_ecb_setkey() calls crypto_cipher_setkey() instead
>of crypto_blkcipher_setkey() and the layout of struct blkcipher_tfm
>has the *iv where cipher_tfm has the setkey(). And oops, since the *iv
>is zero we have a null pointer call. But maybe I'm just missing another patch...
Please send me (private if you prefer) a full log and I look into it.

>thanks, Jan

Sebastian
