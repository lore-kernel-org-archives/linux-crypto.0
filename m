From: Eran Ben-Avi <eranpublic@yahoo.com>
Subject: OCF(20070727) cryptosoft errors with openssl 0.9.8e
Date: Wed, 29 Aug 2007 05:14:58 -0700 (PDT)
Message-ID: <163963.79179.qm@web62508.mail.re1.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from web62508.mail.re1.yahoo.com ([69.147.75.100]:33761 "HELO
	web62508.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756415AbXH2MO7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Aug 2007 08:14:59 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi,

Did anyone test latest OCF(20070727) with openssl 0.9.8e ?
I patched the OCF on kernel 2.6.23(rc) and ssl.patch on openssl 0.9.8e and got errors when tried to perform key decryption using cryptosoft driver.
I tested it with older OCF on older kernel(2.6.12.6) and it worked properly.


Thanks,
Eran Ben-Avi


       
____________________________________________________________________________________
Got a little couch potato? 
Check out fun summer activities for kids.
http://search.yahoo.com/search?fr=oni_on_mail&p=summer+activities+for+kids&cs=bz 
