Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA8EBC4338F
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jul 2021 03:11:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C54DE60E9B
	for <linux-crypto@archiver.kernel.org>; Fri, 30 Jul 2021 03:11:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235753AbhG3DLF (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 29 Jul 2021 23:11:05 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:51572 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230196AbhG3DLE (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 29 Jul 2021 23:11:04 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1m9IvB-0000g8-Ug; Fri, 30 Jul 2021 11:10:49 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1m9Iv9-0003Bd-W0; Fri, 30 Jul 2021 11:10:48 +0800
Date:   Fri, 30 Jul 2021 11:10:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Xiyu Yang <xiyuyang19@fudan.edu.cn>, yuanxzhang@fudan.edu.cn,
        Xin Tan <tanxin.ctf@gmail.com>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] padata: Convert from atomic_t to refcount_t on
 parallel_data->refcnt
Message-ID: <20210730031047.GD12121@gondor.apana.org.au>
References: <20210719214649.w65ifdp2hriryrsc@oracle.com>
 <20210720150511.877668-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720150511.877668-1-daniel.m.jordan@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jul 20, 2021 at 11:05:11AM -0400, Daniel Jordan wrote:
> From: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> 
> refcount_t type and corresponding API can protect refcounters from
> accidental underflow and overflow and further use-after-free situations.
> 
> Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
> Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
> Acked-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> ---
> 
> This seems not to have made it to the lists even though they were
> originally cc'd.  Reposting.
> 
>  include/linux/padata.h | 3 ++-
>  kernel/padata.c        | 8 ++++----
>  2 files changed, 6 insertions(+), 5 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
