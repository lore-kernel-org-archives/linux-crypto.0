Return-Path: <linux-crypto-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF25CC001B4
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Apr 2021 17:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8408D60FF3
	for <linux-crypto@archiver.kernel.org>; Thu,  1 Apr 2021 17:48:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234994AbhDARsA (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Thu, 1 Apr 2021 13:48:00 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29242 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234919AbhDARlS (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Thu, 1 Apr 2021 13:41:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617298878;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc; bh=tQ7T2L7I+YC/lfS/ewKVEL0zytv8HCHdOwuDx1mlT40=;
        b=iGxpPHL3NMQ+iIDPggUb1kF4H19Vg6nduJhwuFZ0vYklK1MDcU0MlhVoTIa1W8mgKz3jo0
        kYMiwTe7a5WXpMvvHqxHfdMiuQ/IvRa6NdkBotX6j0xm4HJ+GkfYY6ctBcb2Dxde7Rfto4
        11NPqR7pLu64IyDyio7Zv7/Q9vCo4eE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-oOZdNLTcNfKnonAP-_pS_Q-1; Thu, 01 Apr 2021 08:25:05 -0400
X-MC-Unique: oOZdNLTcNfKnonAP-_pS_Q-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 40B3E107ACCA;
        Thu,  1 Apr 2021 12:25:04 +0000 (UTC)
Received: from crecklin.bos.com (unknown [10.22.8.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 286F477520;
        Thu,  1 Apr 2021 12:24:59 +0000 (UTC)
From:   Chris von Recklinghausen <crecklin@redhat.com>
To:     ardb@kernel.org, simo@redhat.com, rafael@kernel.org,
        decui@microsoft.com, linux-pm@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] use crc32 instead of md5 for hibernation e820 integrity check
Date:   Thu,  1 Apr 2021 08:24:57 -0400
Message-Id: <20210401122458.12663-1-crecklin@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Currently, suspend on x86_64 fails when FIPS mode is enabled because it uses md5
to generate a digest of the e820 region. MD5 is not FIPS compliant so an error
is reported and the suspend fails.

MD5 is used only to create a digest to ensure integrity of the region, no actual
encryption is done. This patch set changes the integrity check to use crc32
instead of md5 since crc32 is available in both FIPS and non-FIPS modes.

Chris von Recklinghausen (1):
  use crc32 instead of md5 for hibernation image integrity check

 arch/x86/power/hibernate.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

-- 
2.18.1

