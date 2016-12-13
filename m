From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 0/8] Conversion crypto API documentation to Sphinx
Date: Tue, 13 Dec 2016 16:40:01 -0700
Message-ID: <20161213164001.63fd5645@lwn.net>
References: <2053893.WjF01BJSDF@positron.chronox.de>
        <2168354.PkToFvufzV@positron.chronox.de>
        <20161213145059.5204d498@lwn.net>
        <3555336.Wm4L5bpP9y@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: Stephan =?UTF-8?B?TcO8bGxlcg==?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:46534 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751041AbcLMXkG (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2016 18:40:06 -0500
In-Reply-To: <3555336.Wm4L5bpP9y@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 13 Dec 2016 23:06:14 +0100
Stephan Müller <smueller@chronox.de> wrote:

> I am sorry, then I may have misunderstood you.
> 
> I would think that Herbert agreed that you push the entire patch set through 
> your tree, including the documentation changes to the crypto header files.
> 
> I just did a patch on the parts that touch the crypto header files. All apply 
> cleanly except patch 07/08 which has a 5 line hunk due to other changes, Is 
> that hunk ok for you, it would be great if you could take it. If you do not 
> like that hunk, we could push it through the cryptodev tree once rc-1 is out.

Clearly there was a bit of misunderstanding going around :)

I've applied the patch set to docs-next.  Oddly I had no trouble with #7,
but #2 was badly mailer-mangled and took some work.  

Anyway, it should make its way into linux-next; if there's no fireworks,
I'll endeavor to send it Linusward in time to avoid interfering with his
kitchen duties.

Sorry for the confusion,

jon
