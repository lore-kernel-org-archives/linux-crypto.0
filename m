Return-Path: <SRS0=mFw2=7S=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1154AC433E0
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 18:48:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DED3F207ED
	for <linux-crypto@archiver.kernel.org>; Fri,  5 Jun 2020 18:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591382928;
	bh=Ekno/URQVX9oAmcyKj/ytrDBD7qiF4bwfOAZ7/sCKaI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=l0oOz37Lngi4y0QE8olDXr7x1MRTnsPbVZukk4WpWwbose0JhmR/eLZt925I0EXA3
	 5IA+VMxSoQpwDsgThvWx07fTU+OoweyCVA6UAz3/h4PQiuAzu5GS/t6RmrujZx/SYu
	 +lFul7fKLBQ+ZMU86vVssqyNFSmeOuxEeF3M7wZc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgFESss (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 5 Jun 2020 14:48:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:57088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726846AbgFESss (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 5 Jun 2020 14:48:48 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6976206FA;
        Fri,  5 Jun 2020 18:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591382927;
        bh=Ekno/URQVX9oAmcyKj/ytrDBD7qiF4bwfOAZ7/sCKaI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dCSkmTmnNr2ESl8D20Z8p024eiYzgc79JuQoQWx9hy/O49TzsVnsSScNCWaHC3vQr
         7kY01woELUxK4dVLilvG9DhfxC7kCZPj68V2DXPJTCLhbttZQ2p0K1NVFQ1NpM5hQY
         6/7x3Q1GZJqQUI9PdrSculW3pW+sCnjxd/9EHZ9A=
Date:   Fri, 5 Jun 2020 11:48:46 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [v2 PATCH] crc-t10dif: Fix potential crypto notify dead-lock
Message-ID: <20200605184846.GI1373@sol.localdomain>
References: <20200604063324.GA28813@gondor.apana.org.au>
 <20200605065918.GA813@gondor.apana.org.au>
 <20200605182237.GG1373@sol.localdomain>
 <20200605182522.GA9536@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605182522.GA9536@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jun 06, 2020 at 04:25:22AM +1000, Herbert Xu wrote:
> > That would make the checks for a NULL tfm in crc_t10dif_transform_show() and
> > crc_t10dif_notify() unnecessary.  Also, it would make it so that
> > crc_t10dif_update() no longer crashes if called before module_init().
> 
> crc_t10dif_update can never be called prior to module_init while
> the other two functions both can.
> 

That's only guaranteed to be true if the code is built is a loadable module.  If
it's built-in to the kernel, it could be called earlier, by a previous initcall.

Probably no one is running into this now, but it could happen in the future.

- Eric
