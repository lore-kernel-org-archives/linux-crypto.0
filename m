From: Rick Jones <rick.jones2@hpe.com>
Subject: Re: ipsec impact on performance
Date: Tue, 1 Dec 2015 10:17:42 -0800
Message-ID: <565DE446.2070609@hpe.com>
References: <20151201175953.GC21252@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
To: Sowmini Varadhan <sowmini.varadhan@oracle.com>,
	netdev@vger.kernel.org, linux-crypto@vger.kernel.org
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:50401 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932079AbbLASRp (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Tue, 1 Dec 2015 13:17:45 -0500
In-Reply-To: <20151201175953.GC21252@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 12/01/2015 09:59 AM, Sowmini Varadhan wrote:
> But these are all still relatively small things - tweaking them
> doesnt get me significantly past the 3 Gbps limit. Any suggestions
> on how to make this budge (or design criticism of the patch) would
> be welcome.

What do the perf profiles show?  Presumably, loss of TSO/GSO means an 
increase in the per-packet costs, but if the ipsec path significantly 
increases the per-byte costs...

Short of a perf profile, I suppose one way to probe for per-packet 
versus per-byte would be to up the MTU.  That should reduce the 
per-packet costs while keeping the per-byte roughly the same.

You could also compare the likes of a single-byte netperf TCP_RR test 
between ipsec enabled and not to get an idea of the basic path length 
differences without TSO/GSO/whatnot muddying the waters.

happy benchmarking,

rick jones
