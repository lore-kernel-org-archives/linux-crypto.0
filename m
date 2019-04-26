Return-Path: <SRS0=Wqm9=S4=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7262C43219
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 16:54:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C2022084F
	for <linux-crypto@archiver.kernel.org>; Fri, 26 Apr 2019 16:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556297651;
	bh=yDxLLh/5/6b2YknfzDhsixPsautFvuPJCpErserMFKA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=MVtYvAaaOkt8lvfbVxTq2NKfVFcMkp/UMYqXFB6EFR6dfqz0+5FEg1mAKvEfwDeLi
	 gOfCCVOlXvM6vcEsnkBbvm0SWzHlhzjFetISDJ3tJvODQxk8oDPQgVTaDWwLSp7txG
	 SboXiP60RuO4lJzPHpvn/wMkZ81iVYqGzgXN2dIQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbfDZQyK (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 26 Apr 2019 12:54:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:37750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725944AbfDZQyK (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 26 Apr 2019 12:54:10 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B71F9206E0;
        Fri, 26 Apr 2019 16:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556297649;
        bh=yDxLLh/5/6b2YknfzDhsixPsautFvuPJCpErserMFKA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R23b7UVsU04NiyFZcXMWVa5GGvldWNkIBM/NI0/ZAdUqR8LElL9svUq6m8WlgbNNN
         BdMP2P44v4vZAQP911kfmoYNPzZLdqjGpqSdMNpgWH1KkMv0w5cB9SXs5nQIuT/GVJ
         q1PvhnyWRwuVTxlGiKQsG4hI5Lvr5zTATPjSX5nc=
Date:   Fri, 26 Apr 2019 09:54:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/7] crypto: fuzz algorithms against their generic
 implementation
Message-ID: <20190426165406.GA691@sol.localdomain>
References: <20190412045742.1725-1-ebiggers@kernel.org>
 <VI1PR0402MB3485A6BE1840DD5B060FACB7983E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB3485A6BE1840DD5B060FACB7983E0@VI1PR0402MB3485.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Horia,

On Fri, Apr 26, 2019 at 04:35:05PM +0000, Horia Geanta wrote:
> On 4/12/2019 8:00 AM, Eric Biggers wrote:
> > So far I've tested all generic, x86, arm, and arm64 algorithms, plus
> > some PowerPC algorithms.  I have not tested hardware drivers.  I
> > encourage people to run the tests on drivers and other architectures, as
> > they will find more bugs.
> > 
> I am seeing some errors in caam hardware driver.
> They are due to error code mismatch b/w generic algorithm implementation and
> what caam driver returns.
> 
> Random skcipher tests for block cipher algorithms are expected to fail when
> input size is not a multiple of algorithm block size.
> Generic implementation returns -EINVAL.
> caam driver returns the status received from HW.
> 
> This probably has to be fixed in caam driver, but I wonder if there's an
> agreement on what error code should be returned in every single case (since I'll
> have to do a N:M mapping b/w errors returned by HW and errors expected by crypto
> API).
> Should I take the generic S/W implementation as reference?
> 
> Thanks,
> Horia

Yes, use the generic driver as a reference.  I don't understand why you're
saying there are so many cases to handle, though.  The only error cases I'd
expect to actually be encountered during the tests are invalid input lengths and
invalid key lengths, where you should return -EINVAL.  There may be other errors
your driver could theoretically produce, but I wouldn't expect them to be
encountered during the tests unless there are testmgr, driver, or hardware bugs.

But remember you must always return a -errno code, not a driver-specific code.

- Eric
