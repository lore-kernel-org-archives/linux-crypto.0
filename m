From: Krzysztof Halasa <khc@pm.waw.pl>
Subject: Re: Crypto test results unused?
Date: Mon, 28 Dec 2009 21:14:17 +0100
Message-ID: <m37hs6rh46.fsf@intrepid.localdomain>
References: <m3ws07q865.fsf@intrepid.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: lkml <linux-kernel@vger.kernel.org>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from khc.piap.pl ([195.187.100.11]:55106 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750995AbZL1UOT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 28 Dec 2009 15:14:19 -0500
In-Reply-To: <m3ws07q865.fsf@intrepid.localdomain> (Krzysztof Halasa's message
	of "Mon, 28 Dec 2009 19:12:50 +0100")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Krzysztof Halasa <khc@pm.waw.pl> writes:

> is the core crypto code supposed to "kill" algorithms which fail the
> test?
>
> On little-endian IXP4xx 3 hardware-assisted algorithms fail (due to
> apparently unrelated bug which I will take care of). It seems the kernel
> is still using these failing algorithms (my debugging code adds extra
> fields to the /proc output):
>
> alg: skcipher: Test 1 failed on encryption for ecb(des)-ixp4xx
> 00000000: 01 23 45 67 89 ab cd e7
> alg: skcipher: Test 1 failed on encryption for ecb(des3_ede)-ixp4xx
> 00000000: 73 6f 6d 65 64 61 74 61
> alg: skcipher: Test 1 failed on encryption for ecb(aes)-ixp4xx
> 00000000: 00 11 22 33 44 55 66 77 88 99 aa bb cc dd ee ff
>
> # grep 'ecb(des)-ixp4xx\|ecb(des3_ede)-ixp4xx\|ecb(aes)-ixp4xx' /proc/cryp
> to -A 6
> driver       : ecb(aes)-ixp4xx
> module       : ixp4xx_crypto
> priority     : 300
> refcnt       : 1
> flags        : 0x85
> ptr          : 0xbf020074
> selftest     : unknown
> ^^^^^^^^^^^^^^^^^^^^^^

I think probably crypto_alg_tested() should mark the failing algorithm
somehow?
void crypto_alg_tested(const char *name, int err)
{
	...
found:
	q->cra_flags |= CRYPTO_ALG_DEAD;
	alg = test->adult;

  >>>>>>>>>>>>> maybe here? if (err) mark_as_failed(alg); <<<<<<<<<<<<<<<<

	if (err || list_empty(&alg->cra_list))
		goto complete;

	alg->cra_flags |= CRYPTO_ALG_TESTED;
-- 
Krzysztof Halasa
