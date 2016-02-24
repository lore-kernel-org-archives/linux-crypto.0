From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] Re: Broken userspace crypto in linux-4.1.18
Date: Wed, 24 Feb 2016 09:54:48 +0100
Message-ID: <56CD6FD8.20004@gmail.com>
References: <56C47DF9.6030704@whissi.de> <20160217233353.GC31125@1wt.eu>
 <56C50725.6080408@whissi.de> <4580306.arupsYiYbb@positron.chronox.de>
 <56C591E7.5080808@suse.cz> <56C5A66E.5010905@whissi.de>
 <56C87929.8040304@whissi.de> <56C9E865.3050500@gmail.com>
 <56CD6AB6.7000801@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Willy Tarreau <w@1wt.eu>, Sasha Levin <sasha.levin@oracle.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Ondrej Kozina <okozina@redhat.com>
To: Jiri Slaby <jslaby@suse.cz>, "Thomas D." <whissi@whissi.de>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:37035 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbcBXIyv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Feb 2016 03:54:51 -0500
In-Reply-To: <56CD6AB6.7000801@suse.cz>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 02/24/2016 09:32 AM, Jiri Slaby wrote:
>> +	af_alg_release_parent(sk);
> 
> and this occurs to me like a double release?

yes, my copy&paste mistake.

Anyway, there should be also two more patches from series.

If it helps, I copied proper backport here (upstream commit is referenced in header)
https://mbroz.fedorapeople.org/tmp/4.1/

Older kernel probably need some more changes but I hope these should be trivial.

Thanks,
Milan
