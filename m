Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DCF8C433E9
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EB8B22482
	for <linux-crypto@archiver.kernel.org>; Wed, 23 Dec 2020 08:13:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727759AbgLWINf (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 23 Dec 2020 03:13:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:46662 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727712AbgLWINf (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 23 Dec 2020 03:13:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71C29224B1;
        Wed, 23 Dec 2020 08:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608711174;
        bh=fJvvlUbZ+ZnE9DMtGC+qGx+ypAakOfgJ3h5h3DOtI7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hgUab9ejMd6tw83BmVEpH9nAOzPXmcy8F0TTpIuvpXt6Rs1OPlxF9ohod1+6IwiKb
         kuwILck+wqZ+q9JQXBfXU0jbZ50SnR37eNRZZQNZIGy8+zYcMizxSiQLnCAId0Ev8/
         NDIJkaVaxgTUUelwONFQembbtifmEzwdZ56IDm+4JzQMsjCHUQlE0Q6F3tufB9eDw4
         3bX4MYkJtz29uVqdw35daOUX3mw6QTP2jj+HQMLNDNKkapuqLEUOY1W6xqNoYX/IhA
         Xy3MT0dFsvvK9xJf9pk15uoTvZWQKlFex8TJnuSEKljsqT3pW4/IhUkAVBF/7zPrmA
         bIIUCzg0W2xPg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-arm-kernel@lists.infradead.org,
        Ard Biesheuvel <ardb@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        David Sterba <dsterba@suse.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Paul Crowley <paulcrowley@google.com>
Subject: [PATCH v3 03/14] crypto: blake2s - remove unneeded includes
Date:   Wed, 23 Dec 2020 00:09:52 -0800
Message-Id: <20201223081003.373663-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201223081003.373663-1-ebiggers@kernel.org>
References: <20201223081003.373663-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

It doesn't make sense for the generic implementation of BLAKE2s to
include <crypto/internal/simd.h> and <linux/jump_label.h>, as these are
things that would only be useful in an architecture-specific
implementation.  Remove these unnecessary includes.

Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 crypto/blake2s_generic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/crypto/blake2s_generic.c b/crypto/blake2s_generic.c
index e3aa6e7ff3d83..b89536c3671cf 100644
--- a/crypto/blake2s_generic.c
+++ b/crypto/blake2s_generic.c
@@ -4,11 +4,9 @@
  */
 
 #include <crypto/internal/blake2s.h>
-#include <crypto/internal/simd.h>
 #include <crypto/internal/hash.h>
 
 #include <linux/types.h>
-#include <linux/jump_label.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 
-- 
2.29.2

