From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] [RESEND] crypto: qat - don't use userspace pointer
Date: Fri, 13 Nov 2015 18:09:31 +0800
Message-ID: <20151113100931.GA10553@gondor.apana.org.au>
References: <20151021215709.32366.20870.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, qat-linux@intel.com,
	stable@vger.kernel.org
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:37326 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332AbbKMKJi (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 13 Nov 2015 05:09:38 -0500
Content-Disposition: inline
In-Reply-To: <20151021215709.32366.20870.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 21, 2015 at 02:57:09PM -0700, Tadeusz Struk wrote:
> Bugfix - don't dereference userspace pointer.
> 
> Resend with the correct way for inclusion in the stable kernel.

Applied to crypto.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
