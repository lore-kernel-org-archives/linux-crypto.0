From: Kim Phillips <kim.phillips@freescale.com>
Subject: Re: questions of crypto async api
Date: Fri, 5 Apr 2013 17:33:20 -0500
Message-ID: <20130405173320.bed824d33bb493e8f5015835@freescale.com>
References: <A83C99F8370D4D42BEB2D2B3153A6BBC23CDB94D@NASANEXD02C.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
To: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:20151
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1162912Ab3DEWg5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 5 Apr 2013 18:36:57 -0400
In-Reply-To: <A83C99F8370D4D42BEB2D2B3153A6BBC23CDB94D@NASANEXD02C.na.qualcomm.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 4 Apr 2013 14:38:41 +0000
"Hsieh, Che-Min" <cheminh@qti.qualcomm.com> wrote:

> If a driver supports multiple instances of HW crypto engines, the ord=
er of=A0the request completion from HW can be different from the order =
of requests submitted=A0to different HW.=A0 The 2nd request sent out to=
 the 2nd=A0HW instance may take shorter time to complete than the first=
 request=A0for different HW instance.=A0 Is the driver responsible for =
re-ordering the completion callout? Or the agents (such as IP protocol =
stack) are responsible for reordering? How does pcrypt do it?
>=20
> =A0Does it make sense for a transform to send multiple requests outst=
anding to async crypto api?

see:

http://comments.gmane.org/gmane.linux.kernel.cryptoapi/5350

> =A0Is scatterwalk_sg_next() preferred method over sg_next()?=A0 Why?

scatterwalk_* is the crypto subsystem's version of the function, so
yes.

> =A0sg_copy_to_buffer() and sg_copy_from_buffer() -> sg_copy_buffer()-=
>sg_copy_buffer() -> sg_miter_next()-> sg_next()
> Sometimes sg_copy_to_buffer() and sg_copy_from_buffer() in our driver=
 do not copy the whole list. We have to rewrite those functions by usin=
g scattewalk_sg_next() to walk down the list. Is this the correct behav=
ior?

sounds like you're on the right track, although buffers shouldn't be
being copied that often, if at all.

Kim
