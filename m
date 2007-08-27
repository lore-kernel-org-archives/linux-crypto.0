From: Eran Ben-Avi <eranpublic@yahoo.com>
Subject: OCF for Openswan 2.4.9 - tasklet or workqueue ?
Date: Mon, 27 Aug 2007 15:12:45 -0700 (PDT)
Message-ID: <384203.83962.qm@web62514.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from web62514.mail.re1.yahoo.com ([69.147.75.106]:29823 "HELO
	web62514.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751971AbXH0WMu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Aug 2007 18:12:50 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

I tested IPSec(tunnel mode) routing performance between 2 GbE ports using packet generator(SMARTBIT)  on ARM 500MHz with latest OCF patched on Openswan2.4.9 and I noticed the callback functions are using workqueue.
Since RX was performed in NAPI mode with higher priority then TX (in workqueue), the callback function(in ipsec_ocf.c) was starved with zero routing.
The problem was solved after I switched to use tasklet instead of current workqueue.
Is there a room for updating next OCF release ?

Please advice.

Thanks,
Eran Ben-Avi


       
____________________________________________________________________________________
Be a better Heartthrob. Get better relationship answers from someone who knows. Yahoo! Answers - Check it out. 
http://answers.yahoo.com/dir/?link=list&sid=396545433





       
____________________________________________________________________________________
Building a website is a piece of cake. Yahoo! Small Business gives you all the tools to get online.
http://smallbusiness.yahoo.com/webhosting 
