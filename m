Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB477C43381
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:03:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A86CD213F2
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 13:03:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731290AbfCVNDF (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 09:03:05 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:49444 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730714AbfCVNDE (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 09:03:04 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h7Jp9-000674-3p; Fri, 22 Mar 2019 21:03:03 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h7Jp3-0005c8-Fn; Fri, 22 Mar 2019 21:02:57 +0800
Date:   Fri, 22 Mar 2019 21:02:57 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Vakul Garg <vakul.garg@nxp.com>
Cc:     "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Horia Geanta <horia.geanta@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [PATCH v3] crypto: caam/jr - optimize job ring enqueue and
 dequeue operations
Message-ID: <20190322130257.drdgj7ym4z7e6exl@gondor.apana.org.au>
References: <20190305180040.8860-1-vakul.garg@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190305180040.8860-1-vakul.garg@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 05, 2019 at 06:03:14PM +0000, Vakul Garg wrote:
> Instead of reading job ring's occupancy registers for every req/rsp
> enqueued/dequeued respectively, we read these registers once and store
> them in memory. After completing a job enqueue/dequeue, we decrement
> these values. When these values become zero, we refresh the snapshot of
> job ring's occupancy registers. This eliminates need of expensive device
> register read operations for every job enqueued and dequeued and hence
> makes caam_jr_enqueue() and caam_jr_dequeue() faster. The performance of
> kernel ipsec improved by about 6% on ls1028 (for frame size 408 bytes).
> 
> Signed-off-by: Vakul Garg <vakul.garg@nxp.com>
> ---
> 
> Changes since v2:
> 	- Added magnitude of performance improvement in commit log.
> 
>  drivers/crypto/caam/intern.h |  1 +
>  drivers/crypto/caam/jr.c     | 12 ++++++++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
