Return-Path: <SRS0=smUI=QA=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55893C282C3
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 18:22:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A77221872
	for <linux-crypto@archiver.kernel.org>; Thu, 24 Jan 2019 18:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548354151;
	bh=dgd4MLRhgS7sjOwwgjVTMbOh3xyNoB00wMC+ZZVqkzI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=OrLQIv9O4eTj+sa1tP2AaRWn/aQniRqR5Kl74+7oKX1i0QYIeXlGWi6zS0Ox9EZod
	 EpIb4iNo7gtc/F/b55zXmZzPIa9CtzcKKeUVb51anKgi1xL3PqqCh4B7hK5Z2K6X8W
	 5Fe/dAxb9Xos4fyRpUq5o7jmmLtogX5lOgexD4jg=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726030AbfAXSWa (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 24 Jan 2019 13:22:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:47806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725974AbfAXSWa (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 24 Jan 2019 13:22:30 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A16202184C;
        Thu, 24 Jan 2019 18:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548354149;
        bh=dgd4MLRhgS7sjOwwgjVTMbOh3xyNoB00wMC+ZZVqkzI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PV2BA+gI9eyiSXiMmyUtCImdil5lE+jj9m5Dmsd+efIZUuYFFq/+CIiRBc8JFF1lN
         WcBFoUOPUXsXXwcp0irgQ9ZjYak0LZ2z8H4wNYjM3iXLkGtOgpyDyqJk3azBN+gvpS
         uWz1rZkuq7RmZNlj5UOlJpqcG5Q/cLKDbdGj9G/8=
Date:   Thu, 24 Jan 2019 10:22:28 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC/RFT PATCH 00/15] crypto: improved skcipher, aead, and hash
 tests
Message-ID: <20190124182226.GA10448@gmail.com>
References: <20190123224926.250525-1-ebiggers@kernel.org>
 <20190124084818.GA650@sol.localdomain>
 <CAKv+Gu9zridWAYO3cR_KAAbupWfLd+FAMmcgAMuYE5Lgxoek-w@mail.gmail.com>
 <20190124092359.hvizqdi2ptjdsot7@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190124092359.hvizqdi2ptjdsot7@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 24, 2019 at 05:23:59PM +0800, Herbert Xu wrote:
> On Thu, Jan 24, 2019 at 09:50:35AM +0100, Ard Biesheuvel wrote:
> >
> > Thanks for yet another round of cleanup
> > 
> > I'll look into these, but I'd like to clarify one thing first.
> > 
> > IIUC, you are trying to deal with the case where a single scatterlist
> > element describes a range that strides two pages, and I wonder if that
> > is a valid use of scatterlists in the first place.
> > 
> > Herbert?
> 
> Yes it is valid.  IIRC the network stack may generate such a
> scatterlist.
> 

Also it can easily happen with kmalloced buffers, e.g.

	buf = kmalloc(10000, GFP_KERNEL);

	[...]

	sg_init_one(&sg, buf, 10000);

- Eric
