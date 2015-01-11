From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 3/6] crypto: sparc64/camellia - fix module alias
Date: Sun, 11 Jan 2015 12:57:24 -0500 (EST)
Message-ID: <20150111.125724.974760304657460444.davem@davemloft.net>
References: <1420996667-31693-1-git-send-email-minipli@googlemail.com>
	<1420996667-31693-4-git-send-email-minipli@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org
To: minipli@googlemail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:37828 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbbAKR50 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 11 Jan 2015 12:57:26 -0500
In-Reply-To: <1420996667-31693-4-git-send-email-minipli@googlemail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Mathias Krause <minipli@googlemail.com>
Date: Sun, 11 Jan 2015 18:17:44 +0100

> The module alias should be "camellia", not "aes".
> 
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Mathias Krause <minipli@googlemail.com>

Acked-by: David S. Miller <davem@davemloft.net>
