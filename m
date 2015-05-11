From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH RFC v2 1/2] crypto: add PKE API
Date: Mon, 11 May 2015 14:24:21 +0800
Message-ID: <20150511062421.GA2266@gondor.apana.org.au>
References: <20150506193643.9329.75351.stgit@tstruk-mobl1>
 <20150506193648.9329.27232.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
	jwboyer@redhat.com, richard@nod.at, steved@redhat.com,
	qat-linux@intel.com, dhowells@redhat.com,
	linux-crypto@vger.kernel.org, james.l.morris@oracle.com,
	jkosina@suse.cz, zohar@linux.vnet.ibm.com, davem@davemloft.net,
	vgoyal@redhat.com
To: Tadeusz Struk <tadeusz.struk@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:45149 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbbEKGYe (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 May 2015 02:24:34 -0400
Content-Disposition: inline
In-Reply-To: <20150506193648.9329.27232.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, May 06, 2015 at 12:36:48PM -0700, Tadeusz Struk wrote:
> + * @capabilities:
> + *		Specifies what operations are provided by the algorithm
> + *		implementation.

Don't do this.  It's a nightmare for the user to have to deal with
multiple implementations with differing capabilities.

Make the implementor provide backups/fallbacks.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
