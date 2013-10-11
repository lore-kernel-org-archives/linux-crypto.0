From: "Lendacky, Thomas" <Thomas.Lendacky@amd.com>
Subject: Scatterwalk / scatterlist compatibility
Date: Fri, 11 Oct 2013 13:51:47 +0000
Message-ID: <986457BC66A4884EBFFDEFEBEB20F84C0A23A5F9@satlexdag03.amd.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
To: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:53063
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751665Ab3JKNvv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Fri, 11 Oct 2013 09:51:51 -0400
Received: from mail185-ch1 (localhost [127.0.0.1])	by
 mail185-ch1-R.bigfish.com (Postfix) with ESMTP id 84BC260053	for
 <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2013 13:51:50 +0000 (UTC)
Received: from CH1EHSMHS022.bigfish.com (snatpool1.int.messaging.microsoft.com
 [10.43.68.253])	by mail185-ch1.bigfish.com (Postfix) with ESMTP id
 C97E01E0075	for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2013 13:51:48
 +0000 (UTC)
Received: from satlvexedge01.amd.com (satlvexedge01.amd.com [10.177.96.28])
	(using TLSv1 with cipher AES128-SHA (128/128 bits))	(No client certificate
 requested)	by atltwp02.amd.com (Axway MailGate 5.2.1) with ESMTPS id
 2F4FED16013	for <linux-crypto@vger.kernel.org>; Fri, 11 Oct 2013 08:51:11
 -0500 (CDT)
Content-Language: en-US
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Should a scatterlist created using the scatterwalk APIs be compatible
with the standard scatterlist APIs?  Specifically when the
scatterwalk_crypto_chain function is used the chain indicator bit is
not set so a simple sg_nents call against the resulting scatterlist will
segfault.

Thanks,
Tom
