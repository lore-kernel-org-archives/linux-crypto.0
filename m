Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50D65C4708C
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 07:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2BF96611CD
	for <linux-crypto@archiver.kernel.org>; Fri, 28 May 2021 07:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbhE1Haa (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 28 May 2021 03:30:30 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50388 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229608AbhE1Ha3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 28 May 2021 03:30:29 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtp (Exim 4.92 #5 (Debian))
        id 1lmWvI-0003ln-2z; Fri, 28 May 2021 15:28:48 +0800
Received: from herbert by gondobar with local (Exim 4.92)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1lmWvH-00021s-U9; Fri, 28 May 2021 15:28:47 +0800
Date:   Fri, 28 May 2021 15:28:47 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hui Tang <tanghui20@huawei.com>
Cc:     davem@davemloft.net, linux-crypto@vger.kernel.org,
        xuzaibo@huawei.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] crypto: ecdh - register NIST P384
Message-ID: <20210528072847.GP7392@gondor.apana.org.au>
References: <1621651471-42010-1-git-send-email-tanghui20@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621651471-42010-1-git-send-email-tanghui20@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, May 22, 2021 at 10:44:27AM +0800, Hui Tang wrote:
> Register NIST P384 tfm and extend the testmgr with NIST P384 test vectors.
> 
> Summary of changes:
> 
> * crypto/ecdh.c
>   - fix 'ecdh_init' not unregistering NIST P192
>   - add ecdh_nist_p384_init_tfm
>   - register and unregister P384 tfm
> 
> * crypto/testmgr.c
>   - add test vector for P384 on vector of tests
> 
> * crypto/testmgr.h
>   - add test vector params for P384
> 
> ---
> v1 -> v2:
> * Add patch#1:
>   - Fix ecdh-nist-p192's entry in testmgr.
>   - Add a comment for registering ecdh-nist-p192.
> 
> v2 - > v3:
> * Fix patch#1 subject format.
> ---
> 
> Hui Tang (4):
>   crypto: ecdh - fix ecdh-nist-p192's entry in testmgr
>   crypto: ecdh - fix 'ecdh_init'
>   crypto: ecdh - register NIST P384 tfm
>   crypto: ecdh - add test suite for NIST P384
> 
>  crypto/ecdh.c    | 45 +++++++++++++++++++++++++++++++++++++++-
>  crypto/testmgr.c | 10 ++++++---
>  crypto/testmgr.h | 63 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  3 files changed, 112 insertions(+), 6 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
