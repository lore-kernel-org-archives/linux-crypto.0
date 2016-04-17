From: "Thomas D." <whissi@whissi.de>
Subject: Re: [PATCH] Re: Broken userspace crypto in linux-4.1.18
Date: Mon, 18 Apr 2016 00:17:21 +0200
Message-ID: <7210213c-7446-5181-c2b2-8d7aaa756a2a@whissi.de>
References: <56C47DF9.6030704@whissi.de> <20160217233353.GC31125@1wt.eu>
 <56C50725.6080408@whissi.de> <4580306.arupsYiYbb@positron.chronox.de>
 <56C591E7.5080808@suse.cz> <56C5A66E.5010905@whissi.de>
 <56C87929.8040304@whissi.de> <56C9E865.3050500@gmail.com>
 <56CD6AB6.7000801@suse.cz> <56CD6FD8.20004@gmail.com>
 <20160224171203.GE16597@kroah.com> <56D0361B.8040301@gmail.com>
 <56D080AA.7030307@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Milan Broz <gmazyland@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>,
	Stephan Mueller <smueller@chronox.de>,
	Willy Tarreau <w@1wt.eu>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Ondrej Kozina <okozina@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from yamato.tf-network.de ([93.186.202.221]:49996 "EHLO
	yamato.tf-network.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbcDQWWv (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Sun, 17 Apr 2016 18:22:51 -0400
In-Reply-To: <56D080AA.7030307@oracle.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Hi,

Sasha, can you please revert commit
f857638dd72680e2a8faafef7eebb4534cb39fd1 like Greg did with linux-3.10.101

> commit 1f2493fcd87bd810c608aa7976388157852eadb2
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Sat Mar 12 21:30:16 2016 -0800
> 
>     Revert: "crypto: af_alg - Disallow bind/setkey/... after accept(2)"
>     
>     This reverts commit 5a707f0972e1c9d8a4a921ddae79d0f9dc36a341 which is
>     commit c840ac6af3f8713a71b4d2363419145760bd6044 upstream.
>     
>     It's been widely reported that this patch breaks existing userspace
>     applications when backported to the stable kernel releases.  As no fix
>     seems to be forthcoming, just revert it to let systems work again.

and linux-3.14.65

> commit c4eb62da6f34bfa9bbcbd005210a90fdfca7e367
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Sat Mar 12 21:30:16 2016 -0800
> 
>     Revert: "crypto: af_alg - Disallow bind/setkey/... after accept(2)"
>     
>     This reverts commit 06b4194533ff92ed5888840e3a6beaf29a8fe5d4 which is
>     commit c840ac6af3f8713a71b4d2363419145760bd6044 upstream.
>     
>     It's been widely reported that this patch breaks existing userspace
>     applications when backported to the stable kernel releases.  As no fix
>     seems to be forthcoming, just revert it to let systems work again.


Linux-3.18.x is the only LTS kernel left with this problem. If nobody
cares we should at least revert back to a working kernel...


-Thomas
