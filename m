Return-Path: <SRS0=kkja=VR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8EDFC76188
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Jul 2019 06:58:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DE272187F
	for <linux-crypto@archiver.kernel.org>; Sat, 20 Jul 2019 06:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1563605890;
	bh=OFZAHQHXLV8GwXYrMSGu/SOmauNVVlNoeQquIaDV4sg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=hO/2Evu8coVc9C07zMcK+lYdEfRicCn9LIssmIy2jgD7M8gv5yy8ANl7Ny6+lWKw6
	 foXa043/VU3P7vzxJeRtS+MUvSFRpR3xNKusE6hRklB5l0Tum8WKMVDIedCgWzqM1G
	 mvlJ8102E4eweWjlpTzHcZsRFwN5DC77ObQfiP68=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfGTG6J (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 20 Jul 2019 02:58:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726533AbfGTG6J (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 20 Jul 2019 02:58:09 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC18E21873;
        Sat, 20 Jul 2019 06:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563605889;
        bh=OFZAHQHXLV8GwXYrMSGu/SOmauNVVlNoeQquIaDV4sg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2GwRSuZC0c9rkYEqR9wXTttGef4p2LVlv9kQc/mhRUi6jC9Kdbzw58EUyS9cKb8xH
         aUEJWIQyPe8x70Kgu0U8Ql9DAn+hLv77YXg1Le91HwmYfDGa5iEBwechIsO2RsbHWr
         2u/lUp7HMyk0KqUUG2/wVX+A9JoxKsG3BNu47G00=
Date:   Fri, 19 Jul 2019 23:58:07 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>
Subject: Re: [dm-devel] xts fuzz testing and lack of ciphertext stealing
 support
Message-ID: <20190720065807.GA711@sol.localdomain>
Mail-Followup-To: Milan Broz <gmazyland@gmail.com>,
        Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>
References: <20190716221639.GA44406@gmail.com>
 <VI1PR0402MB34857BBB18C2BB8CBA2DEC7198C90@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190717172823.GA205944@gmail.com>
 <CAKv+Gu__offPaWvyURJr8v56ig58q-Deo16QhP26EJ32uf5m3w@mail.gmail.com>
 <20190718065223.4xaefcwjoxvujntw@gondor.apana.org.au>
 <CAKv+Gu9-EWNpJ9viSsjhYRdOZb=7a=Mpddmyt8SLEq9aFtawjg@mail.gmail.com>
 <20190718072154.m2umem24x4grbf6w@gondor.apana.org.au>
 <36e78459-1594-6d19-0ab4-95b03a6de036@gmail.com>
 <MN2PR20MB2973E61815F069E8C7D74177CAC80@MN2PR20MB2973.namprd20.prod.outlook.com>
 <b042649c-db98-9710-b063-242bdf520252@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b042649c-db98-9710-b063-242bdf520252@gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 18, 2019 at 01:19:41PM +0200, Milan Broz wrote:
> 
> > From that perspective - to prevent people from doing cryptographically stupid things -
> > IMHO it would be better to just pull the CTS into the XTS implementation i.e. make
> > xts natively support blocks that are not a multiple of (but >=) the cipher blocksize ...
> 
> I would definitely prefer adding CTS directly to XTS (as it is in gcrypt or OpenSSL now)
> instead of some new compositions.
> 
> Also, I would like to avoid another "just because it is nicer" module dependence (XTS->XEX->ECB).
> Last time (when XTS was reimplemented using ECB) we have many reports with initramfs
> missing ECB module preventing boot from AES-XTS encrypted root after kernel upgrade...
> Just saying. (Despite the last time it was keyring what broke encrypted boot ;-)
> 

Can't the "missing modules in initramfs" issue be solved by using a
MODULE_SOFTDEP()?  Actually, why isn't that being used for xts -> ecb already?

(There was also a bug where CONFIG_CRYPTO_XTS didn't select CONFIG_CRYPTO_ECB,
but that was simply a bug, which was fixed.)

Or "xts" and "xex" could go in the same kernel module xts.ko, which would make
this a non-issue.

Anyway, I agree that the partial block support, if added, should just be made
available under the name "xts", as people would expect.  It doesn't need a new
name.

- Eric
