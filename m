From: Vasile Marii <vascim@yahoo.com>
Subject: Geode-CBC
Date: Fri, 16 May 2008 05:07:22 -0700 (PDT)
Message-ID: <258065.19866.qm@web31504.mail.mud.yahoo.com>
Reply-To: vascim@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from web31504.mail.mud.yahoo.com ([68.142.198.133]:32299 "HELO
	web31504.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753481AbYEPMOF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 16 May 2008 08:14:05 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

I asked some time ago a question regarding what happens while cripting cbc.
A'm returning bac because i couldn't understand and solve it.
I have a geode-aes  cripto device, working with a modified driver(meaning i just printk-ing the input data output data IV, and the key). The fact is that the values obtained from crypting operation(also captured on whire) are not corresponding to the data that must be obtained according to rfc(erlier i made som tests introducing the test vectors from rfc dirrectly to the input and the results where diffrent http://archive.netbsd.se/?ml=linux-crypto&a=2008-04&t=6899366) are not corresponding to those from tessting application. I know that geode works fine, but why the data dont' correspond to rfc? Where is the trick? There are more CBC versions?
---------------
Vasile Marii



      
