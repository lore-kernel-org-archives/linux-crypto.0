Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97B63C282C0
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 66764218A2
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 10:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfAYKsF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 05:48:05 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:44452 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725909AbfAYKsF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 05:48:05 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gmz1n-0005hb-SD; Fri, 25 Jan 2019 18:48:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gmz1m-00026b-Gu; Fri, 25 Jan 2019 18:48:02 +0800
Date:   Fri, 25 Jan 2019 18:48:02 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Xiongfeng Wang <wangxiongfeng2@huawei.com>
Cc:     davem@davemloft.net, ebiggers@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        broonie@kernel.org, ard.biesheuvel@linaro.org,
        jonathan.cameron@huawei.com
Subject: Re: [PATCH V3 0/5] Crypto Cleanup
Message-ID: <20190125104802.edcc6ryexkqhtq7f@gondor.apana.org.au>
References: <1547791095-48339-1-git-send-email-wangxiongfeng2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1547791095-48339-1-git-send-email-wangxiongfeng2@huawei.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 18, 2019 at 01:58:10PM +0800, Xiongfeng Wang wrote:
> The patchset introduce a helper to (un)register a array of crypto templates.
> The following patches use this helper to simplify the code. This is also
> a preparation for a coming patchset, which will register several crypto
> templates.
> 
> Changelog:
> v2 -> v3:
> 	remove the extra blank line in the fourth patch
> 	change author to Xiongfeng Wang <xiongfeng.wang@linaro.org>
> v1 -> v2: 
> 	rebased to cryptodev, fix some format issue
> 
> Xiongfeng Wang (5):
>   crypto: api - add a helper to (un)register a array of templates
>   crypto: ccm - use template array registering API to simplify the code
>   crypto: gcm - use template array registering API to simplify the code
>   crypto: ctr - use template array registering API to simplify the code
>   crypto: chacha20poly1305 - use template array registering API to
>     simplify the code
> 
>  crypto/algapi.c           | 27 ++++++++++++++++
>  crypto/ccm.c              | 78 ++++++++++++++---------------------------------
>  crypto/chacha20poly1305.c | 37 +++++++++-------------
>  crypto/ctr.c              | 42 +++++++++----------------
>  crypto/gcm.c              | 73 ++++++++++++++------------------------------
>  include/crypto/algapi.h   |  2 ++
>  6 files changed, 103 insertions(+), 156 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
