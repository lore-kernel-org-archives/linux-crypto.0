From: Anup Patel <anup.patel@broadcom.com>
Subject: Re: [PATCH v2 2/5] async_tx: Handle DMA devices having support for
 fewer PQ coefficients
Date: Fri, 10 Feb 2017 08:54:16 +0530
Message-ID: <CAALAos-LzJG+2fMunWPYgqEXoiy9pbHvN_Mad=bPiskZ71rHmQ@mail.gmail.com>
References: <1486455406-11202-1-git-send-email-anup.patel@broadcom.com>
 <1486455406-11202-3-git-send-email-anup.patel@broadcom.com>
 <CAPcyv4gbV1yf52JrejW+Dn3wOPn7Er+8HWdu2qsW0+Qm+cRr9g@mail.gmail.com>
 <CAALAos_yhXufdt79KWY0eugjF5oyJ8+NcPh2E-dEXnSQu2WhhA@mail.gmail.com>
 <CAPcyv4hK_1f8bryq6smPQy7vTnP+QEzmT9wnAEE1xpxq7EAnjQ@mail.gmail.com>
 <CAALAos9ovab4x=waRgM7G2adRC7syHMkY0Rhf-UPB_+h4w3yNQ@mail.gmail.com>
 <CAPcyv4iFJXxvJFrUs2jtwP9GX5NcJ8LiEDHeZ5b1fwjCAToe5w@mail.gmail.com>
 <CAALAos-ua6hVpUqjnJSQ=ysSOKrN67toiT3J808uHC4A_ZV3mg@mail.gmail.com>
 <CAPcyv4gDq+our1+sAPShBru-qvebo+Zvk0crgSUNXucHGQwZ1Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>,
 Device Tree <devicetree@vger.kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Scott Branden <sbranden@broadcom.com>, Vinod Koul <vinod.koul@intel.com>,
 Ray Jui <rjui@broadcom.com>, Jassi Brar <jassisinghbrar@gmail.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 linux-raid <linux-raid@vger.kernel.org>, Jon Mason <jonmason@broadcom.com>,
 Rob Herring <robh+dt@kernel.org>,
 BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
 linux-crypto@vger.kernel.org, Rob Rice <rob.rice@broadcom.com>,
 "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
 "David S . Miller" <davem@davemloft.net>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
To: Dan Williams <dan.j.williams@intel.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <CAPcyv4gDq+our1+sAPShBru-qvebo+Zvk0crgSUNXucHGQwZ1Q@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Feb 9, 2017 at 10:14 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, Feb 9, 2017 at 1:29 AM, Anup Patel <anup.patel@broadcom.com> wrote:
>> On Wed, Feb 8, 2017 at 9:54 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> On Wed, Feb 8, 2017 at 12:57 AM, Anup Patel <anup.patel@broadcom.com> wrote:
>>>> On Tue, Feb 7, 2017 at 11:46 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>>>> On Tue, Feb 7, 2017 at 1:02 AM, Anup Patel <anup.patel@broadcom.com> wrote:
>>>>>> On Tue, Feb 7, 2017 at 1:57 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>>>>>>> On Tue, Feb 7, 2017 at 12:16 AM, Anup Patel <anup.patel@broadcom.com> wrote:
>>>>>>>> The DMAENGINE framework assumes that if PQ offload is supported by a
>>>>>>>> DMA device then all 256 PQ coefficients are supported. This assumption
>>>>>>>> does not hold anymore because we now have BCM-SBA-RAID offload engine
>>>>>>>> which supports PQ offload with limited number of PQ coefficients.
>>>>>>>>
>>>>>>>> This patch extends async_tx APIs to handle DMA devices with support
>>>>>>>> for fewer PQ coefficients.
>>>>>>>>
>>>>>>>> Signed-off-by: Anup Patel <anup.patel@broadcom.com>
>>>>>>>> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
>>>>>>>
>>>>>>> I don't like this approach. Define an interface for md to query the
>>>>>>> offload engine once at the beginning of time. We should not be adding
>>>>>>> any new extensions to async_tx.
>>>>>>
>>>>>> Even if we do capability checks in Linux MD, we still need a way
>>>>>> for DMAENGINE drivers to advertise number of PQ coefficients
>>>>>> handled by the HW.
>>>>>>
>>>>>> I agree capability checks should be done once in Linux MD but I don't
>>>>>> see why this has to be part of BCM-SBA-RAID driver patches. We need
>>>>>> separate patchsets to address limitations of async_tx framework.
>>>>>
>>>>> Right, separate enabling before we pile on new hardware support to a
>>>>> known broken framework.
>>>>
>>>> Linux Async Tx not broken framework. The issue is:
>>>> 1. Its not complete enough
>>>> 2. Its not optimized for very high through-put offload engines
>>>
>>> I'm not understanding your point. I'm nak'ing this change to add yet
>>> more per-transaction capability checking to async_tx. I don't like the
>>> DMA_HAS_FEWER_PQ_COEF flag, especially since it is equal to
>>> DMA_HAS_PQ_CONTINUE. I'm not asking for all of async_tx's problems to
>>> be fixed before this new hardware support, I'm simply saying we should
>>> start the process of moving offload-engine capability checking to the
>>> raid code.
>>
>> The DMA_HAS_FEWER_PQ_COEF is not equal to
>> DMA_HAS_PQ_CONTINUE.
>
> #define DMA_HAS_PQ_CONTINUE (1 << 15
> #define DMA_HAS_FEWER_PQ_COEF (1 << 15)

You are only looking at the values of these flags.

The semantics of both these flags are different and both
flags are set in different members of "struct dma_device"
The DMA_HAS_PQ_CONTINUE is set in "max_pq" whereas
DMA_HAS_FEWER_PQ_COEF is set in "max_pqcoef".

When DMA_HAS_PQ_CONTINUE is set in "max_pq", it
means that PQ HW is capable of taking P & Q computed
previous txn as input. If DMA_HAS_PQ_CONTINUE is
not supported the async_pq() will pass P & Q computed
by previous txn as sources with coef as g^0.

When DMA_HAS_FEWER_PQ_COEF is set in "max_pqcoef",
it means the PQ HW is not capable of handling all 256 coefs.

>
>> I will try to drop this patch and take care of unsupported PQ
>> coefficients in BCM-SBA-RAID driver itself even if this means
>> doing some computations in BCM-SBA-RAID driver itself.
>
> That should be nak'd as well, please do capability detection in a
> routine that is common to all raid engines.

Thanks for NAKing this patch.

This motivated me to find clean work-around for handling
unsupported PQ coefs in BCM-SBA-RAID driver.

Let's assume max number of PQ coefs supported by PQ HW
is m coefs. Now for any coef n > m, we can use RAID6 math
to get g^n = (g^m)*(g^m)*....*(g^k) where k <= m.

Using the above fact, we can create chained txn for each
source of PQ request in BCM-SBA-RAID driver where each
txn will only compute PQ from one source using above
described RAID6 math. Also, each txn in chained txn will
depend on output of previous txn because we are computing
PQ from one source at a time.

I will drop this patch and send updated BCM-SBA-RAID
driver with above described work-around for handling
unsupported PQ coefs.

Regards,
Anup
