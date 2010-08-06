From: David Howells <dhowells@redhat.com>
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and cryptomgr problem
Date: Fri, 06 Aug 2010 03:27:25 +0100
Message-ID: <14347.1281061645@redhat.com>
References: <20100806014057.GA22395@gondor.apana.org.au> <23662.1281056463@redhat.com> <20100806011706.GA21657@gondor.apana.org.au>
Cc: dhowells@redhat.com, torvalds@osdl.org, gregkh@suse.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Herbert Xu <herbert@gondor.hengli.com.au>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935156Ab0HFC1k (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
	Thu, 5 Aug 2010 22:27:40 -0400
In-Reply-To: <20100806014057.GA22395@gondor.apana.org.au>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Herbert Xu <herbert@gondor.hengli.com.au> wrote:

> This patch should do the trick:
> 
> commit 326a6346ffb5b19eb593530d9d3096d409e46f62
> Author: Herbert Xu <herbert@gondor.apana.org.au>
> Date:   Fri Aug 6 09:40:28 2010 +0800
> 
>     crypto: testmgr - Fix test disabling option

It does work.

David
