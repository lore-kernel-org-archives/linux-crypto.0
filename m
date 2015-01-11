From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 4/6] crypto: sparc64/des - add "des3_ede" module alias
Date: Sun, 11 Jan 2015 12:57:33 -0500 (EST)
Message-ID: <20150111.125733.1209997053952344020.davem@davemloft.net>
References: <1420996667-31693-1-git-send-email-minipli@googlemail.com>
	<1420996667-31693-5-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: minipli@googlemail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:37830 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbbAKR5e (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Jan 2015 12:57:34 -0500
In-Reply-To: <1420996667-31693-5-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Mathias Krause <minipli@googlemail.com>
Date: Sun, 11 Jan 2015 18:17:45 +0100

> This module provides implementations for "des3_ede", too. Announce those
> via an appropriate crypto module alias so it can be used in favour to
> the generic C implementation.
> 
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Acked-by: David S. Miller <davem@davemloft.net>
