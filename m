Return-Path: <SRS0=juXm=2K=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A293CC43603
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 07:07:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 821222467F
	for <linux-crypto@archiver.kernel.org>; Fri, 20 Dec 2019 07:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfLTHHP (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 20 Dec 2019 02:07:15 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:58802 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725874AbfLTHHO (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 20 Dec 2019 02:07:14 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1iiCNV-0008TV-Dk; Fri, 20 Dec 2019 15:07:13 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1iiCNR-0007qf-Uu; Fri, 20 Dec 2019 15:07:09 +0800
Date:   Fri, 20 Dec 2019 15:07:09 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Pascal van Leeuwen <pascalvanl@gmail.com>
Cc:     linux-crypto@vger.kernel.org, antoine.tenart@bootlin.com,
        davem@davemloft.net, Pascal van Leeuwen <pvanleeuwen@rambus.com>
Subject: Re: [PATCH 0/3] crypto: inside-secure - Made driver work on EIP97
Message-ID: <20191220070709.l24ejzkt46wzzqw2@gondor.apana.org.au>
References: <1576081957-5971-1-git-send-email-pvanleeuwen@rambus.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1576081957-5971-1-git-send-email-pvanleeuwen@rambus.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Dec 11, 2019 at 05:32:34PM +0100, Pascal van Leeuwen wrote:
> This patchset fixes various errors and hang cases that occurred when
> running the crypto self-tests, and in particular the extra tests, on
> an EIP97 type engine (e.g. Marvell Armada 3700LP as used on EspressoBin)
> 
> Tested on Macchiatobin, EspressoBin (thanks, Antoine Tenart), EIP97HW2.3
> and EIP197HW3.2 on the Xilinx VCU118 FPGA development board.
> 
> Pascal van Leeuwen (3):
>   crypto: inside-secure - Fix Unable to fit even 1 command desc error w/
>     EIP97
>   crypto: inside-secure - Fix hang case on EIP97 with zero length input
>     data
>   crypto: inside-secure - Fix hang case on EIP97 with basic DES/3DES ops
> 
>  drivers/crypto/inside-secure/safexcel.c        |  12 +-
>  drivers/crypto/inside-secure/safexcel.h        |  34 +-
>  drivers/crypto/inside-secure/safexcel_cipher.c | 552 +++++++++++++++----------
>  drivers/crypto/inside-secure/safexcel_hash.c   |  14 +-
>  drivers/crypto/inside-secure/safexcel_ring.c   | 130 ++++--
>  5 files changed, 473 insertions(+), 269 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
