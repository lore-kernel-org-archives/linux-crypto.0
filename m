From: Rabin Vincent <rabin.vincent@axis.com>
Subject: Re: [PATCH] crypto: doc - Fix hash export state information
Date: Thu, 26 Jan 2017 16:33:37 +0100
Message-ID: <20170126153336.GA31875@axis.com>
References: <1485359706-7184-1-git-send-email-rabin.vincent@axis.com>
 <5671933.EqcuFpxzUF@tauon.atsec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from bes.se.axis.com ([195.60.68.10]:58511 "EHLO bes.se.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753581AbdAZPdp (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 26 Jan 2017 10:33:45 -0500
Content-Disposition: inline
In-Reply-To: <5671933.EqcuFpxzUF@tauon.atsec.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Jan 25, 2017 at 05:18:05PM +0100, Stephan Müller wrote:
> Am Mittwoch, 25. Januar 2017, 16:55:06 CET schrieb Rabin Vincent:
> > The documentation states that crypto_ahash_reqsize() provides the size
> > of the state structure used by crypto_ahash_export().  But it's actually
> > crypto_ahash_statesize() which provides this size.
> 
> ack for the statesize documentation addition.
> 
> In addition, can you please add crypto_ahash_statesize to Documentation/
> crypto/api-digest.rst.

OK.

> nack - The documentation is quite right for reqsize: it returns the *request 
> data structure* size as documented.

It's only that one line which is correct, the rest of the documentation
talked about the state size.  I'll add back that one line, since similar
functions like crypto_aead_reqsize() have it.
