Return-Path: <SRS0=zv6R=V2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F23C76186
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 23:53:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2C522073F
	for <linux-crypto@archiver.kernel.org>; Mon, 29 Jul 2019 23:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1564444390;
	bh=UN0jOoxpDETHiH+HWW//MyP8iFqFuu/5XMZ9YO3sgg4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=iYV2xmo1jVXwnOrEH7FRECT5p+8zhjOL4FxYGs4p/NZLh4Fl5nLmY0rKKkZjtr/4i
	 FtRAYyTVVjF2n94EooDVld87Um7OIexsUEWyZv8svib5rlgpLBhdJLAmxWc3kKACDz
	 vqsfsBmDMonusRFdhwsMU2+M2YL/jCc/kfsKHnXY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728808AbfG2XxI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 29 Jul 2019 19:53:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:40818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728275AbfG2XxH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 29 Jul 2019 19:53:07 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BC3D206BA;
        Mon, 29 Jul 2019 23:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564444387;
        bh=UN0jOoxpDETHiH+HWW//MyP8iFqFuu/5XMZ9YO3sgg4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=x1jdAsxTe2OKiJVPF5gwp1rKTqjyRdOYB12MsQSJbzHsPQ1OmbVnwCb6uxUcLKbzO
         hrYtZ4OYZB9JBhCFCiMI3DgGefcu34JLdLaaeZM0jKRM0o7wh9UCwHp5uWa0mKAYYM
         uMNERPWWWMlmiDTBfr6dI1fQvVONBCE26V5V+CIE=
Date:   Mon, 29 Jul 2019 16:53:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params for
 AEAD fuzz testing
Message-ID: <20190729235304.GJ169027@gmail.com>
Mail-Followup-To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Pascal van Leeuwen <pascalvanl@gmail.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
References: <1563960917-8236-1-git-send-email-pvanleeuwen@verimatrix.com>
 <20190728173040.GA699@sol.localdomain>
 <MN2PR20MB29737962BC74CCA790470C0BCADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729181738.GB169027@gmail.com>
 <MN2PR20MB2973C131062F1D1CABA77015CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
 <20190729223112.GA7529@gondor.apana.org.au>
 <MN2PR20MB29736A0F55875B91587142D9CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR20MB29736A0F55875B91587142D9CADD0@MN2PR20MB2973.namprd20.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jul 29, 2019 at 10:49:38PM +0000, Pascal Van Leeuwen wrote:
> Herbert,
> 
> > -----Original Message-----
> > From: Herbert Xu <herbert@gondor.apana.org.au>
> > Sent: Tuesday, July 30, 2019 12:31 AM
> > To: Pascal Van Leeuwen <pvanleeuwen@verimatrix.com>
> > Cc: Eric Biggers <ebiggers@kernel.org>; Pascal van Leeuwen <pascalvanl@gmail.com>; linux-
> > crypto@vger.kernel.org; davem@davemloft.net
> > Subject: Re: [PATCH] crypto: testmgr - Improve randomization of params for AEAD fuzz testing
> > 
> > On Mon, Jul 29, 2019 at 10:16:48PM +0000, Pascal Van Leeuwen wrote:
> > >
> > > > EINVAL is for invalid lengths while EBADMSG is for inauthentic inputs.
> > > > Inauthentic test vectors aren't yet automatically generated (even after this
> > > > patch), so I don't think EBADMSG should be seen here.  Are you sure there isn't
> > > > a bug in your patch that's causing this?
> > > >
> > > As far as I understand it, the output of the encryption is fed back in to
> > > decrypt. However, if the encryption didn't work due to blocksize mismatch,
> > > there would not be any valid encrypted and authenticated data written out.
> > > So, if the (generic) driver checks that for decryption, it would result in
> > > -EINVAL. If it wouldn't check that, it would try to decrypt and authentica
> > > te the data, which would almost certainly result in a tag mismatch and
> > > thus an -EBADMSG error being reported.
> > >
> > > So actually, the witnessed issue can be perfectly explained from a missing
> > > block size check in aesni.
> > 
> > The same input can indeed fail for multiple reasons.  I think in
> > such cases it is unreasonable to expect all implementations to
> > return the same error value.
> > 
> Hmmm ... first off, testmgr expects error codes to match exactly. So if
> you're saying that's not always the case, it would need to be changed.
> (but then, what difference would still be acceptable?)
> But so far it seems to have worked pretty well, except for this now.
> 
> You're the expert, but shouldn't there be some priority to the checks
> being performed? To me, it seems reasonable to do things like length
> checks prior to even *starting* decryption and authentication.
> Therefore, it makes more sense to get -EINVAL than -EBADMSG in this 
> case. IMHO you should only get -EBADMSG if the message was properly
> formatted, but the tags eventually mismatched. From a security point
> of view it can be very important to have a very clear distinction
> between those 2 cases.
> 

Oh, I see.  Currently the fuzz tests assume that if encryption fails with an
error (such as EINVAL), then decryption fails with that same error.

Regardless of what we think the correct decryption error is, running the
decryption test at all in this case is sort of broken, since the ciphertext
buffer was never initialized.  So for now we probably should just sidestep this
issue by skipping the decryption test if encryption failed, like this:

diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index 96e5923889b9c1..0413bdad9f6974 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -2330,10 +2330,12 @@ static int test_aead_vs_generic_impl(const char *driver,
 					req, tsgls);
 		if (err)
 			goto out;
-		err = test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name, cfg,
-					req, tsgls);
-		if (err)
-			goto out;
+		if (vec.crypt_error != 0) {
+			err = test_aead_vec_cfg(driver, DECRYPT, &vec, vec_name,
+						cfg, req, tsgls);
+			if (err)
+				goto out;
+		}
 		cond_resched();
 	}
 	err = 0;

I'm planning to (at some point) update the AEAD tests to intentionally generate
some inauthentic inputs, but that will take some more work.

- Eric
