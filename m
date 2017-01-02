From: Javier Martinez Canillas <javier@osg.samsung.com>
Subject: Re: [PATCH] crypto: picoxcell - Fix module autoload for non-OF
 registration
Date: Mon, 2 Jan 2017 13:13:24 -0300
Message-ID: <ab87e239-6623-764b-998d-3d8148a6adf1@osg.samsung.com>
References: <1483371482-4956-1-git-send-email-javier@osg.samsung.com>
 <2761495.aqgObxUbGB@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Jamie Iles <jamie@jamieiles.com>,
        "David S. Miller" <davem@davemloft.net>
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:57102
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S933057AbdABQNe (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 2 Jan 2017 11:13:34 -0500
In-Reply-To: <2761495.aqgObxUbGB@wuerfel>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello Arnd,

On 01/02/2017 01:05 PM, Arnd Bergmann wrote:
> On Monday, January 2, 2017 12:38:02 PM CET Javier Martinez Canillas wrote:
>> If the driver is built as a module, autoload won't work because the module
>> alias information is not filled. So user-space can't match the registered
>> device with the corresponding module if the device isn't registered via OF.
>>
>> Export the module alias information using the MODULE_DEVICE_TABLE() macro.
> 
> I think we can just remove the table, as the platform only supports
> booting through DT anyway.
> 

Agreed. I should had checked if mach-picoxcell was DT-only indeed.

Should I also make the driver to depend on OF and remove the #ifdefery then?

> 	Arnd
> 

Best regards,
-- 
Javier Martinez Canillas
Open Source Group
Samsung Research America
