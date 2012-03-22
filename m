From: Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [PATCH 00/17] Platform Facilities Option and crypto accelerator
 driver
Date: Thu, 22 Mar 2012 14:08:06 -0500
Message-ID: <1332443286.3858.70.camel@key-ThinkPad-W510>
References: <1332365297.3858.5.camel@key-ThinkPad-W510>
	 <C23F031B-1431-4E98-92DC-3EB7E31D2776@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	rcj@linux.vnet.ibm.com, benh@kernel.crashing.org,
	linuxppc-dev@lists.ozlabs.org
To: Kumar Gala <galak@kernel.crashing.org>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.149]:44305 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759307Ab2CVTH2 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 22 Mar 2012 15:07:28 -0400
Received: from /spool/local
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-crypto@vger.kernel.org> from <key@linux.vnet.ibm.com>;
	Thu, 22 Mar 2012 13:07:27 -0600
In-Reply-To: <C23F031B-1431-4E98-92DC-3EB7E31D2776@kernel.crashing.org>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi Kumar,

> Is there a reason this isn't in drivers/crypto/

  Other arch-specific dirs have their crypto subdir as well such as
arch/s390.  I was just matching that.

Kent

> - k
