From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 5/7] random: replace non-blocking pool with a
 Chacha20-based CRNG
Date: Mon, 20 Jun 2016 11:52:10 -0700
Message-ID: <b9ce7eec-e573-f187-feb5-b1110313f2ac@zytor.com>
References: <1465832919-11316-1-git-send-email-tytso@mit.edu>
 <20160620051917.GA8719@gondor.apana.org.au> <20160620150147.GD9848@thunk.org>
 <2101992.L9gKN5cFdv@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	linux-crypto@vger.kernel.org, andi@firstfloor.org,
	sandyinchina@gmail.com, jsd@av8n.com
To: Stephan Mueller <smueller@chronox.de>,
	"Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:44934 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753466AbcFTSzL (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 20 Jun 2016 14:55:11 -0400
In-Reply-To: <2101992.L9gKN5cFdv@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 06/20/16 08:49, Stephan Mueller wrote:
> Am Montag, 20. Juni 2016, 11:01:47 schrieb Theodore Ts'o:
> 
> Hi Theodore,
> 
>>
>> So simply doing chacha20 encryption in a tight loop in the kernel
>> might not be a good proxy for what would actually happen in real life
>> when someone calls getrandom(2).  (Another good question to ask is
>> when someone might be needing to generate millions of 256-bit session
>> keys per second, when the D-H setup, even if you were using ECCDH,
>> would be largely dominating the time for the connection setup anyway.)
> 
> Is speed everything we should care about? What about:
> 
> - offloading of crypto operation from the CPU
> 

This sounds like a speed operation (and very unlikely to be a win given
the usage).

> - potentially additional security features a hardware cipher may provide like 
> cache coloring attack resistance?

How about burning that bridge when and if we get to it?  It sounds very
hypothetical.

I guess I could add in some comments here about how a lot of these
problems can be eliminated by offloading an entire DRNG into hardware,
but I don't think it is productive.

	-hpa
