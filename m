From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH v2] virtio-crypto: adjust priority of algorithm
Date: Fri, 13 Jan 2017 22:37:42 +0800
Message-ID: <20170113143742.GD26101@gondor.apana.org.au>
References: <1484300056-35284-1-git-send-email-arei.gonglei@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: virtualization@lists.linux-foundation.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        mst@redhat.com, borntraeger@de.ibm.com
To: Gonglei <arei.gonglei@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.hengli.com.au ([209.40.204.226]:47925 "EHLO
        helcar.apana.org.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751766AbdAMOhw (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 13 Jan 2017 09:37:52 -0500
Content-Disposition: inline
In-Reply-To: <1484300056-35284-1-git-send-email-arei.gonglei@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Fri, Jan 13, 2017 at 05:34:16PM +0800, Gonglei wrote:
> Some hardware accelerators (like intel aesni or the s390
> cpacf functions) have lower priorities than virtio
> crypto, and those drivers are faster than the same in
> the host via virtio. So let's lower the priority of
> virtio-crypto's algorithm, make it's higher than software
> implementations but lower than the hardware ones.
> 
> Suggested-by: Christian Borntraeger <borntraeger@de.ibm.com>
> Signed-off-by: Gonglei <arei.gonglei@huawei.com>
> Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
