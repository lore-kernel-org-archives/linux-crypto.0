From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] Re: Broken userspace crypto in linux-4.1.18
Date: Mon, 18 Apr 2016 22:41:36 +0200
Message-ID: <57154680.7070304@gmail.com>
References: <56C5A66E.5010905@whissi.de> <56C87929.8040304@whissi.de>
 <56C9E865.3050500@gmail.com> <56CD6AB6.7000801@suse.cz>
 <56CD6FD8.20004@gmail.com> <20160224171203.GE16597@kroah.com>
 <56D0361B.8040301@gmail.com> <56D080AA.7030307@oracle.com>
 <7210213c-7446-5181-c2b2-8d7aaa756a2a@whissi.de>
 <57141096.1000802@oracle.com> <20160418020230.GA16179@gondor.apana.org.au>
 <8cf2e39f-003a-3af8-2666-bbaf43035995@whissi.de>
 <5714D917.7020006@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Greg KH <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>,
	Stephan Mueller <smueller@chronox.de>,
	Willy Tarreau <w@1wt.eu>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Ondrej Kozina <okozina@redhat.com>
To: Sasha Levin <sasha.levin@oracle.com>,
	"Thomas D." <whissi@whissi.de>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <5714D917.7020006@oracle.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 04/18/2016 02:54 PM, Sasha Levin wrote:
> On 04/18/2016 05:48 AM, Thomas D. wrote:
>> Hi,
>>
>> Milan's patches apply against 3.18.30, however I am getting build errors:
> 
> Milan, Herbert, should I just be reverting the offending patches:
> 
> bcfa841 crypto: af_alg - Forbid bind(2) when nokey child sockets are present
> eb1ab00 crypto: af_alg - Allow af_af_alg_release_parent to be called on nokey path
> 3db68eb crypto: af_alg - Add nokey compatibility path
> ac9c75f crypto: af_alg - Fix socket double-free when accept fails
> f857638 crypto: af_alg - Disallow bind/setkey/... after accept(2)
> 
> Or will you send me a backport?

Hi,

could you please try backported patches here
https://mbroz.fedorapeople.org/tmp/3.18/ ?

It should be the same backport as I sent for 4.1 here (just with some 3.18 socket specifics).
("cryptsetup benchmark" works again and that command uses this API.)

I think similar patches should be in 3.12 stable tree already.

Thanks,
Milan
