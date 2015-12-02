From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: n2 - Use platform_register/unregister_drivers()
Date: Wed, 02 Dec 2015 17:19:20 -0500 (EST)
Message-ID: <20151202.171920.561108913754901110.davem@davemloft.net>
References: <1449072996-10591-1-git-send-email-thierry.reding@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org
To: thierry.reding@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:51246 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753471AbbLBWTX (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 2 Dec 2015 17:19:23 -0500
In-Reply-To: <1449072996-10591-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Thierry Reding <thierry.reding@gmail.com>
Date: Wed,  2 Dec 2015 17:16:36 +0100

> From: Thierry Reding <treding@nvidia.com>
> 
> These new helpers simplify implementing multi-driver modules and
> properly handle failure to register one driver by unregistering all
> previously registered drivers.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Acked-by: David S. Miller <davem@davemloft.net>
