Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4874BC5519F
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 03:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F116522201
	for <linux-crypto@archiver.kernel.org>; Fri, 13 Nov 2020 03:41:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726215AbgKMDlI (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 12 Nov 2020 22:41:08 -0500
Received: from helcar.hmeau.com ([216.24.177.18]:33236 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726174AbgKMDlH (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 12 Nov 2020 22:41:07 -0500
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1kdPxM-00009a-V1; Fri, 13 Nov 2020 14:41:02 +1100
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 13 Nov 2020 14:41:00 +1100
Date:   Fri, 13 Nov 2020 14:41:00 +1100
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Horia =?utf-8?Q?Geant=C4=83?= <horia.geanta@nxp.com>
Cc:     wangqing@vivo.com, aymen.sghaier@nxp.com, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: crypto: caam/qi - simplify error path for context allocation
Message-ID: <20201113034100.GA28413@gondor.apana.org.au>
References: <7e8409c9-ce91-3970-6ae0-e6e06987c117@nxp.com>
 <20201113033924.GA28388@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201113033924.GA28388@gondor.apana.org.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Nov 13, 2020 at 02:39:24PM +1100, Herbert Xu wrote:
> Horia Geantă <horia.geanta@nxp.com> wrote:
> >
> > -- >8 --
> > 
> > Subject: [PATCH] crypto: caam/qi - simplify error path for context allocation
> 
> You can't do this.  Patchwork takes any replies with the same
> Subject line as a comment.
> 
> You need to resend this patch with a different subject.

Nevermind, you did change the email subject too.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
