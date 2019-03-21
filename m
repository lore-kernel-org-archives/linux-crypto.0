Return-Path: <SRS0=F/PC=RY=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10925C10F00
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 12:11:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DD7C7218A5
	for <linux-crypto@archiver.kernel.org>; Thu, 21 Mar 2019 12:11:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbfCUMLi (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 21 Mar 2019 08:11:38 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:36956 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727878AbfCUMLh (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 21 Mar 2019 08:11:37 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1h6wXi-00076N-OM; Thu, 21 Mar 2019 20:11:30 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1h6wXc-0003Kt-UI; Thu, 21 Mar 2019 20:11:24 +0800
Date:   Thu, 21 Mar 2019 20:11:24 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 02/11] crypto: akcipher - check the presence of
 callback before the call
Message-ID: <20190321121124.lg4fjitsew5kpvq6@gondor.apana.org.au>
References: <20190301175918.29694-1-vt@altlinux.org>
 <20190301175918.29694-3-vt@altlinux.org>
 <20190321111918.4kr7vdgz23xzjwed@gondor.apana.org.au>
 <20190321114209.qdaql3kdtfsnfzla@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190321114209.qdaql3kdtfsnfzla@altlinux.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Mar 21, 2019 at 02:42:10PM +0300, Vitaly Chikunov wrote:
>
> I guess patch "PATCH v7 01/11] KEYS: report to keyctl only actually
> supported key ops" should also be removed and will infer anything from
> presence of the callbacks.

Indeed.  Especially if this is exposed to user-space then you
need to be careful changing the user-space API by clearing the
verify/sign bits for raw RSA.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
