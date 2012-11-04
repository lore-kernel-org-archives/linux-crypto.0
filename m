From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: picoxcell: Add terminating entry for
 platform_device_id table
Date: Sun, 04 Nov 2012 12:41:05 -0500 (EST)
Message-ID: <20121104.124105.1180255461095055631.davem@davemloft.net>
References: <1352043385.11324.4.camel@phoenix>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, jamie@jamieiles.com,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
To: axel.lin@ingics.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:39314 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2KDRlH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 4 Nov 2012 12:41:07 -0500
In-Reply-To: <1352043385.11324.4.camel@phoenix>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Axel Lin <axel.lin@ingics.com>
Date: Sun, 04 Nov 2012 23:36:25 +0800

> The platform_device_id table is supposed to be zero-terminated.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Acked-by: David S. Miller <davem@davemloft.net>
