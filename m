From: Lokesh Vutla <lokeshvutla@ti.com>
Subject: Re: [PATCH 02/10] crypto: omap-aes: Fix configuring of AES mode
Date: Thu, 2 Jul 2015 15:13:22 +0530
Message-ID: <559507BA.8090700@ti.com>
References: <1435814320-30347-1-git-send-email-lokeshvutla@ti.com> <1435814320-30347-3-git-send-email-lokeshvutla@ti.com> <20150702075732.GB4033@saruman.tx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <herbert@gondor.apana.org.au>, <linux-crypto@vger.kernel.org>,
	<davem@davemloft.net>, <linux-omap@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <t-kristo@ti.com>, <nsekhar@ti.com>
To: <balbi@ti.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150702075732.GB4033@saruman.tx.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thursday 02 July 2015 01:27 PM, Felipe Balbi wrote:
> On Thu, Jul 02, 2015 at 10:48:32AM +0530, Lokesh Vutla wrote:
>> AES_CTRL_REG is used to configure AES mode. Before configuring
>> any mode we need to make sure all other modes are reset or else
>> driver will misbehave. So mask all modes before configuring
>> any AES mode.
>>
>> Signed-off-by: Lokesh Vutla <lokeshvutla@ti.com>
>> ---
>>  drivers/crypto/omap-aes.c |   13 +++++--------
>>  1 file changed, 5 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
>> index a923101..96fc7f7 100644
>> --- a/drivers/crypto/omap-aes.c
>> +++ b/drivers/crypto/omap-aes.c
>> @@ -63,6 +63,7 @@
>>  #define AES_REG_CTRL_DIRECTION		(1 << 2)
>>  #define AES_REG_CTRL_INPUT_READY	(1 << 1)
>>  #define AES_REG_CTRL_OUTPUT_READY	(1 << 0)
>> +#define AES_REG_CTRL_MASK		FLD_MASK(24, 2)
> 
> you end up masking bits which aren't even defined in this driver. What
> are those bits ? Perhaps add macros for them and define
> AES_REG_CTRL_MASK by explicitly ORing those macros ? That would, at
> least, be clearer
Hardware supports ECB, CBC, CTR, CFB, F8, CBC_MAC, F9, GCM, CCM, XTS modes.
But current driver has only ECB, CBC, CTR modes support.
That is why the other fields are not yet defined.
So, defining these is fine, but ORing all these will be very big and looks a bit ugly.
So I kept it as mask of all these bits.
Ill move it to GEN_MASK here only.

Thanks and regards,
Lokesh

> 
