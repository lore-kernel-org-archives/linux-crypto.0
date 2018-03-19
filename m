From: =?iso-8859-2?Q?Horia_Geant=E3?= <horia.geanta@nxp.com>
Subject: Re: [PATCH] crypto: doc - clarify hash callbacks state machine
Date: Mon, 19 Mar 2018 06:39:50 +0000
Message-ID: <AM3PR04MB45284A83B66E00785872DE698D40@AM3PR04MB452.eurprd04.prod.outlook.com>
References: <20180305103945.3517-1-horia.geanta@nxp.com>
 <20180316151642.GA6606@gondor.apana.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
Cc: "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 3/16/2018 5:16 PM, Herbert Xu wrote:=0A=
> On Mon, Mar 05, 2018 at 12:39:45PM +0200, Horia Geant=E3 wrote:=0A=
>> Even though it doesn't make too much sense, it is perfectly legal to:=0A=
>> - call .init() and then (as many times) .update()=0A=
>> - subseqently _not_ call any of .final(), .finup() or .export()=0A=
> =0A=
> Actually it makes perfect sense, because there can be an arbitrary=0A=
> number of requests for a given tfm.  There is no requirement that=0A=
> you must finalise the first request before submitting new ones.=0A=
> =0A=
> IOW there can be an arbitrary number of outstanding requests even=0A=
> without the user intentionally abandoning any hash request.=0A=
> =0A=
The fact that there can be multiple requests in parallel (for a given tfm) =
is a=0A=
different topic.=0A=
Each request object has its state in its own state machine, independent fro=
m the=0A=
other request objects.=0A=
I assume this is clear enough.=0A=
=0A=
Why I wanted to underline is that "abandoning" a hash request is allowed (e=
ven=0A=
though doing this is at least questionable), thus implementations must take=
=0A=
special care not to leak resources in this case.=0A=
=0A=
If you think the commit message should be updated, then probably so should =
the=0A=
documentation update.=0A=
=0A=
Thanks,=0A=
Horia=0A=
