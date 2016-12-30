From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - modify format of dev top level debugfs
 entries
Date: Fri, 30 Dec 2016 20:20:18 +0800
Message-ID: <20161230122018.GF15832@gondor.apana.org.au>
References: <20161222150034.6203-1-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@gmail.com,
        Pablo Marcos Oltra <pablo.marcos.oltra@intel.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38389 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753820AbcL3MUY (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2016 07:20:24 -0500
Content-Disposition: inline
In-Reply-To: <20161222150034.6203-1-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 22, 2016 at 03:00:34PM +0000, Giovanni Cabiddu wrote:
> From: Pablo Marcos Oltra <pablo.marcos.oltra@intel.com>
> 
> Remove leading zeros in pci function number to be consistent
> with output from lspci.
> 
> Signed-off-by: Pablo Marcos Oltra <pablo.marcos.oltra@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
