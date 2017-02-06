From: Anup Patel <anup.patel@broadcom.com>
Subject: Re: [PATCH 1/6] mailbox: Add new API mbox_channel_device() for clients
Date: Mon, 6 Feb 2017 09:57:12 +0530
Message-ID: <CAALAos-BGyad53wrr6d+6LB0fiSi-PhTSzUJOsPT0-J3402OpQ@mail.gmail.com>
References: <1486010836-25228-1-git-send-email-anup.patel@broadcom.com>
 <1486010836-25228-2-git-send-email-anup.patel@broadcom.com> <CABb+yY1yKnFN-6=+xhZzcYrXNBe5eATthwOoHdvDrLmQzpEZ-Q@mail.gmail.com>
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
        linux-crypto@vger.kernel.org,
        linux-raid <linux-raid@vger.kernel.org>
To: Jassi Brar <jassisinghbrar@gmail.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABb+yY1yKnFN-6=+xhZzcYrXNBe5eATthwOoHdvDrLmQzpEZ-Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Feb 3, 2017 at 5:35 PM, Jassi Brar <jassisinghbrar@gmail.com> wrote:
> On Thu, Feb 2, 2017 at 10:17 AM, Anup Patel <anup.patel@broadcom.com> wrote:
>> The remote processor can have DMAENGINE capabilities and client
>> can pass data to be processed via main memory. In such cases,
>> the client will require DMAble memory for remote processor.
>>
>> This patch adds new API mbox_channel_device() which can be
>> used by clients to get struct device pointer of underlying
>> mailbox controller. This struct device pointer of mailbox
>> controller can be used by clients to allocate DMAble memory
>> for remote processor.
>>
> IIUC, DT already provides a way for what you need.

Thanks for the suggestion. I will explore in this direction and
try to avoid this patch in next revision.

Can you please have a look at FlexRM driver which I
had submitted previously?
https://lkml.org/lkml/2017/1/5/291
https://lkml.org/lkml/2017/1/5/293

Regards,
Anup
