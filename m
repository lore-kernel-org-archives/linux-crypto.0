From: "Kevin Coffman" <kwc@citi.umich.edu>
Subject: Re: AES with CTS Mode
Date: Thu, 17 Jan 2008 10:42:05 -0500
Message-ID: <4d569c330801170742h522096ev90a34f641c35d11c@mail.gmail.com>
References: <4d569c330801151228o1cf32b2dn6f6e49922b1036e9@mail.gmail.com>
	 <20080117044406.GC6221@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:31315 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbYAQPmH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 17 Jan 2008 10:42:07 -0500
Received: by wr-out-0506.google.com with SMTP id c49so224745wra.1
        for <linux-crypto@vger.kernel.org>; Thu, 17 Jan 2008 07:42:05 -0800 (PST)
In-Reply-To: <20080117044406.GC6221@gondor.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Jan 16, 2008 11:44 PM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, Jan 15, 2008 at 08:28:15PM +0000, Kevin Coffman wrote:
> > I need to implement AES with CTS mode for NFSv4 (rfc3962 & rfc4121).
>
> I love new algorithm submissions :)
>
> > I have implemented CTS starting with a copy of CBC (crypto/cbc.c),
> > since CTS is the same as CBC except for the last two blocks.
>
> I think you're going about this the hard way.  CTS should be done as
> a generic wrapper on top of any existing block mode of operations.
> In other words, the final result should look like "cts(cbc(aes))".
>
> That means you don't need to implement anything specific to CBC.

Thanks for the reply.

I'm obviously no expert.  I hadn't realized that CTS could be used
with ECB as well.  However, if I'm understanding
http://en.wikipedia.org/wiki/Ciphertext_stealing correctly, then
things are done differently for ecb vs. cbc, so a generic wrapper as
you are describing would have to have knowledge of the underlying
block mode?

> > A problem that I'm running into is that the NFS/RPC code needs to call
> > the crypt functions in chunks as we currently do for other encryption
> > types.  However, I am not seeing a way to inform the crypto code of
> > the total length to be encrypted such that it can just do regular CBC
> > until the last two blocks (of the last chunk).
>
> If you can put the entire plain text into one SG list then it would
> be best.  If not then just do as you described and feed whole blocks
> to plain CBC until you reach the last two and give them to CTS.

I'll attempt a single SG list again.  My first attempt failed.  Which
brings up a question:

My first attempt tried to create asymmetrical input and output SG
lists because I was avoiding moving and copying data to make them
symmetric.  (What I mean by asymmetrical is that the input list may
have had 3 entries of length 40, 16, and 24 bytes, and the output list
consisted of 2 entries of 48 and 32 bytes.  As you can see, this also
resulted in SG list entires that were not always an even multiple of
the block size.)

Is it
1) a requirement that the input and output lists be symmetrical (same
number of entries and matching lengths for input and output entries)
and
2) that each entry in the list deals with an even multiple of the block size?

Thanks,
K.C.
