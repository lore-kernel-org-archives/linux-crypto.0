From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] virtio-crypto: support crypto engine framework
Date: Fri, 30 Dec 2016 20:20:52 +0800
Message-ID: <20161230122052.GH15832@gondor.apana.org.au>
References: <1482821347-47664-1-git-send-email-arei.gonglei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, wu.wubin@huawei.com,
        longpeng2@huawei.com, Baolin Wang <baolin.wang@linaro.org>,
        "Michael S . Tsirkin" <mst@redhat.com>
To: Gonglei <arei.gonglei@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:38071 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753630AbcL3MVW (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 30 Dec 2016 07:21:22 -0500
Content-Disposition: inline
In-Reply-To: <1482821347-47664-1-git-send-email-arei.gonglei@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Dec 27, 2016 at 02:49:07PM +0800, Gonglei wrote:
> crypto engine was introduced since 'commit 735d37b5424b ("crypto: engine
> - Introduce the block request crypto engine framework")' which uses work
> queue to realize the asynchronous processing for ablk_cipher and ahash.
> 
> For virtio-crypto device, I register an engine for each
> data virtqueue so that we can use the capability of
> multiple data queues in future.
> 
> Cc: Baolin Wang <baolin.wang@linaro.org>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Gonglei <arei.gonglei@huawei.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
