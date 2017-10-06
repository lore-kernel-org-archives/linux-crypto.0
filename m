From: Fabien DESSENNE <fabien.dessenne@st.com>
Subject: Re: [PATCH v3 1/3] crypto: engine - permit to enqueue aead_request
Date: Fri, 6 Oct 2017 09:26:07 +0000
Message-ID: <9d89727b-f3cb-3322-6513-962e9df63ca8@st.com>
References: <1503047946-27799-1-git-send-email-fabien.dessenne@st.com>
 <1503047946-27799-2-git-send-email-fabien.dessenne@st.com>
 <20170922090921.GA15677@gondor.apana.org.au>
 <20206811-7075-5ca9-98cd-26a5709751fb@st.com>
 <20171005033925.GA31996@gondor.apana.org.au>
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
In-Reply-To: <20171005033925.GA31996@gondor.apana.org.au>
Content-Language: en-US
Content-ID: <C0B609ED5768BF43A409E2B1F4009EE6@st.com>
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

OK, I will send an initial version without the AEAD part.


On 05/10/17 05:39, Herbert Xu wrote:
> On Tue, Oct 03, 2017 at 07:48:08AM +0000, Fabien DESSENNE wrote:
>> It looks like there is no more activity around this "crypto_engine
>> interface clean up" task.
>> This unfortunately has been blocking the introduction of this new STM32
>> crypto driver for 3 months now.
>> Would it make sense to have this driver reviewed first, and then
>> reworked (I expect minor update here) when the interface update is ready?
> Hmm, is it possible to disable the AEAD part of the driver first?
>
> Cheers,
