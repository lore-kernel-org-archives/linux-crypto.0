Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6C4C433FE
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:28:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6618E61360
	for <linux-crypto@archiver.kernel.org>; Tue, 16 Nov 2021 11:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234967AbhKPLby (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Tue, 16 Nov 2021 06:31:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235030AbhKPLbc (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Tue, 16 Nov 2021 06:31:32 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5701C061202;
        Tue, 16 Nov 2021 03:27:54 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id d72-20020a1c1d4b000000b00331140f3dc8so2118116wmd.1;
        Tue, 16 Nov 2021 03:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=vWgOKohvQ1jgRBXJgzAciLoS0Yy7GFRwvJIzGnozW3I=;
        b=i1BgAeNO/tOsTb8KAd2vhXRtX4E303K14B3V/34rANciSCktefSUex0sMNQAm1f4To
         VPvE2xSPiOIG67HlR7UE6BkUKkUvWlGa48Ti4Wl1syF48lsOr8skMdR+sKtjmKa0TOBE
         VcQnADecEsinktocIlx+qrPmNVC3N6nCZfkx/i1IIPdNqBwmIjTwsRXfF0vq1/u8NGz5
         jSTirGYqEUEVr0U+eZJBBDqndltIcnXBNyr6SFxS95JaecNLDO8YFGKZBSBqTQ0MOwF+
         /8n1WkDRCknE9uuoHqQwPtMQZ1XbH/YkDb1AAEOMR9bCedB3vpfW2flwdGjH0ONM1ixt
         gVAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=vWgOKohvQ1jgRBXJgzAciLoS0Yy7GFRwvJIzGnozW3I=;
        b=G2548SxBGI0gMETp0nNj6MxPn2hR4D0UpiGZ5rVtZiUM2FAKJ5WXQFe1zuV25d5WQz
         HEfQzKYMKv8qL7mwQko9qrOZUTKVw2jbu5OBBloAoNL/GIe/RvpzuSn2b1Mbd4fTeZj1
         l+W9o4/s46+Sjqj2z/3UhoqXK/5eep7+joAWi3WOOoNhKqQXoHFGuiSzQcDvzcskbVfY
         SrTms7kvF8FBb5QGoSbN6n3LZsuDyHt92fRjb40R10LL++AFlMedDvYsTcfrV8dwNLUd
         A6dZuP7h/VrLntZpsXIUOV8JzL23qIMomXddHd7VlsXjpwx3mlfeL7Br8ZLsVc/hZlRA
         K1Qw==
X-Gm-Message-State: AOAM532mtrh4RH4nesIyh7HtAilQ8rrQR/MUENw63nwtJkE4aC24n1Z3
        pgz93RfckWwhR5DLrGoiAMWE7hykzcQpL5+nbNtX+mlPWoM=
X-Google-Smtp-Source: ABdhPJyBWvBh4Y082LIMiso5r6ENmFOkrKKeIhWG2FaAVAUFGOMJlcUc34PbNoiCJ2YYaifii8INeV82KxFVp67pB1Q=
X-Received: by 2002:a05:600c:2246:: with SMTP id a6mr67603571wmm.5.1637062073422;
 Tue, 16 Nov 2021 03:27:53 -0800 (PST)
MIME-Version: 1.0
From:   Sandy Harris <sandyinchina@gmail.com>
Date:   Tue, 16 Nov 2021 19:27:41 +0800
Message-ID: <CACXcFmke4tekfof2x3jqW0zA1yC9cMKhwo2SrRG3vzC_CCot8Q@mail.gmail.com>
Subject: [PATCH 2/8] Replace memset() with memzero_explicit()
To:     LKML <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Replace memset(address,0,bytes) which may be optimised away
with memzero_explicit(address,bytes) which resists
such optimisation

---
 crypto/drbg.c | 25 ++++++++++++-------------
 1 file changed, 12 insertions(+), 13 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index f72f340a1321..08c4586a4cc9 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -507,9 +507,9 @@ static int drbg_ctr_df(struct drbg_state *drbg,
     ret = 0;

 out:
-    memset(iv, 0, drbg_blocklen(drbg));
-    memset(temp, 0, drbg_statelen(drbg) + drbg_blocklen(drbg));
-    memset(pad, 0, drbg_blocklen(drbg));
+    memzero_explicit(iv, drbg_blocklen(drbg));
+    memzero_explicit(temp, drbg_statelen(drbg) + drbg_blocklen(drbg));
+    memzero_explicit(pad, drbg_blocklen(drbg));
     return ret;
 }

@@ -580,9 +580,9 @@ static int drbg_ctr_update(struct drbg_state
*drbg, struct list_head *seed,
     ret = 0;

 out:
-    memset(temp, 0, drbg_statelen(drbg) + drbg_blocklen(drbg));
+    memzero_explicit(temp, drbg_statelen(drbg) + drbg_blocklen(drbg));
     if (2 != reseed)
-        memset(df_data, 0, drbg_statelen(drbg));
+        memzero_explicit(df_data, drbg_statelen(drbg));
     return ret;
 }

@@ -852,7 +852,7 @@ static int drbg_hash_df(struct drbg_state *drbg,
     }

 out:
-    memset(tmp, 0, drbg_blocklen(drbg));
+    memzero_explicit(tmp, drbg_blocklen(drbg));
     return ret;
 }

@@ -895,7 +895,7 @@ static int drbg_hash_update(struct drbg_state
*drbg, struct list_head *seed,
     ret = drbg_hash_df(drbg, drbg->C, drbg_statelen(drbg), &datalist2);

 out:
-    memset(drbg->scratchpad, 0, drbg_statelen(drbg));
+    memzero_explicit(drbg->scratchpad, drbg_statelen(drbg));
     return ret;
 }

@@ -927,7 +927,7 @@ static int drbg_hash_process_addtl(struct drbg_state *drbg,
              drbg->scratchpad, drbg_blocklen(drbg));

 out:
-    memset(drbg->scratchpad, 0, drbg_blocklen(drbg));
+    memzero_explicit(drbg->scratchpad, drbg_blocklen(drbg));
     return ret;
 }

@@ -967,8 +967,7 @@ static int drbg_hash_hashgen(struct drbg_state *drbg,
     }

 out:
-    memset(drbg->scratchpad, 0,
-           (drbg_statelen(drbg) + drbg_blocklen(drbg)));
+    memzero_explicit(drbg->scratchpad, (drbg_statelen(drbg) +
drbg_blocklen(drbg)));
     return len;
 }

@@ -1015,7 +1014,7 @@ static int drbg_hash_generate(struct drbg_state *drbg,
     drbg_add_buf(drbg->V, drbg_statelen(drbg), u.req, 8);

 out:
-    memset(drbg->scratchpad, 0, drbg_blocklen(drbg));
+    memzero_explicit(drbg->scratchpad, drbg_blocklen(drbg));
     return len;
 }

@@ -1202,8 +1201,8 @@ static int drbg_seed(struct drbg_state *drbg,
struct drbg_string *pers,
     }

     if (!reseed) {
-        memset(drbg->V, 0, drbg_statelen(drbg));
-        memset(drbg->C, 0, drbg_statelen(drbg));
+        memzero_explicit(drbg->V, drbg_statelen(drbg));
+        memzero_explicit(drbg->C, drbg_statelen(drbg));
     }

     ret = __drbg_seed(drbg, &seedlist, reseed);
-- 
2.25.1
