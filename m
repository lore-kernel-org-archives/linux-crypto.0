From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH 0/3] crypto: introduce Microchip / Atmel ECC driver
Date: Wed, 5 Jul 2017 14:44:55 +0300
Message-ID: <3c858d4f-d583-61c3-0a51-d4d931ac8816@microchip.com>
References: <1499249280-31779-1-git-send-email-tudor.ambarus@microchip.com>
 <A53140BD-29A8-498B-A0C9-2891E3F0EF7E@holtmann.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        <wsa@the-dreams.de>, <linux-i2c@vger.kernel.org>,
        <nicolas.ferre@microchip.com>
To: Marcel Holtmann <marcel@holtmann.org>
Return-path: <linux-i2c-owner@vger.kernel.org>
In-Reply-To: <A53140BD-29A8-498B-A0C9-2891E3F0EF7E@holtmann.org>
Content-Language: en-US
Sender: linux-i2c-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi, Marcel,

On 05.07.2017 13:54, Marcel Holtmann wrote:
> Hi Tudor,
> 
>> This patch set introduces Microchip / Atmel ECC driver.
>>
>> The first patch adds some helpers that will be used by fallbacks to
>> kpp software implementations.
>>
>> The second patch adds ECDH support for the ATECC508A (I2C)
>> cryptographic engine. The I2C interface is designed to operate
>> at a maximum clock speed of 1MHz.
>>
>> The device features hardware acceleration for the NIST standard
>> P256 prime curve and supports the complete key life cycle from
>> private key generation to ECDH key agreement.
>>
>> Random private key generation is supported internally within
>> the device to ensure that the private key can never be known
>> outside of the device. If the user wants to use its own private
>> keys, the driver will fallback to the ecdh software implementation.
> 
> can we get this testing with the Bluetooth SMP code? I would really like to see this being offloaded to hardware. For Bluetooth SMP we never really need the private key either. The end result is an symmetric 128-bit key for AES. And we throw the generated key pairs away.
> 
> With the limitation of private is not available to Linux directly, we should make sure that KPP users that don’t require the private key are working properly and can utilize the offload.

The driver was tested with testmgr, the offload worked.

I've extended recently the ecdh software implementation with
ecc privkey generation support. I also added a kpp test in
testmgr to prove that it works correctly (see [1]).

I will take a look at Bluetooth SMP code.

Thanks,
ta

[1] http://www.mail-archive.com/linux-crypto@vger.kernel.org/msg25835.html
