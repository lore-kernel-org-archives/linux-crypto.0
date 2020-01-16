Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEA3DC33CB1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 07:29:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BECE6206D9
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 07:29:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729652AbgAPH3L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 02:29:11 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:39946 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729431AbgAPH3L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 02:29:11 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1irzaV-0005Z8-M0; Thu, 16 Jan 2020 15:29:07 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1irzaS-0000nI-Hs; Thu, 16 Jan 2020 15:29:04 +0800
Date:   Thu, 16 Jan 2020 15:29:04 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Rijo Thomas <Rijo-john.Thomas@amd.com>
Cc:     Jens Wiklander <jens.wiklander@linaro.org>,
        Gary R Hook <gary.hook@amd.com>, tee-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Nimesh Easow <Nimesh.Easow@amd.com>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 0/5] amdtee: Address bug report
Message-ID: <20200116072904.o65qfy3atn66ruxi@gondor.apana.org.au>
References: <cover.1578572591.git.Rijo-john.Thomas@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1578572591.git.Rijo-john.Thomas@amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jan 09, 2020 at 06:23:17PM +0530, Rijo Thomas wrote:
> This patch series addresses the bug report submitted by Dan Carpenter.
> 
> Link: https://lists.linaro.org/pipermail/tee-dev/2020-January/001417.html
> 
> Since, these patches are based on cryptodev-2.6 tree, I have included
> linux-crypto list as well.
> 
> This patch series does not fix the static checker warning reported due
> to incorrect use of IS_ERR. Colin Ian King has submitted a fix for this
> issue. Link: https://lkml.org/lkml/2020/1/8/88
> 
> Rijo Thomas (5):
>   tee: amdtee: remove unused variable initialization
>   tee: amdtee: print error message if tee not present
>   tee: amdtee: skip tee_device_unregister if tee_device_alloc fails
>   tee: amdtee: rename err label to err_device_unregister
>   tee: amdtee: remove redundant NULL check for pool
> 
>  drivers/tee/amdtee/call.c | 14 +++++++-------
>  drivers/tee/amdtee/core.c | 32 +++++++++++++++++---------------
>  2 files changed, 24 insertions(+), 22 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
