Return-Path: <SRS0=BTb3=TX=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B39AEC04AAC
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 05:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8DBDA21019
	for <linux-crypto@archiver.kernel.org>; Thu, 23 May 2019 05:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725806AbfEWFjH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 23 May 2019 01:39:07 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:47222 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725786AbfEWFjH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 May 2019 01:39:07 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hTgRL-0000hH-M2; Thu, 23 May 2019 13:38:55 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hTgRF-0006oF-Lf; Thu, 23 May 2019 13:38:49 +0800
Date:   Thu, 23 May 2019 13:38:49 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Philippe Mazenauer <philippe.mazenauer@outlook.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto: arm/sha512 - make function static
Message-ID: <20190523053849.u2rpdk5ddafrkcnx@gondor.apana.org.au>
References: <VI1PR07MB44324EFEF57062FCCA758358FD000@VI1PR07MB4432.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <VI1PR07MB44324EFEF57062FCCA758358FD000@VI1PR07MB4432.eurprd07.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, May 22, 2019 at 10:07:14AM +0000, Philippe Mazenauer wrote:
> Function sha512_arm_final() is only used in this file, therefore should
> be static
> 
> ../arch/arm/crypto/sha512-glue.c:40:5: warning: no previous prototype for ‘sha512_arm_final’ [-Wmissing-prototypes]
>  int sha512_arm_final(struct shash_desc *desc, u8 *out)
>      ^~~~~~~~~~~~~~~~
> 
> Signed-off-by: Philippe Mazenauer <philippe.mazenauer@outlook.de>

An identical patch is already in the patchwork queue.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
