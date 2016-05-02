From: Jeffrey Walton <noloader@gmail.com>
Subject: Re: [PATCH 3/3] random: add interrupt callback to VMBus IRQ handler
Date: Mon, 2 May 2016 05:00:47 -0400
Message-ID: <CAH8yC8nFUm6-+AhYWCHiLCucCbcOu5Hba21tzAaonVyH6OZOAA@mail.gmail.com>
References: <1462170413-7164-1-git-send-email-tytso@mit.edu>
	<1462170413-7164-4-git-send-email-tytso@mit.edu>
Reply-To: noloader@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-kernel@vger.kernel.org,
	Stephan Mueller <smueller@chronox.de>,
	Herbert Xu <herbert@gondor.apana.org.au>, andi@firstfloor.org,
	Sandy Harris <sandyinchina@gmail.com>,
	cryptography@lakedaemon.net, jsd@av8n.com, hpa@zytor.com,
	linux-crypto@vger.kernel.org,
	Stephan Mueller <stephan.mueller@atsec.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:36431 "EHLO
	mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805AbcEBJAs (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Mon, 2 May 2016 05:00:48 -0400
In-Reply-To: <1462170413-7164-4-git-send-email-tytso@mit.edu>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, May 2, 2016 at 2:26 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> From: Stephan Mueller <smueller@chronox.de>
>
> The Hyper-V Linux Integration Services use the VMBus implementation for
> communication with the Hypervisor. VMBus registers its own interrupt
> handler that completely bypasses the common Linux interrupt handling.
> This implies that the interrupt entropy collector is not triggered.
> ...

Stephan correctly identified the problem of virtualized environments
in his paper, but there does not appear to be any real defenses in
place for VM rollback attacks.

Perhpas the following will make interesting reading:

* When Virtual is Harder than Real: Security Challenges in Virtual
Machine Based Computing Environments,
https://www.usenix.org/legacy/event/hotos05/final_papers/full_papers/garfinkel/garfinkel.pdf

* When Good Randomness Goes Bad: Virtual Machine Reset Vulnerabilities
and Hedging Deployed Cryptography,
http://pages.cs.wisc.edu/~rist/papers/sslhedge.pdf

Jeff
