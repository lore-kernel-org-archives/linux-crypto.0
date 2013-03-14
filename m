From: =?UTF-8?B?SG9yaWEgR2VhbnTEgw==?= <horia.geanta@freescale.com>
Subject: Re: authencesn compatibility problemn between software crypto and
 talitos driver
Date: Thu, 14 Mar 2013 12:21:20 +0200
Message-ID: <5141A4A0.1090105@freescale.com>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C583E5@RockMX01.rock.corp> <20130311071518.GD21448@secunet.com> <513F602A.9000201@freescale.com> <BD54DDEB2546894FAB0731EA7B0EDF8D07C58712@RockMX01.rock.corp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:28352 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756618Ab3CNKVe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 14 Mar 2013 06:21:34 -0400
In-Reply-To: <BD54DDEB2546894FAB0731EA7B0EDF8D07C58712@RockMX01.rock.corp>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 3/12/2013 10:57 PM, Chaoxing Lin wrote:
>
>> Seems that somehow I got confused, considering the "one/single-pass =
over data" description the same as "combined mode algorithm".
>> I will post a fix or revert the patch if HW does not allow the corre=
ct behaviour.
>
> Horia,
>
> Do you plan to fix talitos driver to make it ESN capable in the near =
future? Or just simply remove ESN option completely.

On-going discussion internally, since right now adding proper support=20
for ESN doesn't seem to be trivial, so right now I don't have an answer=
=2E

>
> The freescale crypto engine is still capable of doing AES-CBC + HMAC-=
SHAxxx in one shot.
> "DESC_HDR_TYPE_IPSEC_ESP" may not able to achieve authencesn.

Correct. And that's why I think reverting "crypto: talitos - add IPsec=20
ESN support" is the right thing to do.

> But the hmac-snoop-aes should do the job well.

You mean "hmac_snoop_no_afeu" (defined DESC_HDR_TYPE_HMAC_SNOOP_NO_AFEU=
=20
but not implemented...) ? I doubt this is the straightforward choice.

> 2 descriptors are needed.

Agree.

> The first one is to do AES-CBC,
> The second one snoop the output from the first crypto operation and t=
hen does HMAC-SHAxxx.
> The two descriptors are chained and pushed to crypto engine at the sa=
me time. Callback is triggered only when both operations are done.

 From the looks of it, both descriptors need to be of type=20
"DESC_HDR_TYPE_COMMON_NONSNOOP_NO_AFEU", first - ablkcipher - doing=20
aes(cbc), second - ahash - performing hmac(sha).

> Since you are from freescale, I assume you know what I am talking abo=
ut.

Try searching "AN3645 SEC 2/3x Descriptor Programmer=E2=80=99s Guide", =
the=20
application note contains more details than the reference manual I=20
assume you are using.
