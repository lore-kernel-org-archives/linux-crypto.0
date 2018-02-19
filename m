From: =?windows-1258?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 16/18] crypto: talitos - do hw_context DMA mapping outside
 the requests
Date: Mon, 19 Feb 2018 08:30:49 +0000
Message-ID: <VI1PR0402MB334256E1706A4E1AED09F4A598C80@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
 <e47bf94ae44f23230b1647e31c9623f1075d3b79.1507284818.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB3342A0A8530F74D408CA2F0298FC0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <2338eb8d-a26a-9722-d667-5a9785b32977@c-s.fr>
 <VI1PR0402MB3342D90D574C8829701882BE98C90@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <630c313c-5eca-224d-a5ac-fb3f2783573a@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1258"
Content-Transfer-Encoding: quoted-printable
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Christophe LEROY <christophe.leroy@c-s.fr>, Herbert Xu
 <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>
Return-path: <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
Content-Language: en-US
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev/>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
 <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Errors-To: linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org
Sender: "Linuxppc-dev"
 <linuxppc-dev-bounces+glppe-linuxppc-embedded-2=m.gmane.org@lists.ozlabs.org>
List-Id: linux-crypto.vger.kernel.org

On 2/19/2018 9:58 AM, Christophe LEROY wrote:=0A=
> Le 18/02/2018 =E0 18:14, Horia Geant=E3 a =E9crit=A0:=0A=
>> There is no ahash_exit() callback mirroring ahash_init().=0A=
>>=0A=
>> The clean-up of request ctx should be done in the last states of the has=
h flows=0A=
>> described here:=0A=
>> https://www.kernel.org/doc/html/latest/crypto/devel-algos.html#cipher-de=
finition-with-struct-shash-alg-and-ahash-alg=0A=
>> for e.g. in the final() callback.=0A=
> =0A=
> Unfortunatly it seems that we can't rely on those finalising functions =
=0A=
> being called all the time.=0A=
> If you look into test_ahash_jiffies() for instance, in case of error the =
=0A=
> call of crypto_hash_final() is skipped.=0A=
=0A=
If test_ahash_jiffies() errors before calling crypto_ahash_final(req), this=
=0A=
means a previous callback failed.=0A=
Accordingly, DMA unmapping should be performed also on the corresponding er=
rors=0A=
paths in the driver.=0A=
=0A=
Horia=0A=
