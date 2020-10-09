Return-Path: <SRS0=BuJA=DQ=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C21DC433E7
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Oct 2020 16:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1906F22282
	for <linux-crypto@archiver.kernel.org>; Fri,  9 Oct 2020 16:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602262113;
	bh=PtT8tA9ZiM41SPRuLlgpDHN+xt6ZKJNv3y+QK6l6Fno=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=i72kgIu6jTTzwUD/LFRzBv9v4qpdpEhxnmfo3Ahztm2L4gGqv49B7+4cCqXvaAXZJ
	 q0LUXBMOhG5SuTPui830Fa4rmUqljyPf+nJ8oODs1wHRnnroFiDI+d30Q9SzIUk0Rq
	 +Viev8c/C7itdO8e33VIvZ/YyVXagjVrcUwZCzZE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389847AbgJIQsc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 9 Oct 2020 12:48:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:44508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389431AbgJIQsc (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 9 Oct 2020 12:48:32 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C06C622280;
        Fri,  9 Oct 2020 16:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602262112;
        bh=PtT8tA9ZiM41SPRuLlgpDHN+xt6ZKJNv3y+QK6l6Fno=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0OmeX3/9Cx9QrT1hMHHVqF4zZi8qflWwLxpF49/scvT8f0KQJqIX7pNPiZQ1AIeYq
         zUs4tIDDq6Ozz0nrsXBSPlYhekdMsvb/see/QpxNuqdEZB5+8ntR+WJyquXm9GaWCA
         q2hkfrtzut0JUvwiaFKpUXqKyR9BbOY1UgiOdV1Y=
Date:   Fri, 9 Oct 2020 09:48:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     poojatrivedi@gmail.com, linux-crypto@vger.kernel.org,
        mallesh537@gmail.com, josh.tway@stackpath.com,
        netdev@vger.kernel.org
Subject: Re: [RFC 1/1] net/tls(TLS_SW): Handle -ENOSPC error return from
 device/AES-NI
Message-ID: <20201009094830.57736e5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201008053534.GA4685@gondor.apana.org.au>
References: <20201007134746.069d7f2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201008053534.GA4685@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, 8 Oct 2020 16:35:34 +1100 Herbert Xu wrote:
> Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > Why would the driver return EBUSY from an async API? What's the caller
> > supposed to do with that?  
> 
> The Crypto API offers two modes for callers to deal with congestion.
> If the request can be safely dropped (e.g., IPsec) then ENOSPC will
> be returned and should be dealt with accordingly.
> 
> If the request cannot be dropped then EBUSY is returned to indicate
> congestion, and the caller must refrain from issuing any more
> requests until the Crypto API signals that there is space for them.
> 
> The request flag CRYPTO_TFM_REQ_MAY_BACKLOG is used to indicate
> which mode you wish to use.

Are you saying that if we set CRYPTO_TFM_REQ_MAY_BACKLOG we should
never see ENOSPC with a correctly functioning driver? Or do we need 
to handle both errors, regardless?
