From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: vmx: remove unnecessary check
Date: Tue, 20 Jun 2017 11:42:30 +0800
Message-ID: <20170620034230.GK17764@gondor.apana.org.au>
References: <1497602388-6886-1-git-send-email-tudor.ambarus@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: leosilva@linux.vnet.ibm.com, pfsmorigo@linux.vnet.ibm.com,
        linux-crypto@vger.kernel.org
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from orcrist.hmeau.com ([104.223.48.154]:60954 "EHLO
        deadmen.hmeau.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751018AbdFTDnF (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 19 Jun 2017 23:43:05 -0400
Content-Disposition: inline
In-Reply-To: <1497602388-6886-1-git-send-email-tudor.ambarus@microchip.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jun 16, 2017 at 11:39:48AM +0300, Tudor Ambarus wrote:
> You can't reach init() if parent alg_name is invalid. Moreover,
> cypto_alloc_base() will return ENOENT if alg_name is NULL.
> Found while grasping the fallback mechanism.
> 
> Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
