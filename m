From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] Adding ADMA support for PPC460EX DMA engine.
Date: Fri, 23 Jul 2010 12:21:08 -0700
Message-ID: <AANLkTi=M1L3xPiA1zyvDkA3403B=OpXdWfhMEP7mahrW@mail.gmail.com>
References: <1279846638-22323-1-git-send-email-tmarri@amcc.com>
	<201007230815.14464.sr@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: linuxppc-dev@lists.ozlabs.org, tmarri@amcc.com,
	linux-crypto@vger.kernel.org, linux-raid@vger.kernel.org
To: Stefan Roese <sr@denx.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201007230815.14464.sr@denx.de>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Jul 22, 2010 at 11:15 PM, Stefan Roese <sr@denx.de> wrote:
> Hi Marri,
>
> On Friday 23 July 2010 02:57:18 tmarri@amcc.com wrote:
>> From: Tirumala Marri <tmarri@amcc.com>
>>
>> =A0 This patch will add ADMA support for DMA engine and HW offload f=
or
>> =A0 XOR/ADG (RAID-5/6) functionalities.
>> =A0 1. It supports memcpy, xor, GF(2) based RAID-6.
>> =A0 2. It supports interrupt based DMA completions.
>> =A0 3. Also supports memcpy in RAID-1 case.
>>
>> =A0 Kernel version: 2.6.35-rc5
>>
>> =A0 Testing:
>> =A0 =A0 Created RAID-5/6 arrays usign mdadm.
>> =A0 =A0 And ran raw IO and filesystem IO to the RAID array.
>> =A0 =A0 Chunk size 4k,64k was tested.
>> =A0 =A0 RAID rebuild , disk fail, resync tested.
>>
>> =A0 File names:
>> =A0 =A0 This code is similar to ppc440spe . So I named the files as
>> =A0 =A0 drivers/dma/ppc4xx/adma1.c and drivers/dma/ppc4xx/adma1.h
>
> As you describe above, a lot of the code seems to be copied from
> drivers/dma/ppc4xx/adma.c/h. Wouldn't it make more sense to factor ou=
t the
> common code instead of duplicating it?
>

Yes, and you might look to drivers/dma/iop-adma.c as an example of a
way to support similar hardware with a single code base.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
