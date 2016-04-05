From: Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] dt/bindings: Add bindings for hisilicon random number
 generator
Date: Tue, 5 Apr 2016 09:16:58 +0800
Message-ID: <5703120A.6040803@huawei.com>
References: <1459474664-11264-1-git-send-email-wangkefeng.wang@huawei.com>
 <20160404051549.GF17806@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	<linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, <xuwei5-C8/M+/jPZTeaMJb+Lgu22Q@public.gmane.org>,
	Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>,
	<linux-crypto-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	Herbert Xu <herbert-lOAM2aK0SrRLBo1qDEOMRrpzq4S04n8Q@public.gmane.org>,
	<guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160404051549.GF17806@rob-hp-laptop>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-crypto.vger.kernel.org



On 2016/4/4 13:15, Rob Herring wrote:
> On Fri, Apr 01, 2016 at 09:37:43AM +0800, Kefeng Wang wrote:
>> Document the devicetree bindings for the random number generator
>> found on Hisilicon Hip04 and Hip05 soc.
[...]
>> +
>> +Required properties:
>> +- compatible : Should be "hisilicon,hisi-rng"
> 
> hisi is a bit redundant with hisilicon and please define SoC specific 
> compatible strings.

Due to it exists in both Hip04/Hip05 soc(and maybe some other chips),
how about drop hisi-, just "hisilicon,rng".

Thanks

> 
>> +- reg : Offset and length of the register set of this block
>> +
>> +Example:
>> +
>> +rng@d1010000 {
>> +	compatible = "hisilicon,hisi-rng";
>> +	reg = <0xd1010000 0x100>;
>> +};
>> -- 
>> 1.7.12.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe devicetree" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> .
> 

--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
