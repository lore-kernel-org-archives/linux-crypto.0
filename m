From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: add .gitignore for crypto/*.-asn1.[ch] files
Date: Thu, 25 Jun 2015 23:35:50 +0800
Message-ID: <20150625153550.GA11592@gondor.apana.org.au>
References: <1435227483-15604-1-git-send-email-kuleshovmail@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org,
	Tadeusz Struk <tadeusz.struk@intel.com>,
	linux-kernel@vger.kernel.org
To: Alexander Kuleshov <kuleshovmail@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:51441 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbbFYPf7 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 25 Jun 2015 11:35:59 -0400
Content-Disposition: inline
In-Reply-To: <1435227483-15604-1-git-send-email-kuleshovmail@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, Jun 25, 2015 at 04:18:03PM +0600, Alexander Kuleshov wrote:
> There are two generated files: crypto/rsakey-asn1.c and crypto/raskey-asn1.h,
> after the cfc2bb32b31371d6bffc6bf2da3548f20ad48c83 commit. Let's add
> .gitignore to ignore *-asn1.[ch] files.
> 
> Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
