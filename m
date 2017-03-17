From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 1/4] crypto: s5p-sss - Close possible race for completed
 requests
Date: Fri, 17 Mar 2017 18:57:28 +0100
Message-ID: <1899144.GIZL8RDvWl@amdc3058>
References: <20170317144922.27379-1-krzk@kernel.org>
 <20170317144922.27379-2-krzk@kernel.org>
 <CGME20170317175731epcas5p4c078b2e8bfa782fc2bd2a0412f51f03f@epcas5p4.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Nathan Royce <nroycea+kernel@gmail.com>,
        "# v4 . 10 . x" <stable@vger.kernel.org>
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:37155 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751031AbdCQR5k (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 17 Mar 2017 13:57:40 -0400
In-reply-to: <20170317144922.27379-2-krzk@kernel.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Friday, March 17, 2017 04:49:19 PM Krzysztof Kozlowski wrote:
> Driver is capable of handling only one request at a time and it stores
> it in its state container struct s5p_aes_dev.  This stored request must be
> protected between concurrent invocations (e.g. completing current
> request and scheduling new one).  Combination of lock and "busy" field
> is used for that purpose.
> 
> When "busy" field is true, the driver will not accept new request thus
> it will not overwrite currently handled data.
> 
> However commit 28b62b145868 ("crypto: s5p-sss - Fix spinlock recursion
> on LRW(AES)") moved some of the write to "busy" field out of a lock
> protected critical section.  This might lead to potential race between
> completing current request and scheduling a new one.  Effectively the
> request completion might try to operate on new crypto request.
> 
> Cc: <stable@vger.kernel.org> # v4.10.x
> Fixes: 28b62b145868 ("crypto: s5p-sss - Fix spinlock recursion on LRW(AES)")
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>

Reviewed-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>

Best regards,
