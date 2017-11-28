From: Fabien DESSENNE <fabien.dessenne@st.com>
Subject: Re: [PATCH v5 2/2] crypto: stm32 - Support for STM32 CRYP crypto
 module
Date: Tue, 28 Nov 2017 09:47:54 +0000
Message-ID: <63a930a0-e56b-9fd4-ad47-e8ebb494a77f@st.com>
References: <1508425830-13565-1-git-send-email-fabien.dessenne@st.com>
 <1508425830-13565-3-git-send-email-fabien.dessenne@st.com>
 <20171022072659.GB8489@Red> <d924a278-90d0-969e-f1ae-a12f92e8972d@st.com>
 <774a92f2-af70-0424-b066-0cc1db3f9ab0@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 Alexandre TORGUE <alexandre.torgue@st.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Lionel DEBIEVE <lionel.debieve@st.com>, Rob Herring <robh+dt@kernel.org>,
 Corentin Labbe <clabbe.montjoie@gmail.com>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Ludovic BARRE <ludovic.barre@st.com>, "David S . Miller" <davem@davemloft.net>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Benjamin GAIGNARD <benjamin.gaignard@st.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <774a92f2-af70-0424-b066-0cc1db3f9ab0@st.com>
Content-Language: en-US
Content-ID: <16DC39CAF100614886DB8316D4C7E37B@st.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
List-Id: linux-crypto.vger.kernel.org

Just a gentle ping ... or have I missed out on a reply?


On 13/11/17 11:30, Fabien DESSENNE wrote:
> Hi Herbert,
>
> Can you check if this patchset (removed the AEAD part as you suggested +
> libkcapi test OK as suggested by Corentin) can be applied now?
>
> BR
>
> Fabien
>
>
> On 07/11/17 15:40, Fabien DESSENNE wrote:
>> On 22/10/17 09:26, Corentin Labbe wrote:
>>> On Thu, Oct 19, 2017 at 05:10:30PM +0200, Fabien Dessenne wrote:
>>>> This module registers block cipher algorithms that make use of the
>>>> STMicroelectronics STM32 crypto "CRYP1" hardware.
>>>> The following algorithms are supported:
>>>> - aes: ecb, cbc, ctr
>>>> - des: ecb, cbc
>>>> - tdes: ecb, cbc
>>>>
>>>> Signed-off-by: Fabien Dessenne <fabien.dessenne@st.com>
>>>> ---
>>>>     drivers/crypto/stm32/Kconfig      |    9 +
>>>>     drivers/crypto/stm32/Makefile     |    3 +-
>>>>     drivers/crypto/stm32/stm32-cryp.c | 1172 +++++++++++++++++++++++++++++++++++++
>>>>     3 files changed, 1183 insertions(+), 1 deletion(-)
>>>>     create mode 100644 drivers/crypto/stm32/stm32-cryp.c
>>>>
>>>> diff --git a/drivers/crypto/stm32/Kconfig b/drivers/crypto/stm32/Kconfig
>>>> +static void stm32_cryp_irq_write_block(struct stm32_cryp *cryp)
>>>> +{
>>>> +	unsigned int i, j;
>>>> +	u32 *src;
>>>> +	u8 d8[4];
>>>> +
>>>> +	src = sg_virt(cryp->in_sg) + _walked_in;
>>>> +
>>>> +	for (i = 0; i < cryp->hw_blocksize / sizeof(u32); i++) {
>>>> +		if (likely(cryp->total_in >= sizeof(u32))) {
>>>> +			/* Write a full u32 */
>>>> +			stm32_cryp_write(cryp, CRYP_DIN, *src);
>>> Hello
>>>
>>> Try also to test your driver with userspace via AF_ALG (libkcapi is a good start).
>>> It should probably crash here.
>>> I have do the same on my first sunxi-ss driver and you should use kmap().
>>>
>>> Regards
>> Hi Corentin,
>>
>> Thank you for suggesting to test from userspace through the AF_ALG
>> socket with libkcapi.
>> This increases my test coverage.
>>
>> I ran the miscellaneous tests (kcapi-enc-test(large).sh + test.sh) and
>> could not observe any crash.
>> Note that I had already fixed some 'memory crashes' while testing with
>> testmgr / tcrypt while testing from the kernel.
>>
>> So it looks like the proposed implementation is fine.
>>
>> BR
>>
>> Fabien
