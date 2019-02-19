Return-Path: <SRS0=4Nwj=Q2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50376C43381
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 04:37:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2709720818
	for <linux-crypto@archiver.kernel.org>; Tue, 19 Feb 2019 04:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbfBSEhk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 18 Feb 2019 23:37:40 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:35112 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725805AbfBSEhk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 18 Feb 2019 23:37:40 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gvx9y-0006od-WE; Tue, 19 Feb 2019 12:37:35 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gvx9w-0007WS-TB; Tue, 19 Feb 2019 12:37:32 +0800
Date:   Tue, 19 Feb 2019 12:37:32 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 1/4] X.509: Parse public key parameters from x509 for
 akcipher
Message-ID: <20190219043732.x3sbwzqlz4ikntxo@gondor.apana.org.au>
References: <20190106133608.820-1-vt@altlinux.org>
 <20190106133608.820-2-vt@altlinux.org>
 <20190209214240.56gq7ivn3pw3bssf@altlinux.org>
 <20190210184628.yupsxgjlaicwbxg6@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190210184628.yupsxgjlaicwbxg6@altlinux.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sun, Feb 10, 2019 at 09:46:28PM +0300, Vitaly Chikunov wrote:
>
> >From the other point of view, set_params may never be called or
> implemented. So, making it called first and move memory zeroing
> into set_params may create more complications than simplicity.
> 
> Making both callbacks callable in any order also will not make
> things simpler. (Need to be prepared to be called in different
> order.)

How about encoding these parameters together with the public/private
keys so that they can be set through the existing setkey functions?

You might want to have a look at how we handle this in crypto/dh.c.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
