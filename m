From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: RSA signature verification
Date: Tue, 22 Mar 2011 16:58:42 +0800
Message-ID: <20110322085842.GA23630@gondor.apana.org.au>
References: <4D875AF9.4060302@nokia.com> <20110321140653.GA14174@gondor.apana.org.au> <4D8848EC.6070306@nokia.com> <20110322073407.GA23028@gondor.apana.org.au> <4D886493.5050204@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	James Morris <jmorris@namei.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59175 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab1CVI6p (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2011 04:58:45 -0400
Content-Disposition: inline
In-Reply-To: <4D886493.5050204@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 22, 2011 at 10:57:55AM +0200, Dmitry Kasatkin wrote:
> Hi,
> 
> Accepted by whom?
> We extend functionality of Integrity subsystem in order to support
> flashable images which can be verified with public keys...

Whoever that's going to merge the use-case for this :)

I'm not adding a whole new API unless we have a solid in-kernel
user or we're doing this for hardware enablement.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
