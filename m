From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/2] crypto: n2 - remove null check before kfree
Date: Sat, 26 Aug 2017 18:49:35 -0700 (PDT)
Message-ID: <20170826.184935.212347255600368908.davem@davemloft.net>
References: <1503782130-10137-1-git-send-email-himanshujha199640@gmail.com>
        <1503782130-10137-2-git-send-email-himanshujha199640@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
To: himanshujha199640@gmail.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:36582 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751128AbdH0Btl (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sat, 26 Aug 2017 21:49:41 -0400
In-Reply-To: <1503782130-10137-2-git-send-email-himanshujha199640@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Himanshu Jha <himanshujha199640@gmail.com>
Date: Sun, 27 Aug 2017 02:45:29 +0530

> kfree on NULL pointer is a no-op and therefore checking it is redundant.
> 
> Signed-off-by: Himanshu Jha <himanshujha199640@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
