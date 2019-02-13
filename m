Return-Path: <SRS0=2+RY=QU=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: *
X-Spam-Status: No, score=1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DDDEC282C2
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Feb 2019 18:51:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 257C420811
	for <linux-crypto@archiver.kernel.org>; Wed, 13 Feb 2019 18:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1550083913;
	bh=BRP+ed8m+M0Mm/r0Svodh6t20BG2JiW2Pr00H4SjVE4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=cqHi0mtI7hIcg7K86WGAA0+HZF80FMdgeanqcBBAsO0JH35RecszWNPTeH3Gu2koQ
	 IRfYAqIQ7RTCYYjrlwdI0r8TO0IzafmU22pCQByuwT4aHdU63reMdWk1VEfBe4tYeL
	 yN9Ox+u/iqltBS/uuYxIHs+uWD3Tt74hSEYNF1Fk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbfBMSvq (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 13 Feb 2019 13:51:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:48578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729390AbfBMSvi (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 13 Feb 2019 13:51:38 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8F11520811;
        Wed, 13 Feb 2019 18:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1550083897;
        bh=BRP+ed8m+M0Mm/r0Svodh6t20BG2JiW2Pr00H4SjVE4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1IzQ7/lSvDst6ho6X2Krj0/zaMhuFRyBNdgmGttktW5cSEhG0YK8BYbkuAPhMdVLe
         fKjPLPI5/uFWCEuF9FOi/EaUDIRZeKGyvYKzfoDN85x3p1glHw+z0Hdj6jYvxlFiKC
         0gJU+JHvXfLSiwN7mYciIgYGRr8pP5dIIyb1s2Jc=
Date:   Wed, 13 Feb 2019 10:51:36 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Horia Geanta <horia.geanta@nxp.com>
Cc:     Iuliana Prodan <iuliana.prodan@nxp.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Aymen Sghaier <aymen.sghaier@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH 0/4] crypto: caam - add ecb mode support
Message-ID: <20190213185135.GA140810@gmail.com>
References: <1549633810-10380-1-git-send-email-iuliana.prodan@nxp.com>
 <20190209215219.GA688@sol.localdomain>
 <HE1PR0402MB3484556884375681E3E81BE998660@HE1PR0402MB3484.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HE1PR0402MB3484556884375681E3E81BE998660@HE1PR0402MB3484.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Feb 13, 2019 at 06:45:16PM +0000, Horia Geanta wrote:
> On 2/9/2019 11:52 PM, Eric Biggers wrote:
> > Do you have an actual use case for adding more DES, 3DES, and ARC4
> > implementations, or are you simply adding them because the hardware happens to
> > supports it?  These old ciphers are insecure, so IMO more implementations should
> > only be added if there is a real use case where they're absolutely needed.
> > 
> One legit use case is PIN encryption in Point of Sale solution.
> 
> Horia

You are claiming you need DES-ECB, 3DES-ECB, *and* ARC4 for that?

Which one is it actually, if any?
