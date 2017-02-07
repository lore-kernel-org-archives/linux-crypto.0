From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 2/5] async_tx: Handle DMA devices having support for
 fewer PQ coefficients
Date: Tue, 7 Feb 2017 00:27:23 -0800
Message-ID: <CAPcyv4gbV1yf52JrejW+Dn3wOPn7Er+8HWdu2qsW0+Qm+cRr9g@mail.gmail.com>
References: <1486455406-11202-1-git-send-email-anup.patel@broadcom.com> <1486455406-11202-3-git-send-email-anup.patel@broadcom.com>
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
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Device Tree <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>
To: Anup Patel <anup.patel@broadcom.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-oi0-f42.google.com ([209.85.218.42]:35469 "EHLO
        mail-oi0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753251AbdBGI1Y (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 Feb 2017 03:27:24 -0500
Received: by mail-oi0-f42.google.com with SMTP id j15so60823764oih.2
        for <linux-crypto@vger.kernel.org>; Tue, 07 Feb 2017 00:27:24 -0800 (PST)
In-Reply-To: <1486455406-11202-3-git-send-email-anup.patel@broadcom.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Feb 7, 2017 at 12:16 AM, Anup Patel <anup.patel@broadcom.com> wrote:
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

I don't like this approach. Define an interface for md to query the
offload engine once at the beginning of time. We should not be adding
any new extensions to async_tx.
