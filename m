Return-Path: <SRS0=0bM2=3R=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D9E5C33CB7
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 02:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1308A2173E
	for <linux-crypto@archiver.kernel.org>; Tue, 28 Jan 2020 02:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580180155;
	bh=nPCZMW+ucFeiAv6PJ0U8u697QhEtA9gfg4X/lUBIuMg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=p1lWXxNGE6hGN0WWH4eRmTdRZZ9wLOqUmnJo+T+ahSg2u9omjlLH64yzo8tOPL216
	 JC8q+7jh1KETdhde0ss4pe6RogSEEVfeAcD8G2H2qmODw8lOgKdjJvt6er6nVliYJK
	 0L+eA4yBjveMv4ADDiAvsWfFNgn+CbKKGOGzOO7s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgA1Czy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 27 Jan 2020 21:55:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbgA1Czy (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 27 Jan 2020 21:55:54 -0500
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 41F17205F4;
        Tue, 28 Jan 2020 02:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580180153;
        bh=nPCZMW+ucFeiAv6PJ0U8u697QhEtA9gfg4X/lUBIuMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gc3If7w0LF7yAxCopVwnRIO5+0+XPmE6sk1dSxYZ+sf6FnYXihS4av0uh+j6AiIRj
         euGTuMghRQSyMoTWeytrVrZvbzQs2HrmShyuotyYRW0D5dThKQeFenuYkc4a7991ht
         jF5pBjamiP1U1mW980hGfSFw+yTyWD4Ix8hbA3nM=
Date:   Mon, 27 Jan 2020 18:55:51 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Gilad Ben-Yossef <gilad@benyossef.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v3] crypto: ccree - protect against short scatterlists
Message-ID: <20200128025551.GE960@sol.localdomain>
References: <20200127150822.12126-1-gilad@benyossef.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200127150822.12126-1-gilad@benyossef.com>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jan 27, 2020 at 05:08:21PM +0200, Gilad Ben-Yossef wrote:
> Deal gracefully with the event of being handed a scatterlist
> which is shorter than expected.
> 
> This mitigates a crash in some cases due to
> attempt to map empty (but not NULL) scatterlists with none
> zero lengths.
> 
> Signed-off-by: Gilad Ben-Yossef <gilad@benyossef.com>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>

It's definitely wrong use of the crypto API to pass a scatterlist that's too
short.  Note that this is *not* what the test code is doing.

So I don't think you should be hacking around it here.

It is possible the bug is actually in cc_aead_chain_data()?  It looks like it's
adding the authentication tag size to the source data size for encryption, which
is not correct.  The authentication tag is part of the destination only.

	size_for_map += (direct == DRV_CRYPTO_DIRECTION_ENCRYPT) ?
			authsize : 0;
	src_mapped_nents = cc_get_sgl_nents(dev, req->src, size_for_map,
					    &src_last_bytes);

- Eric
