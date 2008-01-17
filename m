From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AES with CTS Mode
Date: Thu, 17 Jan 2008 15:44:06 +1100
Message-ID: <20080117044406.GC6221@gondor.apana.org.au>
References: <4d569c330801151228o1cf32b2dn6f6e49922b1036e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Kevin Coffman <kwc@citi.umich.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:57952 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752983AbYAQEoJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jan 2008 23:44:09 -0500
Content-Disposition: inline
In-Reply-To: <4d569c330801151228o1cf32b2dn6f6e49922b1036e9@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 15, 2008 at 08:28:15PM +0000, Kevin Coffman wrote:
> I need to implement AES with CTS mode for NFSv4 (rfc3962 & rfc4121).

I love new algorithm submissions :)

> I have implemented CTS starting with a copy of CBC (crypto/cbc.c),
> since CTS is the same as CBC except for the last two blocks.

I think you're going about this the hard way.  CTS should be done as
a generic wrapper on top of any existing block mode of operations.
In other words, the final result should look like "cts(cbc(aes))".

That means you don't need to implement anything specific to CBC.

> A problem that I'm running into is that the NFS/RPC code needs to call
> the crypt functions in chunks as we currently do for other encryption
> types.  However, I am not seeing a way to inform the crypto code of
> the total length to be encrypted such that it can just do regular CBC
> until the last two blocks (of the last chunk).

If you can put the entire plain text into one SG list then it would
be best.  If not then just do as you described and feed whole blocks
to plain CBC until you reach the last two and give them to CTS.

Thanks,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
