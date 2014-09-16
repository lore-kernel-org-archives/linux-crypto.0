From: Romain Francoise <romain@orebokech.com>
Subject: Re: v3.17-rc5: alg: skcipher: Test 4 failed on encryption for ctr-aes-aesni
Date: Tue, 16 Sep 2014 22:01:07 +0200
Message-ID: <87fvfr2v3w.fsf@kima.orebokech.com>
References: <87sijti8kh.fsf@kima.orebokech.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: herbert@gondor.apana.org.au,
	Chandramouli Narayanan <mouli@linux.intel.com>,
	Mathias Krause <minipli@googlemail.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from stringer.orebokech.com ([212.83.175.182]:48637 "EHLO
	stringer.orebokech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817AbaIPUBI (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Sep 2014 16:01:08 -0400
In-Reply-To: <87sijti8kh.fsf@kima.orebokech.com> (Romain Francoise's message
	of "Mon, 15 Sep 2014 10:36:46 +0200")
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Sep 15, 2014 at 10:36:46AM +0200, Romain Francoise wrote:
> I upgraded from v3.16 to v3.17-rc5 and the ctr-aes-aesni encryption test
> fails, which makes my IPsec tunnels unhappy (see trace below). Before I
> start bisecting (2cddcc7df8fd3 is probably my first guess), is this
> already known?

> Sep 15 08:07:56 silenus kernel: [   35.137145] alg: skcipher: Test 4 failed on encryption for ctr-aes-aesni [...]

Update: reverting 2cddcc7df8 ("crypto: aes - AES CTR x86_64 "by8" AVX
optimization") fixes this. This machine is Sandy Bridge (Core i7-2600),
and the problem doesn't seem to occur with the exact same kernel image
on Ivy Bridge (Xeon E3-1240v2).
