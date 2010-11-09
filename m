From: David Safford <safford@watson.ibm.com>
Subject: Re: [PATCH v1.2 3/4] keys: add new trusted key-type
Date: Tue, 09 Nov 2010 11:25:10 -0500
Message-ID: <1289319910.16976.52.camel@localhost.localdomain>
References: <1289230246-3856-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20101109064016.GF16307@obsidianresearch.com>
	 <1289315838.16976.38.camel@localhost.localdomain>
	 <201011091702.58449.roberto.sassu@polito.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
	Mimi Zohar <zohar@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
	linux-crypto@vger.kernel.org, David Howells <dhowells@redhat.com>,
	James Morris <jmorris@namei.org>,
	Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	Mimi Zohar <zohar@us.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from igw2.watson.ibm.com ([129.34.20.6]:57947 "EHLO
	igw2.watson.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0KIQcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 9 Nov 2010 11:32:08 -0500
In-Reply-To: <201011091702.58449.roberto.sassu@polito.it>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, 2010-11-09 at 17:02 +0100, Roberto Sassu wrote:

> i want to inform you i've created a set of utilities for the creation of
> trusted and encrypted keys which also works with the TrustedGRUB software:
> for instance the new "trk_create" tool generates or updates a trusted key
> passing the pcrinfo structure relative to the future configuration
> by performing the same extend operations done by TrustedGRUB during the
> boot process:
...
> I have tested these tools using the Fedora 13 operating system and they may be of interest
> if the TrustedGRUB part is not yet implemented by your tools. 
> 
> Roberto

My tools don't yet do the future boot pcr calculation,
so this is wonderful. Are they available?

dave
