From: Kent Borg <kentborg@borg.org>
Subject: Re: HW Accelerated IPSEC?
Date: Fri, 10 Jun 2011 10:38:18 -0400
Message-ID: <4DF22C5A.2000907@borg.org>
References: <20110610005951.GA27419@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from borg.org ([64.105.205.123]:58249 "EHLO borg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab1FJOiV (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 10 Jun 2011 10:38:21 -0400
In-Reply-To: <20110610005951.GA27419@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu wrote:
 > Since your IPsec is actually breaking, then mv_cesa is probably 
getting used.

Yes, that makes sense.

 > Did you compile in the self-test suite (unset
 > CONFIG_CRYPTO_MANAGER_DISABLE_TESTS)?

I have it unset, and /proc/crypto is reporting all tests as passed for 
mv_cesa. (My driver, which also doesn't work with IPSec, also passes all 
the tests.)

> It sounds like a bug in mv_cesa.
>   

(Assuming I am not breaking it some how in my usage.) And a 
corresponding bug in my driver. I looked at mv_cesa and other drivers, I 
might have copied an mv_cesa bug.

I made module versions of aes_generic, sha1_generic, and sha256_generic, 
and boosted the priorities a bit. When I run IPSec through them, I see 
the use counts for my munged versions go up, and it works. So I guess I 
have shown that a module can do crypto for IPSec. Just not mv_cesa nor 
my module.

Looking at packet dumps in both the good and bad IPSec cases, it seems 
the key negotiation is working, but when a payload packet is expected 
(the first packet that I think will use the crypto module), I never see 
it in the mv_cesa case.

I was hoping that passing the self-test meant my code worked. I also 
used an encrypted lookback filesystem with both mv_cesa and my module, 
and, after I fixed my "last bug", both can handle that.

Maybe both modules are processing the data-in/data-out aspect correctly, 
but are misbehaving in some other way; a missing lock on a critical 
section, for example. For some reason IPSec gets unhappy where self-test 
and loopback are quite content. Or, maybe IPSec has a bug that is 
somehow exposed when a different HW unit gets into the act. (Which is 
why I was looking for any confirmed case of IPSec going through the 
kernel's crypto infrastructure for HW acceleration.)


Thanks,

-kb, the Kent who is looking for a way to simplify the problem.
