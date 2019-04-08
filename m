Return-Path: <SRS0=0IUk=SK=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C32EC282CE
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 760A22084F
	for <linux-crypto@archiver.kernel.org>; Mon,  8 Apr 2019 06:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbfDHGkk (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 8 Apr 2019 02:40:40 -0400
Received: from orcrist.hmeau.com ([104.223.48.154]:45860 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfDHGkk (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 8 Apr 2019 02:40:40 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hDNxO-00088w-D3; Mon, 08 Apr 2019 14:40:38 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hDNxM-0005pV-LU; Mon, 08 Apr 2019 14:40:36 +0800
Date:   Mon, 8 Apr 2019 14:40:36 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     linux-crypto@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 1/2] crypto: scompress: return proper error code for
 allocation failure
Message-ID: <20190408064036.n23pj24kqmnvfn4j@gondor.apana.org.au>
References: <20190329130956.15935-1-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190329130956.15935-1-bigeasy@linutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Fri, Mar 29, 2019 at 02:09:55PM +0100, Sebastian Andrzej Siewior wrote:
> If scomp_acomp_comp_decomp() fails to allocate memory for the
> destination then we never copy back the data we compressed.
> It is probably best to return an error code instead 0 in case of
> failure.
> I haven't found any user that is using acomp_request_set_params()
> without the `dst' buffer so there is probably no harm.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  crypto/scompress.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
