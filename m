From: Gilad Ben-Yossef <gilad@benyossef.com>
Subject: Re: [PATCH v2 1/2] crypto: ccree: enable support for hardware keys
Date: Thu, 26 Apr 2018 10:05:06 +0300
Message-ID: <CAOtvUMd-Fkva9RGqRu0HkDjGLfuw9vtvPxQ0r6SBtinOZ=Q1_w@mail.gmail.com>
References: <1524468316-6606-1-git-send-email-gilad@benyossef.com>
 <1524468316-6606-2-git-send-email-gilad@benyossef.com> <0caa0d1d-eb05-c5a1-9958-2285bb11db8c@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Ofir Drang <ofir.drang@arm.com>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
To: Tudor Ambarus <tudor.ambarus@microchip.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <0caa0d1d-eb05-c5a1-9958-2285bb11db8c@microchip.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Apr 25, 2018 at 6:47 PM, Tudor Ambarus
<tudor.ambarus@microchip.com> wrote:
> Hi, Gilad,
>
> On 04/23/2018 10:25 AM, Gilad Ben-Yossef wrote:
>>
>> Enable CryptoCell support for hardware keys.
>>
>> Hardware keys are regular AES keys loaded into CryptoCell internal memory
>> via firmware, often from secure boot ROM or hardware fuses at boot time.
>>
>> As such, they can be used for enc/dec purposes like any other key but
>> cannot (read: extremely hard to) be extracted since since they are not
>> available anywhere in RAM during runtime.
>>
>> The mechanism has some similarities to s390 secure keys although the keys
>> are not wrapped or sealed, but simply loaded offline. The interface was
>> therefore modeled based on the s390 secure keys support.
>
>
> I'm interested in hardware keys, ecc508 supports them too. In your
> proposal you expect that the user will provide a specific key token that
> is meaningful only for the ccree driver. If another driver that supports
> "cbc(paes)" shows up, you will force the user to select a specific
> driver implementation and to know what kind of key token to provide.
> Shouldn't we have a common API that can address other drivers too?

The v1 of the patch gave a unique name ("haes") to the CryptoCell HW
key format, since the information in the key for CryptoCell and the
s390 is very different (in short: cryptocell uses key size + slot
index, s390 provide an key encrypted by a HW known key).
Herbert expressed the sentiment that since the user needs to be aware
of the specific format of the token for each device anyway, she must
be aware of which tfm provider is being used anyway, so must be using
the device specific name.
Hence, I change the name to use "paes" just like the s390.

It's pretty obvious that the s390 and CryptoCell HW/protected keys
don't have anything in common and are not interchangeable.
I would say that if the ecc508 tokens are yet a third format, we
should follow the same example and just leave it as "paes" and let the
user specify an exact device name.

However, if we can find a common token format for ecc508 with either
CryptoCell or the s390 (probably less likely), maybe its worth using a
common name for those and a different for the outlier?

Gilad


-- 
Gilad Ben-Yossef
Chief Coffee Drinker

"If you take a class in large-scale robotics, can you end up in a
situation where the homework eats your dog?"
 -- Jean-Baptiste Queru
