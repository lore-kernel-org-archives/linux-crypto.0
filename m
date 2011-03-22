From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: RSA signature verification
Date: Tue, 22 Mar 2011 15:34:07 +0800
Message-ID: <20110322073407.GA23028@gondor.apana.org.au>
References: <4D875AF9.4060302@nokia.com> <20110321140653.GA14174@gondor.apana.org.au> <4D8848EC.6070306@nokia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	James Morris <jmorris@namei.org>
To: Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:45775 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab1CVHeL (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Mar 2011 03:34:11 -0400
Content-Disposition: inline
In-Reply-To: <4D8848EC.6070306@nokia.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Mar 22, 2011 at 08:59:56AM +0200, Dmitry Kasatkin wrote:
> 
> As I have said in my email that it will be used by IMA/EVM subsystem.
> See security/integrity subdirectory in Linux kernel...

Has the use of software asymmetric crypto in the kernel been
accepted for that purpose?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
