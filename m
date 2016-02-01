From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] fix out of bound read in __test_aead()
Date: Mon, 1 Feb 2016 22:26:40 +0800
Message-ID: <20160201142640.GA11363@gondor.apana.org.au>
References: <1454073009-13665-1-git-send-email-jmarchan@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jerome Marchand <jmarchan@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:58446 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932418AbcBAO0q (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 1 Feb 2016 09:26:46 -0500
Content-Disposition: inline
In-Reply-To: <1454073009-13665-1-git-send-email-jmarchan@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 29, 2016 at 02:10:09PM +0100, Jerome Marchand wrote:
> __test_aead() reads MAX_IVLEN bytes from template[i].iv, but the
> actual length of the initialisation vector can be shorter.
> The length of the IV is already calculated earlier in the
> function. Let's just reuses that.
> This fix an out-of-bound error detected by KASan.
> 
> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>

This patch creates a new warning that iv_len may be uninitialised.

Please fix this and resubmit.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
