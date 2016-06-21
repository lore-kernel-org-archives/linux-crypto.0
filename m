From: Tero Kristo <t-kristo@ti.com>
Subject: Re: [PATCH 23/28] ARM: dts: DRA7: Add DT node for DES IP
Date: Tue, 21 Jun 2016 20:56:15 +0300
Message-ID: <57697FBF.7020709@ti.com>
References: <1464771389-10640-1-git-send-email-t-kristo@ti.com>
 <1464772006-11254-1-git-send-email-t-kristo@ti.com>
 <1464772006-11254-4-git-send-email-t-kristo@ti.com>
 <20160610113836.GF22406@atomide.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: <linux-omap@vger.kernel.org>, <linux-crypto@vger.kernel.org>,
	<herbert@gondor.apana.org.au>, <davem@davemloft.net>,
	<linux-arm-kernel@lists.infradead.org>, <lokeshvutla@ti.com>
To: Tony Lindgren <tony@atomide.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:36019 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbcFUR4o (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 21 Jun 2016 13:56:44 -0400
In-Reply-To: <20160610113836.GF22406@atomide.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 10/06/16 14:38, Tony Lindgren wrote:
> * Tero Kristo <t-kristo@ti.com> [160601 02:09]:
>> From: Joel Fernandes <joelf@ti.com>
>>
>> DRA7xx SoCs have a DES3DES IP. Add DT data for the same.
>
> Are these dts changes safe to apply separately or do they
> cause issues like extra warnings during boot?

DTS changes are fine to merge as is separately, some crypto 
functionality might not work properly though (well, the support is 
somewhat broken on am43xx/dra7 anyways.) I just gave the kernel a boot 
test with am43xx/dra7 platforms with the DT data only applied, and that 
part worked fine.

I noticed that if you merge the hwmod changes before you have the DTS 
data though, you will get some extra boot warnings of the following kind 
on am43xx/dra7:

<snip>
[    0.315623] omap_hwmod: aes1: no dt node
[    0.315631] ------------[ cut here ]------------
[    0.315656] WARNING: CPU: 0 PID: 1 at 
arch/arm/mach-omap2/omap_hwmod.c:2497 _init+0x1d0/0x41c
[    0.315663] omap_hwmod: aes1: doesn't have mpu register target base
<snip>

Do you want to pick-up the DTS changes from this revision of series as 
is or shall I repost those also? I think the series would require a 
re-ordering of posting the DTS changes before the hwmod data.

-Tero
