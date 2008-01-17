From: "Kevin Coffman" <kwc@citi.umich.edu>
Subject: Re: AES with CTS Mode
Date: Wed, 16 Jan 2008 19:10:41 -0500
Message-ID: <4d569c330801161610o8c3617od7f157605a1d09f4@mail.gmail.com>
References: <4d569c330801151228o1cf32b2dn6f6e49922b1036e9@mail.gmail.com>
	 <1200517999.13706.6.camel@faith.austin.ibm.com>
	 <4d569c330801161351q4e48d448yff9ae08a2cc2e8bd@mail.gmail.com>
	 <1200525886.13706.36.camel@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-crypto@vger.kernel.org
To: "Joy Latten" <latten@austin.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.224]:4576 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbYAQAKm (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 16 Jan 2008 19:10:42 -0500
Received: by wx-out-0506.google.com with SMTP id h31so296259wxd.4
        for <linux-crypto@vger.kernel.org>; Wed, 16 Jan 2008 16:10:41 -0800 (PST)
In-Reply-To: <1200525886.13706.36.camel@faith.austin.ibm.com>
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Jan 16, 2008 6:24 PM, Joy Latten <latten@austin.ibm.com> wrote:
> On Wed, 2008-01-16 at 16:51 -0500, Kevin Coffman wrote:
> > On Jan 16, 2008 4:13 PM, Joy Latten <latten@austin.ibm.com> wrote:
> > > On Tue, 2008-01-15 at 15:28 -0500, Kevin Coffman wrote:
> > > > Hello,
> > > > I need to implement AES with CTS mode for NFSv4 (rfc3962 & rfc4121).
> > > >
> > > > I have implemented CTS starting with a copy of CBC (crypto/cbc.c),
> > > > since CTS is the same as CBC except for the last two blocks.
> > > >
> > >
> > > I am not sure I understand, but couldn't you use the CTS in cryptoapi?
> > >
> > > regards,
> > > Joy
> >
> > Thanks for the reply!  It may be me that doesn't understand.  I'm
> > currently stuck at 2.6.24-rc3.  I do see messages about CTR mode being
> > added -- which I think is different than CTS?
> >
> > If CTS is already available, please give me more details of where to
> > find it and ignore the rest of this rambling!
>
> Geez I really jumbled up my acronyms! You were talking about CTS, not
> CTR. :-)
>
> > To (hopefully) better explain my problem, because of data placement
> > and alignment issues, we currently call crypto_blkcipher_encrypt_iv()
> > multiple times for a single RPC request (i.e. a large data write).
> > This works fine with CBC mode (used by DES and 3DES) since there is no
> > difference in how any of the blocks are treated, as long as the IV is
> > carried forward correctly.
> >
> > When trying to do the same for AES with CTS, each trip into
> > crypto_blkcipher_encrypt_iv() treats the last two blocks of that
> > "chunk" differently.  So what I think I need is a way to tell the code
> > up front that I'm going to be calling it several times and not to do
> > the CTS trick until the last "chunk" containing the last two blocks.
> > (That is simplifying it a bit, since the last chunk may not be two
> > blocks long... Also, the last block may not be a complete block.)
> >
> Ah, I understand.
> I am definitely not an expert, so I don't know how acceptable my
> suggestion is, but perhaps arranging CTS such that there is
> a function that only does the CBC part and a function that does the
> "CTS trick". Then your "encrypt" function can appropriately call both
> the CBC part and "CTS trick" part. That way, other routines that want
> to encrypt all in one call can do so. And your NFS code, could call
> the CBC and "CTS trick" parts directly as needed. I haven't fully
> thought this through, so I could be missing something...
>
> regards,
> Joy

Thanks for your suggestion.  We discussed a similar strategy here today.

For the rpcsecgss code, we need to handle several encryption
algorithms for Kerberos; and currently have generic code to handle
encrypting/decrypting an xdr_buffer.  If possible, I'd like to avoid
adding special code there to handle cts(aes) differently.  I'd prefer
to hide those details as much as possible within the crypto code.  I
do understand that this may not be possible...

Thanks again,
K.C.
