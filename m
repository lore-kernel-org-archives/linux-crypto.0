From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] crypto: engine - Handle the kthread worker using the new
 API
Date: Tue, 25 Oct 2016 11:43:18 +0800
Message-ID: <20161025034318.GH18685@gondor.apana.org.au>
References: <1476878070-12024-1-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "David S. Miller" <davem@davemloft.net>,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
To: Petr Mladek <pmladek@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476878070-12024-1-git-send-email-pmladek@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Wed, Oct 19, 2016 at 01:54:30PM +0200, Petr Mladek wrote:
> Use the new API to create and destroy the crypto engine kthread
> worker. The API hides some implementation details.
> 
> In particular, kthread_create_worker() allocates and initializes
> struct kthread_worker. It runs the kthread the right way
> and stores task_struct into the worker structure.
> 
> kthread_destroy_worker() flushes all pending works, stops
> the kthread and frees the structure.
> 
> This patch does not change the existing behavior except for
> dynamically allocating struct kthread_worker and storing
> only the pointer of this structure.
> 
> It is compile tested only because I did not find an easy
> way how to run the code. Well, it should be pretty safe
> given the nature of the change.
> 
> Signed-off-by: Petr Mladek <pmladek@suse.com>

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
