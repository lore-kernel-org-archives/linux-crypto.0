From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH v2] kernel/padata.c: share code between CPU_ONLINE and
 CPU_DOWN_FAILED, same to CPU_DOWN_PREPARE and CPU_UP_CANCELED
Date: Fri, 23 Aug 2013 12:44:48 +0200
Message-ID: <20130823104448.GI26773@secunet.com>
References: <5212E5E4.8010408@asianux.com>
 <5212E61F.7010602@asianux.com>
 <20130822051122.GB26773@secunet.com>
 <5215A134.90607@asianux.com>
 <20130822060503.GC26773@secunet.com>
 <5215B319.3020908@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Chen Gang <gang.chen@asianux.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5215B319.3020908@asianux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Thu, Aug 22, 2013 at 02:43:37PM +0800, Chen Gang wrote:
> Share code between CPU_ONLINE and CPU_DOWN_FAILED, same to
> CPU_DOWN_PREPARE and CPU_UP_CANCELED.
> 
> It will fix 2 bugs:
> 
>   "not check the return value of __padata_remove_cpu() and __padata_add_cpu()".
>   "need add 'break' between CPU_UP_CANCELED and CPU_DOWN_FAILED".
> 
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

This looks ok to me, Herbert can you take this one?

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
