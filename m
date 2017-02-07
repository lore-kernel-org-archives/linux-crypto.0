From: Anup Patel <anup.patel@broadcom.com>
Subject: Re: [PATCH v2 2/5] async_tx: Handle DMA devices having support for
 fewer PQ coefficients
Date: Tue, 7 Feb 2017 14:32:15 +0530
Message-ID: <CAALAos_yhXufdt79KWY0eugjF5oyJ8+NcPh2E-dEXnSQu2WhhA@mail.gmail.com>
References: <1486455406-11202-1-git-send-email-anup.patel@broadcom.com>
 <1486455406-11202-3-git-send-email-anup.patel@broadcom.com>
 <CAPcyv4gbV1yf52JrejW+Dn3wOPn7Er+8HWdu2qsW0+Qm+cRr9g@mail.gmail.com>
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
In-Reply-To: <CAPcyv4gbV1yf52JrejW+Dn3wOPn7Er+8HWdu2qsW0+Qm+cRr9g@mail.gmail.com>
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

On Tue, Feb 7, 2017 at 1:57 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Feb 7, 2017 at 12:16 AM, Anup Patel <anup.patel@broadcom.com> wrote:
>> The DMAENGINE framework assumes that if PQ offload is supported by a
>> DMA device then all 256 PQ coefficients are supported. This assumption
>> does not hold anymore because we now have BCM-SBA-RAID offload engine
>> which supports PQ offload with limited number of PQ coefficients.
>>
>> This patch extends async_tx APIs to handle DMA devices with support
>> for fewer PQ coefficients.
>>
>> Signed-off-by: Anup Patel <anup.patel@broadcom.com>
>> Reviewed-by: Scott Branden <scott.branden@broadcom.com>
>
> I don't like this approach. Define an interface for md to query the
> offload engine once at the beginning of time. We should not be adding
> any new extensions to async_tx.

Even if we do capability checks in Linux MD, we still need a way
for DMAENGINE drivers to advertise number of PQ coefficients
handled by the HW.

I agree capability checks should be done once in Linux MD but I don't
see why this has to be part of BCM-SBA-RAID driver patches. We need
separate patchsets to address limitations of async_tx framework.

Regards,
Anup
