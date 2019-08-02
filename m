Return-Path: <SRS0=PsuD=V6=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDB9C433FF
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 04:45:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 48DFF206A3
	for <linux-crypto@archiver.kernel.org>; Fri,  2 Aug 2019 04:45:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731893AbfHBEpg (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 2 Aug 2019 00:45:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:48560 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728157AbfHBEpg (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 2 Aug 2019 00:45:36 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1htPRd-0006A3-PW; Fri, 02 Aug 2019 14:45:33 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1htPRa-0004fB-2e; Fri, 02 Aug 2019 14:45:30 +1000
Date:   Fri, 2 Aug 2019 14:45:29 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        davem@davemloft.net,
        Pascal van Leeuwen <pvanleeuwen@verimatrix.com>
Subject: Re: [PATCH 0/2] Add support for the AES-XTS algorithm
Message-ID: <20190802044529.GA17763@gondor.apana.org.au>
References: <1564153233-29390-1-git-send-email-pvanleeuwen@verimatrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564153233-29390-1-git-send-email-pvanleeuwen@verimatrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jul 26, 2019 at 05:00:31PM +0200, Pascal van Leeuwen wrote:
> This patch set adds support for the AES-XTS skcipher algorithm.
> 
> Pascal van Leeuwen (3):
>   crypto: inside-secure - Move static cipher alg & mode settings to init
>   crypto: inside-secure - Add support for the AES-XTS algorithm
> 
>  drivers/crypto/inside-secure/safexcel.c        |   1 +
>  drivers/crypto/inside-secure/safexcel.h        |   2 +
>  drivers/crypto/inside-secure/safexcel_cipher.c | 360 ++++++++++++++----------
>  3 files changed, 212 insertions(+), 151 deletions(-)

This patch series doesn't apply against cryptodev.  Please resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
