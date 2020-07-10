Return-Path: <SRS0=tT4M=AV=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6214CC433E0
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 06:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 470C6206E2
	for <linux-crypto@archiver.kernel.org>; Fri, 10 Jul 2020 06:37:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726664AbgGJGh6 (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 10 Jul 2020 02:37:58 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38298 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725966AbgGJGh6 (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 10 Jul 2020 02:37:58 -0400
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.0.7])
        by fornost.hmeau.com with smtp (Exim 4.92 #5 (Debian))
        id 1jtmfS-0006IF-3g; Fri, 10 Jul 2020 16:37:55 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 10 Jul 2020 16:37:54 +1000
Date:   Fri, 10 Jul 2020 16:37:54 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     mpatocka@redhat.com, linux-crypto@vger.kernel.org,
        dm-devel@redhat.com
Subject: Re: [PATCH 2/6] crypto: algapi - use common mechanism for inheriting
 flags
Message-ID: <20200710063753.GA1974@gondor.apana.org.au>
References: <20200701045217.121126-3-ebiggers@kernel.org>
 <20200709053126.GA5510@gondor.apana.org.au>
 <20200710062403.GB2805@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710062403.GB2805@sol.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jul 09, 2020 at 11:24:03PM -0700, Eric Biggers wrote:
>
> I decided to make crypto_check_attr_type() return the mask instead, and do so
> via a pointer argument instead of the return value (so that we don't overload an
> errno return value and prevent flag 0x80000000 from working).
> Please take a look at v2.  Thanks!

Looks good.  Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
