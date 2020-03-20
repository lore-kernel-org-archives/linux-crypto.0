Return-Path: <SRS0=WfFd=5F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16E5BC4332B
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 03:51:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAD9620722
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Mar 2020 03:51:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbgCTDv3 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 19 Mar 2020 23:51:29 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:33918 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726847AbgCTDv3 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 19 Mar 2020 23:51:29 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jF8gW-0001WX-Vp; Fri, 20 Mar 2020 14:51:02 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 20 Mar 2020 14:51:00 +1100
Date:   Fri, 20 Mar 2020 14:51:00 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Torsten Duwe <duwe@lst.de>
Cc:     Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Patch][Fix] crypto: arm{,64} neon: memzero_explicit aes-cbc key
Message-ID: <20200320035100.GE27372@gondor.apana.org.au>
References: <20200313110258.94A0668C4E@verein.lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313110258.94A0668C4E@verein.lst.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 13, 2020 at 12:02:58PM +0100, Torsten Duwe wrote:
> From: Torsten Duwe <duwe@suse.de>
> 
> At function exit, do not leave the expanded key in the rk struct
> which got allocated on the stack.
> 
> Signed-off-by: Torsten Duwe <duwe@suse.de>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
