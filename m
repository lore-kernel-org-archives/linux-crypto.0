Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1DFCC33CB1
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 07:06:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9A6F720730
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 07:06:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729241AbgAPHF4 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 02:05:56 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:38450 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgAPHF4 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 02:05:56 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1irzDx-0005Bk-Ai; Thu, 16 Jan 2020 15:05:49 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1irzDs-0006Vy-ML; Thu, 16 Jan 2020 15:05:44 +0800
Date:   Thu, 16 Jan 2020 15:05:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     "Thomas, Rijo-john" <Rijo-john.Thomas@amd.com>
Cc:     Colin King <colin.king@canonical.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Devaraj Rangasamy <Devaraj.Rangasamy@amd.com>,
        Gary R Hook <gary.hook@amd.com>, tee-dev@lists.linaro.org,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] tee: fix memory allocation failure checks on
 drv_data and amdtee
Message-ID: <20200116070544.doegatlwgsftbhc4@gondor.apana.org.au>
References: <20200107143601.105321-1-colin.king@canonical.com>
 <747f9c93-7465-99aa-0b91-a05fd64c7d1f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <747f9c93-7465-99aa-0b91-a05fd64c7d1f@amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 08, 2020 at 12:33:08PM +0530, Thomas, Rijo-john wrote:
> +linux-crypto
> 
> On 07/01/20 8:06 pm, Colin King wrote:
> > From: Colin Ian King <colin.king@canonical.com>
> > 
> > Currently the memory allocation failure checks on drv_data and
> > amdtee are using IS_ERR rather than checking for a null pointer.
> > Fix these checks to use the conventional null pointer check.
> > 
> > Addresses-Coverity: ("Dereference null return")
> > Fixes: 757cc3e9ff1d ("tee: add AMD-TEE driver")
> > Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> Reviewed-by: Rijo Thomas <Rijo-john.Thomas@amd.com>

This patch needs to be resubmitted to the linux-crypto list for
it to be picked up by patchwork.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
