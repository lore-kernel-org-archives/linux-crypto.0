From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 3/6] async_tx: Handle DMA devices having support for fewer
 PQ coefficients
Date: Wed, 1 Feb 2017 22:01:13 -0800
Message-ID: <CAPcyv4gBFu7skx_8cvsaL0sL5=44DMcWY_EjWSCfaNd8oh=Svw@mail.gmail.com>
References: <1486010836-25228-1-git-send-email-anup.patel@broadcom.com> <1486010836-25228-4-git-send-email-anup.patel@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Vinod Koul <vinod.koul@intel.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        devicetree@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>
To: Anup Patel <anup.patel@broadcom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ot0-f169.google.com ([74.125.82.169]:34572 "EHLO
        mail-ot0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750926AbdBBGBO (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 2 Feb 2017 01:01:14 -0500
Received: by mail-ot0-f169.google.com with SMTP id f9so4745898otd.1
        for <linux-crypto@vger.kernel.org>; Wed, 01 Feb 2017 22:01:14 -0800 (PST)
In-Reply-To: <1486010836-25228-4-git-send-email-anup.patel@broadcom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 1, 2017 at 8:47 PM, Anup Patel <anup.patel@broadcom.com> wrote:
> The DMAENGINE framework assumes that if PQ offload is supported by a
> DMA device then all 256 PQ coefficients are supported. This assumption
> does not hold anymore because we now have BCM-SBA-RAID offload engine
> which supports PQ offload with limited number of PQ coefficients.
>
> This patch extends async_tx APIs to handle DMA devices with support
> for fewer PQ coefficients.
>
> Signed-off-by: Anup Patel <anup.patel@broadcom.com>
> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
> ---
>  crypto/async_tx/async_pq.c          |  3 +++
>  crypto/async_tx/async_raid6_recov.c | 12 ++++++++++--
>  include/linux/dmaengine.h           | 19 +++++++++++++++++++
>  include/linux/raid/pq.h             |  3 +++
>  4 files changed, 35 insertions(+), 2 deletions(-)

So, I hate the way async_tx does these checks on each operation, and
it's ok for me to say that because it's my fault. Really it's md that
should be validating engine offload capabilities once at the beginning
of time. I'd rather we move in that direction than continue to pile
onto a bad design.
