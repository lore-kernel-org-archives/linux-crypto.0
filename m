From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [cryptodev PATCH] qat: cleanup unnecessary break checkpatch
 warning
Date: Fri, 24 Oct 2014 22:55:07 +0800
Message-ID: <20141024145507.GE21055@gondor.apana.org.au>
References: <20141015183327.23860.11389.stgit@gitlad.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, tadeusz.struk@intel.com,
	davem@davemloft.net, qat-linux@intel.com
To: Bruce Allan <bruce.w.allan@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:53928 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755406AbaJXOzJ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 24 Oct 2014 10:55:09 -0400
Content-Disposition: inline
In-Reply-To: <20141015183327.23860.11389.stgit@gitlad.jf.intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 15, 2014 at 11:33:27AM -0700, Bruce Allan wrote:
> WARNING:UNNECESSARY_BREAK: break is not useful after a goto or return
> #472: FILE: drivers/crypto/qat/qat_common/qat_algs.c:472:
> +               goto bad_key;
> +               break;
> 
> Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
