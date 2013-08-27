From: Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH] kernel/padata.c: Register hotcpu notifier after
 initialization
Date: Tue, 27 Aug 2013 11:30:41 +0200
Message-ID: <20130827093041.GD7660@secunet.com>
References: <1377256353-7979-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	herbert@gondor.apana.org.au, gang.chen@asianux.com
To: Richard Weinberger <richard@nod.at>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1377256353-7979-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Fri, Aug 23, 2013 at 01:12:33PM +0200, Richard Weinberger wrote:
> padata_cpu_callback() takes pinst->lock, to avoid taking
> an uninitialized lock, register the notifier after it's
> initialization.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Looks ok,

Acked-by: Steffen Klassert <steffen.klassert@secunet.com>
