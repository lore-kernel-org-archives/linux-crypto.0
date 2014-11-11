From: Daniel Borkmann <dborkman@redhat.com>
Subject: Re: crypto: zeroization of sensitive data in af_alg
Date: Tue, 11 Nov 2014 10:19:20 +0100
Message-ID: <5461D498.1000502@redhat.com>
References: <1979092.odOtqL46qU@tachyon.chronox.de> <CACXcFmmp=SMisc0p-Fx=M3myXE0E-kH3zN6NGrODeVzQrXUdFA@mail.gmail.com> <3021915.VU7Ypy9It6@tachyon.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Sandy Harris <sandyinchina@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39080 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751544AbaKKJTi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 11 Nov 2014 04:19:38 -0500
In-Reply-To: <3021915.VU7Ypy9It6@tachyon.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 11/11/2014 05:16 AM, Stephan Mueller wrote:
...
> That is a good idea.
>
> Herbert: I can prepare a patch that uses memzero_explicit. However, your
> current tree does not yet implement that function as it was added to Linus'
> tree after you pulled from it.

Yep, Ted took it [1] on top of the random driver fix as discussed.

   [1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=7185ad2672a7d50bc384de0e38d90b75d99f3d82
