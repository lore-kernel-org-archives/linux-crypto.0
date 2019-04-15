Return-Path: <SRS0=EtZ3=SR=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE060C10F0E
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 09:36:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B40C420675
	for <linux-crypto@archiver.kernel.org>; Mon, 15 Apr 2019 09:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbfDOJgl (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 15 Apr 2019 05:36:41 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:33658 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725779AbfDOJgl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 15 Apr 2019 05:36:41 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hFy2Y-0007Sb-8C; Mon, 15 Apr 2019 17:36:38 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hFy2W-0004SO-4G; Mon, 15 Apr 2019 17:36:36 +0800
Date:   Mon, 15 Apr 2019 17:36:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Atul Gupta <atul.gupta@chelsio.com>
Cc:     David Miller <davem@davemloft.net>, jakub.kicinski@netronome.com,
        linux-crypto@vger.kernel.org, netdev@vger.kernel.org,
        dt@chelsio.com
Subject: Re: [crypto 0/4] Inline TLS client and v6 support
Message-ID: <20190415093636.3pvrlv5jugzlcd32@gondor.apana.org.au>
References: <20190411094010.61f93a25@cakuba.netronome.com>
 <ae56c100-d072-bf6b-465a-5136d29b84be@chelsio.com>
 <20190411114506.10d19a40@cakuba.netronome.com>
 <20190411.115228.894374097382770159.davem@davemloft.net>
 <11ea3b48-4b50-3384-4e43-81248ec812b3@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <11ea3b48-4b50-3384-4e43-81248ec812b3@chelsio.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 15, 2019 at 02:40:03PM +0530, Atul Gupta wrote:
>
> Have taken care to keep code out of netdev into crypto driver
> and allow user to choose record offload capability.

Excuse me but the crypto driver is not a dumping ground for code
that is unacceptable for the network stack.  If it's unacceptable
for netdev then it's unacceptable to include them in your crypto
driver.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
