From: Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Per-cpu tfm allocation/free functions
Date: Thu, 01 Dec 2011 11:01:00 -0600
Message-ID: <4ED7B2CC.3090209@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Dave Hansen <dave@linux.vnet.ibm.com>
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:48367 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755356Ab1LARBS (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 1 Dec 2011 12:01:18 -0500
Received: from /spool/local
	by e4.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <sjenning@linux.vnet.ibm.com>;
	Thu, 1 Dec 2011 12:01:17 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id pB1H13dZ3522812
	for <linux-crypto@vger.kernel.org>; Thu, 1 Dec 2011 12:01:04 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id pB1H13Bg031615
	for <linux-crypto@vger.kernel.org>; Thu, 1 Dec 2011 15:01:03 -0200
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

linux-crypto,

I am currently working on the zcache RAM compression driver (in the staging 
tree) and have a question.

I am looking to use the crypto compression API instead of the hardcoded LZO
calls that are in there right now, but I need to allocate a tfm per cpu per
compression algorithm being used.

I've already written the code but it looks very similar to what is already in
ipcomp_alloc/free_tfms() in net/xfrm/xfrm_ipcomp.c.

Has there ever been any talk about implementing functions like that inside
the cryptographic API in order to prevent duplicate per-cpu code by the users?

Would there be any interest/objections regarding a patch that did implement them? 

--
Seth
