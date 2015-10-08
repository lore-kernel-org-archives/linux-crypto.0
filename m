From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v5 1/2] lib/mpi: Add mpi sgl helpers
Date: Thu, 8 Oct 2015 21:36:26 +0800
Message-ID: <20151008133626.GA24687@gondor.apana.org.au>
References: <20151002051032.27263.21150.stgit@tstruk-mobl1>
 <20151002051038.27263.5476.stgit@tstruk-mobl1>
 <20151008130203.GA24128@gondor.apana.org.au>
 <56167048.5080505@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58214 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757562AbbJHNg3 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Oct 2015 09:36:29 -0400
Content-Disposition: inline
In-Reply-To: <56167048.5080505@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Oct 08, 2015 at 06:31:52AM -0700, Tadeusz Struk wrote:
>
> The sgl has to be big enough to take the whole integer.
> What would be the point to export only part of a number?

You're not getting it.  Just because the SGL is X bytes long
it doesn't give you the right to write X bytes.  The number of
bytes that you may write to (let's call it Y) may be smaller.

The value of Y must be passed into the helper and verified.

This is why dst_len exists.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
