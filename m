From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - remove empty functions and turn
 qat_uregister fn to void
Date: Thu, 1 Oct 2015 22:00:16 +0800
Message-ID: <20151001140016.GB27726@gondor.apana.org.au>
References: <20150922185747.23055.52171.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:39644 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849AbbJAOAT (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Oct 2015 10:00:19 -0400
Content-Disposition: inline
In-Reply-To: <20150922185747.23055.52171.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Sep 22, 2015 at 11:57:47AM -0700, Tadeusz Struk wrote:
> Some code cleanups after crypto API changes:
> - Change qat_algs_unregister to a void function to keep it consistent
>   with qat_asym_algs_unregister.
> - Remove empty functions qat_algs_init & qat_algs_exit.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
