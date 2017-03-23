From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] crypto: ixp4xx - Use sg_virt()
Date: Thu, 23 Mar 2017 10:48:04 -0700 (PDT)
Message-ID: <20170323.104804.1545934092766639619.davem@davemloft.net>
References: <a41fae798473b657f09859ae113403655b1717f9.1490258141.git.geliangtang@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: geliangtang@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:55390 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755026AbdCWRsI (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 23 Mar 2017 13:48:08 -0400
In-Reply-To: <a41fae798473b657f09859ae113403655b1717f9.1490258141.git.geliangtang@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Geliang Tang <geliangtang@gmail.com>
Date: Thu, 23 Mar 2017 21:16:30 +0800

> Use sg_virt() instead of open-coding it.
> 
> Signed-off-by: Geliang Tang <geliangtang@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
