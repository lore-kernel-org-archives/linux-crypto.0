Return-Path: <SRS0=5sM8=RP=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839A3C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Mar 2019 04:58:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A09D2084F
	for <linux-crypto@archiver.kernel.org>; Tue, 12 Mar 2019 04:58:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbfCLE61 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 12 Mar 2019 00:58:27 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:37292 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbfCLE61 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 12 Mar 2019 00:58:27 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h3ZUc-0001lo-FF; Tue, 12 Mar 2019 12:58:22 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h3ZUY-000496-Mf; Tue, 12 Mar 2019 12:58:18 +0800
Date:   Tue, 12 Mar 2019 12:58:18 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Subject: [GIT] Crypto Fixes for 5.1
Message-ID: <20190312045818.bgpiuxogmaxyscdv@gondor.apana.org.au>
References: <20180105073808.GA14405@gondor.apana.org.au>
 <20180212031702.GA26153@gondor.apana.org.au>
 <20180428080517.haxgpvqrwgotakyo@gondor.apana.org.au>
 <20180622145403.6ltjip7che227fuo@gondor.apana.org.au>
 <20180829033353.agnzxra3jk2r2mzg@gondor.apana.org.au>
 <20181116063146.e7a3mep3ghnfltxe@gondor.apana.org.au>
 <20181207061409.xflg423nknleuddw@gondor.apana.org.au>
 <20190118104006.ye5amhxkgd4xrbmc@gondor.apana.org.au>
 <20190201054204.ehl7u7aaqmkdh5b6@gondor.apana.org.au>
 <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190215024738.fynl64d5u5htcy2l@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi Linus: 

This push fixes a bug in the newly added Exynos5433 AES code as well
as an old one in the caam driver.


Please pull from

git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6.git linus


Kamil Konieczny (1):
      crypto: s5p-sss - fix AES support for Exynos5433

Wen Yang (1):
      crypto: caam - add missing put_device() call

 drivers/crypto/caam/caamalg.c    | 12 +++++++-----
 drivers/crypto/caam/caamalg_qi.c | 11 ++++++++---
 drivers/crypto/caam/caamhash.c   | 18 +++++++++++-------
 drivers/crypto/caam/caampkc.c    | 14 ++++++++++----
 drivers/crypto/caam/caamrng.c    | 22 ++++++++++++++--------
 drivers/crypto/s5p-sss.c         |  2 +-
 6 files changed, 51 insertions(+), 28 deletions(-)

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
