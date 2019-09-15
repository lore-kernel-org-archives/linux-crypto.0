Return-Path: <SRS0=bf8p=XK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0933C4CEC7
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Sep 2019 20:20:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9F342214DA
	for <linux-crypto@archiver.kernel.org>; Sun, 15 Sep 2019 20:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1568578840;
	bh=UssJAOwLJJtcO4Bp3VB/dR2eK1ehe8mxpbQf9IMKDI4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=YB8CBwrYv5Pwcqu1TAbzhbn0g/nXxBq1bwmc6VpgPO7TtjrqIqRAsjhNiWrYGRRxu
	 l99CWIi0IVkriKoAk9Gow/WKK7hKhIA03hkJSGja7ZVgPPspqm23oB2IzCRArSAOu+
	 KotFrA6LBpdt5JVsvY3YDuHzJYGfTj3+VidiJkLI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbfIOUUk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 15 Sep 2019 16:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:40950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725980AbfIOUUj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 15 Sep 2019 16:20:39 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C9E2214AF;
        Sun, 15 Sep 2019 20:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568578839;
        bh=UssJAOwLJJtcO4Bp3VB/dR2eK1ehe8mxpbQf9IMKDI4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ab+LBuBEkVqCox1IaxrH6rm7HL3yYDoDiSmcYswUWCfbyyTJXmHzQkBtvZwPlLod3
         eGGYUqr+7goUvoVnD5HL879YY08PSMSShzOVzzkVE1B8o4CNIN8V7PruHkdSmL0nVb
         JSaqhF8b3ILhycFv3HYbYj5CruV2VM7koYYpkOyo=
Date:   Sun, 15 Sep 2019 13:20:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH 4/7] crypto: testmgr - Added testvectors for the ofb(sm4)
 & cfb(sm4) skciphers
Message-ID: <20190915202037.GB1704@sol.localdomain>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "antoine.tenart@bootlin.com" <antoine.tenart@bootlin.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <1568198304-8101-1-git-send-email-pvanleeuwen@verimatrix.com>
 <1568198304-8101-5-git-send-email-pvanleeuwen@verimatrix.com>
 <20190911160545.GA210122@gmail.com>
 <MN2PR20MB29738D497EDEEC9FBBC939F1CAB10@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB29738D497EDEEC9FBBC939F1CAB10@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Sep 11, 2019 at 07:34:31PM +0000, Pascal Van Leeuwen wrote:
> > -----Original Message-----
> > From: Eric Biggers <ebiggers@kernel.org>
> > Sent: Wednesday, September 11, 2019 6:06 PM
> > To: Pascal van Leeuwen <pascalvanl@gmail.com>
> > Cc: linux-crypto@vger.kernel.org; antoine.tenart@bootlin.com; herbert@gondor.apana.org.au;
> > davem@davemloft.net; Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Subject: Re: [PATCH 4/7] crypto: testmgr - Added testvectors for the ofb(sm4) & cfb(sm4)
> > skciphers
> > 
> > On Wed, Sep 11, 2019 at 12:38:21PM +0200, Pascal van Leeuwen wrote:
> > > Added testvectors for the ofb(sm4) and cfb(sm4) skcipher algorithms
> > >
> > 
> > What is the use case for these algorithms?  Who/what is going to use them?
> > 
> > - Eric
> >
> SM4 is a Chinese replacement for 128 bit AES, which is mandatory to be used for many
> Chinese use cases. So they would use these whereever you would normally use ofb(aes)
> or cfb(aes). Frankly, I'm not aware of any practicle use cases for these feedback
> modes, but we've been supporting them for decades and apparently the Crypto API
> supports them for AES as well. So they must be useful for something ...
> 
> The obvious advantage over CBC mode was that they only require the encrypt part of
> the cipher, but that holds for the (newer) CTR mode as well. So, my guess would be
> some legacy uses cases from before the time CTR mode and AEAD's became popular.
> 
> Maybe someone remembers why these were added for AES in the first place?
> 

So if you have no idea why they should be added, why are you adding them?

- Eric
