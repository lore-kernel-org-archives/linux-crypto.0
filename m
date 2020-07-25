Return-Path: <SRS0=tM/H=BE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49592C433DF
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jul 2020 12:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2277A20674
	for <linux-crypto@archiver.kernel.org>; Sat, 25 Jul 2020 12:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgGYMGH (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Sat, 25 Jul 2020 08:06:07 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:44362 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726612AbgGYMGH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 25 Jul 2020 08:06:07 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jzIw5-0006XY-4K; Sat, 25 Jul 2020 22:05:54 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Sat, 25 Jul 2020 22:05:53 +1000
Date:   Sat, 25 Jul 2020 22:05:53 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     miaoqinglang <miaoqinglang@huawei.com>
Cc:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>,
        gregkh@linuxfoundation.org, aymen.sghaier@nxp.com,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] crypto: caam: Convert to DEFINE_SHOW_ATTRIBUTE
Message-ID: <20200725120552.GA20145@gondor.apana.org.au>
References: <20200723072511.GA6095@gondor.apana.org.au>
 <62dc973d-71b6-c8ec-9f7a-f1c421a7b1d3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <62dc973d-71b6-c8ec-9f7a-f1c421a7b1d3@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Sat, Jul 25, 2020 at 05:00:02PM +0800, miaoqinglang wrote:
> 
> Or If you don't mind, I can resend a patch besed on mainline rather than
> -next now.

Please don't as that will just cause more conflicts.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
