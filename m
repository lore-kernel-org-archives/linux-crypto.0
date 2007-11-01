From: Eran Ben-Avi <eranpublic@yahoo.com>
Subject: mtu/fragmentation problem with openswan 2.4.9
Date: Thu, 1 Nov 2007 07:25:34 -0700 (PDT)
Message-ID: <246126.71492.qm@web62511.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from web62511.mail.re1.yahoo.com ([69.147.75.103]:29597 "HELO
	web62511.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753490AbXKAOcP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Nov 2007 10:32:15 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

I encountered the following issue while working with openswan 2.4.9 on kernel 2.6.22.7:
When I established ipsec tunnel connection between my reference board(ARM) running openswan  Vs.  
windowsXP and tried to send file via ftp(PUT) from the board to  PC  I got the following error loop:
klips_error:ipsec_xmit_send: ip_send() failed, err=90 .
It seems like the ipsec0 device receives 1514 bytes packet from the ip stack and after adding the ipsec header it sends 1536 bytes which cross mtu boundery(1500) and therefore receive this error status from ip_fragment.
I tested the same scenario with openswan 2.4.2 on kernel 2.6.12.6 and after the first error it seems like the linux stack was able to recover (maybe by sending the ICMP from ip_fragment ???) .
I know I can prevent this problem by decreasing the ipsec0 mtu size to < ~1460b or to enable ip_no_pmtu_disc but it seems like bypassing the "real: problem.

Any suggestions ?

Thanks,
Eran Ben-Avi   




__________________________________________________
Do You Yahoo!?
Tired of spam?  Yahoo! Mail has the best spam protection around 
http://mail.yahoo.com 
