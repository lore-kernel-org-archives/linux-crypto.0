From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH 4/8] random: remove unused branch in hot code path
Date: Tue, 17 Jan 2017 23:35:36 -0500
Message-ID: <20170118043536.aeqmxfthmx4h33g7@thunk.org>
References: <3254875.f5A5oHPdxF@positron.chronox.de>
 <3380804.uZWydldqLU@positron.chronox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3380804.uZWydldqLU@positron.chronox.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: linux-crypto.vger.kernel.org

On Tue, Dec 27, 2016 at 11:40:23PM +0100, Stephan Müller wrote:
> The variable ip is defined to be a __u64 which is always 8 bytes on any
> architecture. Thus, the check for sizeof(ip) > 4 will always be true.
> 
> As the check happens in a hot code path, remove the branch.

The fact that it's a hot code path means the compiler will optimize it
out, so the fact that it's on the hot code path is irrelevant.  The
main issue is that on platforms with a 32-bit IP's, ip >> 32 will
always be zero.  It might be that we can just do this via

#if BITS_PER_LONG == 32
  ...
#else
  ...  
#endif

I'm not sure that works for all platforms, though.  More research is
needed...

					- Ted
