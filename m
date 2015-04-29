From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH crypto-2.6] lib: make memzero_explicit more robust against
 dead store elimination
Date: Wed, 29 Apr 2015 16:01:19 +0200
Message-ID: <5540E42F.70607@iogearbox.net>
References: <85dfdd23d98412a183546e2e7659a6a2bed1fca8.1430230786.git.daniel@iogearbox.net> <20150429130816.GA8526@zoho.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
	Theodore Ts'o <tytso@mit.edu>,
	Stephan Mueller <smueller@chronox.de>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	Mark Charlebois <charlebm@gmail.com>,
	Behan Webster <behanw@converseincode.com>
To: mancha security <mancha1@zoho.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from www62.your-server.de ([213.133.104.62]:50073 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966283AbbD2OB0 (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Apr 2015 10:01:26 -0400
In-Reply-To: <20150429130816.GA8526@zoho.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/29/2015 03:08 PM, mancha security wrote:
...
> By the way, has anyone been able to verify that __memory_barrier
> provides DSE protection under various optimizations? Unfortunately, I
> don't have ready access to ICC at the moment or I'd test it myself.

Never used icc, but it looks like it's free for open source projects;
I can give it a try, but in case you're faster than I am, feel free
to post results here.

 From what I see based on the code, i.e. after that buggy cleanup
commit ...

commit 73679e50820123ebdedc67ebcda4562d1d6e4aba
Author: Pranith Kumar <bobby.prani@gmail.com>
Date:   Tue Apr 15 12:05:22 2014 -0400

     compiler-intel.h: Remove duplicate definition

     barrier is already defined as __memory_barrier in compiler.h
     Remove this unnecessary redefinition.

     Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
     Link: http://lkml.kernel.org/r/CAJhHMCAnYPy0%2BqD-1KBnJPLt3XgAjdR12j%2BySSnPgmZcpbE7HQ@mail.gmail.com
     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>

... it looks like it's currently using the _same_ gcc inline asm
for the barrier on icc instead of what that commit intended to do.

So funny enough, we don't actually use __memory_barrier() at the
moment. ;)

Nonetheless, having a look might be good.
