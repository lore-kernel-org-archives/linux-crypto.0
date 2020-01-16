Return-Path: <SRS0=he+G=3F=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C3E2C33CAF
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 19:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B33C206E6
	for <linux-crypto@archiver.kernel.org>; Thu, 16 Jan 2020 19:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579202120;
	bh=6Fd7Q3BMWeJNBGk0kKO5Sfece9B848AW7wMsA8jHAYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=xWZyyYAyT+JBYnFOyyLvhQyAMy/AD9Rb9qyYUgJTvxqP8DmcjbZDG5PpcTdxmXIaj
	 sEfF0WQ7Qzfy49CTB6QBQCNOT998GJwxBKNjYA7XlOWLa+WmRqox//vhIOXI38nJCV
	 qKvuTqB/smYPMr1/raDN0UvNx3VXlf1nYbXCI998=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733172AbgAPTPT (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 16 Jan 2020 14:15:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:42002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733145AbgAPQ4C (ORCPT <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 16 Jan 2020 11:56:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D316A2467C;
        Thu, 16 Jan 2020 16:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193761;
        bh=6Fd7Q3BMWeJNBGk0kKO5Sfece9B848AW7wMsA8jHAYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihPQzphy+LG9NPkWQ6WakpMAiLQ4YWtWnkG5dA3C/uTq3UYfqpRkhjADuJ3CTXKAX
         KFEuLIerUtsaie66toY/XjQW5CNoMiC+iuOEG9o/e7R8fZ8jfR9hhtBZ7TGe+Gi6If
         LMIBKmZ6GCjxN9DKDXuDexGVUIU6JSwsazsPIMGI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org,
        clang-built-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 048/671] pcrypt: use format specifier in kobject_add
Date:   Thu, 16 Jan 2020 11:44:39 -0500
Message-Id: <20200116165502.8838-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116165502.8838-1-sashal@kernel.org>
References: <20200116165502.8838-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit b1e3874c75ab15288f573b3532e507c37e8e7656 ]

Passing string 'name' as the format specifier is potentially hazardous
because name could (although very unlikely to) have a format specifier
embedded in it causing issues when parsing the non-existent arguments
to these.  Follow best practice by using the "%s" format string for
the string 'name'.

Cleans up clang warning:
crypto/pcrypt.c:397:40: warning: format string is not a string literal
(potentially insecure) [-Wformat-security]

Fixes: a3fb1e330dd2 ("pcrypt: Added sysfs interface to pcrypt")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/pcrypt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/crypto/pcrypt.c b/crypto/pcrypt.c
index f8ec3d4ba4a8..a5718c0a3dc4 100644
--- a/crypto/pcrypt.c
+++ b/crypto/pcrypt.c
@@ -394,7 +394,7 @@ static int pcrypt_sysfs_add(struct padata_instance *pinst, const char *name)
 	int ret;
 
 	pinst->kobj.kset = pcrypt_kset;
-	ret = kobject_add(&pinst->kobj, NULL, name);
+	ret = kobject_add(&pinst->kobj, NULL, "%s", name);
 	if (!ret)
 		kobject_uevent(&pinst->kobj, KOBJ_ADD);
 
-- 
2.20.1

