From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [RFC PATCH v5] Crypto: rockchip/crypto - add hash support for
 crypto engine in rk3288
Date: Mon, 11 Jan 2016 16:39:25 +0800
Message-ID: <20160111083925.GA23039@gondor.apana.org.au>
References: <1452484647-30260-1-git-send-email-wzz@rock-chips.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: heiko@sntech.de, davem@davemloft.net, eddie.cai@rock-chips.com,
	linux-rockchip@lists.infradead.org, linux-crypto@vger.kernel.org,
	Zain Wang <zain.wang@rock-chips.com>
To: Zain Wang <wzz@rock-chips.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:57032 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758642AbcAKIjo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Jan 2016 03:39:44 -0500
Content-Disposition: inline
In-Reply-To: <1452484647-30260-1-git-send-email-wzz@rock-chips.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Jan 11, 2016 at 11:57:27AM +0800, Zain Wang wrote:
> From: Zain Wang <zain.wang@rock-chips.com>
> 
> Add md5 sha1 sha256 support for crypto engine in rk3288.
> This patch can't support multiple updatings because of limited of IC,
> as result, it can't support import and export too.

As import and export are a required part of the API you have
to implement them or your algorithm can't even be reigstered.

If you the hardware cannot support them then your choices are
limited to a software fallback.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
