From: PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>
Subject: Re: [PATCH v2 2/5] crypto: stm32 - Support for STM32 CRC32 crypto
 module
Date: Fri, 24 Mar 2017 15:30:56 +0530
Message-ID: <CANc+2y4pZ9TOijOea5bkV35D2R+JunLGrTsuN7s2fWWU_hPQjw@mail.gmail.com>
References: <1490109211-4869-1-git-send-email-fabien.dessenne@st.com>
 <1490109211-4869-3-git-send-email-fabien.dessenne@st.com>
 <CANc+2y4w=HhB230CD4MfxhvFZ2vM7Wsphz0zawhr0nVDSkREzQ@mail.gmail.com>
 <a6c05e57-bdcc-4396-4a72-4d1b2977b8e4@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Mark Rutland <mark.rutland@arm.com>,
 "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
 Alexandre TORGUE <alexandre.torgue@st.com>,
 Russell King <linux@armlinux.org.uk>, Rob Herring <robh+dt@kernel.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Benjamin GAIGNARD <benjamin.gaignard@st.com>,
 "David S . Miller" <davem@davemloft.net>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 Herbert Xu <herbert@gondor.apana.org.au>
To: Fabien DESSENNE <fabien.dessenne@st.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <a6c05e57-bdcc-4396-4a72-4d1b2977b8e4@st.com>
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

On 24 March 2017 at 15:26, Fabien DESSENNE <fabien.dessenne@st.com> wrote:
> On 24/03/17 05:28, PrasannaKumar Muralidharan wrote:
>> On 21 March 2017 at 20:43, Fabien Dessenne <fabien.dessenne@st.com> wrote:
>>> This module registers a CRC32 ("Ethernet") and a CRC32C (Castagnoli)
>>> algorithm that make use of the STMicroelectronics STM32 crypto hardware.
>>>
>>> Theses algorithms are compatible with the little-endian generic ones.
>>> Both algorithms use ~0 as default seed (key).
>>> With CRC32C the output is xored with ~0.
>>>
>>> Using TCRYPT CRC32C speed test, this shows up to 900% speedup compared
>>> to the crc32c-generic algorithm.
>> Comparing with crc3c-generic alogrithm does not sound like a good
>> metric for someone who has to decide between hw crypto or not.
>> Wouldn't it be better if the comparison is between crc32 using NEON
>> with hw crypto module? It will help in choosing between hw crypto or
>> arch optimised crc routiene.
>
> The STM32 microcontrollers are based on ARM Cortex-M7 (or older core)
> that do not have NEON support.

I was not aware of the absence of NEON support. Sorry for the noise.
