From: Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/17] Platform Facilities Option and crypto accelerator
 driver
Date: Mon, 26 Mar 2012 11:10:37 -0500
Message-ID: <1332778237.6578.3.camel@key-ThinkPad-W510>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
	 <C23F031B-1431-4E98-92DC-3EB7E31D2776@kernel.crashing.org>
	 <1332443286.3858.70.camel@key-ThinkPad-W510>
	 <06B7F1E7-951D-4753-BE00-7B0C84BACDAE@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	rcj@linux.vnet.ibm.com, benh@kernel.crashing.org,
	linuxppc-dev@lists.ozlabs.org
To: Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46371 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932798Ab2CZQJv (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Mon, 26 Mar 2012 12:09:51 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <key@linux.vnet.ibm.com>;
	Mon, 26 Mar 2012 12:09:50 -0400
In-Reply-To: <06B7F1E7-951D-4753-BE00-7B0C84BACDAE@kernel.crashing.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>


> 
> From what I can tell this isn't ISA level instructions and thus should NOT be in arch/powerpc.  This should be moved into drivers/crypto

  That makes sense.  I'll move them over in my next submission.

Kent

> - k
