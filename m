From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 14/17] powerpc: crypto: nx driver code supporting nx
 encryption
Date: Tue, 10 Apr 2012 14:41:36 -0400 (EDT)
Message-ID: <20120410.144136.1777978593334560368.davem@davemloft.net>
References: <1334070249.16827.1.camel@key-ThinkPad-W510>
	<1334070657.16827.29.camel@key-ThinkPad-W510>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	rcj@linux.vnet.ibm.com, benh@kernel.crashing.org,
	linuxppc-dev@lists.ozlabs.org
To: key@linux.vnet.ibm.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([198.137.202.13]:46847 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758567Ab2DJSnr (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 10 Apr 2012 14:43:47 -0400
In-Reply-To: <1334070657.16827.29.camel@key-ThinkPad-W510>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Kent Yoder <key@linux.vnet.ibm.com>
Date: Tue, 10 Apr 2012 10:10:57 -0500

> These routines add the base device driver code supporting the Power7+
> in-Nest encryption accelerator (nx) device.
> 
> Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>

This patch should be earlier in the series, so it can
appear before the drivers which use the helper routines
in here.
