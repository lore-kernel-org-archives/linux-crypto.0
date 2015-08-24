From: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] doc: crypto: warning cleanup
Date: Mon, 24 Aug 2015 02:03:42 -0600
Message-ID: <20150824020342.0361f3b5@xps.lwn.net>
References: <20150823135101.270c6630@xps.lwn.net>
	<5137031.WPPXXLuRMs@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org, linux-doc@vger.kernel.org
To: Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tex.lwn.net ([70.33.254.29]:34859 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238AbbHXIDs (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 24 Aug 2015 04:03:48 -0400
In-Reply-To: <5137031.WPPXXLuRMs@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, 24 Aug 2015 06:51:35 +0200
Stephan Mueller <smueller@chronox.de> wrote:

> This one is already in the cryptodev-2.6 kernel.
> 
> From now on, I will always CC the linux-doc mailing list on patches pertaining 
> the crypto documentation so that you can see the patches too.

Ah, OK, I should have peeked at linux-next first.

> >+ * @base: Common crypto API algorithm data structure  
> 
> I am wondering: does this really fix the issue? I tried it and it failed (i.e. 
> still produced errors by the parser) due to the exotic definition in of this 
> variable in the C code.

It fixes part of the issue.  The other required a change to kernel-doc,
which I've posted separately to linux-doc and plan to put in for 4.3.

Thanks,

jon
