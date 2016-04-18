From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] Re: Broken userspace crypto in linux-4.1.18
Date: Mon, 18 Apr 2016 10:02:30 +0800
Message-ID: <20160418020230.GA16179@gondor.apana.org.au>
References: <56C5A66E.5010905@whissi.de>
 <56C87929.8040304@whissi.de>
 <56C9E865.3050500@gmail.com>
 <56CD6AB6.7000801@suse.cz>
 <56CD6FD8.20004@gmail.com>
 <20160224171203.GE16597@kroah.com>
 <56D0361B.8040301@gmail.com>
 <56D080AA.7030307@oracle.com>
 <7210213c-7446-5181-c2b2-8d7aaa756a2a@whissi.de>
 <57141096.1000802@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Thomas D." <whissi@whissi.de>, Milan Broz <gmazyland@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>,
	Stephan Mueller <smueller@chronox.de>,
	Willy Tarreau <w@1wt.eu>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Ondrej Kozina <okozina@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57141096.1000802@oracle.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Sun, Apr 17, 2016 at 06:39:18PM -0400, Sasha Levin wrote:
>
> So I mixed stuff up here, I've received a backport that would fix this problem
> on 4.1, and applied it. However, I forgot about 3.18.
> 
> Would Milan's backport work on 3.18 as well (https://www.mail-archive.com/linux-crypto@vger.kernel.org/msg17949.html)?

It should work.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
