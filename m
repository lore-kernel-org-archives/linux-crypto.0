From: Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: Re: [PATCH v2 1/2] crypto: ccree: enable support for hardware keys
Date: Wed, 25 Apr 2018 18:47:27 +0300
Message-ID: <0caa0d1d-eb05-c5a1-9958-2285bb11db8c@microchip.com>
References: <1524468316-6606-1-git-send-email-gilad@benyossef.com>
 <1524468316-6606-2-git-send-email-gilad@benyossef.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Ofir Drang <ofir.drang@arm.com>, <linux-crypto@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1524468316-6606-2-git-send-email-gilad@benyossef.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi, Gilad,

On 04/23/2018 10:25 AM, Gilad Ben-Yossef wrote:
> Enable CryptoCell support for hardware keys.
> 
> Hardware keys are regular AES keys loaded into CryptoCell internal memory
> via firmware, often from secure boot ROM or hardware fuses at boot time.
> 
> As such, they can be used for enc/dec purposes like any other key but
> cannot (read: extremely hard to) be extracted since since they are not
> available anywhere in RAM during runtime.
> 
> The mechanism has some similarities to s390 secure keys although the keys
> are not wrapped or sealed, but simply loaded offline. The interface was
> therefore modeled based on the s390 secure keys support.

I'm interested in hardware keys, ecc508 supports them too. In your
proposal you expect that the user will provide a specific key token that
is meaningful only for the ccree driver. If another driver that supports
"cbc(paes)" shows up, you will force the user to select a specific
driver implementation and to know what kind of key token to provide.
Shouldn't we have a common API that can address other drivers too?

Best,
ta
