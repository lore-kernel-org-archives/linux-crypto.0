From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/6] netlink: Move netlink attribute parsing support to
 lib/
Date: Wed, 25 Feb 2009 13:59:41 -0800 (PST)
Message-ID: <20090225.135941.33443374.davem@davemloft.net>
References: <1235569394-15217-1-git-send-email-Geert.Uytterhoeven@sonycom.com>
	<1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org
To: Geert.Uytterhoeven@sonycom.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39361
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756590AbZBYV76 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 25 Feb 2009 16:59:58 -0500
In-Reply-To: <1235569394-15217-2-git-send-email-Geert.Uytterhoeven@sonycom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Date: Wed, 25 Feb 2009 14:43:09 +0100

> Netlink attribute parsing may be used even if CONFIG_NET is not set.
> Move it from net/netlink to lib and control its inclusion based on the new
> config symbol CONFIG_NLATTR, which is selected by CONFIG_NET.
> 
> Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Acked-by: David S. Miller <davem@davemloft.net>
