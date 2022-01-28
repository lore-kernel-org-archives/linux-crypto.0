Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F169AC433F5
	for <linux-crypto@archiver.kernel.org>; Fri, 28 Jan 2022 06:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242352AbiA1GWJ (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 Jan 2022 01:22:09 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:60588 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233202AbiA1GWI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 Jan 2022 01:22:08 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1nDKdx-0000rW-J9; Fri, 28 Jan 2022 17:21:58 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 28 Jan 2022 17:21:57 +1100
Date:   Fri, 28 Jan 2022 17:21:57 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Kai Ye <yekai13@huawei.com>
Cc:     gregkh@linuxfoundation.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, wangzhou1@hisilicon.com
Subject: Re: [PATCH v2 0/4] Documentation: update debugfs doc for Hisilicon
 Accelerator
Message-ID: <YfOLhXlmSsa5E9Qg@gondor.apana.org.au>
References: <20220104082919.45742-1-yekai13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220104082919.45742-1-yekai13@huawei.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 04, 2022 at 04:29:15PM +0800, Kai Ye wrote:
> Update documentation describing DebugFS for function's QoS limiting.
> Add the note that described how to use the function's QoS limiting.
> 
> changes v1->v2:
> 	fixup the documentation format.
> 
> Kai Ye (4):
>   Documentation: use the tabs on all acc documentation
>   Documentation: update debugfs doc for Hisilicon SEC
>   Documentation: update debugfs doc for Hisilicon ZIP
>   Documentation: update debugfs doc for Hisilicon HPRE
> 
>  Documentation/ABI/testing/debugfs-hisi-hpre | 178 +++++++++++---------
>  Documentation/ABI/testing/debugfs-hisi-sec  | 146 ++++++++--------
>  Documentation/ABI/testing/debugfs-hisi-zip  | 146 ++++++++--------
>  3 files changed, 250 insertions(+), 220 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
