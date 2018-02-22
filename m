From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 16/18] crypto: talitos - do hw_context DMA mapping outside
 the requests
Date: Thu, 22 Feb 2018 12:29:28 +0000
Message-ID: <AM0PR0402MB3329F899D4777EE356BBE2B698CD0@AM0PR0402MB3329.eurprd04.prod.outlook.com>
References: <e47bf94ae44f23230b1647e31c9623f1075d3b79.1507284818.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB3342A0A8530F74D408CA2F0298FC0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <2338eb8d-a26a-9722-d667-5a9785b32977@c-s.fr>
 <VI1PR0402MB3342D90D574C8829701882BE98C90@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <630c313c-5eca-224d-a5ac-fb3f2783573a@c-s.fr>
 <VI1PR0402MB334256E1706A4E1AED09F4A598C80@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <d5809df9-fc17-03da-b7f4-038d973dbd1f@c-s.fr>
 <VI1PR0402MB334299B37F17771BFA9AFDDA98C80@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20180220103436.GA20571@gondor.apana.org.au>
 <VI1PR0402MB3342B99A1BEA5622F29F79EF98CF0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20180222114741.GA27631@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "David S. Miller" <davem@davemloft.net>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>, Christophe LEROY
 <christophe.leroy@c-s.fr>
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

On 2/22/2018 1:47 PM, Herbert Xu wrote:=0A=
> On Tue, Feb 20, 2018 at 11:32:25AM +0000, Horia Geant=E3 wrote:=0A=
>>=0A=
>> If final/finup is optional, how is the final hash supposed to be retriev=
ed?=0A=
> =0A=
> Sometimes the computation ends with a partial hash, that's what=0A=
> export is for.  Also it is completely legal to abandon the hash=0A=
> state entirely.=0A=
> =0A=
Thanks for the explanation.=0A=
It's unintuitive to call .init() -> .update() and then not to call any of=
=0A=
.final(), .finup(), .export().=0A=
=0A=
Christophe,=0A=
=0A=
IIUC this means that there is no room for improvement.=0A=
This patch needs to be reverted, to restore previous behaviour when the=0A=
hw_context was mapped / unmapped for every request.=0A=
=0A=
Thanks,=0A=
Horia=0A=
