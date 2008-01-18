From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: AES with CTS Mode
Date: Fri, 18 Jan 2008 16:58:16 +1100
Message-ID: <E1JFkF6-0004jb-00@gondolin.me.apana.org.au>
References: <4d569c330801170742h522096ev90a34f641c35d11c@mail.gmail.com>
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: kwc@citi.umich.edu (Kevin Coffman)
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from rhun.apana.org.au ([64.62.148.172]:59443 "EHLO
	arnor.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753220AbYARF6T (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Jan 2008 00:58:19 -0500
In-Reply-To: <4d569c330801170742h522096ev90a34f641c35d11c@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Kevin Coffman <kwc@citi.umich.edu> wrote:
> 
> I'm obviously no expert.  I hadn't realized that CTS could be used
> with ECB as well.  However, if I'm understanding
> http://en.wikipedia.org/wiki/Ciphertext_stealing correctly, then
> things are done differently for ecb vs. cbc, so a generic wrapper as
> you are describing would have to have knowledge of the underlying
> block mode?

Yes they are different due to the presence of the IV for CBC, however,
you can still implement it as one wrapper.  However, that is not what's
important here.  The important thing is that you should implement CTS
on top of "cbc(aes)", as opposed to just "aes".  That way you can use
hardware acceleration which wouldn't be available if you were using
AES.

So I'm fine if you implement CTS such that it only works with CBC, but
please do it so that it runs on top of the existing CBC code.

> My first attempt tried to create asymmetrical input and output SG
> lists because I was avoiding moving and copying data to make them
> symmetric.  (What I mean by asymmetrical is that the input list may
> have had 3 entries of length 40, 16, and 24 bytes, and the output list
> consisted of 2 entries of 48 and 32 bytes.  As you can see, this also
> resulted in SG list entires that were not always an even multiple of
> the block size.)

That's OK.  You can do whatever is easiest for NFS.

> Is it
> 1) a requirement that the input and output lists be symmetrical (same
> number of entries and matching lengths for input and output entries)
> and

No.

> 2) that each entry in the list deals with an even multiple of the block size?

No.

Cheers,
-- 
Visit Openswan at http://www.openswan.org/
Email: Herbert Xu ~{PmV>HI~} <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
