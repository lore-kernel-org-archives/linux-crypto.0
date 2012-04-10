From: Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 14/17] powerpc: crypto: nx driver code supporting nx
 encryption
Date: Tue, 10 Apr 2012 13:53:27 -0500
Message-ID: <1334084007.16827.38.camel@key-ThinkPad-W510>
References: <1334070249.16827.1.camel@key-ThinkPad-W510>
	 <1334070657.16827.29.camel@key-ThinkPad-W510>
	 <20120410.144136.1777978593334560368.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	rcj@linux.vnet.ibm.com, benh@kernel.crashing.org,
	linuxppc-dev@lists.ozlabs.org
To: David Miller <davem@davemloft.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120410.144136.1777978593334560368.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

Hi Dave,

On Tue, 2012-04-10 at 14:41 -0400, David Miller wrote:
> From: Kent Yoder <key@linux.vnet.ibm.com>
> Date: Tue, 10 Apr 2012 10:10:57 -0500
> 
> > These routines add the base device driver code supporting the Power7+
> > in-Nest encryption accelerator (nx) device.
> > 
> > Signed-off-by: Kent Yoder <key@linux.vnet.ibm.com>
> 
> This patch should be earlier in the series, so it can
> appear before the drivers which use the helper routines
> in here.

  I wasn't sure which order to post these in since the structures I
register with the crypto api in this patch live in the earlier .c files,
so there's a circular dependency.  I can reorder if you want though.

Kent

> 
