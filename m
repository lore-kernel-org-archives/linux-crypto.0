From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] kernel/padata.c: always check the return value of
 __padata_remove_cpu() and __padata_add_cpu()
Date: Thu, 22 Aug 2013 07:11:22 +0200
Message-ID: <20130822051122.GB26773@secunet.com>
References: <5212E5E4.8010408@asianux.com>
 <5212E61F.7010602@asianux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
To: Chen Gang <gang.chen@asianux.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5212E61F.7010602@asianux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Aug 20, 2013 at 11:44:31AM +0800, Chen Gang wrote:
> 
> If this patch is correct, better to let CPU_ONLINE and CPU_DOWN_FAILED
> share the same code.
> 
> And do we need a comment "/* fall through */" between CPU_UP_CANCELED
> and CPU_DOWN_FAILED (or it is another bug, need a 'break' statement) ?
> 
> At last, also better to let CPU_DOWN_PREPARE and CPU_UP_CANCELED share
> the same code (if need a 'break'), or share the most of code (if "fall
> through").
> 

CPU_ONLINE and CPU_DOWN_FAILED can share the code. Same is true for
CPU_DOWN_PREPARE and CPU_UP_CANCELED.

Thanks!
