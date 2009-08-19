From: "CEVAN Ondrej" <Ondrej.CEVAN@frequentis.com>
Subject: Talitos input data format
Date: Wed, 19 Aug 2009 13:19:54 +0200
Message-ID: <085C99672E8EFD479528708F30B80A090366E629@VIECLEX01.frequentis.frq>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail1.frequentis.com ([212.186.194.131]:37474 "EHLO
	mail1.frequentis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbZHSLbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 19 Aug 2009 07:31:21 -0400
Content-class: urn:content-classes:message
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hello everybody,

according to the function call in drivers/crypto/talitos.c (Linux version
2.6.29) in function ipsec_esp():

/*hmac data*/
map_single_talitos_ptr(dev, &desc->ptr[1], sg_virt(areq->src) -
sg_virt(areq->assoc), sg_virt(areq->assoc), 0, DMA_TO_DEVICE);

if initialization vector (IV) should be included for HMAC computation, it
must be in the memory after the associated data (ASSOC) and after ASSOC and
IV the areq->src data must follow. Thus in memory it should look like: 
+---------+------+-------------------------+
|  ASSOC  |  IV  | DATA to encrypt/decrypt |
+---------+------+-------------------------+

Is my assumption right? Well my code is working but I want to ask you if it
is really a requirement that is hopefully somewhere specified. Where could I
find such information? My searching in Documentation dir and Google was
without success.  

Also, how does it work when I do not want to use ASSOC but still the IV
should be included in HMAC computation? Is it then intended that the pointer
areq->assoc points on the IV? Or am I not in the right ballpark?

Thanks a lot for your answer!

Ondrej


