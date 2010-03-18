From: Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [BUG] SLOB breaks Crypto
Date: Thu, 18 Mar 2010 18:30:54 +0200
Message-ID: <84144f021003180930s44e239dfmb38183096f07c8a8@mail.gmail.com>
References: <4B9E38AF.70309@fami-braun.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
	Matt Mackall <mpm@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>
To: michael-dev@fami-braun.de
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.159]:41705 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710Ab0CRRBo (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 18 Mar 2010 13:01:44 -0400
In-Reply-To: <4B9E38AF.70309@fami-braun.de>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Mon, Mar 15, 2010 at 3:39 PM,  <michael-dev@fami-braun.de> wrote:
> Hi,
>
> I've been trying to get Linux Kernel Crypto up&running
> on an AMD Geode LX board (Alix 2d2) but instantly
> experienced a huge amount of errors that look much like
> general memory corruption. Among them where NULL-pointer errors in
> net/core/dst.c, ath9k_skb_.*, net_skb.*, page table corruption,
> NULL-pointer errors in add_swap.* (with no swap installed at all) and
> many more. These errors could be trigger by loading tcrypt for any
> installed algorithm severeal times or by loading tcrypt without
> paramters or by compiling crypto statically into the kernel or by
> installing and loading cryptodev or ocf-linux.
>
> I've had the system configured with SLOB and all memory debugging
> enabled. All of these errors instantly disappeared when switching back
> to SLAB.

Even with CONFIG_DEBUG_SLAB enabled or with CONFIG_SLUB and
CONFIG_SLUB_DEBUG_ON?
