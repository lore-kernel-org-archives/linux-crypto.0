Return-Path: <SRS0=n6OX=SL=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A435C282CE
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 06:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DEFA62083E
	for <linux-crypto@archiver.kernel.org>; Tue,  9 Apr 2019 06:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbfDIGSB (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 9 Apr 2019 02:18:01 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:48438 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726032AbfDIGSB (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 9 Apr 2019 02:18:01 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hDk4z-00086R-7S; Tue, 09 Apr 2019 14:17:57 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hDk4y-0007hg-6b; Tue, 09 Apr 2019 14:17:56 +0800
Date:   Tue, 9 Apr 2019 14:17:56 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 00/10] crypto: add EC-RDSA (GOST 34.10) algorithm
Message-ID: <20190409061756.iyja4535fsu7xrqo@gondor.apana.org.au>
References: <20190326125842.24110-1-vt@altlinux.org>
 <20190408160516.wvpcnvrmask56b2g@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190408160516.wvpcnvrmask56b2g@altlinux.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 08, 2019 at 07:05:16PM +0300, Vitaly Chikunov wrote:
> Herbert,
> 
> On Tue, Mar 26, 2019 at 03:58:32PM +0300, Vitaly Chikunov wrote:
> > This patchset changes akcipher API to support ECDSA style signature
> > verification, augments x509 parser to make it work with EC-RDSA certificates,
> > and, finally, implements EC-RDSA (GOST 34.10) signature verification and its
> > integration with IMA.
> 
> Can you please explain what changes are requested?

Please see

https://patchwork.kernel.org/patch/10870987/

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
