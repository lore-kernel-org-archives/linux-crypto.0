Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 083CCC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD7AC218A1
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 04:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552624477;
	bh=bH12L59769d7W/9o6609SayNbxP6NGE7lhYdGRVdHy0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=CPcql6upBPgvC1O+tTFaXgSTPv1Y6p31qJfITDXGyYJJ/HoNaUhzB/Apuej2OBCgx
	 sotTUhd1v6rGQ5xKBin+cKozz0l6AZWMYUWNLi5NF1liPLI+4WK/IX3v7GeCAeflHK
	 xLhHWYettyHHj4tRn8dqqLdrReSlPRAKqyNApVBE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbfCOEeh (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 00:34:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726493AbfCOEeh (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 00:34:37 -0400
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C8D9321871;
        Fri, 15 Mar 2019 04:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552624476;
        bh=bH12L59769d7W/9o6609SayNbxP6NGE7lhYdGRVdHy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yAUUs08a4qxEJPOgiiQWB5UEkR7zEhphOBCfrAsDS3J8fzd+5cOh1RQfYNiifRBC8
         1U0B2akoE6DsigAfnX6yAd5lJYrTZmRcec+/k1YBu1/f37tyAvqN7Xqnh/upeOnnmk
         hG04B9XrIjtnP3wnP57Z+PD4fiVbsQJaacBwlP2U=
Date:   Thu, 14 Mar 2019 21:34:34 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Daniel Axtens <dja@axtens.net>
Cc:     omosnacek@gmail.com, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        marcelo.cerri@canonical.com, Stephan Mueller <smueller@chronox.de>,
        leo.barbosa@canonical.com, linuxppc-dev@lists.ozlabs.org,
        nayna@linux.ibm.com, pfsmorigo@gmail.com, leitao@debian.org
Subject: Re: [PATCH] crypto: vmx - fix copy-paste error in CTR mode
Message-ID: <20190315043433.GC1671@sol.localdomain>
References: <20190315020901.16509-1-dja@axtens.net>
 <20190315022414.GA1671@sol.localdomain>
 <875zsku5mk.fsf@dja-thinkpad.axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875zsku5mk.fsf@dja-thinkpad.axtens.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Daniel,

On Fri, Mar 15, 2019 at 03:24:35PM +1100, Daniel Axtens wrote:
> Hi Eric,
> 
> >> The original assembly imported from OpenSSL has two copy-paste
> >> errors in handling CTR mode. When dealing with a 2 or 3 block tail,
> >> the code branches to the CBC decryption exit path, rather than to
> >> the CTR exit path.
> >
> > So does this need to be fixed in OpenSSL too?
> 
> Yes, I'm getting in touch with some people internally (at IBM) about
> doing that.
> 
> >> This leads to corruption of the IV, which leads to subsequent blocks
> >> being corrupted.
> >> 
> >> This can be detected with libkcapi test suite, which is available at
> >> https://github.com/smuellerDD/libkcapi
> >> 
> >
> > Is this also detected by the kernel's crypto self-tests, and if not why not?
> > What about with the new option CONFIG_CRYPTO_MANAGER_EXTRA_TESTS=y?
> 
> It seems the self-tests do not catch it. To catch it, there has to be a
> test where the blkcipher_walk creates a walk.nbytes such that
> [(the number of AES blocks) mod 8] is either 2 or 3. This happens with
> AF_ALG pretty frequently, but when I booted with self-tests it only hit
> 1, 4, 5, 6 and 7 - it missed 0, 2 and 3.
> 
> I don't have the EXTRA_TESTS option - I'm testing with 5.0-rc6. Is it in
> -next?
> 
> Regards,
> Daniel

The improvements I recently made to the self-tests are intended to catch exactly
this sort of bug.  They were just merged for v5.1, so try the latest mainline.
This almost certainly would be caught by EXTRA_TESTS (and if not I'd want to
know), but it may be caught by the regular self-tests now too.

- Eric
