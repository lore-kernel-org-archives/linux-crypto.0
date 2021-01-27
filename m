Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C541C43381
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Jan 2021 19:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3085B60C40
	for <linux-crypto@archiver.kernel.org>; Wed, 27 Jan 2021 19:33:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344451AbhA0TdG (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 27 Jan 2021 14:33:06 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:49324 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344393AbhA0TdB (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 27 Jan 2021 14:33:01 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1l4qY4-0001Dy-2v; Thu, 28 Jan 2021 06:32:17 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 28 Jan 2021 06:32:15 +1100
Date:   Thu, 28 Jan 2021 06:32:15 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     Stefan Berger <stefanb@linux.vnet.ibm.com>,
        keyrings@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        patrick@puiterwijk.org, Stefan Berger <stefanb@linux.ibm.com>
Subject: Re: [PATCH v3 0/3] Add support for x509 certs with NIST p256 and
 p192 keys
Message-ID: <20210127193215.GB27505@gondor.apana.org.au>
References: <20210127123350.817593-1-stefanb@linux.vnet.ibm.com>
 <3114062.1611757328@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3114062.1611757328@warthog.procyon.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Jan 27, 2021 at 02:22:08PM +0000, David Howells wrote:
>
> I've pulled this into my keys-next branch.

David, please drop them because there are issues with the Crypto API
bits.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
