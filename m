From: Anup Patel <anup.patel@broadcom.com>
Subject: Re: [PATCH 3/6] async_tx: Handle DMA devices having support for fewer
 PQ coefficients
Date: Mon, 6 Feb 2017 09:25:24 +0530
Message-ID: <CAALAos_=yM3V1TJVHU1o6Ztkh5-PmZJw9yYM9SmDU7rN1jWFFg@mail.gmail.com>
References: <1486010836-25228-1-git-send-email-anup.patel@broadcom.com>
 <1486010836-25228-4-git-send-email-anup.patel@broadcom.com>
 <CAPcyv4gBFu7skx_8cvsaL0sL5=44DMcWY_EjWSCfaNd8oh=Svw@mail.gmail.com>
 <CAALAos8HEjPhdM0cibTVB==WsanktBx87e8b8diVsNm1EmCQHQ@mail.gmail.com> <CAPcyv4icg74StGOjsOpYCDb9x02rrvSrkv6O66WtbSvhOwxYnw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-vk0-f51.google.com ([209.85.213.51]:33118 "EHLO
        mail-vk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752772AbdBFDz0 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Sun, 5 Feb 2017 22:55:26 -0500
Received: by mail-vk0-f51.google.com with SMTP id k127so48189467vke.0
        for <linux-crypto@vger.kernel.org>; Sun, 05 Feb 2017 19:55:25 -0800 (PST)
In-Reply-To: <CAPcyv4icg74StGOjsOpYCDb9x02rrvSrkv6O66WtbSvhOwxYnw@mail.gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Sat, Feb 4, 2017 at 12:12 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, Feb 3, 2017 at 2:59 AM, Anup Patel <anup.patel@broadcom.com> wrote:
>>
>>
>> On Thu, Feb 2, 2017 at 11:31 AM, Dan Williams <dan.j.williams@intel.com>
>> wrote:
>>>
>>> On Wed, Feb 1, 2017 at 8:47 PM, Anup Patel <anup.patel@broadcom.com>
>>> wrote:
>>> > The DMAENGINE framework assumes that if PQ offload is supported by a
>>> > DMA device then all 256 PQ coefficients are supported. This assumption
>>> > does not hold anymore because we now have BCM-SBA-RAID offload engine
>>> > which supports PQ offload with limited number of PQ coefficients.
>>> >
>>> > This patch extends async_tx APIs to handle DMA devices with support
>>> > for fewer PQ coefficients.
>>> >
>>> > Signed-off-by: Anup Patel <anup.patel@broadcom.com>
>>> > Reviewed-by: Scott Branden <scott.branden@broadcom.com>
>>> > ---
>>> >  crypto/async_tx/async_pq.c          |  3 +++
>>> >  crypto/async_tx/async_raid6_recov.c | 12 ++++++++++--
>>> >  include/linux/dmaengine.h           | 19 +++++++++++++++++++
>>> >  include/linux/raid/pq.h             |  3 +++
>>> >  4 files changed, 35 insertions(+), 2 deletions(-)
>>>
>>> So, I hate the way async_tx does these checks on each operation, and
>>> it's ok for me to say that because it's my fault. Really it's md that
>>> should be validating engine offload capabilities once at the beginning
>>> of time. I'd rather we move in that direction than continue to pile
>>> onto a bad design.
>>
>>
>> Yes, indeed. All async_tx APIs have lot of checks and for high throughput
>> RAID offload engine these checks can add some overhead.
>>
>> I think doing checks in Linux md would be certainly better but this would
>> mean lot of changes in Linux md as well as remove checks in async_tx.
>>
>> Also, async_tx APIs should not find DMA channel on its own instead it
>> should rely on Linux md to provide DMA channel pointer as parameter.
>>
>> It's better to do checks cleanup in async_tx as separate patchset and
>> keep this patchset simple.
>
> That's been the problem with async_tx being broken like this for
> years. Once you get this "small / simple" patch upstream, that
> arguably makes async_tx a little bit worse, there is no longer any
> motivation to fix the underlying issues. If you care about the long
> term health of raid offload and are enabling new hardware support you
> should first tackle the known problems with it before adding new
> features.

Apart from the checks related issue you pointed there are other
issues with async_tx APIs such as:

1. The mechanism to do update PQ (or RAID6 update) operation
in current async_tx APIs is to call async_gen_syndrome() twice
with ASYNC_TX_PQ_XOR_DST flag set. Also, async_gen_syndrome()
will always prefer SW approach when ASYNC_TX_PQ_XOR_DST flag
is set. This means async_tx API is forcing SW approach for update
PQ operation and in-addition we require two async_gen_syndrome()
calls to achieve update PQ. This limitations of async_gen_syndrome()
reduces performance of async_tx APIs. Instead of this we should
have a dedicated async_update_pq() API which will allow RAID
offload engine drivers (such as BCM-FS4-RAID) to implement
update PQ using HW offload and this new API will fall-back to
SW approach using async_gen_syndrome() if no DMA channel
provides update PQ HW offload.

2. In our stress testing, we have observed that dma_map_page()
and dma_unmap_page() used in various async_tx APIs are the
major cause of overhead. If we directly call DMA channel callbacks
with pre-DMA-mapped pages then we get very high throughput.
The async_tx APIs should provide a way for pre-DMA-mapped
pages so that Linux MD can exploit this fact for better performance.

3. We really don't have a test module to stress/benchmark all
async_tx APIs using multi-threading and batching large number
of request in each thread. This kind of test module is very much
required for performance benchmarking and stressing high
throughput (hundreds of Gbps) RAID offload engines (such as
BCM-FS4-RAID).

>From the above, we already have async_tx_test module to
address point3. We also plan to address point1 above but
this would also require changes in Linux MD to use new
async_update_pq() API.

As you can see, this patchset is not end of story of us if we
want best possible utilization of BCM-FS4-RAID.

Regards,
Anup
