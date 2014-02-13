From: Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: [PATCH 6/9 v6] ARM: dts: exynos5250/5420: add dt node for sss
 module
Date: Fri, 14 Feb 2014 08:32:37 +0900
Message-ID: <52FD5615.20508@samsung.com>
References: <1389095509-14357-6-git-send-email-ch.naveen@samsung.com> <1391750695-27447-1-git-send-email-ch.naveen@samsung.com> <52FD552E.8040008@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Naveen Krishna Chatradhi <ch.naveen@samsung.com>,
	linux-crypto@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-kernel@vger.kernel.org, vzapolskiy@gmail.com,
	herbert@gondor.apana.org.au, naveenkrishna.ch@gmail.com,
	cpgs@samsung.com
To: Kukjin Kim <kgene.kim@samsung.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57912 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806AbaBMXcp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 13 Feb 2014 18:32:45 -0500
In-Reply-To: <52FD552E.8040008@samsung.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/14/14 08:28, Kukjin Kim wrote:
> On 02/07/14 14:24, Naveen Krishna Chatradhi wrote:
>> This patch adds the device tree node for SSS module
>> found on Exynos5420 and Exynos5250
>>
>> Signed-off-by: Naveen Krishna Chatradhi<ch.naveen@samsung.com>
>> Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>> TO:<linux-samsung-soc@vger.kernel.org>
>> CC: Kukjin Kim<kgene.kim@samsung.com>
>> CC:<linux-crypto@vger.kernel.org>
>> ---
>> changes since v5:
>> 1. Added Reviewed-by: Tomasz Figa<t.figa@samsung.com>
>>
>> arch/arm/boot/dts/exynos5250.dtsi | 8 ++++++++
>> arch/arm/boot/dts/exynos5420.dtsi | 10 ++++++++++
>> 2 files changed, 18 insertions(+)
>>
>> diff --git a/arch/arm/boot/dts/exynos5250.dtsi
>> b/arch/arm/boot/dts/exynos5250.dtsi
>> index b7dec41..46b04e8 100644
>> --- a/arch/arm/boot/dts/exynos5250.dtsi
>> +++ b/arch/arm/boot/dts/exynos5250.dtsi
>> @@ -706,4 +706,12 @@
>> io-channel-ranges;
>> status = "disabled";
>> };
>> +
>> + sss@10830000 {
>> + compatible = "samsung,exynos4210-secss";
>> + reg =<0x10830000 0x10000>;
>> + interrupts =<0 112 0>;
>> + clocks =<&clock 348>;
>> + clock-names = "secss";
>> + };
>> };
>> diff --git a/arch/arm/boot/dts/exynos5420.dtsi
>> b/arch/arm/boot/dts/exynos5420.dtsi
>> index 8db792b..b503e96 100644
>> --- a/arch/arm/boot/dts/exynos5420.dtsi
>> +++ b/arch/arm/boot/dts/exynos5420.dtsi
>> @@ -652,4 +652,14 @@
>> clocks =<&clock 319>,<&clock 318>;
>> clock-names = "tmu_apbif", "tmu_triminfo_apbif";
>> };
>> +
>> + sss@10830000 {
>> + compatible = "samsung,exynos4210-secss";
>> + reg =<0x10830000 0x10000>;
>> + interrupts =<0 112 0>;
>> + clocks =<&clock 471>;
>> + clock-names = "secss";
>> + samsung,power-domain =<&g2d_pd>;
>> + };
>> +
>> };
>
> Applied, thanks.
>
> BTW, I think the numbering is strange...maybe I missed something?
> [PATCH 5/5], [PATCH 5/6 V2], [PATCH 6/8 V3] and this [PATCH 6/9 V6]
>
Oops, Naveen, where is bindings doc for "samsung,exynos4210-secss"?

- Kukjin
