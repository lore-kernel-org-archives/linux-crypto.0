Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68B08C7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 21:48:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31F6E21880
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 21:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563572896;
	bh=1XEmkQKGFVNOIXIzmTd2zso65s/+S5+DhVa4UxKPmCg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=HBAuA0rHI/JRL3x0sO0Uix808Q86Oi3dj2I9c4PuDwNEVo+4F5PX5nJ12pBt//jD8
	 1JIRDh1kcBi0TxkGgqXz9zN0QATjL0W3BB+mECmlkMkP4kz0hD5j+HOzqRFlu4Zb9P
	 q46HFvUI9bLvbIO1m7UWn6MY+TvM3BH0HFVCAVa4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727577AbfGSVsP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 17:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:49576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729964AbfGSVsP (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 17:48:15 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 018EE2184E;
        Fri, 19 Jul 2019 21:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563572894;
        bh=1XEmkQKGFVNOIXIzmTd2zso65s/+S5+DhVa4UxKPmCg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=walJPqnQW4Qny/xRhZicf2HFreH1dvEHY7QvVMsviPVfJnLuAD1eJxDRB0t0O2SVD
         bpLN5DvicOc/BEbq7ZROcRrQQK0Qsul3jDBZciyNANYPb/pr2/Rq5vyUR+p7pUsQgt
         tEmehG40dg1s4JvkHfrOJepGqtvv2EsfTVGGUro4=
Date:   Fri, 19 Jul 2019 14:48:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: ghash
Message-ID: <20190719214811.GE1422@gmail.com>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <MN2PR20MB29737F1F60B3CBACBC4BD287CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719161606.GA1422@gmail.com>
 <MN2PR20MB297309BE544695C1B7B3CB21CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719195652.GC1422@gmail.com>
 <MN2PR20MB2973FF077218AB3C2DF2E4A0CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973FF077218AB3C2DF2E4A0CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 19, 2019 at 08:49:02PM +0000, Pascal Van Leeuwen wrote:
> Hi Eric,
> 
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of Eric Biggers
> > Sent: Friday, July 19, 2019 9:57 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.au>; davem@davemloft.net
> > Subject: Re: ghash
> > 
> > Hi Pascal,
> > 
> > On Fri, Jul 19, 2019 at 07:26:02PM +0000, Pascal Van Leeuwen wrote:
> > > > -----Original Message-----
> > > > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of Eric Biggers
> > > > Sent: Friday, July 19, 2019 6:16 PM
> > > > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > > > Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.au>; davem@davemloft.net
> > > > Subject: Re: ghash
> > > >
> > > > On Fri, Jul 19, 2019 at 02:05:01PM +0000, Pascal Van Leeuwen wrote:
> > > > > Hi,
> > > > >
> > > > > While implementing GHASH support for the inside-secure driver and wondering why I couldn't get
> > > > > the test vectors to pass I have come to the conclusion that ghash-generic.c actually does *not*
> > > > > implement GHASH at all. It merely implements the underlying chained GF multiplication, which,
> > > > > I understand, is convenient as a building block for e.g. aes-gcm but is is NOT the full GHASH.
> > > > > Most importantly, it does NOT actually close the hash, so you can trivially add more data to the
> > > > > authenticated block (i.e. the resulting output cannot be used directly without external closing)
> > > > >
> > > > > GHASH is defined as GHASH(H,A,C) whereby you do this chained GF multiply on a block of AAD
> > > > > data padded to 16 byte alignment with zeroes, followed by a block of ciphertext padded to 16
> > > > > byte alignment with zeroes, followed by a block that contains both AAD and cipher length.
> > > > >
> > > > > See also https://en.wikipedia.org/wiki/Galois/Counter_Mode
> > > > >
> > > > > Regards,
> > > > > Pascal van Leeuwen
> > > > > Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> > > > > www.insidesecure.com
> > > > >
> > > >
> > > > Yes that's correct.  The hash APIs don't support multi-argument hashes, so
> > > > there's no natural way for it to be "full GHASH".  So it relies on the caller to
> > > > format the AAD and ciphertext into a single stream.  IMO it really should be
> > > > called something like "ghash_core".
> > > >
> > > > Do you have some question or suggestion, or was this just an observation?
> > > >
> > > Well, considering it's pretending to be GHASH I was more less considering this a bug report ...
> > >
> > > There's the inherent danger that someone not aware of the actual implementation tries to
> > > use it as some efficient (e.g. due to instruction set support) secure authentication function.
> > > Which, without proper external data formatting, it's surely not in its current form. This is
> > > not something you will actually notice when just using it locally for something (until
> > > someone actually breaks it).
> > 
> > You do understand that GHASH is not a MAC, right?  It's only a universal
> > function.  
> >
> It's a universal keyed hash. Which you could use as a MAC, although, admittedly,
> it would be rather weak, which is why the tag is usually additionally encrypted.
> (which you could do externally, knowing that that's needed with GHASH)
> In any case, the crypto API's ghash does not do what you would expect of a GHASH.

Well you could also use CRC-32 "as a MAC".  That doesn't actually make it a MAC.

> 
> > Specifically, "almost-epsilon-XOR-universal".  So even if there was a
> > more natural API to access GHASH, it's still incorrect to use it outside of a
> > properly reviewed crypto mode of operation.  IOW, anyone using GHASH directly as
> > a MAC is screwed anyway no matter which API they are using, or misusing.
> > 
> "Anyone" may actually know what they're doing. But rely on ghash being GHASH ...
> So this is a rather lame argument.
> 
> > >
> > > And then there was the issue of wanting the offload it to hardware, but that's kind of hard
> > > if the software implementation does not follow the spec where the hardware does ...
> > >
> > > I think more care should be taken with the algorithm naming - if it has a certain name,
> > > you expect it to follow the matching specification (fully). I have already identified 2 cases
> > > now (xts and ghash) where that is not actually the case.
> > >
> > 
> > If you take an (AD, Ctext) pair and format it into a single data stream the way
> > the API requires, then you will get the result defined by the specification.  So
> > it does follow the specification as best it can given the API which takes a
> > single data stream.  As I said though, I think "ghash_core" would be a better
> > name.  Note that it was added 10 years ago; I'm not sure it can actually be
> > renamed, but there may be a chance since no one should be using it directly.
> > 
> Ok, I understand that it's legacy so maybe we should keep it as is.
> It's terribly confusing though - I spent days trying to get my acceleration to
> work (i.e. pass testmgr) only to realise after reverse engineering the generic 
> implementation that it's not really ghash at all.
> 
> I guess the real problem is that this information can currently only be 
> obtained by fully reverse engineering the implementation. And I'm a firm
> believer in the natural order of things: programmers write code, compilers 
> read code, not the other way around ...
> 
> > So are you proposing that it be renamed?  Or are you proposing that a multi
> > argument hashing API be added?  Or are you proposing that universal functions
> > not be exposed through the crypto API?  What specifically is your constructive
> > suggestion to improve things?
> > 
> I guess my constructive suggestion *for the future* would be to be more careful
> with the naming. Don't give something a "known" name if it does not comply with
> the matching specification. Renaming stuff now is probably counter-productive,
> but putting some remarks somewhere (near the actual test vectors may work?)
> about implementation x not actually being known entity X would be nice.
> (Or even just some reference on where the test vectors came from!)
> 

I think a comment at the top of ghash-generic.c would be helpful, similar to the
one I wrote in nhpoly1305.c explaining that particular algorithm.

I'm surprised that you spent "days" debugging this, though.  Since the API gives
you a single data stream, surely you would have had to check at some point how
the two formal arguments (AAD, ciphertext) were encoded into it?  Were you just
passing the whole thing as the AAD or something?  Also to reiterate, it actually
does implement the GHASH algorithm correctly; the two formal parameters just
have to be encoded into the single data stream in a particular way.

- Eric
