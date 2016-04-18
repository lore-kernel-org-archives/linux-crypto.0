From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH 1/3] crypto: qat - move vf2pf_init and vf2pf_exit to
 common
Date: Mon, 18 Apr 2016 18:53:23 +0800
Message-ID: <20160418105323.GA19448@gondor.apana.org.au>
References: <1460741880-9479-1-git-send-email-tadeusz.struk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: sumanx.bangalore.sathyanarayana@intel.com,
	linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:34432 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbcDRKxf (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 18 Apr 2016 06:53:35 -0400
Content-Disposition: inline
In-Reply-To: <1460741880-9479-1-git-send-email-tadeusz.struk@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 15, 2016 at 10:37:58AM -0700, Tadeusz Struk wrote:
> The vf2pf_init and vf2pf_exit are exactly the same for all VFs
> so move them to common and reuse.
> 
> Tested-by: Suman Bangalore Sathyanarayana <sumanx.bangalore.sathyanarayana@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

All applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
