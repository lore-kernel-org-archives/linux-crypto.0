Return-Path: <SRS0=5Ot1=SE=vger.kernel.org=linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5F6DC43381
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Apr 2019 02:51:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 728FC2070D
	for <linux-crypto@archiver.kernel.org>; Tue,  2 Apr 2019 02:51:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z4RwRwoZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbfDBCvv (ORCPT
        <rfc822;linux-crypto@archiver.kernel.org>);
        Mon, 1 Apr 2019 22:51:51 -0400
Received: from mail-it1-f194.google.com ([209.85.166.194]:55353 "EHLO
        mail-it1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfDBCvv (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Mon, 1 Apr 2019 22:51:51 -0400
Received: by mail-it1-f194.google.com with SMTP id z126so2639645itd.5;
        Mon, 01 Apr 2019 19:51:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uy9RYIFrt72GyVLolTkfJFGIgbCwRa8GdZWTSePUoCY=;
        b=Z4RwRwoZZVmFSwqVbxiIr6DQKL566vAlqvMcqbc3MA8HqkHN1rWdHtXYuBx6gUn6pq
         OKDQkbkdTYV1xak6yYHSOhBLWlsfTY1CKtsMIdN+RL3DvUe/YcgOuAENHoYn5v+Fa62/
         0eJQxmSZpVlbK6XIwRP5SOKCYMPgx1hpaGxVBc0snFSYZBU8YWNWn3DBbm+r7sYqIEHH
         3bJdIaT2sbmBCHuwagiZZP5beVdphNUzwKc0wKOondMjdsUsKqEFfo1n5WDXblNoNzGx
         O3f7vdcSJGYA+/24PPRSUqnOGZ4Sx7gH0BVpHn/oor/IcEkBSmyLQpallREVhQaKMgUZ
         z9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uy9RYIFrt72GyVLolTkfJFGIgbCwRa8GdZWTSePUoCY=;
        b=OPJ95Q0uDdUNms+J8TQMJCYK25P0tufImMMJkJ/RBMBwX1ELfE2QqHH0+qjTDXpAn3
         XuVSDoUCC7bCA6WN3SsrMhdB6XXRdqPbV4a++gE6798gWSeGKVnFCKQaa63qeY6kYRdP
         qL3+6oxzoy9yQAoLZKyPShv6PUhUBvG9KuPT4rcL2Tt2UbS9iBNajH9q6qEbVpLm2liU
         oXuvmj3hgE8xI/U3sF5jBjFsVabwtvBw88VvUWFDFi+vk+qgpzG+KRx16X69PZJU+X5A
         3TyQHr1zo1xo8yJoNa8sf+26QungpZ1o7/YDJKTXxvOJIdHYmsWher7JiVAcySMibUYr
         jdIQ==
X-Gm-Message-State: APjAAAXm4JQjW1tYBfExCkqXJyk10gWXtQ0kTB33q4mNpy01j6K7eRml
        iv/XmYA5nzuOWQPKqZTBow4=
X-Google-Smtp-Source: APXvYqxv9kztG8Q90vbiKZClsp3czANWx8QLxheFYvSEQ/qGbFkSJ6K9X/bMVj0FQKnlWhiyc5WN9g==
X-Received: by 2002:a05:660c:4c2:: with SMTP id v2mr2337278itk.71.1554173509961;
        Mon, 01 Apr 2019 19:51:49 -0700 (PDT)
Received: from ubu (2600-6c48-437f-c81d-984d-b4e8-0abe-7e26.dhcp6.chtrptr.net. [2600:6c48:437f:c81d:984d:b4e8:abe:7e26])
        by smtp.gmail.com with ESMTPSA id j10sm6238546itj.32.2019.04.01.19.51.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 01 Apr 2019 19:51:49 -0700 (PDT)
Date:   Mon, 1 Apr 2019 22:51:47 -0400
From:   Kimberly Brown <kimbrownkd@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 6/8] padata: Replace padata_attr_type default_attrs field
 with groups
Message-ID: <8aa9c80adff66fa093601bb8ca7227586279f49f.1554151487.git.kimbrownkd@gmail.com>
References: <20190322201440.GA30814@ubu-Virtual-Machine>
 <cover.1554151487.git.kimbrownkd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1554151487.git.kimbrownkd@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-crypto-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

The kobj_type default_attrs field is being replaced by the
default_groups field. Replace padata_attr_type's default_attrs field
with default_groups and use the ATTRIBUTE_GROUPS macro to create
padata_default_groups.

This patch was tested by loading the pcrypt module and verifying that
the sysfs files for the attributes in the default groups were created.

Signed-off-by: Kimberly Brown <kimbrownkd@gmail.com>
---
 kernel/padata.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 3e2633ae3bca..2d2fddbb7a4c 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -957,6 +957,7 @@ static struct attribute *padata_default_attrs[] = {
 	&parallel_cpumask_attr.attr,
 	NULL,
 };
+ATTRIBUTE_GROUPS(padata_default);
 
 static ssize_t padata_sysfs_show(struct kobject *kobj,
 				 struct attribute *attr, char *buf)
@@ -995,7 +996,7 @@ static const struct sysfs_ops padata_sysfs_ops = {
 
 static struct kobj_type padata_attr_type = {
 	.sysfs_ops = &padata_sysfs_ops,
-	.default_attrs = padata_default_attrs,
+	.default_groups = padata_default_groups,
 	.release = padata_sysfs_release,
 };
 
-- 
2.17.1

