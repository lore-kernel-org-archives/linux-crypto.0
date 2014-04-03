From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: algif for compression?
Date: Thu, 3 Apr 2014 20:41:36 +0800
Message-ID: <20140403124136.GA32279@gondor.apana.org.au>
References: <CALZtONBFtCqQEfOgjNs_MqLm0xXP+9QK47a1t_HE4DuUBkxpsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Dan Streetman <ddstreet@ieee.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ringil.hengli.com.au ([178.18.16.133]:53869 "EHLO
	ringil.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751655AbaDCMlk (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 3 Apr 2014 08:41:40 -0400
Content-Disposition: inline
In-Reply-To: <CALZtONBFtCqQEfOgjNs_MqLm0xXP+9QK47a1t_HE4DuUBkxpsg@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Dan Streetman <ddstreet@ieee.org> wrote:
> I see the algif_hash and algif_blkcipher implementations to allow
> userspace AF_ALG socket access to kernel blkcipher and hash
> algorithms, but has anyone done a algif_compression to allow userspace
> access to compression algs?  I'm asking specifically wrt the 842
> crypto module, which uses the hardware compression coprocessors on
> newer powerpc systems.
> 
> If not, is there any reason against adding a algif_compression to
> provide the access?

For a start nx-842 isn't even hooked into the crypto layer so
there is no chance of exporting it through algif as is.

There is no reason why you couldn't add it of course but that'd
be a first step.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
