Return-Path: <SRS0=uowK=SU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF11C282DD
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:27:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED3A120835
	for <linux-crypto@archiver.kernel.org>; Thu, 18 Apr 2019 14:27:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388996AbfDRO1L (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 18 Apr 2019 10:27:11 -0400
Received: from [5.180.42.13] ([5.180.42.13]:55196 "EHLO deadmen.hmeau.com"
        rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388819AbfDRO1L (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 18 Apr 2019 10:27:11 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hH80E-0004oa-00; Thu, 18 Apr 2019 22:27:02 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hH808-0004Dx-R9; Thu, 18 Apr 2019 22:26:56 +0800
Date:   Thu, 18 Apr 2019 22:26:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Zhang Zhijie <zhangzj@rock-chips.com>
Cc:     linux-crypto@vger.kernel.org, heiko@sntech.de, ebiggers@google.com,
        huangtao@rock-chips.com, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: rockchip - update IV buffer to contain the next
 IV
Message-ID: <20190418142656.jshlacrmzils67gy@gondor.apana.org.au>
References: <20190412091633.32697-1-zhangzj@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190412091633.32697-1-zhangzj@rock-chips.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 12, 2019 at 05:16:33PM +0800, Zhang Zhijie wrote:
> The Kernel Crypto API request output the next IV data to
> IV buffer for CBC implementation. So the last block data of
> ciphertext should be copid into assigned IV buffer.
> 
> Reported-by: Eric Biggers <ebiggers@google.com>
> Fixes: 433cd2c617bf ("crypto: rockchip - add crypto driver for rk3288")
> Cc: <stable@vger.kernel.org> # v4.5+
> Signed-off-by: Zhang Zhijie <zhangzj@rock-chips.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
