From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - fix double release_firmware on error path
Date: Tue, 7 Apr 2015 21:36:47 +0800
Message-ID: <20150407133647.GC19660@gondor.apana.org.au>
References: <20150403154117.1172.27874.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: davem@davemloft.net, ahsan.atta@intel.com,
	linux-crypto@vger.kernel.org, qat-linux@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38961 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753459AbbDGNgu (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 7 Apr 2015 09:36:50 -0400
Content-Disposition: inline
In-Reply-To: <20150403154117.1172.27874.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Apr 03, 2015 at 08:41:17AM -0700, Tadeusz Struk wrote:
> release_firmware was called twice on error path causing an Oops.
> 
> Reported-by: Ahsan Atta  <ahsan.atta@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
