From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: caam - properly set IV after {en,de}crypt
Date: Thu, 7 Sep 2017 10:12:56 +0000
Message-ID: <VI1PR0402MB3342196084129C22870CD18898940@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <20170602122446.2427-1-david@sigma-star.at>
 <20170628132710.97278-1-david@sigma-star.at>
 <VI1PR0401MB2591AE2CA996495656C797B398DD0@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <VI1PR0401MB2591C51C446CFA129B50022298D20@VI1PR0401MB2591.eurprd04.prod.outlook.com>
 <CAOtvUMfa66v6_MfasHRG8Qk9h81GMTnObuBSObBGcSL4QoOMDQ@mail.gmail.com>
 <VI1PR0402MB3342A3AB9EEC3B36A79F253698960@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <CAOtvUMc9PzdfifN7T3cgMemr6j3qxBb3KD_uXmHYAk0HuxUgRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: David Gstir <david@sigma-star.at>,
        Dan Douglass <dan.douglass@nxp.com>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "richard@sigma-star.at" <richard@sigma-star.at>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 9/6/2017 1:14 PM, Gilad Ben-Yossef wrote:=0A=
> On Tue, Sep 5, 2017 at 6:33 PM, Horia Geant=E3 <horia.geanta@nxp.com> wro=
te:=0A=
>> On 8/14/2017 10:59 AM, Gilad Ben-Yossef wrote:=0A=
>>> Hi,=0A=
>>>=0A=
>>> On Thu, Jun 29, 2017 at 1:19 PM, Horia Geant=E3 <horia.geanta@nxp.com> =
wrote:=0A=
>>>> On 6/28/2017 4:42 PM, Horia Geant=E3 wrote:=0A=
>>>>> On 6/28/2017 4:27 PM, David Gstir wrote:=0A=
>>>>>> Certain cipher modes like CTS expect the IV (req->info) of=0A=
>>>>>> ablkcipher_request (or equivalently req->iv of skcipher_request) to=
=0A=
>>>>>> contain the last ciphertext block when the {en,de}crypt operation is=
 done.=0A=
>>>>>> This is currently not the case for the CAAM driver which in turn bre=
aks=0A=
>>>>>> e.g. cts(cbc(aes)) when the CAAM driver is enabled.=0A=
>>>>>>=0A=
>>>>>> This patch fixes the CAAM driver to properly set the IV after the=0A=
>>>>>> {en,de}crypt operation of ablkcipher finishes.=0A=
>>>>>>=0A=
>>>>>> This issue was revealed by the changes in the SW CTS mode in commit=
=0A=
>>>>>> 0605c41cc53ca ("crypto: cts - Convert to skcipher")=0A=
>>>>>>=0A=
>>>>>> Cc: <stable@vger.kernel.org> # 4.8+=0A=
>>>>>> Signed-off-by: David Gstir <david@sigma-star.at>=0A=
>>>>> Reviewed-by: Horia Geant=E3 <horia.geanta@nxp.com>=0A=
>>>>>=0A=
>>>> Btw, instead of updating the IV in SW, CAAM engine could be programmed=
=0A=
>>>> to do it - by saving the Context Register of the AES accelerator.=0A=
>>>>=0A=
>>>> Unfortunately this would require changes in quite a few places: shared=
=0A=
>>>> descriptor, HW S/G generation logic, IV dma (un)mapping and maybe othe=
rs.=0A=
>>>>=0A=
>>>> So it's better to have this fix now (which, considering size, is=0A=
>>>> appropriate for -stable) and later, if needed, offload IV updating in =
HW.=0A=
>>>>=0A=
>>>=0A=
>>> My apologies for reviving this thread from the dead, but doesn't the pa=
tch fail=0A=
>>> for in-place decryption since we are copying from req->dst after=0A=
>>> the operation is done, and therefore it no longer contains the cipherte=
xt?=0A=
>>>=0A=
>> You are right, thanks! Will follow up with a fix.=0A=
>> Though cts(cbc(aes)) in particular is working, see below.=0A=
>>=0A=
>>> I'm asking since I ran into a similar issue in the ccree driver and tho=
ught=0A=
>>> to deploy a similar fix but could not convince myself why this works.=
=0A=
>>>=0A=
>> IIUC cts(cbc(aes)) in-place decryption (with cbc(aes) offloaded to CAAM=
=0A=
>> engine) works since SW implementation of cts, when performing the=0A=
>> ciphertext stealing phase in cts_cbc_decrypt() does not use req->iv, but=
=0A=
>> a previously value, saved before staring decryption in crypto_cts_decryp=
t():=0A=
>>=0A=
>> if (cbc_blocks <=3D 1)=0A=
>>         memcpy(space, req->iv, bsize);=0A=
>> else=0A=
>>         scatterwalk_map_and_copy(space, req->src, offset - 2 * bsize,=0A=
>>                                  bsize, 0);=0A=
>>=0A=
> =0A=
> Is that not a performance bug in software CTS than? I mean all those=0A=
> transformation=0A=
> drivers doing that extra copy and possibly malloc and free to save the=0A=
> data for the info=0A=
> and than have the CTS implementation ignore that and do its own memory co=
py?=0A=
> =0A=
AFAICT, in case cbc_blocks > 1 cts saves the second from last full=0A=
block, while underlying cbc subrequest saves the last full block.=0A=
=0A=
Horia=0A=
