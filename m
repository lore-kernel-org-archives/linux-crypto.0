Return-Path: <SRS0=/CTJ=QB=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0945AC282C6
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 13:46:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE9D32087E
	for <linux-crypto@archiver.kernel.org>; Fri, 25 Jan 2019 13:46:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728631AbfAYNqX (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 25 Jan 2019 08:46:23 -0500
Received: from orcrist.hmeau.com ([104.223.48.154]:44860 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728145AbfAYNqX (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 25 Jan 2019 08:46:23 -0500
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1gn1oG-0003oZ-Ah; Fri, 25 Jan 2019 21:46:16 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1gn1oE-0003JC-Bd; Fri, 25 Jan 2019 21:46:14 +0800
Date:   Fri, 25 Jan 2019 21:46:14 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@gmail.com>,
        linux-integrity@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3] akcipher: Introduce verify_rsa/verify for public
 key algorithms
Message-ID: <20190125134614.jflpiybs2b5ezbha@gondor.apana.org.au>
References: <20190118205846.20309-1-vt@altlinux.org>
 <20190125100929.zxmqbsibnnikh7tv@gondor.apana.org.au>
 <20190125111808.slyoptlns53t7fiw@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190125111808.slyoptlns53t7fiw@altlinux.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Jan 25, 2019 at 02:18:09PM +0300, Vitaly Chikunov wrote:
> 
> Well, if we allowed to reuse dst* fields why not just put digest over
> dst scatterlist? That would be much simpler.

Please see below.
 
> > The advantage of having it in one scatterlist is that for those
> > users that already have the two pieces together could simply provide
> > a single SG element (I don't know how likely that is in practice
> > though).
> > 
> > For others you would simply tack on an extra SG element.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
