From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - fix leak on error path
Date: Tue, 16 Feb 2016 20:20:46 +0000
Message-ID: <20160216202046.GD11908@gondor.apana.org.au>
References: <1455145184-5610-1-git-send-email-tadeusz.struk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:49403 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854AbcBPUUt (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 16 Feb 2016 15:20:49 -0500
Content-Disposition: inline
In-Reply-To: <1455145184-5610-1-git-send-email-tadeusz.struk@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 10, 2016 at 02:59:44PM -0800, Tadeusz Struk wrote:
> Fix a leak on error path in qat asym
> 
> Reported-by: Salvatore Benedetto <salvatore.benedetto@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Appiled.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
