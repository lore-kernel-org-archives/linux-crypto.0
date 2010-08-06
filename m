From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: Initcall ordering problem (TTY vs modprobe vs MD5) and
	cryptomgr problem
Date: Fri, 6 Aug 2010 16:39:00 +0800
Message-ID: <20100806083900.GA25385@gondor.apana.org.au>
References: <20100806080642.GA4642@dspnet.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kyle@moffetthome.net, torvalds@linux-foundation.org,
	herbert@gondor.hengli.com.au, dhowells@redhat.com, gregkh@suse.de,
	linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
To: Olivier Galibert <galibert@pobox.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:59477 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755326Ab0HFIjZ (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Fri, 6 Aug 2010 04:39:25 -0400
Content-Disposition: inline
In-Reply-To: <20100806080642.GA4642@dspnet.fr>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

Olivier Galibert <galibert@pobox.com> wrote:
>
> Of course in practice without the tests your boot would probably just
> have failed.  Badly-decrypted root partitions tend to be noticed as
> such long before trying to write to them.  Then you would have bitched
> on the list and the driver would have been fixed or removed faster
> than having to wait for you (or other people with the hardware issue)
> to notice the spew in dmesg.

So you'd rather have a box that doesn't boot rather than one
that automatically falls back to software crypto allowing you
to diagnose and report the problem.

Yes that makes a lot of sense.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
