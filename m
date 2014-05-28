From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] crypto: lzo: try kmalloc() before vmalloc()
Date: Wed, 28 May 2014 10:41:20 -0700
Message-ID: <1401298880.3645.16.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1401211735.5367.254.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140527173050.GA18214@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "David S. Miller" <davem@davemloft.net>,
	linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:61542 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaE1RlV (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 28 May 2014 13:41:21 -0400
Received: by mail-pa0-f52.google.com with SMTP id fa1so11339991pad.25
        for <linux-crypto@vger.kernel.org>; Wed, 28 May 2014 10:41:21 -0700 (PDT)
In-Reply-To: <20140527173050.GA18214@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, 2014-05-28 at 01:30 +0800, Herbert Xu wrote:

> Looks good to me.  This would seem like something that could be
> generalised to other vmalloc users, no?

BTW, any objections if I send patches to add NUMA allocations into
crypto layer, or was it already considered ?
