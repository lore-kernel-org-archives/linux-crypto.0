From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: rsa-padding - don't allocate buffer on stack
Date: Tue, 22 Dec 2015 21:21:21 +0800
Message-ID: <20151222132121.GA25844@gondor.apana.org.au>
References: <1449896631-20472-1-git-send-email-andrew.zaborowski@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Andrew Zaborowski <andrew.zaborowski@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:52027 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbbLVNVp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 22 Dec 2015 08:21:45 -0500
Content-Disposition: inline
In-Reply-To: <1449896631-20472-1-git-send-email-andrew.zaborowski@intel.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Andrew Zaborowski <andrew.zaborowski@intel.com> wrote:
> Avoid the s390 compile "warning: 'pkcs1pad_encrypt_sign_complete'
> uses dynamic stack allocation" reported by kbuild test robot.  Don't
> use a flat zero-filled buffer, instead zero the contents of the SGL.
> 
> Signed-off-by: Andrew Zaborowski <andrew.zaborowski@intel.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
