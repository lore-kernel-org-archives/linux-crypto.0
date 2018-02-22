From: Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH Resend 0/5] hwrng: stm32 - Improvement for stm32-rng
Date: Thu, 22 Feb 2018 16:25:46 +0100
Message-ID: <8dcbcea1-78f7-27ff-66a0-a6180d32a05e@st.com>
References: <20180215130312.23612-1-lionel.debieve@st.com>
 <20180222140328.GE28447@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Cc: Rob Herring <rob.herring@linaro.org>,
 Benjamin Gaignard <benjamin.gaignard@st.com>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
 linux-crypto@vger.kernel.org, Maxime Coquelin <mcoquelin.stm32@gmail.com>,
 Matt Mackall <mpm@selenic.com>, Ludovic Barre <ludovic.barre@st.com>,
 linux-arm-kernel@lists.infradead.org
To: Herbert Xu <herbert@gondor.apana.org.au>, Lionel Debieve
 <lionel.debieve@st.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180222140328.GE28447@gondor.apana.org.au>
Content-Language: en-US
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

Hi

On 02/22/2018 03:03 PM, Herbert Xu wrote:
> On Thu, Feb 15, 2018 at 02:03:07PM +0100, Lionel Debieve wrote:
>> This set of patches add extended functionalities for stm32 rng
>> driver.
>> Patch #1 includes a reset during probe to avoid any error status
>> which can occur during bootup process and keep safe rng integrity.
>>
>> Patch #3 adds a new property to manage the clock error detection
>> feature which can be disabled on specific target.
>>
>> Patch #5 rework the timeout calculation for read value that was
>> previously defined based on loop operation and is now based on
>> timer.
> 
> I should take only patches 1/3/5, right?

You could take all (dt-bindings + drivers part).

regards
alex

> 
> Cheers,
> 
