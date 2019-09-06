Return-Path: <SRS0=4a8U=XB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14BDC43331
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 01:57:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C25C8207E0
	for <linux-crypto@archiver.kernel.org>; Fri,  6 Sep 2019 01:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567735076;
	bh=934DU6MwReEW40rotKLbl7KMSZQskTWS7eZl/xvW5nQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=Hz6/ZMueHQ66NAH2M1TlpgWCm3JqoMdanBYhlfZITvWpHMgkhwoSwcylmp94N9qVR
	 IqM9yTR3yl2LOoirssENSzJRms7zycQRqThROYts2rrTr79g1/qTbbFasjsAYMCXrx
	 EAxh2oRMc0FXqsPiKoT/6fb2E4EdS0z1eKGORWNI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404293AbfIFB5z (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 5 Sep 2019 21:57:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:34940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730991AbfIFB5z (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 5 Sep 2019 21:57:55 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAF02206CD;
        Fri,  6 Sep 2019 01:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567735075;
        bh=934DU6MwReEW40rotKLbl7KMSZQskTWS7eZl/xvW5nQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ETdKtX0CsWoTBbGN7rAuMQL5GC+m5EBFLy7ycKiWIPVuNcbhw17hsYeaPEAq52ucL
         6rQU5cYx6L/On6TkpHbagTRsjvusEIeHbrNX+oS4ylZwJ9loZavjRrIe6q2XbcM0/h
         l5K3wdnpCubfBomGn1hUikVhApUXlA9cj6lIib88=
Date:   Thu, 5 Sep 2019 18:57:53 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Subject: Re: crypto: skcipher - Unmap pages after an external error
Message-ID: <20190906015753.GA803@sol.localdomain>
Mail-Followup-To: Herbert Xu <herbert@gondor.apana.org.au>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
References: <20190821143253.30209-1-ard.biesheuvel@linaro.org>
 <20190821143253.30209-9-ard.biesheuvel@linaro.org>
 <20190830080347.GA6677@gondor.apana.org.au>
 <CAKv+Gu-4QBvPcE7YUqgWbT31gdLM8vcHTPbdOCN+UnUMXreuPg@mail.gmail.com>
 <20190903065438.GA9372@gondor.apana.org.au>
 <20190903135020.GB5144@zzz.localdomain>
 <20190903223641.GA7430@gondor.apana.org.au>
 <20190905052217.GA722@sol.localdomain>
 <20190905054032.GA3022@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190905054032.GA3022@gondor.apana.org.au>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Sep 05, 2019 at 03:40:32PM +1000, Herbert Xu wrote:
> On Wed, Sep 04, 2019 at 10:22:17PM -0700, Eric Biggers wrote:
> >
> > Okay, but what about external callers that pass in an error?  (I mean, I don't
> > actually see any currently, but the point of this patch is to allow it...)
> > What would prevent the crash in scatterwalk_done() in that case?
> 
> With external callers the pages are always mapped and therefore
> they have to be unmapped, regardless of whether the actual crypto
> succeeded or not.
> 

That's not what I'm talking about.  I'm talking about flushing the page, in
scatterwalk_done().  It assumes the page that was just processed was:

	sg_page(walk->sg) + ((walk->offset - 1) >> PAGE_SHIFT)

But if no bytes were processed, this is invalid.  Notably, if no bytes were
processed then walk->offset can be 0, causing a crash.

- Eric
