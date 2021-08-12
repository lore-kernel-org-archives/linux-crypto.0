Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85DF3C4338F
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 11:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7210760F57
	for <linux-crypto@archiver.kernel.org>; Thu, 12 Aug 2021 11:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbhHLLhL (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Aug 2021 07:37:11 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:52736 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236931AbhHLLhI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Aug 2021 07:37:08 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1mE90q-0003Ll-4h; Thu, 12 Aug 2021 19:36:40 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1mE90p-0000Aj-SA; Thu, 12 Aug 2021 19:36:39 +0800
Date:   Thu, 12 Aug 2021 19:36:39 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hongbo Li <herbert.tencent@gmail.com>
Cc:     linux-crypto@vger.kernel.org, ebiggers@kernel.org,
        herberthbli@tencent.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib/mpi: use kcalloc in mpi_resize
Message-ID: <20210812113639.GD561@gondor.apana.org.au>
References: <1628153612-14419-1-git-send-email-herbert.tencent@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1628153612-14419-1-git-send-email-herbert.tencent@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Aug 05, 2021 at 04:53:32PM +0800, Hongbo Li wrote:
> From: Hongbo Li <herberthbli@tencent.com>
> 
> We should set the additional space to 0 in mpi_resize().
> So use kcalloc() instead of kmalloc_array().
> 
> In lib/mpi/ec.c:
> /****************
>  * Resize the array of A to NLIMBS. the additional space is cleared
>  * (set to 0) [done by m_realloc()]
>  */
> int mpi_resize(MPI a, unsigned nlimbs)
> 
> Like the comment of kernel's mpi_resize() said, the additional space
> need to be set to 0, but when a->d is not NULL, it does not set.
> 
> The kernel's mpi lib is from libgcrypt, the mpi resize in libgcrypt
> is _gcry_mpi_resize() which set the additional space to 0.
> 
> This bug may cause mpi api which use mpi_resize() get wrong result
> under the condition of using the additional space without initiation.
> If this condition is not met, the bug would not be triggered.
> Currently in kernel, rsa, sm2 and dh use mpi lib, and they works well,
> so the bug is not triggered in these cases.
> 
> add_points_edwards() use the additional space directly, so it will
> get a wrong result.
> 
> Fixes: cdec9cb5167a ("crypto: GnuPG based MPI lib - source files (part 1)")
> Signed-off-by: Hongbo Li <herberthbli@tencent.com>
> ---
>  lib/mpi/mpiutil.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
