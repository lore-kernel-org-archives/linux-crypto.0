Return-Path: <SRS0=1Yk9=S5=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E755CC43219
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Apr 2019 17:02:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B9E002087F
	for <linux-crypto@archiver.kernel.org>; Sat, 27 Apr 2019 17:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556384579;
	bh=/InuKA7ppSvYgDbpoQTmazbq6WEwAwXrECmMt10GlVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=2Up5KPes+kW7ZnQ0JsF/22x7PzDcs0fjkWx/Z6Zf5q2Yh6b9MfgP63lMfcGuFJ1yJ
	 KFTlVtgzkruXYWwMrY45zmMVN0/RuATtPtKPsQ2ASSdosoBsdbaQcro5o3BT7fMxBY
	 WMW6b1DumetY1X3GfKWkkR+XHapRuEprv9/z/TVY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725995AbfD0RC6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 27 Apr 2019 13:02:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbfD0RC6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 27 Apr 2019 13:02:58 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D641D2087E;
        Sat, 27 Apr 2019 17:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556384577;
        bh=/InuKA7ppSvYgDbpoQTmazbq6WEwAwXrECmMt10GlVs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=K58Giwd1x3vtLUfBnytntnsF3YcX8wJSyEtXAou8J8nf6wDntgaRj2Vf0KY1Pjfar
         Kxnjji011iRJ1+x7H7G0Rwp9Xl0Uy2zmu2UXYLpXE/Sl19ZDyeaR4IeQHtLqEwckvB
         hmxft73Rg+S398snxiCvrANwzlC/w9+pj0usVEfU=
Date:   Sat, 27 Apr 2019 10:02:55 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/7] crypto: fuzz algorithms against their generic
 implementation
Message-ID: <20190427170254.GA652@sol.localdomain>
References: <20190412045742.1725-1-ebiggers@kernel.org>
 <VI1PR0402MB3485A6BE1840DD5B060FACB7983E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
 <20190426165406.GA691@sol.localdomain>
 <VI1PR0402MB34857CA032C0134714BE9A61983F0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB34857CA032C0134714BE9A61983F0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Apr 27, 2019 at 03:24:38PM +0000, Horia Geanta wrote:
> On 4/26/2019 7:54 PM, Eric Biggers wrote:
> > Hi Horia,
> > 
> > On Fri, Apr 26, 2019 at 04:35:05PM +0000, Horia Geanta wrote:
> >> On 4/12/2019 8:00 AM, Eric Biggers wrote:
> >>> So far I've tested all generic, x86, arm, and arm64 algorithms, plus
> >>> some PowerPC algorithms.  I have not tested hardware drivers.  I
> >>> encourage people to run the tests on drivers and other architectures, as
> >>> they will find more bugs.
> >>>
> >> I am seeing some errors in caam hardware driver.
> >> They are due to error code mismatch b/w generic algorithm implementation and
> >> what caam driver returns.
> >>
> >> Random skcipher tests for block cipher algorithms are expected to fail when
> >> input size is not a multiple of algorithm block size.
> >> Generic implementation returns -EINVAL.
> >> caam driver returns the status received from HW.
> >>
> >> This probably has to be fixed in caam driver, but I wonder if there's an
> >> agreement on what error code should be returned in every single case (since I'll
> >> have to do a N:M mapping b/w errors returned by HW and errors expected by crypto
> >> API).
> >> Should I take the generic S/W implementation as reference?
> >>
> >> Thanks,
> >> Horia
> > 
> > Yes, use the generic driver as a reference.  I don't understand why you're
> > saying there are so many cases to handle, though.  The only error cases I'd
> > expect to actually be encountered during the tests are invalid input lengths and
> > invalid key lengths, where you should return -EINVAL.  There may be other errors
> There's at least one more in testmgr: -EBADMSG.

AEADs must return -EBADMSG when the authentication tag is wrong, but you said it
was an skcipher algorithm.  Which algorithm are you talking about, exactly?

> 
> > your driver could theoretically produce, but I wouldn't expect them to be
> > encountered during the tests unless there are testmgr, driver, or hardware bugs.
> > 
> Is the error code matching a crypto API requirement or a testmgr requirement?
> 
> I think testmgr doesn't cover all possible failures. Thus if somebody wants to
> make sure the implementation is _fully_ compliant (and not only passing testmgr
> tests), a lot of effort will be required.
> 

Everything testmgr tests for is an "API requirement".  There are also API
requirements that testmgr doen't yet test for, e.g. for skciphers that the
source data is not modified unless it coincides with the destination data.

However with regards to failures, as I see it the only failures which *must* be
handled consistently are those that apply to every implementation.  I think this
only includes cases where the input is bad, e.g. invalid key or message length,
or authentication tag mismatch.  If you also have implementation specific
failures, e.g. your hardware randomly stopped working or something, then for
them you may choose appropriate error codes from errno.h.

> > But remember you must always return a -errno code, not a driver-specific code.
> > 
> Correct, I'll fix this.
> 
> Thanks,
> Horia
