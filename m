Return-Path: <SRS0=K/JA=DT=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9587C433DF
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 03:07:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 87D9120782
	for <linux-crypto@archiver.kernel.org>; Mon, 12 Oct 2020 03:07:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgJLDHn (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sun, 11 Oct 2020 23:07:43 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:55510 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbgJLDHn (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 11 Oct 2020 23:07:43 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kRoBT-0008T6-9j; Mon, 12 Oct 2020 14:07:36 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Mon, 12 Oct 2020 14:07:35 +1100
Date:   Mon, 12 Oct 2020 14:07:35 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     poojatrivedi@gmail.com, linux-crypto@vger.kernel.org,
        mallesh537@gmail.com, josh.tway@stackpath.com,
        netdev@vger.kernel.org
Subject: Re: [RFC 1/1] net/tls(TLS_SW): Handle -ENOSPC error return from
 device/AES-NI
Message-ID: <20201012030735.GA24873@gondor.apana.org.au>
References: <20201007134746.069d7f2f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201008053534.GA4685@gondor.apana.org.au>
 <20201009094830.57736e5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009094830.57736e5d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Oct 09, 2020 at 09:48:30AM -0700, Jakub Kicinski wrote:
>
> Are you saying that if we set CRYPTO_TFM_REQ_MAY_BACKLOG we should
> never see ENOSPC with a correctly functioning driver? Or do we need 
> to handle both errors, regardless?

Correct, you will never see ENOSPC if you request MAY_BACKLOG.
However, you must then ensure that when you get EBUSY that you
stop issuing new requests until the Crypto API signals through
the callback that you can start again.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
