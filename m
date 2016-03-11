From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: qat - remove redundant arbiter configuration
Date: Fri, 11 Mar 2016 21:32:22 +0800
Message-ID: <20160311133222.GF24332@gondor.apana.org.au>
References: <1457462235-27433-1-git-send-email-tadeusz.struk@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, ahsan.atta@intel.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45472 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbcCKNcZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Mar 2016 08:32:25 -0500
Content-Disposition: inline
In-Reply-To: <1457462235-27433-1-git-send-email-tadeusz.struk@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 08, 2016 at 10:37:15AM -0800, Tadeusz Struk wrote:
> The default arbiter configuration for ring weights and response ordering
> is exactly what we want so we don't need to configure anything more.
> This will also fix the problem where number of bundles is different
> between different devices.
> 
> Reported-by: Ahsan Atta <ahsan.atta@intel.com>
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
