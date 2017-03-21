From: Anup Patel <anup.patel@broadcom.com>
Subject: Re: [PATCH v6 0/4] Broadcom SBA RAID support
Date: Tue, 21 Mar 2017 14:17:21 +0530
Message-ID: <CAALAos-k_DBYAz49278wBr_GoceOKYVH_UuzTLn1h7QCiUd8pg@mail.gmail.com>
References: <1488793408-25592-1-git-send-email-anup.patel@broadcom.com>
 <20170321083052.GY2843@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>,
 Device Tree <devicetree@vger.kernel.org>,
 Herbert Xu <herbert@gondor.apana.org.au>,
 Scott Branden <sbranden@broadcom.com>, Jon Mason <jonmason@broadcom.com>,
 Ray Jui <rjui@broadcom.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
 linux-raid <linux-raid@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
 BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
 linux-crypto@vger.kernel.org, Rob Rice <rob.rice@broadcom.com>,
 dmaengine@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
 "David S . Miller" <davem@davemloft.net>,
 Linux ARM Kernel <linux-arm-kernel@lists.infradead.org>
To: Vinod Koul <vinod.koul@intel.com>, Jassi Brar <jassisinghbrar@gmail.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20170321083052.GY2843@localhost>
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

On Tue, Mar 21, 2017 at 2:00 PM, Vinod Koul <vinod.koul@intel.com> wrote:
> On Mon, Mar 06, 2017 at 03:13:24PM +0530, Anup Patel wrote:
>> The Broadcom SBA RAID is a stream-based device which provides
>> RAID5/6 offload.
>>
>> It requires a SoC specific ring manager (such as Broadcom FlexRM
>> ring manager) to provide ring-based programming interface. Due to
>> this, the Broadcom SBA RAID driver (mailbox client) implements
>> DMA device having one DMA channel using a set of mailbox channels
>> provided by Broadcom SoC specific ring manager driver (mailbox
>> controller).
>>
>> The Broadcom SBA RAID hardware requires PQ disk position instead
>> of PQ disk coefficient. To address this, we have added raid_gflog
>> table which will help driver to convert PQ disk coefficient to PQ
>> disk position.
>>
>> This patchset is based on Linux-4.11-rc1 and depends on patchset
>> "[PATCH v5 0/2] Broadcom FlexRM ring manager support"
>
> Okay I applied and was about to push when I noticed this :(
>
> So what is the status of this..?

PATCH2 is Acked but PATCH1 is under-review. Currently, its
v6 of that patchset.

The only dependency on that patchset is the changes in
brcm-message.h which are required by this BCM-SBA-RAID
driver.

@Jassi,
Can you please have a look at PATCH v6?

Regards,
Anup
