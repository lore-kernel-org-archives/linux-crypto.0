Return-Path: <SRS0=cdcO=3E=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B7DC33CB1
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jan 2020 06:02:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 517FB2187F
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jan 2020 06:02:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgAOGCg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Jan 2020 01:02:36 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:40360 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725962AbgAOGCg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Jan 2020 01:02:36 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1irblD-0007S7-Cu; Wed, 15 Jan 2020 14:02:35 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1irblC-0003eD-R0; Wed, 15 Jan 2020 14:02:34 +0800
Date:   Wed, 15 Jan 2020 14:02:34 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ayush Sawal <ayush.sawal@asicdesigners.com>
Cc:     linux-crypto@vger.kernel.org, manojmalviya@chelsio.com
Subject: Re: Advertise maximum number of sg supported by driver in single
 request
Message-ID: <20200115060234.4mm6fsmsrryzpymi@gondor.apana.org.au>
References: <7f7216f7-c76f-35ba-38c0-de197c2df7f1@asicdesigners.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7f7216f7-c76f-35ba-38c0-de197c2df7f1@asicdesigners.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Jan 14, 2020 at 03:23:30PM +0530, Ayush Sawal wrote:
> Hi all,
> 
> The hardware crypto drivers have a limit on max number of sgs they can
> handle per crypto request.If data size in one crypto request is
> huge,hardware crypto driver may not be able to send the request in single
> shot to hardware and end up using fallback to software.
> 
> Does it make sense to have a new API for crypto drivers using that drivers
> can advertise the max number of sg it can handle in one crypto request?
> 
> and then  crypto framework may also have to include the similar API which
> crypto framework user can use while forming the crypto request .
> 
> Does this implementation make sense?

What is the actual limit? Are you running into this limit with
real-life requests?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
