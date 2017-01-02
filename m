From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH] crypto: picoxcell - Fix module autoload for non-OF
 registration
Date: Mon, 2 Jan 2017 13:32:11 -0300
Message-ID: <e66bdf95-a99b-1942-334f-1125ee552d05@osg.samsung.com>
References: <1483371482-4956-1-git-send-email-javier@osg.samsung.com>
 <2761495.aqgObxUbGB@wuerfel>
 <ab87e239-6623-764b-998d-3d8148a6adf1@osg.samsung.com>
 <2972455.z8LBYOSBAA@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
        "David S. Miller" <davem@davemloft.net>
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <2972455.z8LBYOSBAA@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 01/02/2017 01:24 PM, Arnd Bergmann wrote:
> On Monday, January 2, 2017 1:13:24 PM CET Javier Martinez Canillas wrote:
>> Hello Arnd,
>>
>> On 01/02/2017 01:05 PM, Arnd Bergmann wrote:
>>> On Monday, January 2, 2017 12:38:02 PM CET Javier Martinez Canillas wrote:
>>>> If the driver is built as a module, autoload won't work because the module
>>>> alias information is not filled. So user-space can't match the registered
>>>> device with the corresponding module if the device isn't registered via OF.
>>>>
>>>> Export the module alias information using the MODULE_DEVICE_TABLE() macro.
>>>
>>> I think we can just remove the table, as the platform only supports
>>> booting through DT anyway.
>>>
>>
>> Agreed. I should had checked if mach-picoxcell was DT-only indeed.
>>
>> Should I also make the driver to depend on OF and remove the #ifdefery then?
> 
> I don't think we need a dependency, the #ifdef checks in there were needed
> only to make the driver smaller if OF is disabled and it should still build
> fine if someone tries to compile it for CONFIG_COMPILE_TEST without
> CONFIG_OF.
>

OK, the driver doesn't depend on COMPILE_TEST though but I agree with you
since it seems the driver only has runtime but no build time dependencies
with ARCH_PICOXCELL.
 
> If we remove the platform ID, we can however also remove the 
> spacc_is_compatible() function and just call of_device_is_compatible()
> in its place.
>

Yes.

> 	Arnd
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
