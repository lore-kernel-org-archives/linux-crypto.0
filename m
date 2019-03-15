Return-Path: <SRS0=TeaG=RS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C319C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 19:49:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8363218D0
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Mar 2019 19:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552679358;
	bh=u/ImkoFUPoumUuDbNgNtQwsXm1RMmaWB/EYBPuXwTAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=QG3YC1klkBhgwpgeNusFXUSrBfrT+PiI7+OEBybJNvEA+2nZ8yettgjjb8weo3NBl
	 oel5KKrSWqF+LwZwc4GQyxCPDonNtHUyj4FPWFcoFsoFVgZfyA2gETzmUAjxnYcda+
	 TyDM49c7BWcOj8StLUPloLkhT0cdN+NE9R5fNIuQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfCOTtS (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Mar 2019 15:49:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:33052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbfCOTtS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Mar 2019 15:49:18 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F0A62063F;
        Fri, 15 Mar 2019 19:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552679357;
        bh=u/ImkoFUPoumUuDbNgNtQwsXm1RMmaWB/EYBPuXwTAk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m3rsBPEbWKM84GDKqr9TXvGkWy9m8i2nq0i15URId6gbb/HMxnhO6x3ypbdo/oGxp
         AF61iSwuz3XOBzmxwX2NzqdEKUr4VMmQD06nBg5b40mY/flJ0w5bXCXvMGxnAvxMDY
         xPH11AmOb4rxysHAA9wB+GEF5RxzxVJwPss1fQ4w=
Date:   Fri, 15 Mar 2019 12:49:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Petr Vorel <pvorel@suse.cz>
Cc:     ltp@lists.linux.it, linux-crypto@vger.kernel.org
Subject: Re: [LTP] [PATCH 4/6] crypto/af_alg03: new regression test for
 rfc7539 hash alg validation
Message-ID: <20190315194914.GC77949@gmail.com>
References: <20190221053026.18489-1-ebiggers@kernel.org>
 <20190221053026.18489-5-ebiggers@kernel.org>
 <20190315092952.GA4990@dell5510>
 <20190315161341.GA77949@gmail.com>
 <20190315184018.GA3112@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190315184018.GA3112@x230>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 15, 2019 at 07:40:18PM +0100, Petr Vorel wrote:
> Hi Eric,
> 
> > > you forget to add af_alg03 into runtest/cve.
> > > The same applies to af_alg0{4,5}.
> 
> > As far as I know, there are no CVEs assigned for those bugs.
> Wouldn't be better to add them to runtest/cve (or other runtest file) just with
> filename? And rename them in runtest file once the CVEs are assigned?
> 
> > - Eric
> 
> Kind regards,
> Petr

Oh, I missed that they're not in any runtest file at all.  They all should be in
runtest/crypto (in addition to the ones with CVEs being in runtest/cve).

- Eric
