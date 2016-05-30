From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH-v3 0/5] random: replace urandom pool with a CRNG
Date: Mon, 30 May 2016 16:59:31 -0400
Message-ID: <20160530205931.GI12629@thunk.org>
References: <1464586765-14436-1-git-send-email-tytso@mit.edu>
 <20160530175322.GB13997@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	smueller@chronox.de, herbert@gondor.apana.org.au,
	sandyinchina@gmail.com, cryptography@lakedaemon.net, jsd@av8n.com,
	hpa@zytor.com, linux-crypto@vger.kernel.org
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160530175322.GB13997@two.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Mon, May 30, 2016 at 10:53:22AM -0700, Andi Kleen wrote:
> 
> It should work the same on larger systems, the solution scales
> naturally to lots of sockets. It's not clear it'll help enough on systems
> with a lot more cores per socket, like a Xeon Phi. But for now it should
> be good enough.

One change which I'm currently making is to use kmalloc_node() instead
of kmalloc() for the per-NUMA node, and I suspect *that* is going
to make a quite a lot of different on those systems where the ratio of
remote to local memory access times is larger (as I assume it probably
would be on really big systems).

						- Ted
