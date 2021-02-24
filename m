Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CD8C433E0
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:32:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D247A64EF1
	for <linux-crypto@archiver.kernel.org>; Wed, 24 Feb 2021 16:32:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbhBXQcP (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 24 Feb 2021 11:32:15 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:30598 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234633AbhBXQbG (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 24 Feb 2021 11:31:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614184178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=oHPOZACUKSG7YhdvvJWq0Sj5EssZNqse+Iw/jpiSFLU=;
        b=KfLspqnmJuwLl61xD9O5OMF4pvo5ub2DtnmgDFI+/tBhgQuQ6Lm/2hBRrRj/tqSJH6108M
        2Bs1P0Mg8gswES1CKdjJPiPpv3HVSqNLqa6u1nROEu5zHYsyLHA/42aVd22QyPjSSOIjm3
        hehbmMxZOkOr8LFGIf60ngFcUC5rdhA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-364-HBySC3erPXKM8pophtMdYQ-1; Wed, 24 Feb 2021 11:29:33 -0500
X-MC-Unique: HBySC3erPXKM8pophtMdYQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1BD2B803F62;
        Wed, 24 Feb 2021 16:29:32 +0000 (UTC)
Received: from treble.redhat.com (ovpn-118-134.rdu2.redhat.com [10.10.118.134])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0ED3760CDE;
        Wed, 24 Feb 2021 16:29:29 +0000 (UTC)
From:   Josh Poimboeuf <jpoimboe@redhat.com>
To:     x86@kernel.org, Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-kernel@vger.kernel.org, Miroslav Benes <mbenes@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>,
        Eric Biggers <ebiggers@google.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        linux-crypto@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH 00/13] x86/crypto/asm: objtool support
Date:   Wed, 24 Feb 2021 10:29:13 -0600
Message-Id: <cover.1614182415.git.jpoimboe@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Standardize the crypto asm to make it resemble compiler-generated code,
so that objtool can understand it.

This magically enables ORC unwinding from crypto code.  It also fixes
the last known remaining objtool warnings on vmlinux.o, for LTO and
more.

Josh Poimboeuf (13):
  objtool: Support asm jump tables
  x86/crypto/aesni-intel_avx: Remove unused macros
  x86/crypto/aesni-intel_avx: Fix register usage comments
  x86/crypto/aesni-intel_avx: Standardize stack alignment prologue
  x86/crypto/camellia-aesni-avx2: Unconditionally allocate stack buffer
  x86/crypto/crc32c-pcl-intel: Standardize jump table
  x86/crypto/sha_ni: Standardize stack alignment prologue
  x86/crypto/sha1_avx2: Standardize stack alignment prologue
  x86/crypto/sha256-avx2: Standardize stack alignment prologue
  x86/crypto/sha512-avx: Standardize stack alignment prologue
  x86/crypto/sha512-avx2: Standardize stack alignment prologue
  x86/crypto/sha512-ssse3: Standardize stack alignment prologue
  x86/crypto: Enable objtool in crypto code

 arch/x86/crypto/Makefile                     |  2 -
 arch/x86/crypto/aesni-intel_avx-x86_64.S     | 28 +++++--------
 arch/x86/crypto/camellia-aesni-avx2-asm_64.S |  5 +--
 arch/x86/crypto/crc32c-pcl-intel-asm_64.S    |  7 +---
 arch/x86/crypto/sha1_avx2_x86_64_asm.S       |  8 ++--
 arch/x86/crypto/sha1_ni_asm.S                |  8 ++--
 arch/x86/crypto/sha256-avx2-asm.S            | 13 +++---
 arch/x86/crypto/sha512-avx-asm.S             | 41 +++++++++----------
 arch/x86/crypto/sha512-avx2-asm.S            | 42 ++++++++++----------
 arch/x86/crypto/sha512-ssse3-asm.S           | 41 +++++++++----------
 tools/objtool/check.c                        | 14 ++++++-
 11 files changed, 98 insertions(+), 111 deletions(-)

-- 
2.29.2

