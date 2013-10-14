From: Stephan Mueller <smueller@chronox.de>
Subject: Re: Fwd: [PATCH] CPU Jitter RNG: inclusion into kernel crypto API and /dev/random
Date: Mon, 14 Oct 2013 16:26:18 +0200
Message-ID: <1986949.99Vxe5uoXS@tauon>
References: <2579337.FPgJGgHYdz@tauon> <CACXcFm=3Ee1+HGYRpsjhFMwqn2t15qAZNnMpZ8jOsE_HkB2CPg@mail.gmail.com> <5084508.OCAIYQezeq@tauon>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: Theodore Ts'o <tytso@mit.edu>, LKML <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org
To: Sandy Harris <sandyinchina@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.eperm.de ([89.247.134.16]:53937 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab3JNO03 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 14 Oct 2013 10:26:29 -0400
Received: from tauon.localnet
	by mail.eperm.de with [XMail 1.27 ESMTP Server]
	id <S15D> for <linux-crypto@vger.kernel.org> from <smueller@chronox.de>;
	Mon, 14 Oct 2013 16:26:19 +0200
In-Reply-To: <5084508.OCAIYQezeq@tauon>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Am Montag, 14. Oktober 2013, 16:12:24 schrieb Stephan Mueller:

Hi Sandy,

>
>(PS: I am aware that in case none of the individual bits would contain
>one full bit of entropy, the folding operation may --mathematically
>spoken-- not deliver one full bit of entropy. However, after speaking
>with a mathematician, that slight inconsistency is ok, if I can show
>that the distribution of the folded bit is 50% zeros and 50% ones. That
>is what I did in section 5.2.1. Thus, the conclusion is that I receive
>one bit of entropy after the folding loop.)

One followup on this issue: if one believes that he has a problem with 
that consideration, he can initialize the CPU Jitter RNG with an 
oversampling rate. That rate simply performs the folding operation 64 
times oversampling rate.

To fill the entropy pool completely once, the RNG needs 64 time deltas 
which are folded into the one bit. All the oversampling rate now does is 
to calculate more than once the complete entropy pool.

For example, when you set the oversampling rate to 2, you need twice as 
long for the random value as each bit the random value is calculated 
twice. And the two independent 64 bit random values are simply XORed 
together.

You can set the oversampling rate to any value above 1.

Ciao
Stephan
