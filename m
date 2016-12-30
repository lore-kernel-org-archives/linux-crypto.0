From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - increase number of supported devices
Date: Fri, 30 Dec 2016 20:20:40 +0800
Message-ID: <20161230122040.GG15832@gondor.apana.org.au>
References: <20161222150102.6376-1-giovanni.cabiddu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, giovanni.cabiddu@gmail.com,
        Xin Zeng <xin.zeng@intel.com>
To: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:41849 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753820AbcL3MUr (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2016 07:20:47 -0500
Content-Disposition: inline
In-Reply-To: <20161222150102.6376-1-giovanni.cabiddu@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Dec 22, 2016 at 03:01:02PM +0000, Giovanni Cabiddu wrote:
> From: Xin Zeng <xin.zeng@intel.com>
> 
> The unsigned long type for init_status and start_status in
> service_hndl are not long enough to represent more than 64
> acceleration devices. Use an array instead.
> 
> Signed-off-by: Xin Zeng <xin.zeng@intel.com>
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
