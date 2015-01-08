From: Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: [PATCH] lib: memzero_explicit: add comment for its usage
Date: Thu, 8 Jan 2015 21:49:02 +1100
Message-ID: <20150108104901.GC8374@gondor.apana.org.au>
References: <1420500465-6522-1-git-send-email-dborkman@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-crypto@vger.kernel.org
To: Daniel Borkmann <dborkman@redhat.com>
Return-path: <linux-crypto-owner@vger.kernel.org>
Received: from helcar.apana.org.au ([209.40.204.226]:41833 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756292AbbAHKtF (ORCPT
	<rfc822;linux-crypto@vger.kernel.org>);
	Thu, 8 Jan 2015 05:49:05 -0500
Content-Disposition: inline
In-Reply-To: <1420500465-6522-1-git-send-email-dborkman@redhat.com>
Sender: linux-crypto-owner@vger.kernel.org
List-ID: <linux-crypto.vger.kernel.org>

On Tue, Jan 06, 2015 at 12:27:45AM +0100, Daniel Borkmann wrote:
> Lets improve the comment to add a note on when to use memzero_explicit()
> for those not digging through the git logs. We don't want people to
> pollute places with memzero_explicit() where it's not really necessary.
> 
> Reference: https://lkml.org/lkml/2015/1/4/190
> Suggested-by: Herbert Xu <herbert@gondor.apana.org.au>
> Signed-off-by: Daniel Borkmann <dborkman@redhat.com>

Applied.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
