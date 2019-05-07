Return-Path: <SRS0=09OG=TH=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	T_DKIMWL_WL_HIGH,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51710C04AAD
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 16:14:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 24C732087F
	for <linux-crypto@archiver.kernel.org>; Tue,  7 May 2019 16:14:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="m9QH7Pj+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbfEGQNc (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 7 May 2019 12:13:32 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36396 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbfEGQNc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 7 May 2019 12:13:32 -0400
Received: by mail-pg1-f196.google.com with SMTP id 85so8550753pgc.3
        for <linux-crypto@vger.kernel.org>; Tue, 07 May 2019 09:13:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=G8Fv5OtINQpv7rQM6n3u/8e+E08Vz7aR23eSUbSIdaA=;
        b=m9QH7Pj+jWZ00plFaD34XJ4bXZX37XD/8YZSihND49nAlrV6HtJ88LaoUwJhJjW69T
         GQ9JRw4jaMO5skBMR6BvxHWfV9SMdXzx+BcrjzOy1LAodcaBMtpxqEiUZJbZ3HjUeErm
         l2nBytWD4PRqBDQj8o/EUasTGI5gnin1CorLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=G8Fv5OtINQpv7rQM6n3u/8e+E08Vz7aR23eSUbSIdaA=;
        b=EtvdjJV/ZjYXpM+TCIVYQTZm3tfY8Gq0glTTLS0YHOXwqQH5srXSSlZpdxRk+xTw5Q
         CV7XodbxCjqPfFp5DoRSDJTvWTn7HJ6A7qvsLzGSKg3eW302QfyyN6g9sJCNqxmqWH5r
         1DHH5g0cauLvUrgoCRwxOY7RNbvfvNZMpj4LSGfbMFOYWbun4o7d7biEa3Vqf7hzZe3G
         PolBWklZum3hjdawhUcyYSLTYimrRG5C4Gt4QTel03hvBbTbC093CnMoGdCZ8qnUs9xC
         X7jeaLC1hsxDFTr/Pc6B0JjpSB3XUt68UOeWJ0wRVtNZto6oGsGZ1stVAnVCm/T9Ffgo
         aKrw==
X-Gm-Message-State: APjAAAWJvm+NVS9iHMsE5bsCHGNVqhXbF+Vt6JF6EC2jNshX64YdVyla
        zvZaSlIoNaEMPZxDWYVi2g2PUg==
X-Google-Smtp-Source: APXvYqx5bxQhuDKx6yG8AtxVsxUDq4d1U+bTyokMD+jyXXBS5DOFMePdxHMknm1qdR/wfQsbWkW94w==
X-Received: by 2002:a63:d343:: with SMTP id u3mr40966454pgi.285.1557245611889;
        Tue, 07 May 2019 09:13:31 -0700 (PDT)
Received: from www.outflux.net (173-164-112-133-Oregon.hfc.comcastbusiness.net. [173.164.112.133])
        by smtp.gmail.com with ESMTPSA id u6sm19591747pfm.10.2019.05.07.09.13.30
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 07 May 2019 09:13:30 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Kees Cook <keescook@chromium.org>, Joao Moreira <jmoreira@suse.de>,
        Eric Biggers <ebiggers@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
Date:   Tue,  7 May 2019 09:13:14 -0700
Message-Id: <20190507161321.34611-1-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

It is possible to indirectly invoke functions with prototypes that do
not match those of the respectively used function pointers by using void
types or casts. This feature is frequently used as a way of relaxing
function invocation, making it possible that different data structures
are passed to different functions through the same pointer.

Despite the benefits, this can lead to a situation where functions with a
given prototype are invoked by pointers with a different prototype. This
is undesirable as it may prevent the use of heuristics such as prototype
matching-based Control-Flow Integrity, which can be used to prevent
ROP-based attacks.

One way of fixing this situation is through the use of inline helper
functions with prototypes that match the one in the respective invoking
pointer.

Given the above, the current efforts to improve the Linux security,
and the upcoming kernel support to compilers with CFI features, this
creates macros to be used to build the needed function definitions,
to be used in camellia, cast6, serpent, twofish, and aesni.

-Kees (and Joao)

v3:
- no longer RFC
- consolidate macros into glue_helper.h
- include aesni which was using casts as well
- remove XTS_TWEAK_CAST while we're at it

v2:
- update cast macros for clarity

v1:
- initial prototype

Joao Moreira (4):
  crypto: x86/crypto: Use new glue function macros
  crypto: x86/camellia: Use new glue function macros
  crypto: x86/twofish: Use new glue function macros
  crypto: x86/cast6: Use new glue function macros

Kees Cook (3):
  crypto: x86/glue_helper: Add static inline function glue macros
  crypto: x86/aesni: Use new glue function macros
  crypto: x86/glue_helper: Remove function prototype cast helpers

 arch/x86/crypto/aesni-intel_glue.c         | 31 ++++-----
 arch/x86/crypto/camellia_aesni_avx2_glue.c | 73 +++++++++-------------
 arch/x86/crypto/camellia_aesni_avx_glue.c  | 63 +++++++------------
 arch/x86/crypto/camellia_glue.c            | 21 +++----
 arch/x86/crypto/cast6_avx_glue.c           | 65 +++++++++----------
 arch/x86/crypto/serpent_avx2_glue.c        | 65 +++++++++----------
 arch/x86/crypto/serpent_avx_glue.c         | 58 ++++++-----------
 arch/x86/crypto/serpent_sse2_glue.c        | 27 +++++---
 arch/x86/crypto/twofish_avx_glue.c         | 71 ++++++++-------------
 arch/x86/crypto/twofish_glue_3way.c        | 28 ++++-----
 arch/x86/include/asm/crypto/camellia.h     | 64 ++++++-------------
 arch/x86/include/asm/crypto/glue_helper.h  | 34 ++++++++--
 arch/x86/include/asm/crypto/serpent-avx.h  | 28 ++++-----
 arch/x86/include/asm/crypto/twofish.h      | 22 ++++---
 include/crypto/xts.h                       |  2 -
 15 files changed, 283 insertions(+), 369 deletions(-)

-- 
2.17.1

