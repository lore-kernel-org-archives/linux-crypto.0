From: Joy Latten <latten@austin.ibm.com>
Subject: combined mode algorithms
Date: Mon, 25 Jun 2007 17:13:58 -0500
Message-ID: <1182809638.15699.221.camel@faith.austin.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37875 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198AbXFYWPT (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 25 Jun 2007 18:15:19 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id l5PMFJFS018367
	for <linux-crypto@vger.kernel.org>; Mon, 25 Jun 2007 18:15:19 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l5PMFJJS551704
	for <linux-crypto@vger.kernel.org>; Mon, 25 Jun 2007 18:15:19 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l5PMFJGL029675
	for <linux-crypto@vger.kernel.org>; Mon, 25 Jun 2007 18:15:19 -0400
Sender: linux-crypto-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

I have been reading IP Encapsulating Payload-(ESP) RFC4303 where use of
combined mode algorithms are mentioned and accommodated for. 
In trying to determine how I should handle this, I examined the
crypto code and could not readily recognize any combined mode
algorithms. Are there any current plans to implement combined mode
algorithms?  

Thanks!

Regards,
Joy
