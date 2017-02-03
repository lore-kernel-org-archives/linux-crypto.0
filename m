From: Jassi Brar <jassisinghbrar@gmail.com>
Subject: Re: [PATCH 1/6] mailbox: Add new API mbox_channel_device() for clients
Date: Fri, 3 Feb 2017 17:35:42 +0530
Message-ID: <CABb+yY1yKnFN-6=+xhZzcYrXNBe5eATthwOoHdvDrLmQzpEZ-Q@mail.gmail.com>
References: <1486010836-25228-1-git-send-email-anup.patel@broadcom.com> <1486010836-25228-2-git-send-email-anup.patel@broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Vinod Koul <vinod.koul@intel.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Dan Williams <dan.j.williams@intel.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        Jon Mason <jonmason@broadcom.com>,
        Rob Rice <rob.rice@broadcom.com>,
        BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        dmaengine@vger.kernel.org,
        Devicetree List <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Anup Patel <anup.patel@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1486010836-25228-2-git-send-email-anup.patel@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Feb 2, 2017 at 10:17 AM, Anup Patel <anup.patel@broadcom.com> wrote:
> The remote processor can have DMAENGINE capabilities and client
> can pass data to be processed via main memory. In such cases,
> the client will require DMAble memory for remote processor.
>
> This patch adds new API mbox_channel_device() which can be
> used by clients to get struct device pointer of underlying
> mailbox controller. This struct device pointer of mailbox
> controller can be used by clients to allocate DMAble memory
> for remote processor.
>
IIUC, DT already provides a way for what you need.
