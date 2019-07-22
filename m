Return-Path: <SRS0=h947=VT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 166DCC76190
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 16:22:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D41A12190F
	for <linux-crypto@archiver.kernel.org>; Mon, 22 Jul 2019 16:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563812563;
	bh=FKPLJ8Xmsiucyw9RaAzZc/XnpNt9bbZ30igXBhufMOY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=U/Y++dwm4TCxAZmneKwJ287eWJI2IAXjdV9dT3fepfhT97tjsRukbjT7R3KSrImhC
	 UtlhwyDpH+fObv5SajD2LxNNGdacutfiKCO4gZLUqKhaVt1b7FNex1aSL6uTqQr1fX
	 gQurYQWZKXbQvpkaI8bhXou+Q7vE2xxcMdeEclcA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729197AbfGVQWn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 22 Jul 2019 12:22:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:41980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727743AbfGVQWm (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 22 Jul 2019 12:22:42 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DC432190D;
        Mon, 22 Jul 2019 16:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563812562;
        bh=FKPLJ8Xmsiucyw9RaAzZc/XnpNt9bbZ30igXBhufMOY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ApHg5oTFwndcAdv+h48n6GnLSIvwiiqAcqkXSmYOcIHgrmQ7E7Y/c8/cxI8jQ3sOg
         8zEfX9ysSUWVatbzAyHCE0twaOyTC61Ih8OO/zkhiu9ibz90kQe33AD+5lkJ/DpHvM
         /SeCd5Qh0v7eYuD9kVdllJ77dIMtriOcMEkk3/fs=
Date:   Mon, 22 Jul 2019 09:22:40 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: AEAD question
Message-ID: <20190722162240.GB689@sol.localdomain>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <MN2PR20MB29734143B4A5F5E418D55001CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB29734143B4A5F5E418D55001CAC40@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 22, 2019 at 12:55:39PM +0000, Pascal Van Leeuwen wrote:
> Eric & Herbert,
> 
> I noticed the testmgr fuzz tester generating (occasionally, see previous mail) tests cases with 
> authsize=0 for the AEAD ciphers. I'm wondering if that is intentional. Or actually, I'm wondering
> whether that should be considered a legal case.
> To me, it doesn't seem to make a whole lot of sense to do *authenticated* encryption and then
> effectively throw away the authentication result ... (it's just a waste of power and/or cycles)
> 
> The reason for this question is that supporting this requires some specific workaround in my 
> driver (yet again). And yes, I'm aware of the fact that I can advertise I don't support zero length
> authentication tags, but then probably/likely testmgr will punish me for that instead.
> 

As before you're actually talking about the "authenc" template for IPSec and not
about AEADs in general, right?  I'm not familiar with that algorithm, so you'll
have to research what the specification says, and what's actually using it.

Using an AEAD with authsize=0 is indeed silly, but perhaps someone using that in
some badly designed protocol where authentication is optional.  Also AFAICS from
the code, any authsize fits naturally into the algorithm; i.e., excluding 0
would be a special case.

But again, someone actually has to research this.  Maybe
crypto_aead_setauthsize() should simply reject authsize=0 for all AEADs.

What we should *not* do, IMO, is remove it from the tests and allow
implementations to do whatever they want.  If it's wrong we should fix it
everywhere, so that the behavior is consistent.

- Eric
