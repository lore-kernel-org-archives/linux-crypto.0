From: Ladvine D Almeida <Ladvine.DAlmeida@synopsys.com>
Subject: Re: [dm-devel] [PATCH] md: dm-crypt: Add Inline Encryption support
 for dmcrypt
Date: Mon, 4 Jun 2018 13:15:35 +0000
Message-ID: <BD7FB879CC136E419544C8E2AE7B9C3020C315@IN01WEMBXA.internal.synopsys.com>
References: <e9120efc-1e25-79c8-6132-9062dd030539@synopsys.com>
 <7a510610-9133-39aa-6841-3925c532f3c0@gmail.com>
 <BD7FB879CC136E419544C8E2AE7B9C3020BB94@IN01WEMBXA.internal.synopsys.com>
 <20180601144625.GA8111@zzz.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>,
        "Mike Snitzer" <snitzer@redhat.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        Manjunath M Bettegowda <Manjunath.MB@synopsys.com>,
        Tejas Joglekar <Tejas.Joglekar@synopsys.com>,
        Prabu Thangamuthu <Prabu.T@synopsys.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
To: Eric Biggers <ebiggers3@gmail.com>,
        Ladvine D Almeida <Ladvine.DAlmeida@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Friday 01 June 2018 03:46 PM, Eric Biggers wrote:=0A=
> Hi Ladvine,=0A=
>=0A=
> On Wed, May 30, 2018 at 02:52:07PM +0000, Ladvine D Almeida wrote:=0A=
>> On Monday 28 May 2018 05:33 PM, Milan Broz wrote:=0A=
>>> On 05/28/2018 03:01 PM, Ladvine D Almeida wrote:=0A=
>>>> This patch adds new option=0A=
>>>>     -- perform_inline_encrypt=0A=
>>>> that set the option inside dmcrypt to use inline encryption for=0A=
>>>> the configured mapping. I want to introduce inline encryption support=
=0A=
>>>> in the UFS Host Controller driver. The usage of the same for accomplis=
hing=0A=
>>>> the Full Disk Encryption is done by the following changes in the=0A=
>>>> dmcrypt subsystem:=0A=
>>>>     - New function crypt_inline_encrypt_submit() is added to the=0A=
>>>> dmcrypt which associate the crypto context to the bios which=0A=
>>>> are submitted by the subsystem.=0A=
>>>>     - Successful configuration for the inline encryption will result i=
n=0A=
>>>> the crypto transformation job being bypassed in the dmcrypt layer and =
the=0A=
>>>> actual encryption happens inline to the block device.=0A=
>>> I am not sure this is a good idea. Dm-crypt should never ever forward=
=0A=
>>> plaintext sector to underlying device.=0A=
>>>=0A=
>>> And you do not even check that your hw is available in the underlying d=
evice!=0A=
>>>=0A=
>>> If you want to use dm-crypt, write a crypto API driver for your crypto =
hw that defines=0A=
>>> specific cipher and let dm-crypt use this cipher (no patches needed in =
this case!)=0A=
>> Thanks for sharing your review.=0A=
>> I am sharing the links for the patches which are related to inline encry=
ption below:=0A=
>> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lkml.org_lkml_201=
8_5_28_1153&d=3DDwIBAg&c=3DDPL6_X_6JkXFx7AXWqB0tg&r=3Dz00zRD9ARrwHpe-XSl1Ot=
Up1uNKGYoXI1G2DhOaDDBI&m=3DqwfogRmPFyDoEzG0-jvbwxKzFR6CEey4rqhZlWnAyGg&s=3D=
McNQrXeM_-QGjnBJCyJklJ7cBXfcGHLy-JcMFHMq1z0&e=3D=0A=
>> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lkml.org_lkml_201=
8_5_28_1196&d=3DDwIBAg&c=3DDPL6_X_6JkXFx7AXWqB0tg&r=3Dz00zRD9ARrwHpe-XSl1Ot=
Up1uNKGYoXI1G2DhOaDDBI&m=3DqwfogRmPFyDoEzG0-jvbwxKzFR6CEey4rqhZlWnAyGg&s=3D=
t11MogIToXI_6PCllWgf1C16-dSOqNqMIv_T2EK4INw&e=3D=0A=
>> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lkml.org_lkml_201=
8_5_28_1158&d=3DDwIBAg&c=3DDPL6_X_6JkXFx7AXWqB0tg&r=3Dz00zRD9ARrwHpe-XSl1Ot=
Up1uNKGYoXI1G2DhOaDDBI&m=3DqwfogRmPFyDoEzG0-jvbwxKzFR6CEey4rqhZlWnAyGg&s=3D=
28i-jGwv-oAAIrSLGhoPppWb8XY1m32JYPsssF-LvdU&e=3D=0A=
>> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lkml.org_lkml_201=
8_5_28_1173&d=3DDwIBAg&c=3DDPL6_X_6JkXFx7AXWqB0tg&r=3Dz00zRD9ARrwHpe-XSl1Ot=
Up1uNKGYoXI1G2DhOaDDBI&m=3DqwfogRmPFyDoEzG0-jvbwxKzFR6CEey4rqhZlWnAyGg&s=3D=
1KRdmOB67zrJQDYGEAUBvdxBtYI6cPrueQ1PH6Io8g0&e=3D=0A=
>> https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lkml.org_lkml_201=
8_5_28_1178&d=3DDwIBAg&c=3DDPL6_X_6JkXFx7AXWqB0tg&r=3Dz00zRD9ARrwHpe-XSl1Ot=
Up1uNKGYoXI1G2DhOaDDBI&m=3DqwfogRmPFyDoEzG0-jvbwxKzFR6CEey4rqhZlWnAyGg&s=3D=
l4PRVW9Oo0QObWye_98AuxGSS3hLhdN5uMKCW-bJZkE&e=3D=0A=
>>=0A=
>> we have crypto API implementation for the hardware for  XTS algorithm, w=
hich will get registered when=0A=
>> the XTS algorithm capability of the inline encryption engine inside UFS =
Host Controller get detected by the UFS HC=0A=
>> driver. dm-crypt will be using this registered cipher.=0A=
>>  dm-crypt patch is unavoidable because the encrypt/decrypt function cann=
ot perform the transformation=0A=
>> when inline encryption engine is involved. Also, it demands forwarding t=
he plaintext sectors to the underlying=0A=
>> block device driver and  the crypto transformation happens internally in=
 controller when data transfer happens.=0A=
>>=0A=
> I appreciate that you're working on this, but can you please send the ful=
l=0A=
> series to the relevant mailing lists, so that everyone has the needed con=
text?=0A=
> Single random patches for this are basically impossible to review.  OFC t=
hat=0A=
> also means including a cover letter that explains the overall problem and=
 your=0A=
> solution.  In the Cc list I also recommend including the ext4 maintainer=
=0A=
> Theodore Ts'o <tytso@mit.edu>, who led a discussion at LSFMM 2017 about t=
his=0A=
> topic (https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__lwn.net_Art=
icles_717754_&d=3DDwIBAg&c=3DDPL6_X_6JkXFx7AXWqB0tg&r=3Dz00zRD9ARrwHpe-XSl1=
OtUp1uNKGYoXI1G2DhOaDDBI&m=3DqwfogRmPFyDoEzG0-jvbwxKzFR6CEey4rqhZlWnAyGg&s=
=3Dx52JiuXr2DWZDm9hObhTwe-He-2waTLXmz9E1Tmz7Y0&e=3D), and the f2fs maintain=
er Jaegeuk Kim=0A=
> <jaegeuk@kernel.org> who has had to deal with this stuff in an Android de=
vice=0A=
> kernel, but for another vendor's inline encryption hardware.=0A=
=0A=
Eric, Thanks for your suggestions. I will add the relevant persons in the c=
c list.=0A=
=0A=
The patches were generated in the below manner:=0A=
For block level changes:=0A=
https://patchwork.kernel.org/patch/10432255/=0A=
=0A=
For dmcrypt changes for Full Disk Encryption support:=0A=
https://lkml.org/lkml/2018/5/28/1027=0A=
=0A=
UFS Host Controller driver changes, patch-series for Inline Encryption supp=
ort:=0A=
https://lkml.org/lkml/2018/5/28/1187 -- cover letter=0A=
https://lkml.org/lkml/2018/5/28/1153=0A=
https://lkml.org/lkml/2018/5/28/1196=0A=
https://lkml.org/lkml/2018/5/28/1158=0A=
https://lkml.org/lkml/2018/5/28/1173=0A=
https://lkml.org/lkml/2018/5/28/1178=0A=
=0A=
=0A=
>   I assume your=0A=
> solution will work for other vendors too?  I think inline encryption is p=
art of=0A=
> the latest UFS specificaton now, so the latest hardware does it in a=0A=
> "standardized" way and doesn't require ad-hoc vendor-specific stuff --- r=
ight?=0A=
=0A=
Yes, correct. Implementation is done referring to Universal Flash Storage H=
ost Controller Interface(UFSHCI)=0A=
document Version 3.0. ** There is no vendor-specific implementation**.=0A=
> And do you have any plans for inline encryption support with fscrypt (ext=
4/f2fs=0A=
> encryption, a.k.a. what Android calls "File-Based Encryption")?  We need =
a=0A=
> design for inline encryption in the upstream kernel that is sufficiently =
general=0A=
> to work for all these vendors and use cases, not just specific ones.=0A=
=0A=
Support for the File Based Encryption requires modifications in the fs/cryp=
to in the=0A=
similar line as modifications in dmcrypt. But, one challenging thing could =
be algorithm=0A=
implementation is agnostic about the block device with which it is used.=0A=
Registered algorithm can be used by filesystem with block device that doesn=
't have inline encryption=0A=
capability. How to identify the same and do a fallback in this case?=0A=
=0A=
>=0A=
> Just at a quick glance, you also seem to be abusing the crypto API by exp=
osing=0A=
> inline encryption capabilities as a skcipher_alg.  With inline encryption=
 by=0A=
> definition you can't actually do encryption outside of a block device req=
uest;=0A=
> as a result, your patch has to use a fallback algorithm to do the actual=
=0A=
> encryption for the skcipher_alg, which makes no sense.  So it is not at a=
ll=0A=
> clear to me that you should use the crypto API at all, as opposed to havi=
ng it=0A=
> be purely a block layer thing.  (Please also Cc linux-crypto if you are d=
oing=0A=
> significant work related to the crypto API.)=0A=
=0A=
The idea behind registering this way is to support fallback incase the hard=
ware=0A=
misses the capability. eg:- when the inline encryption engine cannot perfor=
m=0A=
transformation using 384bits key for XTS algorithm, it could be accomplishe=
d now=0A=
using a fallback.=0A=
The normal flow for the inline encryption will not make use of the encrypt/=
decrypt=0A=
functions:=0A=
    - It use setkey function to identify the key configuration index(when t=
he hardware=0A=
        support multiple key slots) and to program the key.=0A=
    - the dm-crypt layer bypasses calling the encrypt/decrypt function and =
passes reference=0A=
       to the crypto information in each bio that is submitted by it.=0A=
The intention behind implementation as crypto API is to stick to LKCF so th=
at existing utilities=0A=
can be used.=0A=
=0A=
=0A=
>=0A=
>>> If I read the patch correctly, you do not check any parameters for=0A=
>>> compatibility with your hw support (cipher, mode, IV algorithm, key len=
gth, sector size ...)=0A=
>> I am registering an algorithm with cipher mode, IV size, block size, sup=
ported key size etc. for use by dm-crypt=0A=
>> as per the hardware capability of inline encryption engine.=0A=
>> If any other cipher mode, etc is used during the setup stage, DM-Crypt w=
ill work as normal.=0A=
>>=0A=
>>> It seems like if the "perform_inline_encrypt" option is present, you ju=
st submit=0A=
>>> the whole bio to your code with new INLINE_ENCRYPTION bit set.=0A=
>> when the optional argument "perform_inline_encrypt" is set, we are not u=
nconditionally sending the bio=0A=
>> to the block devices. The steps are explained below:=0A=
>> 1. user invokes the dm-setup command with the registered cipher "xts" an=
d with the optional argument=0A=
>> "perform_inline_encrypt".=0A=
>> 2. dm-setup invokes the setkey function of the newly introduced algorith=
m, which finds the available key slots=0A=
>> to be programmed(UFS Host controller Inline Encryption engine has multip=
le keyslots), program the key slot,=0A=
>> and return the key slot index as return value of the set key function.=
=0A=
>> 3. When read/write operation happens, crypt_map() function in dm-crypt v=
alidates whether there is associated=0A=
>> key configuration index for the request. The Bio will be submitted direc=
tly in this case only with the associated=0A=
>> crypto context.=0A=
>> 4. Block device driver, eg. UFS host controller driver will create the T=
ransfer requests as per this crypto context and=0A=
>> encryption happens inside the controller.=0A=
>>=0A=
>>> What happens, if the cipher in table is different from what your hw is =
doing?=0A=
>> In this case, the dm-crypt will work as previous. This is because the se=
tkey returns 0.=0A=
>> whenever there is key configuration index associated, setkey returns ind=
ex value(greater than 0). The bios are submitted=0A=
>> with that information to underlying block device drivers.=0A=
>> Also, care is taken to ensure that fallback will happen incase hardware =
lacks the support of any key lengths.=0A=
>>=0A=
>> Appreciate your suggestions/feedback. We are trying to bring modificatio=
ns into the subsystem to support controllers with=0A=
>> inline encryption capabilities and tried our best to take care of any vu=
lnerabilities or risks associated to same.=0A=
>> Inline encryption engines got huge advantage over the accelerators/softw=
are algorithms that it removes overhead associated=0A=
>> to current implementation like performing transformation on 512 byte chu=
nks, allocation of scatterlists etc.=0A=
> Thanks,=0A=
>=0A=
> Eric=0A=
>=0A=
=0A=
Best Regards,=0A=
=0A=
Ladvine=0A=
=0A=
