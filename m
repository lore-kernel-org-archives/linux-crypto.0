From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/5] ARM: wire up HWCAP2 feature bits to the CPU modalias
Date: Mon, 2 Jan 2017 21:06:04 +0000
Message-ID: <CAKv+Gu-hLD0xnLyywceJvPiB8ZkENNwWZTM--OHFvzw6MahYmw@mail.gmail.com>
References: <1476787939-21889-1-git-send-email-ard.biesheuvel@linaro.org>
 <1476787939-21889-2-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu_y7e=sJT+7FNj846NczgpNOdVx53SDC7dupmN-3ztNwA@mail.gmail.com>
 <20161031161319.GF1041@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Steve Capper <steve.capper@linaro.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Herbert Xu <herbert@gondor.apana.org.au>
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20161031161319.GF1041@n2100.armlinux.org.uk>
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

On 31 October 2016 at 16:13, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Sat, Oct 29, 2016 at 11:08:36AM +0100, Ard Biesheuvel wrote:
>> On 18 October 2016 at 11:52, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>> > Wire up the generic support for exposing CPU feature bits via the
>> > modalias in /sys/device/system/cpu. This allows udev to automatically
>> > load modules for things like crypto algorithms that are implemented
>> > using optional instructions.
>> >
>> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>> > ---
>> >  arch/arm/Kconfig                  |  1 +
>> >  arch/arm/include/asm/cpufeature.h | 32 ++++++++++++++++++++
>> >  2 files changed, 33 insertions(+)
>> >
>>
>> Russell,
>>
>> do you have any concerns regarding this patch? If not, I will drop it
>> into the patch system.
>
> It's still something I need to look at... I've been offline last week,
> and sort-of offline the previous week, so I'm catching up.
>

Hi Russell,

Any thoughts yet?

Thanks,
Ard.
