From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v2] dt/bindings: exynos-rng: Move dt binding documentation
 to bindings/crypto
Date: Wed, 23 Aug 2017 22:14:29 +0530
Message-ID: <CANc+2y4BfdAZhgfrP6NorqTPWBYsLsHKAvoeMMa=QUgB_d4Xdg@mail.gmail.com>
References: <20170823150443.8399-1-prasannatsmkumar@gmail.com> <20170823161204.5cleer2rpgjd5vmz@kozik-lap>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: mchehab@kernel.org, Kukjin Kim <kgene@kernel.org>,
        linux-samsung-soc@vger.kernel.org, linux-crypto@vger.kernel.org
To: Krzysztof Kozlowski <krzk@kernel.org>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <20170823161204.5cleer2rpgjd5vmz@kozik-lap>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Krzysztof,

On 23 August 2017 at 21:42, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> On Wed, Aug 23, 2017 at 08:34:43PM +0530, PrasannaKumar Muralidharan wrote:
>> Samsung exynos PRNG driver is using crypto framework instead of
>> hw_random framework. So move the devicetree binding to crypto folder.
>>
>> Signed-off-by: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
>> ---
>> Changes in v2:
>> * Modify MAINTAINERS file to reflect file rename
>>
>>  .../devicetree/bindings/{rng => crypto}/samsung,exynos-rng4.txt         | 0
>>  MAINTAINERS                                                             | 2 +-
>>  2 files changed, 1 insertion(+), 1 deletion(-)
>>  rename Documentation/devicetree/bindings/{rng => crypto}/samsung,exynos-rng4.txt (100%)
>>
>
> Patch is okay but CC list is still incomplete. I do not know how you
> could get Mauro for this patch... just use get_maintainers.pl.

I used get_maintainer.pl. Rechecked again, it says Mauro and couple of
others who may not be interested in this. It did not give your or
crypto mailing list. Its strange.

> Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>

Thanks for the review.

> Best regards,
> Krzysztof
>
