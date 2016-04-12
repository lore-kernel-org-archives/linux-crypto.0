From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v2 1/2] dt/bindings: Add bindings for hisilicon random
 number generator
Date: Tue, 12 Apr 2016 08:54:16 -0500
Message-ID: <CAL_JsqJv57nX7a89OR8U1=m+MLQKJBCOeuORPWXwGRx_P9XXBQ@mail.gmail.com>
References: <1460017397-30996-1-git-send-email-wangkefeng.wang@huawei.com>
 <1460017397-30996-2-git-send-email-wangkefeng.wang@huawei.com>
 <20160411144306.GA24637@rob-hp-laptop> <570C4C52.4020902@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>,
	Wei Xu <xuwei5@hisilicon.com>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-crypto@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Hanjun Guo <guohanjun@huawei.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:43425 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932659AbcDLNyk (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Tue, 12 Apr 2016 09:54:40 -0400
In-Reply-To: <570C4C52.4020902@huawei.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Apr 11, 2016 at 8:16 PM, Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
>
>
> On 2016/4/11 22:43, Rob Herring wrote:
>> On Thu, Apr 07, 2016 at 04:23:16PM +0800, Kefeng Wang wrote:
>>> Document the devicetree bindings for the random number generator found
>>> on Hisilicon Hip04 and Hip05 soc.
>>>
>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>> ---
>>>  Documentation/devicetree/bindings/rng/hisi-rng.txt | 12 ++++++++++++
>>>  1 file changed, 12 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/rng/hisi-rng.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/rng/hisi-rng.txt b/Documentation/devicetree/bindings/rng/hisi-rng.txt
>>> new file mode 100644
>>> index 0000000..72efcc1
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/rng/hisi-rng.txt
>>> @@ -0,0 +1,12 @@
>>> +Hisilicon Random Number Generator
>>> +
>>> +Required properties:
>>> +- compatible : Should be "hisilicon,rng"
>>> +- reg : Offset and length of the register set of this block
>>> +
>>> +Example:
>>> +
>>> +rng@d1010000 {
>>> +    compatible = "hisilicon,rng";
>>
>> This still needs SoC specific compatible strings.
>
> It is used by Hip04/Hip05 at lease, but for new SoC, like Hip06, it maybe different,
> using single Soc prefix is not proper, how about hisilicon,rng-v1, or add two compatible
> hisilicon,hip04-rng and hisilicon,hip05-rng? What's your option?

It is perfectly fine to include hisilicon,hip04-rng string for hip05
and later if the block is the same. You should still have both strings
(the original and current SoC) in case there is some issue or
difference found.

Unless there is a real IP version defined, you should avoid made up
version numbers.

Rob
