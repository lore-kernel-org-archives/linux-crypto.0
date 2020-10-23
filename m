Return-Path: <SRS0=juaY=D6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 319E1C388F9
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 22:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B688E2137B
	for <linux-crypto@archiver.kernel.org>; Fri, 23 Oct 2020 22:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603492284;
	bh=i8RM3CKw39RhCAPy2hzJBpQNkFJtyzO4IU8+1xXvR9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=EFw+32i8hmD4l5xdIYR66gMGuLBncU1zFgBztb/xrdA3IYMGMyBi9gBSXr3GNOcVU
	 HTtgQPdJl6k6dYZzx0IkC02DYUQS0pkgEz9efiKcgRR+/5MyERWjrc/OYfhxr3tRCb
	 NAR6rM5M7Zw9L2MlwnLEp29P3Yyf2LVtXxHMAOR4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1757115AbgJWWbY (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 23 Oct 2020 18:31:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:46764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757099AbgJWWbX (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 23 Oct 2020 18:31:23 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3E3620BED;
        Fri, 23 Oct 2020 22:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603492283;
        bh=i8RM3CKw39RhCAPy2hzJBpQNkFJtyzO4IU8+1xXvR9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AbP1Ugtq/BVULN+PmVbtdY9vNZBB2R+HE3gwR2Pn+LSrpNjR9yROsSthgaoVhgppd
         i1zU4YNHNTvyXWS2lPn03TuE7/1tPPWviObdQZbynpgqhefg0O/mjND1Ra3g4TLCgu
         0QITHOgj9TAJIONWEA2eUiC9clOVXoD1GT5PoSuc=
Date:   Fri, 23 Oct 2020 15:31:21 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 4/5] crypto: lib/sha256 - Unroll SHA256 loop 8 times
 intead of 64
Message-ID: <20201023223121.GC180517@gmail.com>
References: <20201023192203.400040-1-nivedita@alum.mit.edu>
 <20201023192203.400040-5-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201023192203.400040-5-nivedita@alum.mit.edu>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 23, 2020 at 03:22:02PM -0400, Arvind Sankar wrote:
> This reduces code size substantially (on x86_64 with gcc-10 the size of
> sha256_update() goes from 7593 bytes to 1952 bytes including the new
> SHA256_K array), and on x86 is slightly faster than the full unroll
> (tested on Broadwell Xeon).
> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

Looks good,

Reviewed-by: Eric Biggers <ebiggers@google.com>

