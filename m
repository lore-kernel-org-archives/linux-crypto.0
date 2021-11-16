Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E93EC433EF
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:37:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFF2663265
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235401AbhKPLkq (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 06:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbhKPLj6 (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 06:39:58 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6C4C06121D;
        Tue, 16 Nov 2021 03:34:56 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id z1-20020a05600c220100b00337f97d2464so1598399wml.1;
        Tue, 16 Nov 2021 03:34:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=OKm72OBf2FpxYQCv0sB/f+DkBwoP27JOzZaWrwqWFj4=;
        b=O/F/kABNBuHmPwDVg3PSUcnyGVW0cz2m5CMF7/O0fU5kVCBz/Pc2vsnPc7st1wIkvi
         qm/BIGSYiHqg/a8h3TApXiQJtKqyRnhGAMz2NqqGMa1RNSSG7AlABr6JCbWvhn+24feX
         QB2cYDY8uS0FhJ9TMap+c22Atd5FC0rWlZiyvExu1o5SsCggyA2OXWUxFwIzxIVgK91H
         CWD5fs5EQP8Y8V4JtbZ/6JJ1fiAtsr5EQvuRaKmqHdlDcq0k5uYyPmYTy+ePGJCtInUl
         /EuI+FB2d0eVEl9y/zfmiaZ/ECbTUFeu8yv5Z6/SGri/mA0YHNyCLK3l/xyWjWsnNgrt
         q1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OKm72OBf2FpxYQCv0sB/f+DkBwoP27JOzZaWrwqWFj4=;
        b=njE1iCsLGh3aUr9zU1rizsK56D/3o+lf5sFTq+/FqBHhwvtHsDQKBsVPCnDHdbuLWr
         mpfFIBx1/Sz5csezA9haGLlJ8yV5Hnyr+146fE1b/zcpU+D28Ca+6VBbTws7vQVH+p3L
         ywrufyAyjdMtLwTSxcO8mIVxO4gNkGnJtp55Nq6TXCQHFKbzt+0dtJ3ADDpaRJlNG0Eb
         A0RD8njp7JFcDEreH1OgWXkFB/mM4S+cJO6DhzzeFZMYLkKnRWDtvItDqQGuqYqKadA9
         fsp3+t7oFtwdgizYP6fZ4iXA1fNKQR0LX63pDjqkPGjW3OGN0yCAwK4PbvmuTBLIvIqN
         zNZA==
X-Gm-Message-State: AOAM533ja6o6lF79N5Mk0TM65lxu5jmRRVSqOV3MRXax/TCMGmclPXek
        o6zYrkbVvCTY0RQnzGza25ZIAK1RgQ/jRhGQmKxNg23qJ7E=
X-Google-Smtp-Source: ABdhPJzgNg+P77+DN3iCvFUOuqEzCWsgayJFWiSc9f/BHCLia5o5ZFhffvy7YyrzIg41Li3heJK4wrVEoqSiRFGHjBw=
X-Received: by 2002:a7b:cf10:: with SMTP id l16mr69435166wmg.17.1637062494781;
 Tue, 16 Nov 2021 03:34:54 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Tue, 16 Nov 2021 19:34:43 +0800
Message-ID: <CACXcFmmZUggw8Ze7eoXhcvOtf8cWXJoS51MNwVmMGiK7ggCeOw@mail.gmail.com>
Subject: [PATCH 5/8] Replace memset() with memzero_explicit()
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace memset(address,0,bytes) which may be optimised
away with memzero_explicit(address,bytes) which resists
such optimisation

---
 crypto/shash.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/shash.c b/crypto/shash.c
index 0a0a50cb694f..f07d06f5da71 100644
--- a/crypto/shash.c
+++ b/crypto/shash.c
@@ -112,7 +112,7 @@ static int shash_update_unaligned(struct
shash_desc *desc, const u8 *data,

     memcpy(buf, data, unaligned_len);
     err = shash->update(desc, buf, unaligned_len);
-    memset(buf, 0, unaligned_len);
+    memzero_explicit(buf, unaligned_len);

     return err ?:
            shash->update(desc, data + unaligned_len, len - unaligned_len);
@@ -156,7 +156,7 @@ static int shash_final_unaligned(struct shash_desc
*desc, u8 *out)
     memcpy(out, buf, ds);

 out:
-    memset(buf, 0, ds);
+    memzero_explicit(buf, ds);
     return err;
 }

-- 
2.25.1
