Return-Path: <SRS0=CUNG=U2=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 204DFC48BD7
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 17:18:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E973520659
	for <linux-crypto@archiver.kernel.org>; Thu, 27 Jun 2019 17:18:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfF0RSy (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 27 Jun 2019 13:18:54 -0400
Received: from outgoing-auth-1.mit.edu ([18.9.28.11]:38464 "EHLO
        outgoing.mit.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726315AbfF0RSy (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 27 Jun 2019 13:18:54 -0400
Received: from callcc.thunk.org (guestnat-104-133-0-109.corp.google.com [104.133.0.109] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id x5RHIeeq021689
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jun 2019 13:18:41 -0400
Received: by callcc.thunk.org (Postfix, from userid 15806)
        id 687B842002E; Thu, 27 Jun 2019 13:18:40 -0400 (EDT)
Date:   Thu, 27 Jun 2019 13:18:40 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH] fscrypt: remove selection of CONFIG_CRYPTO_SHA256
Message-ID: <20190627171840.GB31445@mit.edu>
References: <20190620181505.225232-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620181505.225232-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

On Thu, Jun 20, 2019 at 11:15:05AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> fscrypt only uses SHA-256 for AES-128-CBC-ESSIV, which isn't the default
> and is only recommended on platforms that have hardware accelerated
> AES-CBC but not AES-XTS.  There's no link-time dependency, since SHA-256
> is requested via the crypto API on first use.
> 
> To reduce bloat, we should limit FS_ENCRYPTION to selecting the default
> algorithms only.  SHA-256 by itself isn't that much bloat, but it's
> being discussed to move ESSIV into a crypto API template, which would
> incidentally bring in other things like "authenc" support, which would
> all end up being built-in since FS_ENCRYPTION is now a bool.
> 
> For Adiantum encryption we already just document that users who want to
> use it have to enable CONFIG_CRYPTO_ADIANTUM themselves.  So, let's do
> the same for AES-128-CBC-ESSIV and CONFIG_CRYPTO_SHA256.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Theodore Ts'o <tytso@mit.edu>
