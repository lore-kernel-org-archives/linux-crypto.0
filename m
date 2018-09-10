From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 1/5] crypto: arm/aes-ce - enable module autoloading based
 on CPU feature bits
Date: Mon, 10 Sep 2018 09:01:56 +0200
Message-ID: <CAKv+Gu_J0s4gcdVQOQ96dD7kpNj=po83wT0BRiiiYR9pu=e0aw@mail.gmail.com>
References: <1495362220-30044-1-git-send-email-ard.biesheuvel@linaro.org>
 <1495362220-30044-2-git-send-email-ard.biesheuvel@linaro.org>
 <f68937805ccdbdd296118ee6871fa25e@agner.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
 <linux-crypto@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Herbert Xu <herbert@gondor.apana.org.au>
To: Stefan Agner <stefan@agner.ch>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <f68937805ccdbdd296118ee6871fa25e@agner.ch>
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

On 10 September 2018 at 08:21, Stefan Agner <stefan@agner.ch> wrote:
> Hi Ard,
>
> On 21.05.2017 03:23, Ard Biesheuvel wrote:
>> Make the module autoloadable by tying it to the CPU feature bit that
>> describes whether the optional instructions it relies on are implemented
>> by the current CPU.
>>
>
> This leads to a compiler warning when compiling multi_v7_defconfig/ARM32
> using Clang 6.0.1:
>
> arch/arm/crypto/aes-ce-glue.c:450:1: warning: variable
> 'cpu_feature_match_AES' is not needed and will not
>       be emitted [-Wunneeded-internal-declaration]
> module_cpu_feature_match(AES, aes_init);
>
> ./include/linux/cpufeature.h:48:33: note: expanded from macro
> 'module_cpu_feature_match'
> static struct cpu_feature const cpu_feature_match_ ## x[] =     \
>
> <scratch space>:83:1: note: expanded from here
> cpu_feature_match_AES
> ^
> 1 warning generated.
>
> Do you happen to have an idea how to alleviate?
>

I guess this only happens for modules that are selected as builtin,
and so MODULE_DEVICE_TABLE() resolves to nothing?
Does this only occur for CPU features?
