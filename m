From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 0/8] Conversion crypto API documentation to Sphinx
Date: Tue, 13 Dec 2016 14:50:59 -0700
Message-ID: <20161213145059.5204d498@lwn.net>
References: <2053893.WjF01BJSDF@positron.chronox.de>
        <1645861.DSRXbPG5tl@positron.chronox.de>
        <20161025023549.GA17875@gondor.apana.org.au>
        <2168354.PkToFvufzV@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: Stephan =?UTF-8?B?TcO8bGxlcg==?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ms.lwn.net ([45.79.88.28]:45998 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932896AbcLMVxB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 13 Dec 2016 16:53:01 -0500
In-Reply-To: <2168354.PkToFvufzV@positron.chronox.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 13 Dec 2016 22:25:07 +0100
Stephan Müller <smueller@chronox.de> wrote:

> Considering that a large batch of documentation updates just landed in Linus' 
> tree, I am wondering why the crypto API documentation update is not among it.

Well, I'd asked if I could run the documentation-specific parts through
docs-next.  I guess I was waiting for a version of the patch set with just
that, rather than intermixed with a bunch of crypto-side changes.  Were
you expecting me to take the whole set?

I can still try to do that, I guess; let me know if I should try to set
the whole set upward.

jon
