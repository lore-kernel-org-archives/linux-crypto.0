From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v3 net-next 0/3] Add support for async socket operations
Date: Mon, 23 Mar 2015 16:42:21 -0400 (EDT)
Message-ID: <20150323.164221.1726829049738525120.davem@davemloft.net>
References: <20150319193118.11500.10463.stgit@tstruk-mobl1>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: linux-aio@kvack.org, herbert@gondor.apana.org.au,
	netdev@vger.kernel.org, ying.xue@windriver.com, bcrl@kvack.org,
	viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org, hch@lst.de,
	linux-crypto@vger.kernel.org
To: tadeusz.struk@intel.com
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([149.20.54.216]:58099 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbbCWUm1 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 23 Mar 2015 16:42:27 -0400
In-Reply-To: <20150319193118.11500.10463.stgit@tstruk-mobl1>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

From: Tadeusz Struk <tadeusz.struk@intel.com>
Date: Thu, 19 Mar 2015 12:31:19 -0700

> After the iocb parameter has been removed from sendmsg() and recvmsg() ops
> the socket layer, and the network stack no longer support async operations.
> This patch set adds support for asynchronous operations on sockets back.
> 
> Changes in v3:
> * As sugested by Al Viro instead of adding new functions aio_sendmsg
>   and aio_recvmsg, added a ptr to iocb into the kernel-side msghdr structure.
>   This way no change to aio.c is required.
> 
> Changes in v2:
> * removed redundant total_size param from aio_sendmsg and aio_recvmsg functions

Series applied to net-next.
