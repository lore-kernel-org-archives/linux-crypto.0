From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 2/2] keys: added cleanup code for trusted and encrypted
 key types
Date: Fri, 8 Oct 2010 08:38:17 +1100 (EST)
Message-ID: <alpine.LRH.2.00.1010080837350.27002@tundra.namei.org>
References: <201010071430.46281.roberto.sassu@polito.it> <1286485501.2809.9.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Roberto Sassu <roberto.sassu@polito.it>, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	David Safford <safford@watson.ibm.com>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	linux-security-module@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from tundra.namei.org ([65.99.196.166]:46479 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961Ab0JGVkj (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 7 Oct 2010 17:40:39 -0400
In-Reply-To: <1286485501.2809.9.camel@localhost.localdomain>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Thu, 7 Oct 2010, Mimi Zohar wrote:

> Thanks for catching this! This patch applies cleanly to the
> trusted/encrypted patch set posted today.
> 
> thanks,
> 
> Acked-by: Mimi Zohar <zohar@us.ibm.com>

It's probably best if you incorporate these fixes into your patches, so we 
don't commit known-broken code into the tree.

-- 
James Morris
<jmorris@namei.org>
