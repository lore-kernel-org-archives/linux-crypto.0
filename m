From: Tarun Ahuja <tarun.ahuja@cavium.com>
Subject: RFC 4868 support for Linux IPsec stack
Date: Mon, 19 Jan 2009 11:27:44 -0800
Message-ID: <4974D430.9000504@cavium.com>
References: <alpine.LSU.2.00.0901172346500.14505@fbirervta.pbzchgretzou.qr> <20090118053713.GB23663@gondor.apana.org.au> <alpine.LSU.2.00.0901180910390.14063@fbirervta.pbzchgretzou.qr> <4974D343.3010302@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail3.caviumnetworks.com ([12.108.191.235]:56191 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbZAST1w (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 19 Jan 2009 14:27:52 -0500
In-Reply-To: <4974D343.3010302@cavium.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Does anybody know the status of support for RFC 4868 (SHA256/384/512 
with iv length of 16/24/32) to
Linux IPsec stack?sending mail as text I believe, as of kernel 2.6.28, 
only SHA256 is supported and that
too only 12 bytes for the icv (instead of 16).

-Tarun
