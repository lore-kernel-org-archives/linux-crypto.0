From: Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH] powerpc/crypto: Remove virt_to_abs() usage in nx-842.c
Date: Fri, 03 Aug 2012 12:32:54 +1000
Message-ID: <1343961174.20119.1.camel@concordia>
References: <1343960595-30232-1-git-send-email-michael@ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linuxppc-dev@ozlabs.org, sjenning@linux.vnet.ibm.com,
	linux-crypto@vger.kernel.org
To: herbert@gondor.apana.org.au
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from ozlabs.org ([203.10.76.45]:38341 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229Ab2HCCcw (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 2 Aug 2012 22:32:52 -0400
In-Reply-To: <1343960595-30232-1-git-send-email-michael@ellerman.id.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Herbert,

We're planning on removing virt_to_abs() from the powerpc tree this
cycle. So if you can take this patch in your tree everything should
continue building when the two trees merge.

cheers
