From: Naveen Krishna Ch <naveenkrishna.ch@gmail.com>
Subject: Re: [PATCH 5/5] ARM: exynos5420: add dt node for sss module
Date: Thu, 9 Jan 2014 09:56:13 +0530
Message-ID: <CAHfPSqC3D-=T+v=zgWYfJbXki=L2Uc_axZWEsnMET8rDi31WKg@mail.gmail.com>
References: <1389095509-14357-1-git-send-email-ch.naveen@samsung.com>
 <1389095509-14357-6-git-send-email-ch.naveen@samsung.com> <1420297.0gEDu9oNDc@flatron>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Naveen Krishna Ch <ch.naveen@samsung.com>,
	linux-crypto@vger.kernel.org,
	"linux-samsung-soc@vger.kernel.org"
	<linux-samsung-soc@vger.kernel.org>, linux-kernel@vger.kernel.org,
	Vladimir Zapolskiy <vzapolskiy@gmail.com>,
	herbert@gondor.apana.org.au, cpgs@samsung.com,
	Kukjin Kim <kgene.kim@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Return-path: <linux-samsung-soc-owner@vger.kernel.org>
In-Reply-To: <1420297.0gEDu9oNDc@flatron>
Sender: linux-samsung-soc-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hello Tomasz,

On 8 January 2014 06:02, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On Tuesday 07 of January 2014 17:21:49 Naveen Krishna Ch wrote:
>> From: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>>
>> this patch adds the device tree nodes for SSS module found on Exynos5420
>
> nit: Sentences in English start with a capital letter. Also this patch
> adds one node, not few of them as the description suggests.
>
> Also patch subject should start with ARM: dts: prefix.
>
>>
>> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
>> TO: <linux-samsung-soc@vger.kernel.org>
>> CC: Kukjin Kim <kgene.kim@samsung.com>
>> CC: <linux-crypto@vger.kernel.org>
>> ---
>>  arch/arm/boot/dts/exynos5420.dtsi |   10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos5420.dtsi b/arch/arm/boot/dts/exynos5420.dtsi
>> index 11dd202..97045f9 100644
>> --- a/arch/arm/boot/dts/exynos5420.dtsi
>> +++ b/arch/arm/boot/dts/exynos5420.dtsi
>> @@ -652,4 +652,14 @@
>>               clocks = <&clock 319>, <&clock 318>;
>>               clock-names = "tmu_apbif", "tmu_triminfo_apbif";
>>       };
>> +
>> +     sss: sss {
>
> Node name should be sss@10830000 as per ePAPR node naming recommendation.
Thanks for the correction, Will correct it and submit. Thanks
>
> Best regards,
> Tomasz
>



-- 
Shine bright,
(: Nav :)
