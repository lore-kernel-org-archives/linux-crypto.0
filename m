From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2 0/3] hwrng: st: Couple of improvements
Date: Thu, 8 Oct 2015 22:23:40 +0800
Message-ID: <20151008142340.GD25166@gondor.apana.org.au>
References: <1444220609-31251-1-git-send-email-lee.jones@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel@stlinux.com, linux-crypto@vger.kernel.org,
	pankaj.dev@st.com, daniel.thompson@linaro.org,
	linux@arm.linux.org.uk
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:46323 "EHLO
	helcar.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649AbbJHOXy (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Oct 2015 10:23:54 -0400
Content-Disposition: inline
In-Reply-To: <1444220609-31251-1-git-send-email-lee.jones@linaro.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Oct 07, 2015 at 01:23:26PM +0100, Lee Jones wrote:
> This set contains a minor documentation fix, greater clarification
> with how the FIFO depth/size is represented and finally a fix to
> prevent early timeout during data acquisition.
> 
> v1 => v2:
>  - Remove phantom bugfix (FIFO really is 4 deep, not 8)
>  - Double timeout value to account for inconsistent call to udelay()
>    - Suggested-by: Russell King <rmk+kernel@arm.linux.org.uk>

All applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
