Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D40C43381
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:15:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 578C621850
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 06:15:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730881AbfB1GOw (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 01:14:52 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:39352 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfB1GOw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 01:14:52 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gzExy-0005V2-G9; Thu, 28 Feb 2019 14:14:46 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gzExw-0007hK-Kq; Thu, 28 Feb 2019 14:14:44 +0800
Date:   Thu, 28 Feb 2019 14:14:44 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] X.509: Parse public key parameters from x509 for
 akcipher
Message-ID: <20190228061444.3escryzoit3idtwg@gondor.apana.org.au>
References: <20190106133608.820-1-vt@altlinux.org>
 <20190106133608.820-2-vt@altlinux.org>
 <20190209214240.56gq7ivn3pw3bssf@altlinux.org>
 <20190210184628.yupsxgjlaicwbxg6@altlinux.org>
 <20190219043732.x3sbwzqlz4ikntxo@gondor.apana.org.au>
 <20190224064840.hii4ccjksjdnewae@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190224064840.hii4ccjksjdnewae@altlinux.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Feb 24, 2019 at 09:48:40AM +0300, Vitaly Chikunov wrote:
> 
> If we pass SubjectPublicKeyInfo into set_pub_key itself (making
> set_params not needed) we will break ABI and compatibility with RSA
> drivers, because whole SubjectPublicKeyInfo is not expected by the

This compatibility does not matter.  We can always add translating
layers into the crypto API to deal with this.  The only ABI that
matters is the one to user-space.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
