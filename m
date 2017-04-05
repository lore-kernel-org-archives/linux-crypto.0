From: Laurentiu Tudor <laurentiu.tudor@nxp.com>
Subject: Re: [7/7] crypto: caam/qi - add ablkcipher and authenc algorithms
Date: Wed, 5 Apr 2017 11:49:24 +0000
Message-ID: <58E4D9C3.4070406@nxp.com>
References: <20170317100602.2837-8-horia.geanta@nxp.com>
 <87vaqkvk6c.fsf@concordia.ellerman.id.au> <58E39F90.6050408@nxp.com>
 <87lgrftbgl.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Dan Douglass <dan.douglass@nxp.com>,
 Cristian Stoica <cristian.stoica@nxp.com>,
 Claudiu Manoil <claudiu.manoil@nxp.com>,
 Alexandru Porosanu <alexandru.porosanu@nxp.com>,
 Vakul Garg <vakul.garg@nxp.com>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "David S.
 Miller" <davem@davemloft.net>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Michael Ellerman <mpe@ellerman.id.au>, =?utf-8?B?SG9yaWEgR2VhbnTEgw==?=
 <horia.geanta@nxp.com>, Herbert Xu <herbert@gondor.apana.org.au>, Scott Wood
 <oss@buserror.net>, Roy Pledge <roy.pledge@nxp.com>
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <87lgrftbgl.fsf@concordia.ellerman.id.au>
Content-Language: en-US
Content-ID: <B471335390D0E341B9E7C2DD27A81E6E@eurprd04.prod.outlook.com>
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



On 04/05/2017 01:06 PM, Michael Ellerman wrote:
> Laurentiu Tudor <laurentiu.tudor@nxp.com> writes:
>
>> Hi Michael,
>>
>> Just a couple of basic things to check:
>>    - was the dtb updated to the newest?
>
> Possibly not, it's an automated build/boot, I'll have to check what it
> does with the dtb.
>
>>    - is the qman node present? This should be easily visible in
>> /proc/device-tree/soc@ffe000000/qman@318000.
>
> No it's not there.
>
> That's running linux-next with:
>
> CONFIG_CRYPTO_DEV_FSL_CAAM_CRYPTO_API_QI=n
>
>
> Does that mean I didn't update the device tree?
>

I think so. Also, I just checked that the node is actually there by 
compiling p5020ds.dts and then decompiling the dtb.

---
Best Regards, Laurentiu
