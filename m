Return-Path: <SRS0=w8RP=WS=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CB3AC3A59D
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 05:56:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 371FE21848
	for <linux-crypto@archiver.kernel.org>; Thu, 22 Aug 2019 05:56:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731502AbfHVF4S (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 22 Aug 2019 01:56:18 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:58396 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731501AbfHVF4S (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Aug 2019 01:56:18 -0400
Received: from gondolin.me.apana.org.au ([192.168.0.6] helo=gondolin.hengli.com.au)
        by fornost.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1i0g4j-0002xI-Jj; Thu, 22 Aug 2019 15:55:57 +1000
Received: from herbert by gondolin.hengli.com.au with local (Exim 4.80)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1i0g4g-00011l-Br; Thu, 22 Aug 2019 15:55:54 +1000
Date:   Thu, 22 Aug 2019 15:55:54 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Denis Efremov <efremov@linux.com>
Cc:     linux-kernel@vger.kernel.org, joe@perches.com,
        Breno =?iso-8859-1?Q?Leit=E3o?= <leitao@debian.org>,
        Nayna Jain <nayna@linux.ibm.com>,
        Paulo Flabiano Smorigo <pfsmorigo@gmail.com>,
        Dan Streetman <ddstreet@ieee.org>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: nx crypto: Fix typo in a filepath
Message-ID: <20190822055554.GD3860@gondor.apana.org.au>
References: <20190325212654.26627-1-joe@perches.com>
 <20190813060610.13550-1-efremov@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190813060610.13550-1-efremov@linux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Tue, Aug 13, 2019 at 09:06:10AM +0300, Denis Efremov wrote:
> Fix typo in nx_debugfs.c filepath. File extension changed from .h to .c
> The file nx_debugfs.h never existed.
> 
> Cc: Breno Leitão <leitao@debian.org>
> Cc: Nayna Jain <nayna@linux.ibm.com>
> Cc: Paulo Flabiano Smorigo <pfsmorigo@gmail.com>
> Cc: Dan Streetman <ddstreet@ieee.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: linux-crypto@vger.kernel.org
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
