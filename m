From: Daniel Borkmann <daniel@iogearbox.net>
Subject: Re: [PATCH crypto-2.6] lib: make memzero_explicit more robust against
 dead store elimination
Date: Wed, 29 Apr 2015 16:56:37 +0200
Message-ID: <5540F125.9090108@iogearbox.net>
References: <85dfdd23d98412a183546e2e7659a6a2bed1fca8.1430230786.git.daniel@iogearbox.net> <20150429130816.GA8526@zoho.com> <5540E42F.70607@iogearbox.net>
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
Received: from www62.your-server.de ([213.133.104.62]:54892 "EHLO
	www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423175AbbD2O4m (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Wed, 29 Apr 2015 10:56:42 -0400
In-Reply-To: <5540E42F.70607@iogearbox.net>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On 04/29/2015 04:01 PM, Daniel Borkmann wrote:
...
> So funny enough, we don't actually use __memory_barrier() at the
> moment. ;)

Anyway, I will send a v2 of the patch since we need to undef the gcc
definition in case someone really uses an ecc compiler that doesn't
support inline asm.

Thanks,
Daniel
