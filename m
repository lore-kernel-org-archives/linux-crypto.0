From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: using 3des with ipsec transport mode
Date: Thu, 2 Jul 2015 15:53:00 +0200
Message-ID: <20150702135300.GG22958@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35310 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbbGBNxH (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Jul 2015 09:53:07 -0400
Received: from userv0021.oracle.com (userv0021.oracle.com [156.151.31.71])
	by userp1040.oracle.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id t62Dr6Ek017942
	(version=TLSv1 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-crypto@vger.kernel.org>; Thu, 2 Jul 2015 13:53:07 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
	by userv0021.oracle.com (8.13.8/8.13.8) with ESMTP id t62Dr6K8022107
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=FAIL)
	for <linux-crypto@vger.kernel.org>; Thu, 2 Jul 2015 13:53:06 GMT
Received: from abhmp0001.oracle.com (abhmp0001.oracle.com [141.146.116.7])
	by aserv0122.oracle.com (8.13.8/8.13.8) with ESMTP id t62Dr6xA004517
	for <linux-crypto@vger.kernel.org>; Thu, 2 Jul 2015 13:53:06 GMT
Content-Disposition: inline
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


I was trying to follow the example for IPsec transport mode at 
http://www.ipsec-howto.org/x304.html with a 4.1 kernel,
and I find that using 3des_cbc does not work - packets get dropped
at the receiver after decryption: e.g., for a ping, the decrypted 
packet has a mangled icmp header, and is dropped for a bad checksum
in icmp_rcv.

Odd thing here is that the icmp payload was never mangled
on my watch, and esp_input does correctly figure out the ULP of
the payload after decrypt, so there is some pattern to this.

Using blowfish instead of 3des works on 4.1, so I suspect the bug
is specific to the encrypt/decrypt method.

FWIW I tried the 3des instructions from ipsec-howto.org with 
2.6.39 kernels, and it still fails (but so did blowfish, so 
something got better along the way).

Has anyone else noticed this behavior for 3des?

--Sowmini
