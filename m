From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - replace hardcoded BIT(0) in vf_isr
Date: Fri, 30 Dec 2016 20:19:11 +0800
Message-ID: <20161230121911.GC15832@gondor.apana.org.au>
References: <20161222145940.5952-1-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@gmail.com
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45707 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753752AbcL3MTR (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2016 07:19:17 -0500
Content-Disposition: inline
In-Reply-To: <20161222145940.5952-1-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 22, 2016 at 02:59:40PM +0000, Giovanni Cabiddu wrote:
> Replace BIT(0) macro with proper definition in pf2vf path
> 
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
