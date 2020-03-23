Return-Path: <SRS0=HSjb=5I=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ECA5C4332B
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 13:59:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 205D52076E
	for <linux-crypto@archiver.kernel.org>; Mon, 23 Mar 2020 13:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584971969;
	bh=i2XkKvOEB0m407zJ3AC3+6f9/mw2d3umu2xYqTdq9h0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=GjLaqHjq2EAuWuIF+kET6v8vx3BCxC9S4xvojVePO4nJ2pr2QDH/dzMrAH+zsvaKY
	 g57rjD6GG2iaQzX6tEcYGk8dxeWveV7x3X50vttWt+MW5CkKEhO+5wPDLuBBBiX4St
	 4V0N//eTrISdX/URyTOPMYoGv8T16+/SSPftRZFo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728548AbgCWN72 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 23 Mar 2020 09:59:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:32938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728541AbgCWN72 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 23 Mar 2020 09:59:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0C86020753;
        Mon, 23 Mar 2020 13:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584971966;
        bh=i2XkKvOEB0m407zJ3AC3+6f9/mw2d3umu2xYqTdq9h0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SUa8zJulcUX2TlRPiG3baAoTHXsgh6D32tvzdsUcHj3a35AA0X/C3jmhNvBWKXDO6
         LXOI08pe6fY2FCEW0JG3LRLAgD+Ea2MZRqYSN/mQxnntODoI7ysXfz4/65v4ERwlIb
         T5+rPZIHt/94Txo2kot5WRxtE0hAXushgIDsab78=
Date:   Mon, 23 Mar 2020 14:59:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Kim, David" <david.kim@ncipher.com>
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Magee, Tim" <tim.magee@ncipher.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: nCipher HSM kernel driver submission feedback request
Message-ID: <20200323135924.GA7768@kroah.com>
References: <1584092894266.92323@ncipher.com>
 <9644fcdd-1453-616a-f607-4a1f39f433ff@zx2c4.com>
 <c34d5419ad38444d951f7cbb29b5c7ae@exukdagfar01.INTERNAL.ROOT.TES>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c34d5419ad38444d951f7cbb29b5c7ae@exukdagfar01.INTERNAL.ROOT.TES>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Mar 23, 2020 at 01:32:06PM +0000, Kim, David wrote:
> Hi Jason,
> 
> Thanks for your reply and helpful summary of the current discussion.
> 
> > 
> > It looks like this is some sort of PCIe HSM device. As far as I know, Linux
> > doesn't have a standardized API for HSM devices (somebody correct me if
> > I'm wrong), and probably that doesn't quite make sense, either, seeing as
> > most HSMs are accessed anyway through userspace "drivers" -- that is, via
> > libusb or over some networking protocol, or something else.
> > Your situation is different in that it uses PCIe, so you need some kernel
> > mediation in order to give access to your userspace components.
> > And, different manufacturers' HSMs expose very different pieces of
> > functionality, and I'm not sure a unified API for them would even make
> > sense.
> 
> Yes, that's correct. There are currently no standardised APIs for HSM devices in
> Linux and our PCIe device needs the kernel to facilitate operation.
> 
> > 
> > It looks like this driver exposes some device file, with a few IOCTLs and then
> > support for reading and writing from and to the device. Besides some driver
> > control things, what actually goes into the device -- that is, the protocol one
> > must use to talk to the thing -- isn't actually described by the driver. You're
> > just shuffling bytes in and out with some mediation around that.
> > 
> > Can you confirm to me whether or not the above is accurate?
> 
> Yes, this is accurate.
> 
> > 
> > If so, then I'm not sure this belongs in the purview of the crypto list or has
> > anything much to do with Linux crypto. This is a PCIe driver for some
> > hardware that userspace has to talk to in order to do some stuff with it.
> 
> Again, you are correct. Although it is cryptographic hardware, the driver code
> does not do anything cryptographic. It is just a PCIe driver.

If this is "just" a PCIe driver, can you use the UIO interface and just
talk to your hardware directly from userspace without any kernel driver
needed?

What exactly does the kernel driver need to do here?

thanks,

greg k-h
