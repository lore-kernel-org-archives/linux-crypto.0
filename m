Return-Path: <SRS0=7kP/=RZ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21760C10F03
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 12:40:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFA87218E2
	for <linux-crypto@archiver.kernel.org>; Fri, 22 Mar 2019 12:40:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730003AbfCVMkL (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 22 Mar 2019 08:40:11 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:49122 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388459AbfCVMkK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 22 Mar 2019 08:40:10 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h7JSq-0003cu-I4; Fri, 22 Mar 2019 20:40:00 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h7JSm-0001uf-8P; Fri, 22 Mar 2019 20:39:56 +0800
Date:   Fri, 22 Mar 2019 20:39:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 00/11] crypto: add EC-RDSA (GOST 34.10) algorithm
Message-ID: <20190322123956.2zfdijje5wfajsyw@gondor.apana.org.au>
References: <20190301175918.29694-1-vt@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190301175918.29694-1-vt@altlinux.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 01, 2019 at 08:59:07PM +0300, Vitaly Chikunov wrote:
> This patchset changes akcipher API to support ECDSA style signature
> verification, augments x509 parser to make it work with EC-RDSA certificates,
> and, finally, implements EC-RDSA (GOST 34.10) signature verification and its
> integration with IMA.
> 
> This patchset should be applied over cryptodev commit 0918f18c7179e8cdf718d0.

I don't have any major issues with this patch-set (apart from the
minor issue with the crypto API).

However, as a number of patches are against areas outside of the
crypto API I would need to get acks for those patches from the
relevant maintainers.

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
