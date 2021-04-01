Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFF0CC43460
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Apr 2021 01:11:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BB6EB61057
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Apr 2021 01:11:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233113AbhDABKc (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 31 Mar 2021 21:10:32 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:37064 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233002AbhDABKI (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 31 Mar 2021 21:10:08 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1lRlqG-0007Ju-0n; Thu, 01 Apr 2021 12:09:49 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 01 Apr 2021 12:09:47 +1100
Date:   Thu, 1 Apr 2021 12:09:47 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Varad Gautam <varad.gautam@suse.com>
Cc:     linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vitaly Chikunov <vt@altlinux.org>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>,
        "open list:ASYMMETRIC KEYS" <keyrings@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/18] X.509: Parse RSASSA-PSS style certificates
Message-ID: <20210401010947.GA4349@gondor.apana.org.au>
References: <20210330202829.4825-1-varad.gautam@suse.com>
 <20210330202829.4825-2-varad.gautam@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210330202829.4825-2-varad.gautam@suse.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Mar 30, 2021 at 10:28:12PM +0200, Varad Gautam wrote:
> An X.509 wrapper for a RSASSA-PSS signature contains additional
> signature parameters over the PKCSv.15 encoding scheme. Extend the
> x509 parser to allow parsing RSASSA-PSS encoded certificates, with
> the defaults taken from RFC8017.

Where is the cover letter for this series?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
