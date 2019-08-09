Return-Path: <SRS0=Ue/q=WF=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5ACEAC31E40
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 16:46:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E7AA20C01
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Aug 2019 16:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1565369174;
	bh=HcjyODSIlc9zJqTP/3TxIz/DQ9p6xELaW6SkZRflCBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=h3L7NDj8vnR6bAqdePtA3LILhM1mLVu3XJArv0xI+UzS2FBki+zTvZYkWtCKFHx96
	 NjpO5jtZkWUNhi3I3pmO10vZNnhk7ntCtGf4HYuxUkHgPRGl50Oltv6lVLDgg+HMiX
	 qJ5W/xUvrYVAl0FEsX/mWggHk8uIX+R8dFT501yg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406412AbfHIQqN (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Aug 2019 12:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52678 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726037AbfHIQqN (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Aug 2019 12:46:13 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0315420B7C;
        Fri,  9 Aug 2019 16:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565369172;
        bh=HcjyODSIlc9zJqTP/3TxIz/DQ9p6xELaW6SkZRflCBg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gODTXl3dmjZBV6nJ2nKCIiAjVUXyEn0UCNt0IebN2EjDu2NnjEtSTSCoEUSKZ8g1A
         YyQbfYTL2SVFhGMWY9cgXMGRY7wBSe6vnNv4S2sjKI+MZ+p01LiPC2t6vVx6H4GwWo
         96EnD6pFdh5hmfFdNRzHhofddTgm86ebmdYKby+4=
Date:   Fri, 9 Aug 2019 09:46:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: XTS template wrapping question
Message-ID: <20190809164610.GA658@sol.localdomain>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <MN2PR20MB2973BB8A78D663C6A3D6A223CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB2973BB8A78D663C6A3D6A223CAD60@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Aug 09, 2019 at 11:39:12AM +0000, Pascal Van Leeuwen wrote:
> Herbert, Eric,
> 
> While working on the XTS template, I noticed that it is being used 
> (e.g. from testmgr, but also when explictly exported from other drivers)
> as e.g. "xts(aes)", with the generic driver actually being 
> "xts(ecb(aes-generic))". 
> 
> While what I would expect would be "xts(ecb(aes))", the reason being
> that plain "aes" is defined as a single block cipher while the XTS
> template actually efficiently wraps an skcipher (like ecb(aes)).
> The generic driver reference actually proves this point.
> 
> The problem with XTS being used without the ecb template in between,
> is that hardware accelerators will typically advertise an ecb(aes)
> skcipher and the current approach makes it impossible to leverage
> that for XTS (while the XTS template *could* actually do that
> efficiently, from what I understand from the code ...).
> Advertising a single block "aes" cipher from a hardware accelerator
> unfortunately defeats the purpose of acceleration.
> 
> I also wonder what happens if aes-generic is the only AES 
> implementation available? How would the crypto API know it needs to 
> do "xts(aes)" as "xts(ecb(aes))" without some explicit export?
> (And I don't see how xts(aes) would work directly, considering 
> that only seems to handle single cipher blocks? Or ... will
> the crypto API actually wrap some multi-block skcipher thing 
> around the single block cipher instance automatically??)
> 

"xts(aes)" is the cra_name for AES-XTS, while everything else (e.g.
"xts(ecb(aes-generic))", "xts-aes-aesni", "xts(ecb-aes-aesni)")
is a cra_driver_name for AES-XTS.

"xts(ecb(aes))" doesn't make sense, as it's neither the cra_name nor does it
name a specific implementation.

See create() in crypto/xts.c.  It allows the XTS template to be passed either
the string "aes", *or* a string which names an *implementation* of "ecb(aes)",
like "ecb(aes-generic)" or "ecb-aes-aesni".  In the first case it allocates
"ecb(aes)" so it gets the highest priority AES-ECB implementation.

So in both cases the XTS template uses AES-ECB via the skcipher API.

- Eric
