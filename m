From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] Re: Broken userspace crypto in linux-4.1.18
Date: Wed, 24 Feb 2016 09:12:03 -0800
Message-ID: <20160224171203.GE16597@kroah.com>
References: <56C47DF9.6030704@whissi.de>
 <20160217233353.GC31125@1wt.eu>
 <56C50725.6080408@whissi.de>
 <4580306.arupsYiYbb@positron.chronox.de>
 <56C591E7.5080808@suse.cz>
 <56C5A66E.5010905@whissi.de>
 <56C87929.8040304@whissi.de>
 <56C9E865.3050500@gmail.com>
 <56CD6AB6.7000801@suse.cz>
 <56CD6FD8.20004@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jiri Slaby <jslaby@suse.cz>, "Thomas D." <whissi@whissi.de>,
	Stephan Mueller <smueller@chronox.de>,
	Willy Tarreau <w@1wt.eu>, Sasha Levin <sasha.levin@oracle.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Ondrej Kozina <okozina@redhat.com>
To: Milan Broz <gmazyland@gmail.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44642 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758359AbcBXRME (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 24 Feb 2016 12:12:04 -0500
Content-Disposition: inline
In-Reply-To: <56CD6FD8.20004@gmail.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Wed, Feb 24, 2016 at 09:54:48AM +0100, Milan Broz wrote:
> On 02/24/2016 09:32 AM, Jiri Slaby wrote:
> >> +	af_alg_release_parent(sk);
> > 
> > and this occurs to me like a double release?
> 
> yes, my copy&paste mistake.

Which is why I want the real patches backported please.  Whenever we do
a "just this smaller patch" for a stable kernel, it is ALWAYS wrong.

Please backport the patches in a correct way so that we can apply
them...

thanks,

greg k-h
