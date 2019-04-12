Return-Path: <SRS0=860h=SO=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4106AC10F0E
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 03:28:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0360321721
	for <linux-crypto@archiver.kernel.org>; Fri, 12 Apr 2019 03:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbfDLD24 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 11 Apr 2019 23:28:56 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:59858 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbfDLD24 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 11 Apr 2019 23:28:56 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hEms3-00058Q-4N; Fri, 12 Apr 2019 11:28:55 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hEms2-00084E-3z; Fri, 12 Apr 2019 11:28:54 +0800
Date:   Fri, 12 Apr 2019 11:28:54 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Denis Kenzior <denkenz@gmail.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH v9 05/10] X.509: parse public key parameters from x509
 for akcipher
Message-ID: <20190412032853.lbyhaeujiwicdmpo@gondor.apana.org.au>
References: <20190411155122.13245-1-vt@altlinux.org>
 <20190411155122.13245-6-vt@altlinux.org>
 <48828e0e-0aef-dece-e7ad-4c0ea9cefbe7@gmail.com>
 <20190411210856.sy3qagw6nhjpebbo@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190411210856.sy3qagw6nhjpebbo@altlinux.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Apr 12, 2019 at 12:08:57AM +0300, Vitaly Chikunov wrote:
>
> Ah! Herbert, should I resend the whole patchset with this typo fix, or
> you could apply small change if you going to accept it?

I'll fix it up when I apply the series.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
