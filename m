From: n.balaji@gdatech.co.in
Subject: Asynchronous Crypto suppor for MPC8360E's Security Engine
Date: Fri, 15 Dec 2006 13:02:41 +0530 (IST)
Message-ID: <35900.202.144.30.226.1166167961.squirrel@mail.gdatech.co.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	n.balaji@gdatech.co.in
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.gdatech.co.in ([202.144.30.226]:42387 "EHLO gdatech.co.in"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751247AbWLOHqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 15 Dec 2006 02:46:50 -0500
Received: from [192.168.0.2] (localhost.localdomain [127.0.0.1])
	by predator.gdatech.co.in (Postfix-out) with ESMTP id 68E238780CC
	for <linux-crypto@vger.kernel.org>; Thu, 14 Dec 2006 23:28:09 -0800 (PST)
Received: from gdatech.co.in ([192.168.0.3])
	by [127.0.0.1] ([127.0.0.1]) (port 7027) (Abaca EPG outproxy filter 1.3.4.5154-maint13 $Rev: 5154 $)
	id r6ce232809-01-2
	for linux-crypto@vger.kernel.org; Thu, 14 Dec 2006 23:28:09 -0800
Received: from mail.gdatech.co.in (unknown [192.168.0.1])
	by predator.gdatech.co.in (Postfix-out) with ESMTP id 1B3018780C8
	for <linux-crypto@vger.kernel.org>;
	Thu, 14 Dec 2006 23:28:09 -0800 (PST)
To: "David McCullough" <david_mccullough@au.securecomputing.com>
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

 I am not a member of the above mailing lists. Please send the mail to me.

-Thanks
 N.Balaji
