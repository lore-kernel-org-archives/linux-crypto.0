Return-Path: <SRS0=XJfk=6W=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B5DC47247
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D74320720
	for <linux-crypto@archiver.kernel.org>; Fri,  8 May 2020 06:05:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727105AbgEHGFf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 8 May 2020 02:05:35 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:40144 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725865AbgEHGFf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 8 May 2020 02:05:35 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jWw1c-0004wW-8O; Fri, 08 May 2020 15:58:21 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Fri, 08 May 2020 16:04:59 +1000
Date:   Fri, 8 May 2020 16:04:59 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Hadar Gat <hadar.gat@arm.com>
Cc:     Matt Mackall <mpm@selenic.com>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Stefan Wahren <wahrenst@gmx.net>,
        Zaibo Xu <xuzaibo@huawei.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Ofir Drang <ofir.drang@arm.com>
Subject: Re: [PATCH v3 0/3] hwrng: cctrng kconfig updates
Message-ID: <20200508060459.GA24832@gondor.apana.org.au>
References: <1587987364-4566-1-git-send-email-hadar.gat@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1587987364-4566-1-git-send-email-hadar.gat@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Apr 27, 2020 at 02:36:01PM +0300, Hadar Gat wrote:
> Some fixes in Kconfig for cctrng:
>  + add missing dependency on OF
>  + change default to 'n'
>  + improve inaccurate help description
> 
> v3 change: fixed compilation issue
> v2 changes:
>   + remove unneeded depends on HW_RANDOM.
>   + remove unneeded line 'default n' in order to follow the convention.
>   + in help description changed to: If unsure, say 'N'
> 
> Hadar Gat (3):
>   hwrng: cctrng - Add dependency on OF
>   hwrng: cctrng - change default to n
>   hwrng: cctrng - update help description
> 
>  drivers/char/hw_random/Kconfig | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
