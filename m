Return-Path: <SRS0=bFfa=QW=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C83CC43381
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Feb 2019 05:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 607E621B1C
	for <linux-crypto@archiver.kernel.org>; Fri, 15 Feb 2019 05:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550210091;
	bh=JqwKM+EN8r8vBdK3ySfdD7PQLUGMAoh4Vq8l0bbAhlk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=d1xvoevB58w2k/pJScN05IyE9aqFYgEoqRnbVm1CW/DAhP2rgg1pGXc3zKkO/ezTQ
	 oK26kapUkvM4gJDHMPNCSmGRLn4QyR0TXLMYHHswkvZFQoXpQAqoXZQy7/8PFeOLNu
	 4t2BdBLSsa76HmlkH/ZjD2tLsbhPHc2WFUEzzAuo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731472AbfBOFyu (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 15 Feb 2019 00:54:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:55984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbfBOFyu (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 15 Feb 2019 00:54:50 -0500
Received: from sol.localdomain (c-107-3-167-184.hsd1.ca.comcast.net [107.3.167.184])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 291132080A;
        Fri, 15 Feb 2019 05:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550210089;
        bh=JqwKM+EN8r8vBdK3ySfdD7PQLUGMAoh4Vq8l0bbAhlk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OFEB+W5+v9fPuTd4SoptTZZ9FOAKkYF2C/z5oTDqsX38FYqma1QEF8luZd9RB5nqF
         2PlxbSP57I9h/Aq2qUF9PcMHMcph4ppfIeZFqi9VnrKHejXa/mxvBVn0fRT7FmAkiI
         Id05YtBlliJqQ32MYEE3JCNmSOZmrmspcehg+zwA=
Date:   Thu, 14 Feb 2019 21:54:47 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Horia Geanta <horia.geanta@nxp.com>,
        Iuliana Prodan <iuliana.prodan@nxp.com>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 0/4] crypto: caam - add ecb mode support
Message-ID: <20190215055430.GA638@sol.localdomain>
References: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
 <20190209215219.GA688@sol.localdomain>
 <HE1PR0402MB3484556884375681E3E81BE998660@HE1PR0402MB3484.eurprd04.prod.outlook.com>
 <20190213185135.GA140810@gmail.com>
 <20190215052442.7ti5d2ni7qh47ilv@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190215052442.7ti5d2ni7qh47ilv@gondor.apana.org.au>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Feb 15, 2019 at 01:24:42PM +0800, Herbert Xu wrote:
> On Wed, Feb 13, 2019 at 10:51:36AM -0800, Eric Biggers wrote:
> >
> > You are claiming you need DES-ECB, 3DES-ECB, *and* ARC4 for that?
> > 
> > Which one is it actually, if any?
> 
> Since these are existing algorithms in the crypto API and we're
> simply adding them to the driver I think the bar of acceptance
> is lower than if it were a completely new addition to the kernel.
> 
> Thanks,
> -- 
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

Sure, but the bar shouldn't be so low that new implementations of insecure
algorithms the world is moving away from are accepted without a real use case.
We should be moving towards removing these algorithms instead.  The original DES
is especially bad as it only has a 56-bit key.  I'd like to better understand
if/why people claim to not only still need these algorithms in 2019, but also
need brand new implementations of them.

- Eric
