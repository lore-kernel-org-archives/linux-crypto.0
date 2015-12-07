From: Sowmini Varadhan <sowmini.varadhan@oracle.com>
Subject: Re: ipsec impact on performance
Date: Mon, 7 Dec 2015 06:27:48 -0500
Message-ID: <20151207112748.GB14535@oracle.com>
References: <20151201175953.GC21252@oracle.com>
 <20151202065305.GB14008@secunet.com>
 <20151202120538.GJ23178@oracle.com>
 <20151203084508.GD14008@secunet.com>
 <20151203113820.GX15262@oracle.com>
 <20151207084050.GH14008@secunet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, linux-crypto@vger.kernel.org
To: Steffen Klassert <steffen.klassert@secunet.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39802 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755075AbbLGL14 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 7 Dec 2015 06:27:56 -0500
Content-Disposition: inline
In-Reply-To: <20151207084050.GH14008@secunet.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On (12/07/15 09:40), Steffen Klassert wrote:
> 
> I've pushed it to
> 
> https://git.kernel.org/cgit/linux/kernel/git/klassert/linux-stk.git/log/?h=net-next-ipsec-offload
> 
> It is just example code, nothing that I would show usually.
> But you asked for it, so here is it :)

that's fine, I dont expect more at this point, just want to 
test-drive it, and see how it compares to my approach. 

thanks!

> The GRO part seems to work well, the GSO part is just a hack at the 
> moment.
