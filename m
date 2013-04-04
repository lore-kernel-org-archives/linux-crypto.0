From: "Hsieh, Che-Min" <cheminh@qti.qualcomm.com>
Subject: questions of crypto async api
Date: Thu, 4 Apr 2013 14:38:41 +0000
Message-ID: <A83C99F8370D4D42BEB2D2B3153A6BBC23CDB94D@NASANEXD02C.na.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:33784 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761973Ab3DDOir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 4 Apr 2013 10:38:47 -0400
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

If a driver supports multiple instances of HW crypto engines, the order=
 of=A0the request completion from HW can be different from the order of=
 requests submitted=A0to different HW.=A0 The 2nd request sent out to t=
he 2nd=A0HW instance may take shorter time to complete than the first r=
equest=A0for different HW instance.=A0 Is the driver responsible for re=
-ordering the completion callout? Or the agents (such as IP protocol st=
ack) are responsible for reordering? How does pcrypt do it?


=A0Does it make sense for a transform to send multiple requests outstan=
ding to async crypto api?


=A0Is scatterwalk_sg_next() preferred method over sg_next()?=A0 Why?
=A0sg_copy_to_buffer() and sg_copy_from_buffer() -> sg_copy_buffer()->s=
g_copy_buffer() -> sg_miter_next()-> sg_next()
Sometimes sg_copy_to_buffer() and sg_copy_from_buffer() in our driver d=
o not copy the whole list. We have to rewrite those functions by using =
scattewalk_sg_next() to walk down the list. Is this the correct behavio=
r?


Thanks.

Chemin
