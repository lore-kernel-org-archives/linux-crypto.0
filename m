Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F30CCA473
	for <linux-crypto@archiver.kernel.org>; Wed, 15 Jun 2022 04:20:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238435AbiFOEUx (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 15 Jun 2022 00:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234067AbiFOEUx (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 15 Jun 2022 00:20:53 -0400
Received: from fornost.hmeau.com (helcar.hmeau.com [216.24.177.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB2374A918;
        Tue, 14 Jun 2022 21:20:50 -0700 (PDT)
Received: from gwarestrin.arnor.me.apana.org.au ([192.168.103.7])
        by fornost.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1o1KWJ-007C2q-Im; Wed, 15 Jun 2022 14:20:45 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Wed, 15 Jun 2022 12:20:43 +0800
Date:   Wed, 15 Jun 2022 12:20:43 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     David Howells <dhowells@redhat.com>
Cc:     Simo Sorce <simo@redhat.com>, Jarkko Sakkinen <jarkko@kernel.org>,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] certs: Add FIPS self-test for signature verification
Message-ID: <YqleGzRD4ax4msjL@gondor.apana.org.au>
References: <165515741424.1554877.9363755381201121213.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165515741424.1554877.9363755381201121213.stgit@warthog.procyon.org.uk>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Mon, Jun 13, 2022 at 10:56:54PM +0100, David Howells wrote:
> 
> Hi Herbert,
> 
> If you could look over this pair of patches?  The second patch adds a simple
> selftest to allow the signature verification code so that it can be FIPS
> compliant.  The first moves load_certificate_list() to the asymmetric key code
> to make this easier and renames it.

Hi David:

It looks OK to me.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
