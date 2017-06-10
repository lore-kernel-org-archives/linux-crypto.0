From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v4 00/14] fixes for kpp and akcipher
Date: Sat, 10 Jun 2017 12:17:05 +0800
Message-ID: <20170610041705.GF14719@gondor.apana.org.au>
References: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, horia.geanta@nxp.com, dan.douglass@nxp.com,
        giovanni.cabiddu@intel.com, salvatore.benedetto@intel.com,
        linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:53018 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbdFJE6r (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 10 Jun 2017 00:58:47 -0400
Content-Disposition: inline
In-Reply-To: <1495696696-22580-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, May 25, 2017 at 10:18:02AM +0300, Tudor Ambarus wrote:
> Hi,
> 
> These are various fixes that I made while reading kpp and akcipher
> implementations.
> 
> Changes in v4:
>  - assume key is already set when calling crypto_akcipher/kpp_maxsize()

All applied, with patch 4/14 taken from v5.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
