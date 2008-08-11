From: Jean-Christophe Dubois <jcd@tribudubois.net>
Subject: question on offloaded crypto engine for network device.
Date: Mon, 11 Aug 2008 22:42:42 +0200
Message-ID: <200808112242.43396.jcd@tribudubois.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from smtp8-g19.free.fr ([212.27.42.65]:38055 "EHLO smtp8-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbYHKUmr (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 11 Aug 2008 16:42:47 -0400
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by smtp8-g19.free.fr (Postfix) with ESMTP id A083132A7DB
	for <linux-crypto@vger.kernel.org>; Mon, 11 Aug 2008 22:42:45 +0200 (CEST)
Received: from lancelot.dubois.etowns.net (lns-bzn-51f-81-56-146-209.adsl.proxad.net [81.56.146.209])
	by smtp8-g19.free.fr (Postfix) with ESMTP id 86C1532A8AC
	for <linux-crypto@vger.kernel.org>; Mon, 11 Aug 2008 22:42:45 +0200 (CEST)
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi guys,

I am looking for some kind of reference implementation for a type of driver 
supporting a network device with built in crypto device.

Basically with this device you don't see the network device itself. You only 
see the crypto device. For example you would build an IPSEC packet with ESP 
header an put commands around it to instruct on what part to do crypting and 
on what part to do authentication. Then you send the packet to the device 
never to see it again (you will just be told when you can free the skbuff and 
other associated resources). The device will take the packet crypt/sign it 
and send it to the network.

Is there in the linux crypto framework the required hooks to support such kind 
of device? could you point me to the right direction?

Thanks

JC

