Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4CE2EB64DA
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jun 2023 19:50:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjF3TuO (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 30 Jun 2023 15:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230364AbjF3TuN (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Jun 2023 15:50:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB47F19A9;
        Fri, 30 Jun 2023 12:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 78B286179C;
        Fri, 30 Jun 2023 19:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8295EC433C0;
        Fri, 30 Jun 2023 19:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1688154611;
        bh=RjHGfeGug/am7KllmZcNTHDBJHShpxNwhkWbu6BH2v0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JYevyD02g6Ftcod4VsIaeKkyzHK3p5fB47QQEQo+KavRrD04fHATBcrvo1SGTpJ2+
         3FFCi1tF6ENa7og7CwQO/imnFT/ZARBAU4/I7zbDGN13yFCrB2V+jTftgvZaMBVUCJ
         3Nx8d5zHbmnNDkiw5dZxiEqgoC6X9lh7/HgdcBHM=
Date:   Fri, 30 Jun 2023 21:50:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Benno Lossin <benno.lossin@proton.me>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        FUJITA Tomonori <fujita.tomonori@gmail.com>,
        rust-for-linux@vger.kernel.org, Gary Guo <gary@garyguo.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Subject: Re: [RFC PATCH v2 1/2] rust: add synchronous message digest support
Message-ID: <2023063045-slightly-scribe-6d09@gregkh>
References: <20230615142311.4055228-1-fujita.tomonori@gmail.com>
 <20230615142311.4055228-2-fujita.tomonori@gmail.com>
 <udHI3v-OLUqHQt3fwnH71QuRJjzGxexw2rkIYEfnsChCmrLoJTIL_GL1wLCARf-UotY51jkPT6tC8nVDvjf8LkY2zvddpgeRQ5owysZwJos=@proton.me>
 <20230622.111419.241422502377572827.ubuntu@gmail.com>
 <0a9af5fa-4df2-11da-b3cb-0a6b1d27fdc2@proton.me>
 <o6lMzg30KAx1IKuGUzjTWb8ciTkkb_vbseDHu2u5nqLeijQ0vX1QgDOij0HGjQkW4NhJcOMoXHvMCstcByEzjq_CjMuN61l1rUo9DaIf97Y=@proton.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <o6lMzg30KAx1IKuGUzjTWb8ciTkkb_vbseDHu2u5nqLeijQ0vX1QgDOij0HGjQkW4NhJcOMoXHvMCstcByEzjq_CjMuN61l1rUo9DaIf97Y=@proton.me>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jun 30, 2023 at 02:48:37PM +0000, Benno Lossin wrote:
> We came up with the following solutions, but could not come to a consensus on any
> particular one, could you please assist us in making this decision?
> 
> 2. panic

Never an option in kernel code, sorry, please don't even suggest it.

thanks,

greg k-h
