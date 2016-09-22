From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] crypto: caam - fix sg dump
Date: Thu, 22 Sep 2016 18:47:50 +0800
Message-ID: <20160922104749.GA6235@gondor.apana.org.au>
References: <1474534678-10118-1-git-send-email-cata.vasile@nxp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-crypto-owner@vger.kernel.org,
        horia.geanta@nxp.com, cata.vasile@nxp.com
To: Catalin Vasile <cata.vasile@nxp.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37696 "EHLO
        helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933394AbcIVKr6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 22 Sep 2016 06:47:58 -0400
Content-Disposition: inline
In-Reply-To: <1474534678-10118-1-git-send-email-cata.vasile@nxp.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Catalin Vasile <cata.vasile@nxp.com> wrote:
> Ensure scatterlists have a virtual memory mapping before dumping.
> 
> Signed-off-by: Catalin Vasile <cata.vasile@nxp.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
