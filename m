From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH 16/18] crypto: talitos - do hw_context DMA mapping outside
 the requests
Date: Tue, 20 Feb 2018 11:32:25 +0000
Message-ID: <VI1PR0402MB3342B99A1BEA5622F29F79EF98CF0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
References: <cover.1507284818.git.christophe.leroy@c-s.fr>
 <e47bf94ae44f23230b1647e31c9623f1075d3b79.1507284818.git.christophe.leroy@c-s.fr>
 <VI1PR0402MB3342A0A8530F74D408CA2F0298FC0@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <2338eb8d-a26a-9722-d667-5a9785b32977@c-s.fr>
 <VI1PR0402MB3342D90D574C8829701882BE98C90@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <630c313c-5eca-224d-a5ac-fb3f2783573a@c-s.fr>
 <VI1PR0402MB334256E1706A4E1AED09F4A598C80@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <d5809df9-fc17-03da-b7f4-038d973dbd1f@c-s.fr>
 <VI1PR0402MB334299B37F17771BFA9AFDDA98C80@VI1PR0402MB3342.eurprd04.prod.outlook.com>
 <20180220103436.GA20571@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
 "David S. Miller" <davem@davemloft.net>,
 "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
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

On 2/20/2018 12:34 PM, Herbert Xu wrote:=0A=
> On Mon, Feb 19, 2018 at 01:16:30PM +0000, Horia Geant=E3 wrote:=0A=
>>=0A=
>>> And what about ALGIF path from user space ?=0A=
>>> What if the user never calls the last sendmsg() which will call =0A=
>>> hash_finup() ?=0A=
>>>=0A=
>> User is expected to follow the rules of the crypto API.=0A=
>> Of course, kernel won't (or at least shouldn't) crash in case of misuse.=
=0A=
>> However, in these cases some resources might not be freed - it's unavoid=
able.=0A=
> =0A=
> the crypto API does not require the presence of a finalisation.=0A=
> It is entirely optional.  So leaving resources pinned down until=0A=
> final/finup occurs is unacceptable, both from user-space and the=0A=
> kernel.=0A=
> =0A=
If final/finup is optional, how is the final hash supposed to be retrieved?=
=0A=
=0A=
According to documentation, these are the accepted flows (with the option t=
o=0A=
export/import a partial hash b/w update and final/finup):=0A=
=0A=
.init() -> .update() -> .final()=0A=
            ^    |         |=0A=
            '----'         '---> HASH=0A=
=0A=
.init() -> .update() -> .finup()=0A=
            ^    |         |=0A=
            '----'         '---> HASH=0A=
=0A=
           .digest()=0A=
               |=0A=
               '---------------> HASH=0A=
=0A=
Note that digest() is not an issue in the case we are discussing, since res=
ource=0A=
allocation happens only in init().=0A=
=0A=
Thanks,=0A=
Horia=0A=
