From: Sebastian Siewior <linux-crypto@ml.breakpoint.cc>
Subject: Re: [RFC] [crypto] padlock-aes loadkey ondemand
Date: Sun, 30 Mar 2008 23:01:52 +0200
Message-ID: <20080330210152.GA25597@Chamillionaire.breakpoint.cc>
References: <20080328223333.GB24018@Chamillionaire.breakpoint.cc> <47EFE3F6.4060704@the2masters.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Cc: linux-crypto@vger.kernel.org
To: Stefan Hellermann <stefan@the2masters.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:43936 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395AbYC3VBy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 30 Mar 2008 17:01:54 -0400
Content-Disposition: inline
In-Reply-To: <47EFE3F6.4060704@the2masters.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

* Stefan Hellermann | 2008-03-30 21:03:18 [+0200]:

>Hi,
Hi,

>I tested this patch with success, "512 bit key, 8192 byte blocks" is 29% faster!
That's something.

>Thanks for this work!
np :)

>Tested-By: Stefan Hellermann
>
>(Or what is the appropriate line here?)
I thing that is okey if we add some numbers you provided.

>Here's tcrypt mode=200 output for xts without this patch
As far as I remember you posted once some MiB/sec dm-crypt numbers the
last time. Could you please post them as well since I don't which block
size is the majority of the read/write request.

>But it's far away from aes(cbc)
>test 14 (256 bit key, 8192 byte blocks): 1 operation in 8912 cycles (8192 bytes)
>... cbc is now only 10 times faster, not 14 times :)
hehe

>Stefan
Sebastian
