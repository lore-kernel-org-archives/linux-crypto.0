Return-Path: <SRS0=8Gy4=RD=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79781C10F00
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 10:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5246A2171F
	for <linux-crypto@archiver.kernel.org>; Thu, 28 Feb 2019 10:37:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731118AbfB1KhX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 28 Feb 2019 05:37:23 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:52762 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726088AbfB1KhX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 28 Feb 2019 05:37:23 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gzJ42-0002Bm-Cp; Thu, 28 Feb 2019 18:37:18 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gzJ3z-0002DS-L9; Thu, 28 Feb 2019 18:37:15 +0800
Date:   Thu, 28 Feb 2019 18:37:15 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] X.509: Parse public key parameters from x509 for
 akcipher
Message-ID: <20190228103715.ijvimcfysiguiwty@gondor.apana.org.au>
References: <20190209214240.56gq7ivn3pw3bssf@altlinux.org>
 <20190210184628.yupsxgjlaicwbxg6@altlinux.org>
 <20190219043732.x3sbwzqlz4ikntxo@gondor.apana.org.au>
 <20190224064840.hii4ccjksjdnewae@altlinux.org>
 <20190228061444.3escryzoit3idtwg@gondor.apana.org.au>
 <20190228070449.gjwoq4c2b3x5grie@altlinux.org>
 <20190228075141.s6mftb44yuylbzys@gondor.apana.org.au>
 <20190228082801.2aofw23r2shzwy4n@altlinux.org>
 <20190228090125.6n62v4oxpwl5yzv4@gondor.apana.org.au>
 <20190228103337.sbjujn27qkkgxqt2@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190228103337.sbjujn27qkkgxqt2@altlinux.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Feb 28, 2019 at 01:33:37PM +0300, Vitaly Chikunov wrote:
>
> To make the same for set_{pub,priv}_key it will require patching RSA
> drivers anyway, since length of the key is stored just once as keylen
> argument.

No we don't need to use the same format for different algorithms.
RSA should stay as is.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
