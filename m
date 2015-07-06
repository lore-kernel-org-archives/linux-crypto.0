From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: Re: [PATCH 08/10] crypto: omap-aes: gmc: Add algo info
Date: Mon, 6 Jul 2015 13:45:47 +0530
Message-ID: <559A3933.7070709@ti.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com> <1435814320-30347-9-git-send-email-lokeshvutla@ti.com> <20150706073539.GA20192@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <linux-crypto@vger.kernel.org>, <davem@davemloft.net>,
	<linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<t-kristo@ti.com>, <nsekhar@ti.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150706073539.GA20192@gondor.apana.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,
On Monday 06 July 2015 01:05 PM, Herbert Xu wrote:
> On Thu, Jul 02, 2015 at 10:48:38AM +0530, Lokesh Vutla wrote:
>> Now the driver supports gcm mode, add omap-aes-gcm
>> algo info to omap-aes driver.
>>
>> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
> 
> You're using the old AEAD interface.  We are now moving to the
> new AEAD interface so I will not be accepting any new implementations
> using the old interface.
> 
> Please convert your driver over to the new interface.
Will convert omap-aes driver to new interface and repost.

Thanks and regards,
Lokesh
> 
> Also please merge your GCM patches into a single patch.  Splitting
> out bug fixes makes no sense.
> 
> Thanks,
> 
