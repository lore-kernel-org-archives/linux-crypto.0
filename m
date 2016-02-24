From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH] Re: Broken userspace crypto in linux-4.1.18
Date: Wed, 24 Feb 2016 09:32:54 +0100
Message-ID: <56CD6AB6.7000801@suse.cz>
References: <56C47DF9.6030704@whissi.de> <20160217233353.GC31125@1wt.eu>
 <56C50725.6080408@whissi.de> <4580306.arupsYiYbb@positron.chronox.de>
 <56C591E7.5080808@suse.cz> <56C5A66E.5010905@whissi.de>
 <56C87929.8040304@whissi.de> <56C9E865.3050500@gmail.com>
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
To: Milan Broz <gmazyland@gmail.com>, "Thomas D." <whissi@whissi.de>,
	Stephan Mueller <smueller@chronox.de>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <56C9E865.3050500@gmail.com>
Sender: stable-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On 02/21/2016, 05:40 PM, Milan Broz wrote:
> On 02/20/2016 03:33 PM, Thomas D. wrote:
>> Hi,
>>
>> FYI: v3.10.97, v3.14.61 and 3.18.27 are also affected.
>>
>> v4.3.6 works. Looks like the patch set is only compatible with >=linux-4.3.
>>
>> v3.12.54 works because it doesn't contain the patch in question.
> 
> Hi,
> 
> indeed, because whoever backported this patchset skipped two patches
> from series (because of skcipher interface file was introduced later).
> 
> I tried to backport it (on 4.1.18 tree, see patch below) and it fixes the problem
> for me.
> 
> Anyway, it is just quick test what is the problem, patch need proper review or
> backport from someone who knows the code better.
> 
> I will release stable cryptsetup soon that will work with new kernel even without
> this patch but I would strongly recommend that stable kernels get these compatibility
> backports as well to avoid breaking existing userspace.
> 
> Thanks,
> Milan
> -
> 
> This patch backports missing parts of crypto API compatibility changes:
> 
>   dd504589577d8e8e70f51f997ad487a4cb6c026f
>   crypto: algif_skcipher - Require setkey before accept(2)
> 
>   a0fa2d037129a9849918a92d91b79ed6c7bd2818
>   crypto: algif_skcipher - Add nokey compatibility path
> 
> --- crypto/algif_skcipher.c.orig	2016-02-21 16:44:27.172312990 +0100
> +++ crypto/algif_skcipher.c	2016-02-21 17:03:58.555785347 +0100
...
> @@ -790,24 +912,50 @@
>  	af_alg_release_parent(sk);

This,

>  }
>  
> -static int skcipher_accept_parent(void *private, struct sock *sk)
> +static void skcipher_sock_destruct(struct sock *sk)
> +{
> +	skcipher_sock_destruct_common(sk);
> +	af_alg_release_parent(sk);

this,

> +}
> +
> +static void skcipher_release_parent_nokey(struct sock *sk)
> +{
> +	struct alg_sock *ask = alg_sk(sk);
> +
> +	if (!ask->refcnt) {
> +		sock_put(ask->parent);
> +		return;
> +	}
> +
> +	af_alg_release_parent(sk);

and this occurs to me like a double release?

thanks,
-- 
js
suse labs
