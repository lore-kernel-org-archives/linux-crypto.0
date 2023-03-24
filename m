Return-Path: <linux-crypto-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F81C6FD20
	for <linux-crypto@archiver.kernel.org>; Fri, 24 Mar 2023 17:49:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231501AbjCXRtr (ORCPT <rfc822;linux-crypto@archiver.kernel.org>);
        Fri, 24 Mar 2023 13:49:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbjCXRtd (ORCPT
        <rfc822;linux-crypto@vger.kernel.org>);
        Fri, 24 Mar 2023 13:49:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B97B206A1
        for <linux-crypto@vger.kernel.org>; Fri, 24 Mar 2023 10:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679680060;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=neMn6XIO4FLNVSN/ptkltqoXMKLLln2HdqxphUzJHq8=;
        b=VCxP8mw0AhTBYTkbhwZdAy/IJSZWndg/XWBTkaIAwa0hSXT4Ca59kBxZnZhrONaPL1ewQu
        LZTdX1fS+Xh/DK3Gcb4Nmg5oQi7XWcyGZmrP7gK9NdbMvATIw0TXHUDwRRIblUyZR8vSAd
        bXp87C5yOuv5e5WV+ZGoLZ7wLWMQ0Zw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-519-99qs1hHTMtiVZU_lfPrnzg-1; Fri, 24 Mar 2023 13:47:36 -0400
X-MC-Unique: 99qs1hHTMtiVZU_lfPrnzg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 530A0185A790;
        Fri, 24 Mar 2023 17:47:36 +0000 (UTC)
Received: from rules.brq.redhat.com (unknown [10.45.242.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2435B492B01;
        Fri, 24 Mar 2023 17:47:34 +0000 (UTC)
From:   Vladis Dronov <vdronov@redhat.com>
To:     Stephan Mueller <smueller@chronox.de>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto@vger.kernel.org, Vladis Dronov <vdronov@redhat.com>
Subject: RE: [PATCH v3] Jitter RNG - Permanent and Intermittent health errors
Date:   Fri, 24 Mar 2023 18:47:09 +0100
Message-Id: <20230324174709.21533-1-vdronov@redhat.com>
In-Reply-To: <5915902.lOV4Wx5bFT@positron.chronox.de>
References: <5915902.lOV4Wx5bFT@positron.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-crypto.vger.kernel.org>
X-Mailing-List: linux-crypto@vger.kernel.org

Hi,
Aaaand I would suggest the following smallest fix, just a comment update:

+        * If the kernel was booted with fips=2, it implies that

change to:

+        * If the kernel was booted with fips=1, it implies that

Otherwise,
Reviewed-by: Vladis Dronov <vdronov@redhat.com>

Best regards,
Vladis

