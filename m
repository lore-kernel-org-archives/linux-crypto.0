From: "Kevin Coffman" <kwc@citi.umich.edu>
Subject: Re: AES with CTS Mode
Date: Fri, 18 Jan 2008 09:09:52 -0500
Message-ID: <4d569c330801180609w43b4d53xd26d5298e602f6b3@mail.gmail.com>
References: <4d569c330801170742h522096ev90a34f641c35d11c@mail.gmail.com>
	 <E1JFkF6-0004jb-00@gondolin.me.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Herbert Xu" <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.233]:14893 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761690AbYAROJx (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 18 Jan 2008 09:09:53 -0500
Received: by wx-out-0506.google.com with SMTP id h31so631276wxd.4
        for <linux-crypto@vger.kernel.org>; Fri, 18 Jan 2008 06:09:52 -0800 (PST)
In-Reply-To: <E1JFkF6-0004jb-00@gondolin.me.apana.org.au>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Jan 18, 2008 12:58 AM, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> Kevin Coffman <kwc@citi.umich.edu> wrote:
> >
> > I'm obviously no expert.  I hadn't realized that CTS could be used
> > with ECB as well.  However, if I'm understanding
> > http://en.wikipedia.org/wiki/Ciphertext_stealing correctly, then
> > things are done differently for ecb vs. cbc, so a generic wrapper as
> > you are describing would have to have knowledge of the underlying
> > block mode?
>
> Yes they are different due to the presence of the IV for CBC, however,
> you can still implement it as one wrapper.  However, that is not what's
> important here.  The important thing is that you should implement CTS
> on top of "cbc(aes)", as opposed to just "aes".  That way you can use
> hardware acceleration which wouldn't be available if you were using
> AES.
>
> So I'm fine if you implement CTS such that it only works with CBC, but
> please do it so that it runs on top of the existing CBC code.
>
> > My first attempt tried to create asymmetrical input and output SG
> > lists because I was avoiding moving and copying data to make them
> > symmetric.  (What I mean by asymmetrical is that the input list may
> > have had 3 entries of length 40, 16, and 24 bytes, and the output list
> > consisted of 2 entries of 48 and 32 bytes.  As you can see, this also
> > resulted in SG list entires that were not always an even multiple of
> > the block size.)
>
> That's OK.  You can do whatever is easiest for NFS.
>
> > Is it
> > 1) a requirement that the input and output lists be symmetrical (same
> > number of entries and matching lengths for input and output entries)
> > and
>
> No.
>
> > 2) that each entry in the list deals with an even multiple of the block size?
>
> No.
>
> Cheers,
>

OK.  Thanks very much.  I'll see what I can get working.

K.C.
