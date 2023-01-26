Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19659C05027
	for <linux-crypto@archiver.kernel.org>; Thu, 26 Jan 2023 03:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229506AbjAZDzH (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Wed, 25 Jan 2023 22:55:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjAZDzH (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Wed, 25 Jan 2023 22:55:07 -0500
Received: from aib29gb123.yyz1.oracleemaildelivery.com (aib29gb123.yyz1.oracleemaildelivery.com [192.29.72.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CAF1457EA
        for <linux-crypto@vger.kernel.org>; Wed, 25 Jan 2023 19:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oci-2023;
 d=n8pjl.ca;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=z4oWTguh112gq5BHQdKzWiYxkFlOOC8XW4Ugi9+/YT8=;
 b=cfoTI/27fHCOyNkyhhSPUDYWTi44fg5kwux/133YaLmoz4PJAhS7UfdSv8rBx35VzKpPipjB3UTx
   tzGOn+0rGCggn//NCMsMuvyksfeXkf6XhaWWfYrxhdtR3AihJvlEjfJ4nCfDnFFWkOHY+8UdiSP/
   h8fpQbW/1sl3jfbV7704kmqbSRzUQNEH82D4zk1GD4kP0E7c8qBETGDTKqZaoUHSwaA8oq5UA0zX
   CKA+c4Xy4DijiSBjsWxj9Tl9C+OcfbW8VHyX3TTGsrgw1T5Kg/D+j3aoWk0UqAUycg/KkJI24mMa
   3itIKuC1SiNT0A5M5HO8IyPgU35ey1I5iL9JXQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-yyz-20200204;
 d=yyz1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=z4oWTguh112gq5BHQdKzWiYxkFlOOC8XW4Ugi9+/YT8=;
 b=l9fyEXBFdrDx+CllGKeaGZ7YiYaavqubL72tm1JJgymaRGni75BXurRFHzTrfHAborleUkbIcMCC
   RkQ7WrEHASkblLMlKVLjl1yOr1Uyn/oDT7g2Si9+KLQzBSX4oWIBHpGq3SRn3LsER05WXLMbeYlp
   cUWHFDbONEabblqzesA3kS0WYeEwArTQfEUb42r93qaJ7+WJ+dfoIsqCf9mUflUmn8cDCE6TQBsf
   WArIfOWe9G5/gJRqQIAE4F5pyHY+UgQvSJ8/ph50ta7zo9ujj+YbQFl+z1oW/S0PonLq0At8wYcT
   DYdK4UTBdkgK34BxJl+UUu+wS2g6ZKzaZ+2o6w==
Received: by omta-ad1-fd1-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230118 64bit (built Jan 18
 2023))
 with ESMTPS id <0RP2000QDQVSX780@omta-ad1-fd1-102-ca-toronto-1.omtaad1.vcndpyyz.oraclevcn.com> for
 linux-crypto@vger.kernel.org; Thu, 26 Jan 2023 03:55:04 +0000 (GMT)
From:   Peter Lafreniere <peter@n8pjl.ca>
To:     linux-crypto@vger.kernel.org
Cc:     Peter Lafreniere <peter@n8pjl.ca>, x86@kernel.org,
        jussi.kivilinna@mbnet.fi
Subject: [PATCH 0/3] crypto: x86/blowfish - Cleanup and convert to ECB/CBC
 macros
Date:   Wed, 25 Jan 2023 22:54:32 -0500
Message-id: <20230126035433.5291-1-peter@n8pjl.ca>
X-Mailer: git-send-email 2.39.1
MIME-version: 1.0
Content-transfer-encoding: 8bit
Reporting-Meta: AAGLmsdiyB4PGyn7+In7rV6QBZ5OTvOSWiLYpD1TZNZj2h0lcACgDMDi0nori/iH
 k6j6g7zEP4tzudYydKlKWKN4ZKPPoQCrl3NWGeivFFHDCpm7T/UNcJd9Ek5LUBnu
 dpAKpSVMiqp8r+VY1vLtPNTY0kaffxQGBycRvD9SUMQHJ8ua7suu8dv6HgFZMCwy
 tBcHJ4x0BfQrKDa3y8xlaAhzoL6z4mGKIOi/i62hMsIJkgItzTghBuJ5mLNaQ06u
 D6OMIHR8N5wzh+CUvP4ORXnXMpRPpQeDyM2QIGoLURT+lnRlWwd0CJtyZWiUbUXN
 oTdOJ4g1kVsSgXQE64m6BnccN9SetTMtMXsqT3IEQ7KWpcwVGEJEfYIi5+7DRBOt
 YbRDCkN/RJ3Ir9j4NmUV7S4OPGEK6sPCQivO45QYYw2aqugz5SzjrU08Z8Zk8hU=
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

We can acheive a reduction in code size by cleaning up unused logic in
assembly functions, and by replacing handwritten ECB/CBC routines with
helper macros from 'ecb_cbc_helpers.h'.

Additionally, these changes can allow future x86_64 optimized
implementations to take advantage of blowfish-x86_64's fast 1-way and
4-way functions with less code churn.

Peter Lafreniere (3):
  crypto: x86/blowfish - Remove unused encode parameter
  crypto: x86/blowfish - Convert to use ECB/CBC helpers
  crypto: x86/blowfish - Eliminate use of SYM_TYPED_FUNC_START in asm

 arch/x86/crypto/blowfish-x86_64-asm_64.S |  71 ++++----
 arch/x86/crypto/blowfish_glue.c          | 200 +++--------------------
 2 files changed, 55 insertions(+), 216 deletions(-)

-- 
2.39.1

