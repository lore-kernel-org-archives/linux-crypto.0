From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - make sure const_tab is 1024 bytes aligned
Date: Tue, 5 Apr 2016 20:48:00 +0800
Message-ID: <20160405124800.GK13048@gondor.apana.org.au>
References: <1458668725-21232-1-git-send-email-tadeusz.struk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:55487 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602AbcDEMsF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 5 Apr 2016 08:48:05 -0400
Content-Disposition: inline
In-Reply-To: <1458668725-21232-1-git-send-email-tadeusz.struk@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 22, 2016 at 10:45:25AM -0700, Tadeusz Struk wrote:
> FW requires the const_tab to be 1024 bytes aligned.
> 
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
