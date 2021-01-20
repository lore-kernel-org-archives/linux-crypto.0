Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60B22C433E9
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 09:32:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33B7B22D08
	for <linux-crypto@archiver.kernel.org>; Wed, 20 Jan 2021 09:32:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729156AbhATJKm (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 20 Jan 2021 04:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729178AbhATJHK (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 20 Jan 2021 04:07:10 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4261C0613D6;
        Wed, 20 Jan 2021 01:06:12 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id cq1so1784214pjb.4;
        Wed, 20 Jan 2021 01:06:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=M1CBK07C46laJoyWYovF4lSgfEz56MEL8US4G4KcnR0=;
        b=n2l91F4By3VLGwLBJpVvXP1nkvLFb4J3UfQ45CgFVauOpq/R8UE7naJRjzVsK1Z6Tc
         yWUZFgzSvOsCrj4dSiqWh5zkhzAAyNGOpRjfytobhn3SySy85wP/rh7m4zAat4FSGBVi
         GATV3bkpxqrkswVNkMig1anryhdnb0I2uzsBHTN8EdV5edS/0Gvy2JAmU3Wio6v9sm9o
         fk8/5az/W4xrAJyZbNPUJnnO8bb3S/8s2nydTMMcWJC8cZMWw3NOvyUcmF+2rr4sQXuF
         tlXrpNK/tOOiOU+uCeNypTb3qrO3y35dI8eJKRbXPzu0zwu6zqzGldfo14lHb+JN+L+g
         4WOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=M1CBK07C46laJoyWYovF4lSgfEz56MEL8US4G4KcnR0=;
        b=gz/tnbNrS8+BuLvdl6LktTzRRSoglFNfueYJWJS5Y1cMRAMY6leNJJ5kZcPcCwp5Hi
         tv5gYM/gMufM+4ufT+ygls9RB7xZ+/XFnXvMsEocW7avh4OHWRVo1V1f/jC39siS6RcE
         cs2gEyon4o8DMmOVpAbtZEHSQNRNZPCwCLL+heOv0UUleH1JyZNbE0BqfEqAs6rRmW0o
         PdyL+I/EKfOR3tSEpIEfzvLg2fldJiTONzwLs1NcIySO/rtQ97WqhaMH3BFPqfgjo1Wy
         LBm8u0AKLwvVgn7UDUStLAWV0tw0miY3UEjOEGKHM3KSKVBrCbCC0zq+5wN+ZW+4xbGT
         iWcg==
X-Gm-Message-State: AOAM533Al0dSBFv9UYQobsq4sjHtv/bpi5bkS0JOpa8zP+hDreJu4rFc
        SbM7/uEjmm54mEqOBbTkFuI=
X-Google-Smtp-Source: ABdhPJwTBQGrDFW8IYQg0Vzds4hUdO8l4R2fsonSWR9cfY9ArY5yg0M0Z1wKgVBSjDJul+B2iZNz+Q==
X-Received: by 2002:a17:90a:d3c7:: with SMTP id d7mr4594364pjw.169.1611133572338;
        Wed, 20 Jan 2021 01:06:12 -0800 (PST)
Received: from linux-l9pv.suse ([124.11.22.254])
        by smtp.gmail.com with ESMTPSA id z2sm1585226pgl.49.2021.01.20.01.06.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 Jan 2021 01:06:11 -0800 (PST)
From:   "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
X-Google-Original-From: "Lee, Chun-Yi" <jlee@suse.com>
To:     David Howells <dhowells@redhat.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Ben Boeckel <me@benboeckel.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Malte Gell <malte.gell@gmx.de>, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Lee, Chun-Yi" <jlee@suse.com>
Subject: [PATCH 4/4] Documentation/admin-guide/module-signing.rst: add openssl command option example for CodeSign EKU
Date:   Wed, 20 Jan 2021 17:05:17 +0800
Message-Id: <20210120090517.23851-5-jlee@suse.com>
X-Mailer: git-send-email 2.12.3
In-Reply-To: <20210120090517.23851-1-jlee@suse.com>
References: <20210120090517.23851-1-jlee@suse.com>
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Add an openssl command option example for generating CodeSign extended
key usage in X.509 when CONFIG_CHECK_CODESIGN_EKU is enabled.

Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
---
 Documentation/admin-guide/module-signing.rst | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/Documentation/admin-guide/module-signing.rst b/Documentation/admin-guide/module-signing.rst
index 7d7c7c8a545c..b57b30c7125f 100644
--- a/Documentation/admin-guide/module-signing.rst
+++ b/Documentation/admin-guide/module-signing.rst
@@ -170,6 +170,12 @@ generate the public/private key files::
 	   -config x509.genkey -outform PEM -out kernel_key.pem \
 	   -keyout kernel_key.pem
 
+When ``CONFIG_CHECK_CODESIGN_EKU`` option be enabled, the following openssl
+command option should be added for generating CodeSign extended key usage in
+X.509::
+
+        -addext "extendedKeyUsage=codeSigning"
+
 The full pathname for the resulting kernel_key.pem file can then be specified
 in the ``CONFIG_MODULE_SIG_KEY`` option, and the certificate and key therein will
 be used instead of an autogenerated keypair.
-- 
2.16.4

