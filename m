From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] crypto: fix error flow of crypto/testmgr.c:test_comp()
Date: Tue, 25 Nov 2008 18:26:56 +0100
Message-ID: <492C3560.8030904@trash.net>
References: <20080421024306.GA6813@gondor.apana.org.au> <20080714121403.GA28523@gondor.apana.org.au> <20081010070918.GA28057@gondor.apana.org.au> <alpine.LFD.2.00.0810101118050.3503@nehalem.linux-foundation.org> <20081011021357.GB3685@gondor.apana.org.au> <20081125085820.GA11401@elte.hu> <20081125152014.GB29096@gondor.apana.org.au> <20081125171438.GK22504@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754636AbYKYR11@vger.kernel.org>
In-Reply-To: <20081125171438.GK22504@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Ingo Molnar wrote:
> btw, on a related note, there's a couple of networking related warning 
> fixes/annotations i've got queued up.
> 
> I've got 37 commits of that nature in the tip/warnings/* topic 
> branches:
> [...]
> 
> They are done mainly so that we can notice the warnings we introduce 
> via any of the -tip trees - but we analyze and look at all other types 
> of upstream kernel warnings as well.
> 
> I'll thus keep these commits indefinitely - but if someone from the 
> networking side would like to work with us to pick them up and 
> eventually nurse them upstream, that would be great!
> 
> One thing is not really feasible: there's just too many of them for me 
> to spend 10 minutes on each to submit them with a proper Cc:, etc. 
> (such overhead mounts up quickly if you do the numbers)
> 
> So i've attached them below as a dump of patches. If someone wants to 
> cherry-pick bits of them, they are also available in 
> tip/auto-warnings-next:
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git auto-warnings-next
> 
> Warning: some of them might be bad, so please double check the 
> analysis.

> commit c390a3784564c1fb2183e4a31ea39a9beb47d034
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Tue Nov 25 11:31:28 2008 +0100
> 
>     fix warning in net/netfilter/nf_conntrack_ftp.c

I've picked up this one in my nf-next-2.6.git tree.

> commit decc1656e870c9e5bd94f2357b8496b8da6c2e73
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Sat Oct 18 19:14:40 2008 +0200
> 
>     fix warning in net/netfilter/nf_conntrack_proto_sctp.c

This one is already fixed differently in my tree.

> commit b5a7c2b9e1a1b4d80da5d66b330545fdeafe1dad
> Author: Ingo Molnar <mingo@elte.hu>
> Date:   Fri Oct 17 19:48:51 2008 +0200
> 
>     fix warning in net/netfilter/nf_conntrack_proto_tcp.c 

I've also picked up this one.
