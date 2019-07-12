Return-Path: <SRS0=HUI/=VJ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43335C742A5
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 02:21:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2320520863
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Jul 2019 02:21:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729399AbfGLCU7 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Jul 2019 22:20:59 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37410 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729395AbfGLCU6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Jul 2019 22:20:58 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hllBA-0007Eg-Gw; Fri, 12 Jul 2019 10:20:56 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hllB5-0007bd-E3; Fri, 12 Jul 2019 10:20:51 +0800
Date:   Fri, 12 Jul 2019 10:20:51 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Gary R Hook <ghook@amd.com>
Cc:     "Hook, Gary" <Gary.Hook@amd.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Subject: Re: [PATCH v2] crypto: ccp - memset structure fields to zero before
 reuse
Message-ID: <20190712022051.jpqpt46mzw625ewv@gondor.apana.org.au>
References: <20190710000849.3131-1-gary.hook@amd.com>
 <20190710015725.GA746@sol.localdomain>
 <2875285f-d438-667e-52d9-801124ffba88@amd.com>
 <20190710203428.GC83443@gmail.com>
 <d4b8006c-0243-b4a4-c695-a67041acc82f@amd.com>
 <20190711004617.GA628@sol.localdomain>
 <7a4dfdce-41ca-2047-f9f2-77e0b7abedb3@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a4dfdce-41ca-2047-f9f2-77e0b7abedb3@amd.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 11, 2019 at 03:25:00PM +0000, Gary R Hook wrote:
>
> Our device only allows 16 byte tags. So I have to figure out how to set 
> up the driver to expose/enforce that limitation. That's where we go awry.

You need to work around it by using a fallback.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
