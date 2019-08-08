Return-Path: <SRS0=IdBJ=WE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE560C433FF
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 08:31:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 23C6C2171F
	for <linux-crypto@archiver.kernel.org>; Thu,  8 Aug 2019 08:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565253063;
	bh=5ESMyMBNu6p05v5ED3QRTCllbzhyiTHzmWVYmG71cxM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DiZ4YuQE0Vs4NY3HgrXCRpFF7e8m0DBKRAslVYsmlv0QpD+eJhh3CCaDTThYqCk10
	 8DHjBBpImM5Ql5I7NnhN8T06ByeboeeXl3mjlcs1Yz4oagQQItA0AgYgaqdZX60c3P
	 W48uhIjEY6dTzy9f6chRBrZpqnlnNa02LbuAbTqU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731719AbfHHIbC (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 8 Aug 2019 04:31:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:48096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731592AbfHHIbC (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 8 Aug 2019 04:31:02 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA236214C6;
        Thu,  8 Aug 2019 08:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565253061;
        bh=5ESMyMBNu6p05v5ED3QRTCllbzhyiTHzmWVYmG71cxM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N3ULtNqvBu60Tv9ro9tXW0UY6SDj9hj3GqVfecTVKX4UP8lRD66ng8u147qkARZDb
         rJzuWmSYrzVvFv9VV4gBSGDhzwHkU++GMZgW1WvboalMp6d3cpHnMOxyLj7D8oBCvd
         WJWei+akZWXQhxbXg7B1tjqKzYD31j/gRugPhv5M=
Date:   Thu, 8 Aug 2019 01:30:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "gmazyland@gmail.com" <gmazyland@gmail.com>
Subject: Re: [RFC PATCH v2] md/dm-crypt - reuse eboiv skcipher for IV
 generation
Message-ID: <20190808083059.GB5319@sol.localdomain>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "gmazyland@gmail.com" <gmazyland@gmail.com>
References: <20190807055022.15551-1-ard.biesheuvel@linaro.org>
 <MN2PR20MB297336108DF89337DDEEE2F6CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu_jFW26boEhpnAZg9sjWWZf60FXSWuSqNvC5FJiL7EVSA@mail.gmail.com>
 <MN2PR20MB2973A02FC4D6F1D11BA80792CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
 <CAKv+Gu8fgg=gt4LSnCfShnf0-PZ=B1TNwM3zdQr+V6hkozgDOA@mail.gmail.com>
 <MN2PR20MB29733EEF59CCD754256D5621CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB29733EEF59CCD754256D5621CAD40@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Aug 07, 2019 at 04:14:22PM +0000, Pascal Van Leeuwen wrote:
> > > > In your case, we are not dealing with known plaintext attacks,
> > > >
> > > Since this is XTS, which is used for disk encryption, I would argue
> > > we do! For the tweak encryption, the sector number is known plaintext,
> > > same as for EBOIV. Also, you may be able to control data being written
> > > to the disk encrypted, either directly or indirectly.
> > > OK, part of the data into the CTS encryption will be previous ciphertext,
> > > but that may be just 1 byte with the rest being the known plaintext.
> > >
> > 
> > The tweak encryption uses a dedicated key, so leaking it does not have
> > the same impact as it does in the EBOIV case. 
> >
> Well ... yes and no. The spec defines them as seperately controllable -
> deviating from the original XEX definition - but in most practicle use cases 
> I've seen, the same key is used for both, as having 2 keys just increases 
> key  storage requirements and does not actually improve effective security 
> (of the algorithm itself, implementation peculiarities like this one aside 
> :-), as  XEX has been proven secure using a single key. And the security 
> proof for XTS actually builds on that while using 2 keys deviates from it.
> 

This is a common misconception.  Actually, XTS needs 2 distinct keys to be a
CCA-secure tweakable block cipher, due to another subtle difference from XEX:
XEX (by which I really mean "XEX[E,2]") builds the sequence of masks starting
with x^1, while XTS starts with x^0.  If only 1 key is used, the inclusion of
the 0th power in XTS allows the attack described in Section 6 of the XEX paper
(https://web.cs.ucdavis.edu/~rogaway/papers/offsets.pdf).

Of course, it's debatable what this means *in practice* to the usual XTS use
cases like disk encryption, for which CCA security may not be critical...  But
technically, single-key XTS isn't secure under as strong an attack model as XEX.

- Eric
