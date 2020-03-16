Return-Path: <SRS0=DGAQ=5B=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4207C0044D
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 11:23:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78EBA20719
	for <linux-crypto@archiver.kernel.org>; Mon, 16 Mar 2020 11:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584357813;
	bh=78ubgV8FCk7j1WxS0FOyLzC9jjCa2CsM725wq6Rixms=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=uGOUrMYmI43jVvn4hvV/k8MVdqbVl5gG8Sj3lyaAklYxd9wTFRtSFjM114g1/8koI
	 3Y+ce9dvct8VMIx/oYjsOZ/boPD1USaJVNVqzSLD55OKehiOerBRsPfMQG2X/iASGA
	 iI5ecX7F48otLz0w8hy/ZKN+MLeGeHrjDE9MEYQQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730764AbgCPLXc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 16 Mar 2020 07:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:40758 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730734AbgCPLXc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 16 Mar 2020 07:23:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8615020724;
        Mon, 16 Mar 2020 11:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584357812;
        bh=78ubgV8FCk7j1WxS0FOyLzC9jjCa2CsM725wq6Rixms=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JO1N9hSRBtoFm+hBbIn6W5GfKFJgWgukvZiik0e68hn+DCi+4TuiAKlVDk4a4QVrj
         Vd82G6KRHR8FvE6IIdNtu5Va85tjc5+xCVdJaeJ0pABpFfF+Zwe0u9HQnC7xMgnugt
         /YBy0FGX47okL9hyQBu/FAFLZKWWgiv0lyPmPLYA=
Date:   Mon, 16 Mar 2020 12:23:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Kim, David" <david.kim@ncipher.com>
Cc:     "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Magee, Tim" <tim.magee@ncipher.com>
Subject: Re: nCipher HSM kernel driver submission feedback request
Message-ID: <20200316112329.GA3688743@kroah.com>
References: <1584092894266.92323@ncipher.com>
 <20200313100922.GB2161605@kroah.com>
 <142189d3a42947d4953b22cf7202e327@exukdagfar01.INTERNAL.ROOT.TES>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <142189d3a42947d4953b22cf7202e327@exukdagfar01.INTERNAL.ROOT.TES>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 16, 2020 at 10:44:46AM +0000, Kim, David wrote:
> 
> > > The driver code for the hardware is straightforward and does not
> > > contain any cryptographic components as the cryptography is handled
> > > within the hardware's secure boundary. We have no plans to use the
> > > linux kernel crypto APIs as our customers require compliance to the FIPS
> > 140 standard or the eIDAS regulations.
> > 
> > But what I said was, you NEED to use the linux kernel crypto apis as you need
> > to not try to create your own.
> > 
> > Just because this is the way you did it before, does not mean it is the correct
> > thing to do.
> > 
> > So what is wrong if you do use the existing apis?  What is preventing you
> > from doing that?
> > 
> 
> Sorry Greg but I'm not understanding what the issue is. Can you please explain a
> bit more what you mean with the apis?
> 
> Our driver code is just a tube between proprietary code on the host machine and
> proprietary code on the HSM. We are not trying to create our own linux crypto
> apis because all the crypto stuff is happening in the existing proprietary code.

If your device does "crypto", then it should tie into the existing
kernel crypto apis so that your, and everyone elses, userspace code also
uses the correct, existing, userspace crypto apis.

We do not want to create a one-off-vendor-specific api for only one
piece of hardware out there.  That way lies madness and is not how we do
things in the kernel whenever possible.

thanks,

greg k-h
