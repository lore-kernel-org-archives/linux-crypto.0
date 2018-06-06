From: Ladvine D Almeida <Ladvine.DAlmeida@synopsys.com>
Subject: Re: [PATCH] md: dm-crypt: Add Inline Encryption support for dmcrypt
Date: Wed, 6 Jun 2018 10:04:14 +0000
Message-ID: <BD7FB879CC136E419544C8E2AE7B9C3020C5D6@IN01WEMBXA.internal.synopsys.com>
References: <e9120efc-1e25-79c8-6132-9062dd030539@synopsys.com>
 <7a510610-9133-39aa-6841-3925c532f3c0@gmail.com>
 <BD7FB879CC136E419544C8E2AE7B9C3020BB94@IN01WEMBXA.internal.synopsys.com>
 <20180601081642.GA25973@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Cc: Milan Broz <gmazyland@gmail.com>, Alasdair Kergon <agk@redhat.com>,
        "Mike Snitzer" <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Manjunath M Bettegowda <Manjunath.MB@synopsys.com>,
        Prabu Thangamuthu <Prabu.T@synopsys.com>,
        Tejas Joglekar <Tejas.Joglekar@synopsys.com>,
        device-mapper development <dm-devel@redhat.com>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
To: Christoph Hellwig <hch@infradead.org>,
        Ladvine D Almeida <Ladvine.DAlmeida@synopsys.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Friday 01 June 2018 09:16 AM, Christoph Hellwig wrote:=0A=
> On Wed, May 30, 2018 at 02:52:07PM +0000, Ladvine D Almeida wrote:=0A=
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
> Why isn't this all controlled by the ufs drivers, using helpers as=0A=
> required?=0A=
=0A=
The idea is to make use of the existing utilities like dmsetup to configure=
 the keys, mapping etc.=0A=
=0A=
>=0A=
> Also why do we even need this API over just implementing TCG=0A=
> Opal/Opalite on the device?=0A=
>=0A=
TCG Opal/Opalite is FDE solution. right?=0A=
=0A=
File Based Encryption is accomplished in the ext4/f2fs layer by invoking th=
e registered algorithms from LKCF.=0A=
=0A=
There is a scope for FBE, if the implementation is crypto API.=0A=
=0A=
=0A=
Regards,=0A=
=0A=
Ladvine=0A=
=0A=
