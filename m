Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41F1BC6FD1F
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Mar 2023 04:05:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbjCPEF2 (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Mar 2023 00:05:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjCPEF1 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Mar 2023 00:05:27 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2FB73599;
        Wed, 15 Mar 2023 21:05:25 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pcerP-004zQn-9J; Thu, 16 Mar 2023 12:05:04 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 16 Mar 2023 12:05:03 +0800
Date:   Thu, 16 Mar 2023 12:05:03 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Dan Williams <dan.j.williams@intel.com>
Cc:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH v2] async_tx: fix kernel-doc notation warnings
Message-ID: <ZBKVbxdu2yosu/HD@gondor.apana.org.au>
References: <20230314024734.9066-1-rdunlap@infradead.org>
 <6412563addf9f_269929487@dwillia2-xfh.jf.intel.com.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6412563addf9f_269929487@dwillia2-xfh.jf.intel.com.notmuch>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Wed, Mar 15, 2023 at 04:35:22PM -0700, Dan Williams wrote:
>
> Looks good to me.
> 
> Reviewed-by: Dan Williams <dan.j.williams@intel.com>
> 
> Herbert, can you pick this up?

Sure will do.  Thanks for fixing this up, I think these might be
the last warnings under the crypto directory :)

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
