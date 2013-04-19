From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 4/9 v2] crypto: ux500/cryp - Prepare clock before enabling it
Date: Fri, 19 Apr 2013 14:23:57 +0200
Message-ID: <201304191423.57261.arnd@arndb.de>
References: <1366280825-31136-1-git-send-email-lee.jones@linaro.org> <1366280825-31136-5-git-send-email-lee.jones@linaro.org> <20130419122226.GB3432@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linus.walleij@stericsson.com,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Andreas Westin <andreas.westin@stericsson.com>,
	linux-crypto@vger.kernel.org
To: Lee Jones <lee.jones@linaro.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:57538 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968238Ab3DSMYE (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 19 Apr 2013 08:24:04 -0400
In-Reply-To: <20130419122226.GB3432@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday 19 April 2013, Lee Jones wrote:
> Slight change of plan for v2.
> 
> Now we're doing a seperate clk_prepare(), as the clk_enable() in the
> previous patch turned out to be called inside a spin_lock().
> 
> Arnd, can you confirm your Ack please?
> 

Acked-by: Arnd Bergmann <arnd@arndb.de>
