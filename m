From: Eran Ben-Avi <eranpublic@yahoo.com>
Subject: Openswan 2.4.9 - tasklet or workqueue ?
Date: Mon, 27 Aug 2007 00:26:34 -0700 (PDT)
Message-ID: <717768.84893.qm@web62515.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from web62515.mail.re1.yahoo.com ([69.147.75.107]:35652 "HELO
	web62515.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751210AbXH0HdQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 27 Aug 2007 03:33:16 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

I tested IPSec(tunnel mode) routing performance between 2 GbE ports using packet generator(SMARTBIT)  on ARM 500MHz with latest OCF patched on Openswan2.4.9 and I noticed the callback functions are using workqueue.
Since RX was performed in NAPI mode with higher priority then TX (in workqueue), the callback function(in ipsec_ocf.c) was starved with zero routing.
The problem was solved after I switched to use tasklet instead of the workqueue.
Is there a room for updating next OCF release ?

Please advice.

Thanks,
Eran Ben-Avi


       
____________________________________________________________________________________
Be a better Heartthrob. Get better relationship answers from someone who knows. Yahoo! Answers - Check it out. 
http://answers.yahoo.com/dir/?link=list&sid=396545433
