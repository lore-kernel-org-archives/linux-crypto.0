From: n.balaji@gdatech.co.in
Subject: Asynchronous Crypto suppor for MPC8360E's Security Engine
Date: Tue, 19 Dec 2006 16:54:02 +0530 (IST)
Message-ID: <48805.202.144.30.226.1166527442.squirrel@mail.gdatech.co.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	n.balaji@gdatech.co.in
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.gdatech.co.in ([202.144.30.226]:48818 "EHLO gdatech.co.in"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752609AbWLSLTU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 19 Dec 2006 06:19:20 -0500
Received: from [192.168.0.2] (localhost.localdomain [127.0.0.1])
	by predator.gdatech.co.in (Postfix-out) with ESMTP id BB8C88780FE
	for <linux-crypto@vger.kernel.org>; Tue, 19 Dec 2006 03:19:18 -0800 (PST)
Received: from gdatech.co.in ([192.168.0.3])
	by [127.0.0.1] ([127.0.0.1]) (port 7027) (Abaca EPG outproxy filter 1.3.4.5154-maint13 $Rev: 5154 $)
	id r6cj031918-01-2
	for linux-crypto@vger.kernel.org; Tue, 19 Dec 2006 03:19:18 -0800
Received: from mail.gdatech.co.in (unknown [192.168.0.1])
	by predator.gdatech.co.in (Postfix-out) with ESMTP id 8D71B8780F6
	for <linux-crypto@vger.kernel.org>;
	Tue, 19 Dec 2006 03:19:18 -0800 (PST)
To: "David McCullough" <david_mccullough@au.securecomputing.com>
References: 
In-Reply-To: 
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,
  I am working on MPC8360E Security Engine. I have ported the Openswan
2.4.5(IPSec --KLIPS) with OCF to MPC8360E's Security Engine (Talitos).
Encryption and Decryption is working. But when I check the performance of
Talitos with netio benchmark Tool, IPSec S/W Algorithms is giving more
bandwidth than Talitos.
  I do not know that why Talitos is giving less bandwidth and any probelm
in Openswan or OCF or Talitos driver or Talitos H/W. Please give your
suggestions and if you have any link related to Talitos, send to me.

  Linux kernel version is 2.6.11.

  We tested the IPSec performance by netio tool. The output is

Without IPSec :
-------------
Packet size  1k bytes:  8735 KByte/s Tx,  11242 KByte/s Rx.
Packet size  2k bytes:  8723 KByte/s Tx,  11001 KByte/s Rx.
Packet size  4k bytes:  8730 KByte/s Tx,  10159 KByte/s Rx.
Packet size  8k bytes:  8762 KByte/s Tx,  10986 KByte/s Rx.
Packet size 16k bytes:  8725 KByte/s Tx,  10997 KByte/s Rx.
Packet size 32k bytes:  8725 KByte/s Tx,  11002 KByte/s Rx.

IPSec in S/W :
------------
Packet size  1k bytes:  884 KByte/s Tx,  1120 KByte/s Rx.
Packet size  2k bytes:  1234 KByte/s Tx,  1149 KByte/s Rx.
Packet size  4k bytes:  1209 KByte/s Tx,  1178 KByte/s Rx.
Packet size  8k bytes:  885 KByte/s Tx,  1155 KByte/s Rx.
Packet size 16k bytes:  1184 KByte/s Tx,  1197 KByte/s Rx.
Packet size 32k bytes:  1194 KByte/s Tx,  1206 KByte/s Rx.

IPSec in H/W :
-------------
Packet size  1k bytes:  55978 Byte/s Tx,  484 KByte/s Rx.
Packet size  2k bytes:  57685 Byte/s Tx,  577 KByte/s Rx.
Packet size  4k bytes:  57344 Byte/s Tx,  812 KByte/s Rx.
Packet size  8k bytes:  58709 Byte/s Tx,  438 KByte/s Rx.
Packet size 16k bytes:  60074 Byte/s Tx,  627 KByte/s Rx.
Packet size 32k bytes:  60072 Byte/s Tx,  575 KByte/s Rx.

 We sholud get more bandwidth when we test through IPSec H/W. But We are
getting less bandwidth compare to IPSec S/W.

 But When we transmit 32 MB size file through tftp, it is transmitted in
139.0 seconds in IPSec S/W. When we transmit the same file, it is
transmitted in 136.2 seconds.

 When we ping the system, we got the reply in 2ms in IPSec S/W and 1ms in
IPSec H/W.

-Thanks
 N.Balaji
