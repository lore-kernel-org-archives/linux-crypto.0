From: Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 1/3] dt: Add DT bindings documentation for SUNXI Security
 System
Date: Sat, 24 May 2014 21:20:03 +0200
Message-ID: <5380F0E3.7020008@gmail.com>
References: <1400771396-9686-1-git-send-email-clabbe.montjoie@gmail.com> <1400771396-9686-2-git-send-email-clabbe.montjoie@gmail.com> <201405241321.32147.marex@denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org,
	linux@arm.linux.org.uk, herbert@gondor.apana.org.au,
	pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
	rdunlap@infradead.org, linux-kernel@vger.kernel.org,
	robh+dt@kernel.org, LABBE Corentin <clabbe.montjoie@gmail.com>,
	linux-crypto@vger.kernel.org, galak@codeaurora.org,
	grant.likely@linaro.org, maxime.ripard@free-electrons.com,
	davem@davemloft.net
To: Marek Vasut <marex@denx.de>, linux-arm-kernel@lists.infradead.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201405241321.32147.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Marek,

On 24.05.2014 13:21, Marek Vasut wrote:
> On Thursday, May 22, 2014 at 05:09:54 PM, LABBE Corentin wrote:
> 
> Missing commit message. Please fix this and send a V2.
> 
>> Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
>> ---
>>  Documentation/devicetree/bindings/crypto/sunxi-ss.txt | 9 +++++++++
>>  1 file changed, 9 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/crypto/sunxi-ss.txt
>>
>> diff --git a/Documentation/devicetree/bindings/crypto/sunxi-ss.txt
>> b/Documentation/devicetree/bindings/crypto/sunxi-ss.txt new file mode
>> 100644
>> index 0000000..356563b
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/crypto/sunxi-ss.txt
>> @@ -0,0 +1,9 @@
>> +* Allwinner Security System found on A20 SoC
>> +
>> +Required properties:
>> +- compatible : Should be "allwinner,sun7i-a20-crypto".
> 
> Why sun7i-a20 ? Is the crypto unit different in other sunxi chips ? Can that not 
> be described by DT props ?

A widely used convention is to define compatible strings after first
SoCs on which particular IP blocks appear. It is quite common among IP
blocks for which there is no well defined versioning scheme.

Best regards,
Tomasz
