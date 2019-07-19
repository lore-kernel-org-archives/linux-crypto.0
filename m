Return-Path: <SRS0=r9n1=VQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DDF4C7618F
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 19:56:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0EE121873
	for <linux-crypto@archiver.kernel.org>; Fri, 19 Jul 2019 19:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563566216;
	bh=jb8v4a7xy2eJsy2Ic4qH1osNN7HIz5f9OeZf3HDfIBs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=gJtevcDxuAuT+dbCnUqJxmPJlQbZuqvz2YpTweA/hviGzbwno/uV6YLZEZTD4iarP
	 dgm4wfJDCWvzZ+WlFqWUWemCbCLWoWUP62AjhRcpAl3MhbOeDiaRRkTw2ydFfulkUd
	 F8oX2p0E8lRvgXBAqKIp/KVoaO0zNJNt0qWdkxKs=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbfGST4z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 19 Jul 2019 15:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727602AbfGST4z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 19 Jul 2019 15:56:55 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBC7A2186A;
        Fri, 19 Jul 2019 19:56:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563566215;
        bh=jb8v4a7xy2eJsy2Ic4qH1osNN7HIz5f9OeZf3HDfIBs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nZvxrSdknAcNtA/SC3deOvWLIdTCfkReSG8kFQjHKbzi61WeD1/V8bGIj0gV2XZ8h
         QeAnicJaJQZIMVlHyLRXeYtPcuy9v69w70MnMswzoDviJaH+RnQODfOgtjJTXV2yjJ
         5NGSb4JcazT7F30PObEe6lPJJyyC+Cre0CRgRZQ0=
Date:   Fri, 19 Jul 2019 12:56:53 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: ghash
Message-ID: <20190719195652.GC1422@gmail.com>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <MN2PR20MB29737F1F60B3CBACBC4BD287CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190719161606.GA1422@gmail.com>
 <MN2PR20MB297309BE544695C1B7B3CB21CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB297309BE544695C1B7B3CB21CACB0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Pascal,

On Fri, Jul 19, 2019 at 07:26:02PM +0000, Pascal Van Leeuwen wrote:
> > -----Original Message-----
> > From: linux-crypto-owner@vger.kernel.org <linux-crypto-owner@vger.kernel.org> On Behalf Of Eric Biggers
> > Sent: Friday, July 19, 2019 6:16 PM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: linux-crypto@vger.kernel.org; Herbert Xu <herbert@gondor.apana.org.au>; davem@davemloft.net
> > Subject: Re: ghash
> > 
> > On Fri, Jul 19, 2019 at 02:05:01PM +0000, Pascal Van Leeuwen wrote:
> > > Hi,
> > >
> > > While implementing GHASH support for the inside-secure driver and wondering why I couldn't get
> > > the test vectors to pass I have come to the conclusion that ghash-generic.c actually does *not*
> > > implement GHASH at all. It merely implements the underlying chained GF multiplication, which,
> > > I understand, is convenient as a building block for e.g. aes-gcm but is is NOT the full GHASH.
> > > Most importantly, it does NOT actually close the hash, so you can trivially add more data to the
> > > authenticated block (i.e. the resulting output cannot be used directly without external closing)
> > >
> > > GHASH is defined as GHASH(H,A,C) whereby you do this chained GF multiply on a block of AAD
> > > data padded to 16 byte alignment with zeroes, followed by a block of ciphertext padded to 16
> > > byte alignment with zeroes, followed by a block that contains both AAD and cipher length.
> > >
> > > See also https://en.wikipedia.org/wiki/Galois/Counter_Mode
> > >
> > > Regards,
> > > Pascal van Leeuwen
> > > Silicon IP Architect, Multi-Protocol Engines @ Verimatrix
> > > www.insidesecure.com
> > >
> > 
> > Yes that's correct.  The hash APIs don't support multi-argument hashes, so
> > there's no natural way for it to be "full GHASH".  So it relies on the caller to
> > format the AAD and ciphertext into a single stream.  IMO it really should be
> > called something like "ghash_core".
> > 
> > Do you have some question or suggestion, or was this just an observation?
> > 
> Well, considering it's pretending to be GHASH I was more less considering this a bug report ...
> 
> There's the inherent danger that someone not aware of the actual implementation tries to
> use it as some efficient (e.g. due to instruction set support) secure authentication function.
> Which, without proper external data formatting, it's surely not in its current form. This is 
> not something you will actually notice when just using it locally for something (until
> someone actually breaks it).

You do understand that GHASH is not a MAC, right?  It's only a universal
function.  Specifically, "almost-epsilon-XOR-universal".  So even if there was a
more natural API to access GHASH, it's still incorrect to use it outside of a
properly reviewed crypto mode of operation.  IOW, anyone using GHASH directly as
a MAC is screwed anyway no matter which API they are using, or misusing.

> 
> And then there was the issue of wanting the offload it to hardware, but that's kind of hard
> if the software implementation does not follow the spec where the hardware does ...
> 
> I think more care should be taken with the algorithm naming - if it has a certain name, 
> you expect it to follow the matching specification (fully). I have already identified 2 cases 
> now (xts and ghash) where that is not actually the case.
> 

If you take an (AD, Ctext) pair and format it into a single data stream the way
the API requires, then you will get the result defined by the specification.  So
it does follow the specification as best it can given the API which takes a
single data stream.  As I said though, I think "ghash_core" would be a better
name.  Note that it was added 10 years ago; I'm not sure it can actually be
renamed, but there may be a chance since no one should be using it directly.

So are you proposing that it be renamed?  Or are you proposing that a multi
argument hashing API be added?  Or are you proposing that universal functions
not be exposed through the crypto API?  What specifically is your constructive
suggestion to improve things?

- Eric
