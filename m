Return-Path: <SRS0=BhDJ=YL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C81CCA9EA0
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 08:05:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1EAB52089C
	for <linux-crypto@archiver.kernel.org>; Fri, 18 Oct 2019 08:05:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442137AbfJRIFZ (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:05:25 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37380 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbfJRIFZ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 18 Oct 2019 04:05:25 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1iLNFb-0001w4-7a; Fri, 18 Oct 2019 19:04:44 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 18 Oct 2019 19:04:43 +1100
Date:   Fri, 18 Oct 2019 19:04:43 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Yunfeng Ye <yeyunfeng@huawei.com>
Cc:     atul.gupta@chelsio.com, davem@davemloft.net, willy@infradead.org,
        kstewart@linuxfoundation.org, ira.weiny@intel.com,
        akpm@linux-foundation.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] crypto: chtls - remove the redundant check in
 chtls_recvmsg()
Message-ID: <20191018080443.GI25128@gondor.apana.org.au>
References: <3c88d0b1-b6c6-9641-ffdf-20104a684402@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c88d0b1-b6c6-9641-ffdf-20104a684402@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 11, 2019 at 08:44:53PM +0800, Yunfeng Ye wrote:
> A warning message reported by a static analysis tool:
>   "
>   Either the condition 'if(skb)' is redundant or there is possible null
>   pointer dereference: skb.
>   "
> 
> Remove the unused redundant check.
> 
> Signed-off-by: Yunfeng Ye <yeyunfeng@huawei.com>
> ---
>  drivers/crypto/chelsio/chtls/chtls_io.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
