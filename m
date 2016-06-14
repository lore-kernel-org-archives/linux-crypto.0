From: Neil Armstrong <narmstrong@baylibre.com>
Subject: Re: [PATCH v2 3/3] ARM64: dts: meson-gxbb: Add Hardware Random
 Generator node
Date: Tue, 14 Jun 2016 06:59:16 +0200
Message-ID: <575F8F24.5000803@baylibre.com>
References: <1465546915-24229-1-git-send-email-narmstrong@baylibre.com>
 <1465546915-24229-4-git-send-email-narmstrong@baylibre.com>
 <m2ziqoviz0.fsf@baylibre.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-amlogic@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org
To: Kevin Hilman <khilman@baylibre.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <m2ziqoviz0.fsf@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 06/14/2016 12:09 AM, Kevin Hilman wrote:
> Hi Neil,
> 
> Neil Armstrong <narmstrong@baylibre.com> writes:
> 
>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
>> ---
>>  arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
>> index 832815d..8353621 100644
>> --- a/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
>> +++ b/arch/arm64/boot/dts/amlogic/meson-gxbb.dtsi
>> @@ -167,6 +167,11 @@
>>  			};
>>  		};
>>  
>> +		rng {
>> +			compatible = "amlogic,meson-rng";
>> +			reg = <0x0 0xc8834000 0x0 0x4>;
>> +		};
> 
> This should be under the periphs bus, with an offset of 0x0 instead of
> at the top level.
> 
> See the for-next branch in the linux-amlogic tree[1] which has separate
> busses for periphs and hiu.

Yes, It was introduced lately.

Herbert,

I'll repost this patch separately to arm-soc directly rebased on [1].

Thanks,
Neil

> Kevin
> 
> [1] git://git.kernel.org/pub/scm/linux/kernel/git/khilman/linux-amlogic.git
> 
