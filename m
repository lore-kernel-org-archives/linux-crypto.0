From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH] arm64: dts: ls1012a: add crypto node
Date: Tue, 28 Mar 2017 07:19:43 +0000
Message-ID: <VI1PR0401MB259164F1B575677D65CB8F2E98320@VI1PR0401MB2591.eurprd04.prod.outlook.com>
References: <20170322122939.22117-1-horia.geanta@nxp.com>
 <20170324015606.GC30608@dragon>
 <DB4PR04MB0847D837CB2762D5094720CB983E0@DB4PR04MB0847.eurprd04.prod.outlook.com>
 <20170324073420.GM30608@dragon>
 <DB4PR04MB0847E3EE8F7FAC11DD85FAA8983E0@DB4PR04MB0847.eurprd04.prod.outlook.com>
 <20170324140320.GP30608@dragon>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Harninder Rai <harninder.rai@nxp.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Bhaskar U <bhaskar.upadhaya@nxp.com>,
        Will Deacon <will.deacon@arm.com>,
        Dan Douglass <dan.douglass@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org"
        <linux-arm-kernel@lists.infradead.org>
To: Shawn Guo <shawnguo@kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-ve1eur01on0058.outbound.protection.outlook.com ([104.47.1.58]:11712
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754313AbdC1HUJ (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 28 Mar 2017 03:20:09 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3/24/2017 4:04 PM, Shawn Guo wrote:=0A=
> On Fri, Mar 24, 2017 at 08:29:17AM +0000, Horia Geant=E3 wrote:=0A=
>> On 3/24/2017 9:35 AM, Shawn Guo wrote:=0A=
>>> On Fri, Mar 24, 2017 at 07:17:50AM +0000, Horia Geant=E3 wrote:=0A=
>>>>>> +		sec_mon: sec_mon@1e90000 {=0A=
>>>>>=0A=
>>>>> Hyphen is more preferred to be used in node name than underscore.=0A=
>>>>>=0A=
>>>> This would imply changing the=0A=
>>>> Documentation/devicetree/bindings/crypto/fsl-sec4.txt binding and=0A=
>>>> dealing with all the consequences, which IIUC is probably not worth.=
=0A=
>>>=0A=
>>> I do not care the bindings doc that much, since I'm not the maintainer=
=0A=
>>> of it.  What are the consequences specifically, if we use a better node=
=0A=
>>> name in dts than bindings example?=0A=
>>>=0A=
>> Users relying on finding the sec_mon node will obviously stop working.=
=0A=
>> I don't see any in-kernel users, however there could be others I am not=
=0A=
>> aware of and DT bindings should provide for backwards compatibility.=0A=
> =0A=
> Okay, point taken.  You can keep the node name as it is.=0A=
> =0A=
>> I could deprecate "sec_mon" in the bindings and suggest "sec-mon"=0A=
>> instead, while leaving all existing dts files as-is.=0A=
>> The risk is breaking LS1012A users relying on "sec_mon".=0A=
> =0A=
> For existing bindings, I do not care that much.  But for new ones, I do=
=0A=
> hope that we recommend to use hyphen, as that's more idiomatic at least=
=0A=
> for Linux kernel.=0A=
> =0A=
>> I see that ePAPR:=0A=
>> -allows both for hyphen and underline in case of node names=0A=
>> -allows only for hyphen (i.e. forbids underline) in case of alias nodes=
=0A=
>>=0A=
>> In the first case, I understand there's an (undocumented?) agreement to=
=0A=
>> prefer hyphen over underline.=0A=
> =0A=
> Both are valid, but hyphen is more idiomatic for Linux kernel.=0A=
> =0A=
>> For the 2nd one, does this mean I should change alias names?=0A=
> =0A=
> This is something I see difference between specification and DTC.=0A=
> =0A=
> 	aliases {=0A=
> 		alias-name =3D &label_name;=0A=
> 	};=0A=
> =0A=
> 	label_name: node-name {=0A=
> 		...=0A=
> 	};=0A=
> =0A=
> The spec says that only hyphen is valid for alias name, but DTC works=0A=
> happily with underscore too.  From my experience with DTC playing, both=
=0A=
> hyphen and underscore are valid for alias and node name.  But for label=
=0A=
> name, only underscore is valid.  Using hyphen in label name will cause=0A=
> DTC to report syntax error.=0A=
> =0A=
Yes indeed, thanks for pointing it out.=0A=
=0A=
For the sake of current patch, please clarify whether a v2 is needed.=0A=
IIUC:=0A=
-sec_mon node name could stay the same (existing binding)=0A=
-label names are ok, since underline is the only option allowed by DTC=0A=
-alias names are out-of-spec but accepted by DTC; if changing underline=0A=
to hyphen is requested, I will push out v2=0A=
=0A=
Thanks,=0A=
Horia=0A=
=0A=
