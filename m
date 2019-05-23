Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	T_DKIMWL_WL_HIGH,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4164CC282DD
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 23:48:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F21D02175B
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 23:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558655339;
	bh=Ttd43cif/btEeH+uxc3NU8v2DB78GwmZ1/URBQWrJi8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=yhLol6pIZ4Z+TtTxWonb2U5QEwdT7CR3RRQTGyxxomV4+a9hJgkDvqkKG30X1OWnN
	 G24OAQa61OmW8qcUFDFybiNf9bOgUBXQ5JaDrvQkivKsuhb1p6/VONsJkcai8xZKNH
	 BTgRm9RcdTZ3ekJKCX/bDcXgHIfdqt7QSzY70AI8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388373AbfEWXs6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 19:48:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:53354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388232AbfEWXs5 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 19:48:57 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73EFC2133D;
        Thu, 23 May 2019 23:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558655336;
        bh=Ttd43cif/btEeH+uxc3NU8v2DB78GwmZ1/URBQWrJi8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hdNQ22ynqcndfRaX6vDuvafi9sNN5o7kHyAfpaP00KmQrXpJ9Ks8U3JMzO31EcQsV
         uwCdJdYTSbViRx8GpcW54qtI5LwLWZOEA0Q/Wspg1XzwYU1FMLGsL9rmWBIBz8Knv/
         QbJTESfc6iQwbA6xcUYKVDESxLXCR8ro80nN2gGg=
Date:   Thu, 23 May 2019 16:48:55 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: another testmgr question
Message-ID: <20190523234853.GC248378@gmail.com>
References: <AM6PR09MB3523CED0B1587FCBDE4095A0D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523185833.GA243994@google.com>
 <AM6PR09MB3523749B0306103E8D2D8315D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
 <20190523200557.GA248378@gmail.com>
 <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM6PR09MB3523DB255516D35B595AEA50D2010@AM6PR09MB3523.eurprd09.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, May 23, 2019 at 09:43:53PM +0000, Pascal Van Leeuwen wrote:
> > -----Original Message-----
> > From: Eric Biggers [mailto:ebiggers@kernel.org]
> > Sent: Thursday, May 23, 2019 10:06 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@insidesecure.com>
> > Cc: linux-crypto@vger.kernel.org
> > Subject: Re: another testmgr question
> >
> > On Thu, May 23, 2019 at 01:07:25PM +0000, Pascal Van Leeuwen wrote:
> > > Eric,
> > >
> > > I'm running into some trouble with some random vectors that do *zero*
> > > length operations. Now you can go all formal about how the API does
> > > not explictly disallow this, but how much sense does it really make
> > > to essentially encrypt, hash or authenticate absolutely *nothing*?
> > >
> > > It makes so little sense that we never bothered to support it in any
> > > of our hardware developed over the past two decades ... and no
> > > customer has ever complained about this, to the best of my knowledge.
> > >
> > > Can't you just remove those zero length tests?
> > >
> >
> > For hashes this is absolutely a valid case.  Try this:
> >
> > $ touch file
> > $ sha256sum file
> > e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  file
> >
> > That shows the SHA-256 digest of the empty message.
> >
> Valid? A totally fabricated case, if you ask me. Yes, you could do that,
> but is it *useful* at all? Really?
> No, it's not because a file of length 0 is a file of length 0, the length
> in itself is sufficient guarantee of its contents. The hash does not add
> *anything* in this case. It's a constant anyway, the same value for *any*
> zero-length file. It doesn't tell you anything you didn't already know.
> IMHO the tool should just return a message stating "hashing an empty file
> does not make any sense at all ...".
> 

Of course it's useful.  It means that *every* possible file has a SHA-256
digest.  So if you're validating a file, you just check the SHA-256 digest; or
if you're creating a manifest, you just hash the file and list the SHA-256
digest.  Making everyone handle empty files specially would be insane.

> >
> > For AEADs it's a valid case too.  You still get an authenticated ciphertext
> > even
> > if the plaintext and/or AAD are empty, telling you that the (plaintext, AAD)
> > pair is authentically from someone with the key.
> >
> Again, you could *theoretically* do that, but I don't know of any *practicle*
> use  case (protocol, application) where you can have *and* 0 length AAD *and*
> 0 length payload (but do correct me when I'm wrong there!)
> In any case, that would result in a value *only* depending on the key (same
> thing applies to zero-length HMAC), which is likely some sort of security
> risk anyway.
> 
> As I mentioned before, we made a lot of hashing and authentication hardware
> over the past 20+ years that has never been capable of doing zero-length
> operations and this has *never* proved to be a problem to *anyone*. Not a
> single support question has *ever* been raised on the subject.
> 

The standard attack model for MACs assumes the attacker can send an arbitrary
(message, MAC) pair.  Depending on the protocol there may be nothing preventing
them from sending an empty message, e.g. maybe it's just a file on the
filesystem which can be empty.  So it makes perfect sense for the HMAC of an
empty message to be defined so that it can be checked without a special case for
empty messages, and indeed the HMAC specification
(https://csrc.nist.gov/csrc/media/publications/fips/198/1/final/documents/fips-198-1_final.pdf)
clearly says that 0 is an allowed input length.  Note that the algorithmic
description of HMAC handles this case naturally; indeed, it would be a special
case if 0 were *not* allowed.

Essentially the same applies for AEADs.

> >
> > It's really only skciphers (length preserving encryption) where it's
> > questionable, since for those an empty input can only map to an empty output.
> >
> True, although that's also the least problematic case to handle.
> Doing nothing at all is not so hard ...
> 
> > Regardless of what we do, I think it's really important that the behavior is
> > *consistent*, so users see the same behavior no matter what implementation of
> > the algorithm is used.
> >
> Consistency should only be required for *legal* ranges of input parameters.
> Which then obviously need to be properly specified somewhere.
> It should be fair to put some reasonable restrictions on these inputs as to
> not burden implementions with potentially difficult to handle fringe cases.
> 

People can develop weird dependencies on corner cases of APIs, so it's best to
avoid cases where the behavior differs depending on which implementation of the
API is used.  So far it's been pretty straightforward to get all the crypto
implementations consistent, so IMO we should simply continue to do that.

What might make sense is moving more checks into the common code so that
implementations need to handle less, e.g. see how
https://patchwork.kernel.org/patch/10949189/ proposed to check the message
length alignment for skciphers (though that particular patch is broken as-is).

- Eric
