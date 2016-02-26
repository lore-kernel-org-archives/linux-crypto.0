From: Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH] Re: Broken userspace crypto in linux-4.1.18
Date: Fri, 26 Feb 2016 12:25:15 +0100
Message-ID: <56D0361B.8040301@gmail.com>
References: <56C47DF9.6030704@whissi.de> <20160217233353.GC31125@1wt.eu>
 <56C50725.6080408@whissi.de> <4580306.arupsYiYbb@positron.chronox.de>
 <56C591E7.5080808@suse.cz> <56C5A66E.5010905@whissi.de>
 <56C87929.8040304@whissi.de> <56C9E865.3050500@gmail.com>
 <56CD6AB6.7000801@suse.cz> <56CD6FD8.20004@gmail.com>
 <20160224171203.GE16597@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Cc: Jiri Slaby <jslaby@suse.cz>, "Thomas D." <whissi@whissi.de>,
	Stephan Mueller <smueller@chronox.de>,
	Willy Tarreau <w@1wt.eu>, Sasha Levin <sasha.levin@oracle.com>,
	"herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
	"dvyukov@google.com" <dvyukov@google.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	"linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	Ondrej Kozina <okozina@redhat.com>
To: Greg KH <gregkh@linuxfoundation.org>,
	Milan Broz <gmazyland@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20160224171203.GE16597@kroah.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 02/24/2016 06:12 PM, Greg KH wrote:
> On Wed, Feb 24, 2016 at 09:54:48AM +0100, Milan Broz wrote:
>> On 02/24/2016 09:32 AM, Jiri Slaby wrote:
>>>> +	af_alg_release_parent(sk);
>>>
>>> and this occurs to me like a double release?
>>
>> yes, my copy&paste mistake.
> 
> Which is why I want the real patches backported please.  Whenever we do
> a "just this smaller patch" for a stable kernel, it is ALWAYS wrong.

I think that it was clear that I do not want you to directly include
this patch, just it points to the direction where is the problem.

Anyway, seems the problem is only in 4.1.18.

> Please backport the patches in a correct way so that we can apply
> them...

Not sure if it is still needed, but I'll reply to this thread with my git version
of backported patches for 4.1.18.
(Resp. only the first need changes, other then applied cleanly from upstream).

Thanks,
Milan
